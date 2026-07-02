"""Functions for extracting PeMS files as parquet."""

from pathlib import Path

import polars as pl
from tqdm import tqdm

STATION_5MIN_READ_SCHEMA = pl.Schema(
    {
        "timestamp": pl.String(),
        "station": pl.Int64(),
        "district": pl.Int64(),
        "freeway": pl.Int64(),
        "direction_of_travel": pl.Enum(["N", "S", "E", "W"]),
        "lane_type": pl.Enum(
            [
                "CD",
                "CH",
                "FF",
                "FR",
                "HV",
                "ML",
                "OR",
            ]
        ),
        "station_length": pl.Float64(),
        "samples": pl.Float64(),
        "percent_observed": pl.Float64(),
        "total_flow": pl.Float64(),
        "avg_occupancy": pl.Float64(),
        "avg_speed": pl.Float64(),
    }
    | {
        f"lane_{i}_{measure}": pl.Int64() if measure in ["observed"] else pl.Float64()
        for i in range(1, 8 + 1)
        for measure in ["samples", "flow", "avg_occ", "avg_speed", "observed"]
    }
)
STATION_HOUR_READ_SCHEMA = pl.Schema(
    {
        "timestamp": pl.String(),
        "station": pl.Int64(),
        "district": pl.Int64(),
        "freeway": pl.Int64(),
        "direction_of_travel": pl.Enum(["N", "S", "E", "W"]),
        "lane_type": pl.Enum(
            [
                "CD",
                "CH",
                "FF",
                "FR",
                "HV",
                "ML",
                "OR",
            ]
        ),
        "station_length": pl.Float64(),
        "samples": pl.Float64(),
        "percent_observed": pl.Float64(),
        "total_flow": pl.Float64(),
        "avg_occupancy": pl.Float64(),
        "avg_speed": pl.Float64(),
        "delay_t_35": pl.Float64(),
        "delay_t_40": pl.Float64(),
        "delay_t_45": pl.Float64(),
        "delay_t_50": pl.Float64(),
        "delay_t_55": pl.Float64(),
        "delay_t_60": pl.Float64(),
    }
    | {
        f"lane_{i}_{measure}": pl.Float64()
        for i in range(1, 8 + 1)
        for measure in ["flow", "avg_occ", "avg_speed"]
    }
)
STATION_DAY_READ_SCHEMA = pl.Schema(
    {
        "timestamp": pl.String(),
        "station": pl.Int64(),
        "district": pl.Int64(),
        "freeway": pl.Int64(),
        "direction_of_travel": pl.Enum(["N", "S", "E", "W"]),
        "lane_type": pl.Enum(
            [
                "CD",
                "CH",
                "FF",
                "FR",
                "HV",
                "ML",
                "OR",
            ]
        ),
        "station_length": pl.Float64(),
        "samples": pl.Float64(),
        "percent_observed": pl.Float64(),
        "total_flow": pl.Float64(),
        "avg_occupancy": pl.Float64(),
        "avg_speed": pl.Float64(),
        "delay_t_35": pl.Float64(),
        "delay_t_40": pl.Float64(),
        "delay_t_45": pl.Float64(),
        "delay_t_50": pl.Float64(),
        "delay_t_55": pl.Float64(),
        "delay_t_60": pl.Float64(),
    }
    | {
        f"lane_{i}_{measure}": pl.Float64()
        for i in range(1, 8 + 1)
        for measure in ["flow", "avg_occ", "avg_speed"]
    }
)


def extract_station_5min(txt_path: Path) -> pl.DataFrame:
    station_5minute = pl.read_csv(
        txt_path,
        schema=STATION_5MIN_READ_SCHEMA,
        has_header=False,
    ).with_columns(timestamp=pl.col("timestamp").str.to_datetime("%m/%d/%Y %T"))
    return station_5minute


def extract_station_hour(txt_path: Path) -> pl.DataFrame:
    station_hour = pl.read_csv(
        txt_path,
        schema=STATION_HOUR_READ_SCHEMA,
        has_header=False,
    ).with_columns(timestamp=pl.col("timestamp").str.to_datetime("%m/%d/%Y %T"))
    return station_hour


def extract_station_day(txt_path: Path) -> pl.DataFrame:
    station_day = pl.read_csv(
        txt_path,
        schema=STATION_DAY_READ_SCHEMA,
        has_header=False,
    ).with_columns(timestamp=pl.col("timestamp").str.to_datetime("%m/%d/%Y %T"))
    return station_day


if __name__ == "__main__":
    # TODO: Base hardcoded loop on some kind of config/environment variable
    for year in [2025, 2026]:
        for month in range(1, 13):
            txt_paths = [
                path
                for path in Path(
                    f"./data/pems/txt/station_5min/{year}/{month:02}/"
                ).iterdir()
                if path.suffix == ".txt"
            ]
            for txt_path in tqdm(txt_paths):
                df = extract_station_5min(txt_path)
                parquet_name = txt_path.stem + ".parquet"
                dir_ = Path(
                    f"./data/pems/parquet/station_5min/{year}/{df['timestamp'].dt.month().first():02}/"
                )
                dir_.mkdir(parents=True, exist_ok=True)
                df.write_parquet(dir_ / f"{parquet_name}")

        txt_paths = [
            path
            for path in Path(f"./data/pems/txt/station_hour/{year}").iterdir()
            if path.suffix == ".txt"
        ]
        for txt_path in tqdm(txt_paths):
            df = extract_station_hour(txt_path)
            parquet_name = txt_path.stem + ".parquet"
            dir_ = Path(f"./data/pems/parquet/station_hour/{year}/")
            dir_.mkdir(parents=True, exist_ok=True)
            df.write_parquet(dir_ / f"{parquet_name}")

        txt_paths = [
            path
            for path in Path(f"./data/pems/txt/station_day/{year}").iterdir()
            if path.suffix == ".txt"
        ]
        for txt_path in tqdm(txt_paths):
            df = extract_station_day(txt_path)
            parquet_name = txt_path.stem + ".parquet"
            dir_ = Path(f"./data/pems/parquet/station_day/{year}/")
            dir_.mkdir(parents=True, exist_ok=True)
            df.write_parquet(dir_ / f"{parquet_name}")
