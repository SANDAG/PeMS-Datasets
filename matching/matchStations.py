"""
Matching PeMS stations to SANDAG highway network links.
Initial Development done by Jeff Yen and Gregor Schroeder.

User provides year of PeMS station metadata and path to highway network e00
file. Process converts PeMS station metadata and highway network to GeoPandas
DataFrames, runs matching process, and outputs exhaustive csv lookup of PeMS
stations to highway network link ids.

The matching process is as follows:
    For each ML/HV station, all highway network links with [ifc] = 1 that
    share the same freeway name (5, 125, 805, etc...), direction (N, S, E, W),
    and HOV/Non-HOV designation that are less than a pre-determined maximum
    allowable distance from the station are considered.

    Within the initial matches, if a station's closest highway link is also the
    highway link's closest station that station-highway link pair is considered
    a final one-to-one match. The pair is removed from all initial matches and
    the process is repeated until no initial matches are left.
"""

import geopandas as gpd
import numpy as np
from osgeo import ogr, osr  # ensure the GDAL_PATH environment variable for
# the Python execution environment is set to ...\Library\share\gdal
# this can be set either in the command prompt or in the Python IDE
# this gdal folder is created when the conda virtual environment is created
import os.path
import pandas as pd
import pyodbc
import re
from shapely import wkt


# user inputs year of PeMS station metadata to use
pemsYear = input("Enter year of PeMS station metadata to use:")
# user inputs file path to a hwycov.e00 file
e00File = input("Enter path to hwycov.e00 file:")


# load the PeMS station metadata from SQL as a GeoPandas DataFrame
conn = pyodbc.connect("Driver={SQL Server};"
                      "Server=;"  # TODO: specify server
                      "Database=;"  # TODO: specify database
                      "Trusted_Connection=yes;")

sql = ("SELECT [station], CONCAT(RTRIM([freeway]),"
       "RTRIM([direction])) AS [hwyNameDir],"
       "CASE WHEN [type] = 'HV' THEN 1 ELSE 0 END AS [HOV],"
       "[shape].ToString() AS [geometry] FROM [pems].[station_metadata] "
       "WHERE [type] IN ('ML', 'HV') AND [shape] IS NOT NULL "
       "AND YEAR(metadata_date) = ")

stations = pd.read_sql_query(sql + pemsYear, conn)
stations["geometry"] = [wkt.loads(x) for x in stations["geometry"]]
stations = gpd.GeoDataFrame(stations, crs="EPSG:4326", geometry="geometry")
stations = stations.to_crs("EPSG:2230")
# following command may be necessary to fix conda install issues with pyproj
# that result in error in to_crs function
# pip install --force-reinstall pyproj


# load the input highway coverage e00 file as a GeoPandas DataFrame
if not os.path.isfile(e00File):
    msg = "input hwycov.e00 file does not exist"
    raise ValueError(msg)
else:

    # load e00 file and get the linestring layer
    f = ogr.GetDriverByName("AVCE00").Open(e00File)
    lyrARC = f.GetLayerByName('ARC')

    # store layer projection and SANDAG standard EPSG:2230 projection
    lyrProjection = lyrARC.GetSpatialRef()
    sandagProjection = osr.SpatialReference()
    sandagProjection.ImportFromEPSG(2230)

    # for each feature in the layer
    # store freeway records, the freeway number, and their direction in a list
    records = []
    for item in lyrARC:
        if item.GetField("IFC") == 1:
            # regular expression to get freeway number from NM field
            # assumes NM field in format XXX-# XX
            hwyName = re.search(r"(?<=-)\d+", item.GetField("NM")).group()

            # get direction from NM field
            hwyDir = np.select(
                condlist=["NB" in item.GetField("NM"),
                          "SB" in item.GetField("NM"),
                          "EB" in item.GetField("NM"),
                          "WB" in item.GetField("NM")],
                choicelist=["N", "S", "E", "W"],
                default=np.nan
            )

            # concatenate freeway number and direction
            hwyNameDir = hwyName + str(hwyDir)

            # get HOV/Non-HOV designation via string search of name field
            HOV = np.select(
                    condlist=["HOV" in item.GetField("NM"),
                              "HOV" not in item.GetField("NM")],
                    choicelist=[1, 0]
                )

            # re-project to epsg:2230
            transform = osr.CoordinateTransformation(lyrProjection, sandagProjection)
            geo = item.GetGeometryRef()
            geo.Transform(transform)

            records.append(
                [item.GetField("HWYCOV-ID"),
                 hwyNameDir,
                 HOV,
                 wkt.loads(geo.ExportToWkt())]
            )

    # convert list of freeway records to a GeoPandas DataFrame
    hwyCov = pd.DataFrame(records, columns=["hwyCovId", "hwyNameDir", "HOV", "geometry"])
    hwyCov = gpd.GeoDataFrame(hwyCov, crs="epsg:2230", geometry="geometry")


# create dictionary of stations and their matched highway links
# initialize dictionary of matched links to stations
matches = {x: [] for x in stations["station"]}
# set the maximum allowable distance from station to network link
distance = 120  # Jeff Yen manually identified best distance

# for each station record
for vds in stations.itertuples():
    # loop through each highway link record
    for link in hwyCov.itertuples():
        # if station and link share freeway name and direction
        # and the station and link share same HOV/Non-HOV designation
        if vds.hwyNameDir == link.hwyNameDir & vds.HOV == link.HOV:
            # calculate distance from station to highway link
            linkDistance = vds.geometry.distance(link.geometry)
            # if distance < maximum allowed
            if linkDistance <= distance:
                # add the link to the list of matches
                matches[vds.station].append([link.hwyCovId, linkDistance])


# create the final result one-to-one match of station to highway link
# loop through the dictionary of stations matched to highway links
# create a DataFrame of the matches only (remove stations without matches)
matchesDf = []
for key in matches:
    if len(matches[key]) > 0:
        for item in matches[key]:
            matchesDf.append([key, *item])
matchesDf = pd.DataFrame(matchesDf, columns=["station", "hwyCovId", "distance"])

# within the DataFrame of matches
# if a station's closest highway link is also the highway link's closest station
# move that station-highway link pair to the results DataFrame
# and remove that station and highway link from the DataFrame of matches
# repeat this process until there is nothing left in the DataFrame of matches
resultDf = pd.DataFrame()
while len(matchesDf.index) > 0:
    minStations = matchesDf.loc[matchesDf.groupby("station")["distance"].idxmin()]
    minHwyCovIds = matchesDf.loc[matchesDf.groupby("hwyCovId")["distance"].idxmin()]
    resultDf = resultDf.append(minStations.merge(minHwyCovIds), ignore_index=True)
    matchesDf = matchesDf[(~matchesDf.station.isin(resultDf.station)) &
                          (~matchesDf.hwyCovId.isin(resultDf.hwyCovId))]

# append stations without matched highway links to the result DataFrame
missingStations = []
for key in matches:
    if key not in resultDf.station.values:
        missingStations.append([key, np.nan, np.nan])
missingStations = pd.DataFrame(missingStations, columns=["station", "hwyCovId", "distance"])
resultDf = resultDf.append(missingStations, ignore_index=True)
resultDf = resultDf.astype({"hwyCovId": "Int64"})


# write the result to a csv file
resultDf.to_csv("match.csv",
                columns=["station", "hwyCovId"],
                index=False)
