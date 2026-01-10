import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awgslue.context import GlueContext
from awsglue.job import Job


sc = SparkContext()
glue_context = GlueContext(sc)
spark = glue_context.spark_session
job = Job(glue_context)
input_df = glue_context.create_dynamic_frame_from_options(
    connection_type = "s3",
    connection_options = {
        "paths" : ["s3://jozi-pizza-medallion-aws-dev-lake/bronze/pizza_data.csv"]
    },
    format = "csv"
)

input_df.show(5)
df = input_df.toDF()
df_pd = df.toPandas()

print("Test script has successfully ran")