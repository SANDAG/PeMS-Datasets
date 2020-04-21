# PeMS-Datasets
This repository houses all objects associated with the storage, loading, and summarization of data-sets from the Caltrans Performance Measurement System (PeMS).

## PeMS data-sets location and acquisition
PeMS data-sets come from the PeMS Data Clearinghouse located at http://pems.dot.ca.gov/. To access the PeMS Data Clearinghouse it is necessary to create a user-name and password.

To download the data-sets it is recommended to use a batch downloader browser extension as Caltrans purposefully disallows the use of programmatic tools to access the data-sets. Once the data-sets of interest are downloaded ensure there are no duplicate files or empty files as this is not an uncommon occurrence in the Data Clearinghouse.

## Loading PeMS data-sets
The final destination of the PeMS data-sets is an internal SQL server instance specified in the Python file main.py of the project python folder. 

Once the data-sets are downloaded, placed in the project data folder, and ready to be loaded into the SQL server instance; ensure the PeMS SQL objects created by the pemsObjects.sql file in the project sql folder exist in the target database of interest. If they do not exist, or it is wished to completely start anew, run the pemsObjects.sql in the target database of interest to drop and create all PeMS related SQL objects.

SANDAG's SQL server service accounts are not currently set-up to handle Kerberos authentication properly. Therefore, this project requires the creation of a SQL Server Login with bulk load privileges in the SQL server instance target database of interest. The credentials must be specified in the Python file main.py located in the project python folder.

Create the Python interpreter from the provided environment.yml file located in the Python folder of the project. Set the interpreter as the default Python interpreter associated with this project. Run the Python file main.py from the project python folder. It will sequentially load the  data-sets of interest from the data folder, extracting the necessary txt files from the compressed gz files and zip archives, and load them directly into the SQL database of interest specified in the Python file main.py.

## Summarizing PeMS data-sets
Stored procedures within the database containing the PeMS data-sets provide yearly aggregations of the PeMS data-sets at the station level for user-specified time resolutions. For more information, refer to this GitHub's Wiki page for each PeMS data-set.

## Matching PeMS stations to SANDAG highway network
A Python micro-service is included in the project matching folder that matches a user-specified year of PeMS station metadata loaded into an internal SQL server instance with a user-specified SANDAG highway network e00 file. The Python script can be run outside of the project folder structure and includes a separate enviornment.yml file from the main project.
