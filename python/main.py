import gzip
import os
import pyodbc
from zipfile import ZipFile


# set SQL connection to location that contains the PeMS objects
# Kerberos authentication issue requires use of a SQL login
# instead of Windows Authentication in the SANDAG environment
# create account when loading then remove
conn = pyodbc.connect("DRIVER={ODBC Driver 13 for SQL Server};"
                      "SERVER=;"
                      "DATABASE=;"
                      "UID=;"  # TODO: create SQL login see README
                      "PWD=")  # TODO: create SQL login see README
cursor = conn.cursor()

# create mappings of PeMS data-set raw file names to PeMS objects
mapping = [
    {"file": "all_text_tmg_vclass_hour", "tbl": "pems.census_vclass_hour"},
    {"file": "d11_text_station_5min", "tbl": "pems.station_five_minute"},
    {"file": "d11_text_station_aadt", "tbl": "pems.station_aadt"},
    {"file": "d11_text_station_day", "tbl": "pems.station_day"},
    {"file": "d11_text_station_hour", "tbl": "pems.station_hour"},
]

# for each PeMS data-set load all files in the data folder
# into their respective PeMS SQL object
for root, dirs, files in os.walk("../data/"):
    # for each file in the data folder
    for file in files:
        print("Loading: " + file)
        path = os.path.join(root, file)

        # only expect ZIP or GZ files in the data folder
        if not (file.endswith(".gz") or file.endswith(".zip")):
            msg = "unexpected file extension (.gz or .zip files expected)"
            raise ValueError(msg)
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
                        line = line.replace(b","*112, b"")
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
            sql = "BULK INSERT " + sqlTbl + " FROM '" + os.path.realpath(writePath) + "' " + \
                  "WITH (TABLOCK, CODEPAGE = 'ACP', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a');"
            cursor.execute(sql)
            cursor.commit()

        # delete underlying data file
        os.remove(writePath)
