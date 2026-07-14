# PeMS-Datasets
This repository houses all objects associated with the downloading and extracting of datasets from the Caltrans Performance Measurement System (PeMS).

## Python Environment
Dependencies required for running code in this repository are located in `pyproject.toml` (and additionall exported into a `requirements.txt` file).  It is recommended to use a package manager like [uv](https://docs.astral.sh/uv/) to setup an environment (by running `uv sync` with uv installed), but the "requirements.txt" could be passed to either pip or conda instead.

## PeMS and Config
PeMS data-sets come from the PeMS Data Clearinghouse located at http://pems.dot.ca.gov/. To access the PeMS Data Clearinghouse it is necessary to create a user-name and password.  To use the scripts included in this repository, these credentials should be saved in a filed named `.env` at the root of the cloned directory.  An example file (`.env.example`) is include for reference. **Note: a file with real credentials should never be commited to this repository.**

Additional configuration should be set in the `config.toml`.  Currently, there are two parameters used for configuration:
1. `pems_years: list[int]`: Lists the years of data to download from the PeMS Data Clearinghouse.
2. `pems_modes: list["station_day" | "station_hour" | "station_5min"]`: Lists the different download "modes" to download from the PeMS Data Clearinghouse.

## Downloading PeMS Data
To download the datasets, run the [`download-PeMS-data.py`](download-PeMS-data.py) script.  It will use an automated Chrome browser to log in to PeMS and download all configured year/mode.  This process should take several minutes for each given dataset, with `station_5min` data taking much longer than other modes.  It is expected for the browser to close and reopen for each year and mode defined in the config.  Files will download to `./data/pems/txt/{pems_mode}/{pems_year}/[{pems_month (for station_5min only)}]/d11_text_{pems_mode}_{date}.txt`.

## Extracting PeMS Data
To extract the raw PeMS .txt files into .parquet files, run the [`./python/extract_parquet.py`](./python/extract_parquet.py) script. Each downloaded .txt file saved to [`./data/pems/txt`](./data/pems/txt) will be extracted to [`./data/pems/parquet`](./data/pems/parquet). This process should take sevearl minutes for each conifugred year/mode.