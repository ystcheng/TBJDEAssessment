import os
import polars as pl
from dotenv import load_dotenv

load_dotenv()


# 2 a)
def process_games(path: str):
    df = pl.read_csv(path, has_header=True).rename(lambda col: col.lower())

    # removes duplicates
    remove_duplicates = (
        df.with_columns(
            pl.col("gamedate")
            .rank("ordinal", descending=True)
            .over("gamepk")
            .alias("rank")
        )
        .filter(pl.col("rank") == 1)
        .drop(pl.col("rank"))
    )

    remove_duplicates.write_database(
        "game", os.environ["CONNECTION"], if_table_exists="append"
    )


# 2 b)
def process_linescores(path: str):
    df = pl.read_csv(path, has_header=True).rename(lambda col: col.lower())

    # removes duplicates
    remove_duplicates = df.unique()

    # calculate the battingteam_score by applying a window function of cumulative sum + lag
    # over the partition by gamepk and battingteam and sorted by inning in ascending order
    result = remove_duplicates.with_columns(
        pl.col("runs")
        .cast(pl.Int64)
        .cum_sum()
        .shift(fill_value=0)
        .over(["gamepk", "battingteamid"], order_by="inning", descending=False)
        .alias("battingteam_score")
    )
    # calculate the opponent's score by the start of the team's half inning
    result = (
        result.with_columns(
            (pl.col("battingteam_score") + pl.col("runs").cast(pl.Int64))
            .shift(fill_value=0)
            .over(["gamepk"], order_by=["inning", "half"], descending=False)
            .alias("opponent_score")
        )
        .with_columns(
            battingteam_score_diff=pl.col("battingteam_score")
            - pl.col("opponent_score")
        )
        .drop("opponent_score")
    )

    result.write_database(
        "linescore", os.environ["CONNECTION"], if_table_exists="append"
    )


# 2 c)
def process_runners(path: str):
    df = pl.read_csv(path, has_header=True).rename(lambda col: col.lower())

    event_sanitized = df.with_columns(
        pl.col("originbase").fill_null("B"),
        pl.col("end").replace(
            "score", "4B"
        ),  # mapped to 4B to match with outbase and makes it easier to do comparison
    )

    result = (
        event_sanitized.with_columns(
            pl.col("originbase").alias("startbase"),
            pl.coalesce(["end", "outbase"]).alias("endbase"),
            pl.col("end").alias("reachedbase"),
            pl.col("isout").alias("is_out"),
        )
        .select(
            "gamepk",
            "atbatindex",
            "playindex",
            "runnerid",
            "playid",
            "runnerfullname",
            "startbase",
            "endbase",
            "reachedbase",
            "is_out",
            "eventtype",
            "movementreason",
        )
        .with_columns(
            pl.col("endbase")
            .rank("ordinal", descending=True)
            .over("gamepk", "atbatindex", "playindex", "runnerid")
            .alias("event_rank"),
        )
    )
    result = (
        result.filter(pl.col("event_rank") == 1)
        .drop("event_rank")
        .with_columns(
            pl.col("reachedbase").str.replace("4B", "HM"),
            pl.col("endbase").str.replace("4B", "HM"),
            is_risp=pl.col("startbase") > "1B",
            is_firsttothird=(pl.col("startbase") == "1B") & (pl.col("endbase") == "3B"),
            is_secondtohome=(pl.col("eventtype") != "home_run")
            & (pl.col("startbase") == "2B")
            & (pl.col("endbase") == "4B"),
        )
    )

    result.write_database(
        "runner_play", os.environ["CONNECTION"], if_table_exists="append"
    )
