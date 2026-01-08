
import sys
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql import functions as F

args = getResolvedOptions(sys.argv, [
    'SILVER_PREFIX', 'GOLD_PREFIX', 'PROJECT', 'ENV'
])

SILVER_PREFIX = args['SILVER_PREFIX']
GOLD_PREFIX   = args['GOLD_PREFIX']
PROJECT       = args['PROJECT']
ENV           = args['ENV']

sc = GlueContext(SparkContext()).spark_session.sparkContext
ctx = GlueContext(sc)
spark = ctx.spark_session

silver_path = f"s3://{PROJECT}-{ENV}-lake/{SILVER_PREFIX}"
silver_df = spark.read.parquet(silver_path)

# Example aggregation (replace with business rules)
gold_df = (
    silver_df.groupBy("user_id", "ingest_date")
             .agg(
                 F.countDistinct("session_id").alias("session_count"),
                 F.sum(F.col("purchase_amount")).alias("purchase_total"),
                 F.max("event_ts").alias("last_event_ts")
             )
)

gold_base = f"s3://{PROJECT}-{ENV}-lake/{GOLD_PREFIX}"
gold_path = f"{gold_base}user_activity_summary/"
(gold_df
 .repartition(5)
 .write
 .mode("overwrite")
 .partitionBy("ingest_date")
 .parquet(gold_path))
