from pathlib import Path

import polars as pl

PEMS_HOLIDAYS_READ_SCHEMA = pl.Schema(
    {
        "date": pl.String(),
        "holiday": pl.String(),
    }
)

TAM_HOLIDAYS_READ_SCHEMA = pl.Schema(
    {
        "date": pl.String(),
        "holiday": pl.String(),
        "type": pl.Enum(["Actual", "Observed", "Residual"]),
    }
)


def extract_holiday(pems_dir: Path | str, tam_dir: Path | str) -> pl.DataFrame:
    pems_dir = Path(pems_dir)
    pems_holidays = pl.read_csv(
        pems_dir / "pems_holiday.csv", schema=PEMS_HOLIDAYS_READ_SCHEMA
    ).with_columns(date=(pl.col("date").str.to_datetime("%-m/%d/%Y")))

    tam_dir = Path(tam_dir)
    tam_holidays = pl.read_csv(
        tam_dir / "pems_holiday_insert_*.txt", schema=TAM_HOLIDAYS_READ_SCHEMA
    ).with_columns(date=(pl.col("date").str.to_datetime("%Y-%m-%d")))

    return (
        pems_holidays.join(tam_holidays, on="date", how="left")
        .select(
            "date",
            "holiday",
            "holiday_right",
            pl.col("holiday").is_not_null().alias("is_pems_holiday"),
            pl.col("holiday_right").is_not_null().alias("is_tam_holiday"),
            pl.col("type").alias("tam_type"),
        )
        .with_columns(holiday=(pl.col("holiday").fill_null(pl.col("holiday_right"))))
        .drop("holiday_right")
    )


if __name__ == "__main__":
    parquet_path = Path("./data/holiday/holiday.parquet")
    if not Path(parquet_path).exists():
        parquet_path.parent.mkdir(exist_ok=True, parents=True)
        holiday = extract_holiday(
            "./holiday_table/pems/",
            "./holiday_table/tam/",
        )
        print(holiday)
        holiday.write_parquet(parquet_path)
