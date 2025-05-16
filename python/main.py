import re
import os
import gzip
import pyodbc
import sqlalchemy
import pandas as pd
import geopandas as gpd
from zipfile import ZipFile
from datetime import datetime

# TODO: set SQL connection to location that contains the PeMS objects
server = "DDAMWSQL16.sandag.org"
database = "travel_data"

# TODO: set file location where pems data is saved
pems_data_folder = "../data/"

# set sqlalchemy engine
engine = sqlalchemy.create_engine(
    f"mssql+pyodbc://@{server}/{database}?driver=SQL+Server"
)

# set pyodbc connection
conn = pyodbc.connect(
    "DRIVER={SQL Server};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)
cursor = conn.cursor()

# create mappings of PeMS data-set raw file names to PeMS objects
mapping = [
    {"file": "all_text_tmg_vclass_hour", "tbl": "pems.census_vclass_hour"},
    {"file": "d11_text_station_5min", "tbl": "pems.station_five_minute"},
    {"file": "d11_text_station_aadt", "tbl": "pems.station_aadt"},
    {"file": "d11_text_station_day", "tbl": "pems.station_day"},
    {"file": "d11_text_station_hour", "tbl": "pems.station_hour"},
    {"file": "d11_text_meta", "tbl": "pems.station_metadata"},
    {"file": "pems_holiday_insert", "tbl": "pems.holiday"},
]

# for each PeMS data-set load all files in the data folder
# into their respective PeMS SQL object
for root, dirs, files in os.walk(pems_data_folder):
    # for each file in the data folder
    for file in files:
        print("Loading: " + file)
        path = os.path.join(root, file)

        # only expect ZIP or GZ or TXT files in the data folder
        if not (file.endswith(".gz") or file.endswith(".zip") or file.endswith(".txt")):
            msg = "unexpected file extension (.gz or .zip ot .txt files expected)"
            raise ValueError(msg)
        else:
            if file.endswith(".txt"):
                writePath = path

            else:
                # if the compressed archive is a ZIP file extract the compressed
                # GZ file from the ZIP archive, this is required only for the
                # PeMS Data Clearinghouse Station AADT source of which we only
                # extract the Station AADT Month Hour data-set
                if file.endswith(".zip"):
                    with ZipFile(path) as zipfile:  # extract file of interest
                        for info in zipfile.infolist():
                            if "d11_text_station_aadt_month_hours_" in info.filename:
                                zipfile.extract(info.filename, path=root)
                                file = info.filename
                    os.remove(path)
                    path = os.path.join(root, file)

                # write out the underlying data file from the compressed GZ file
                writePath = path.rstrip(".gz")
                with open(writePath, "wb") as writeFile:
                    # the Census V-Class Hour data-sets have 112 empty fields appended
                    # past the fields provided in the metadata
                    if "all_text_tmg_vclass_hour" in file:
                        for line in gzip.open(path):
                            line = line.replace(b"," * 112, b"")
                            writeFile.write(line)
                    else:
                        writeFile.write(gzip.open(path).read())
                writeFile.close()

        # bulk load underlying data file to SQL Server
        # destination is dependent on the PeMS Data Clearinghouse source
        sqlTbl = None
        for item in mapping:
            if item["file"] in file:
                sqlTbl = item["tbl"]

        if sqlTbl is None:
            msg = "no SQL destination mapped"
            raise ValueError(msg)
        else:
            if sqlTbl == "pems.station_metadata":
                # convert to GeoDataFrame and load to SQL Database
                df = pd.read_csv(path, delimiter="\t")
                df.columns = [
                    "station",
                    "freeway",
                    "direction",
                    "district",
                    "county",
                    "city",
                    "state_postmile",
                    "absolute_postmile",
                    "latitude",
                    "longitude",
                    "length",
                    "type",
                    "lanes",
                    "name",
                    "user_id_1",
                    "user_id_2",
                    "user_id_3",
                    "user_id_4",
                ]
                match = re.search(r"((\d+)_(\d+)_(\d+))", writePath)
                df.insert(
                    loc=0,
                    column="metadata_date",
                    value=datetime.strptime(match.group(1), "%Y_%m_%d").strftime(
                        "%Y-%m-%d"
                    ),
                )
                df.to_sql(
                    name="station_metadata",
                    schema="pems",
                    con=engine,
                    if_exists="append",
                    index=False,
                )

                # alter df in SQL
                sql = """
                    UPDATE [pems].[station_metadata]
                    SET [shape] = geometry::Point([longitude], [latitude], 4326)
                    WHERE [longitude] IS NOT NULL AND [latitude] IS NOT NULL
                """
                engine.execute(sql)
            else:
                sql = (
                    "BULK INSERT "
                    + sqlTbl
                    + " FROM '"
                    + os.path.realpath(writePath)
                    + "' "
                    + "WITH (TABLOCK, CODEPAGE = 'ACP', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a');"
                )
                cursor.execute(sql)
                cursor.commit()

        # delete underlying data file
        os.remove(writePath)