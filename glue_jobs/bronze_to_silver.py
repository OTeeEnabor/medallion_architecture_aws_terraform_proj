
import sys
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql import functions as F

args = getResolvedOptions(sys.argv, [
    'BRONZE_PREFIX', 'SILVER_PREFIX', 'PROJECT', 'ENV'
])

BRONZE_PREFIX = args['BRONZE_PREFIX']
SILVER_PREFIX = args['SILVER_PREFIX']
PROJECT = args['PROJECT']
ENV = args['ENV']

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

bronze_path = f"s3://{PROJECT}-{ENV}-lake/{BRONZE_PREFIX}"
# Example: adapt to your raw format (CSV/JSON/Parquet)
df = spark.read.json(bronze_path)

# Basic cleaning/conformance (replace with your rules)
df_clean = (
    df.dropDuplicates()
      .dropna(how="all")
      .withColumn("event_ts", F.to_timestamp(F.col("event_ts")))
      .withColumn("ingest_date", F.to_date(F.col("event_ts")))
)

silver_path = f"s3://{PROJECT}-{ENV}-lake/{SILVER_PREFIX}"
(df_clean
 .repartition(10)
 .write
 .mode("overwrite")
 .partitionBy("ingest_date")
 .parquet(silver_path))
