
# file: lambda_unzip_to_bronze.py
import os
import json
import urllib.parse
import boto3
import tempfile
import zipfile

s3 = boto3.client("s3")

BRONZE_PREFIX = os.environ.get("BRONZE_PREFIX", "bronze/")
LANDING_PREFIX = os.environ.get("LANDING_PREFIX", "landing/")

def is_zip_key(key: str) -> bool:
    # Simple heuristic (extend if needed)
    lower = key.lower()
    return lower.endswith(".zip") or ".zip/" in lower

def lambda_handler(event, context):
    # S3 Put event structure
    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])

        # Ignore non-landing paths
        if not key.startswith(LANDING_PREFIX):
            print(f"Skipping non-landing object: {key}")
            continue

        if is_zip_key(key):
            _process_zip_object(bucket, key)
        else:
            _copy_raw_to_bronze(bucket, key)

    return {"status": "ok"}

def _copy_raw_to_bronze(bucket: str, key: str):
    # Derive bronze key (preserve filename; swap prefix)
    bronze_key = key.replace(LANDING_PREFIX, BRONZE_PREFIX, 1)
    print(f"Copying {bucket}/{key} -> {bucket}/{bronze_key}")

    s3.copy_object(
        Bucket=bucket,
        CopySource={"Bucket": bucket, "Key": key},
        Key=bronze_key,
        MetadataDirective="COPY",  # keep original metadata
    )

def _process_zip_object(bucket: str, key: str):
    print(f"Extracting ZIP {bucket}/{key} to Bronze…")
    with tempfile.TemporaryDirectory() as tmpdir:
        zip_path = os.path.join(tmpdir, "archive.zip")
        s3.download_file(bucket, key, zip_path)

        with zipfile.ZipFile(zip_path, "r") as zf:
            # extract members to temp, upload each file to Bronze
            for member in zf.infolist():
                # Skip directories
                if member.is_dir():
                    continue

                # Ensure member filename is safe
                fname = os.path.basename(member.filename)
                if not fname:
                    continue

                # Read member bytes into memory (or stream to disk)
                with zf.open(member, "r") as fsrc:
                    # Compose bronze object key; keep folder context under the uploaded zip path
                    # e.g., landing/drops/batch1.zip -> bronze/drops/batch1/<file>
                    base_without_zip = key[len(LANDING_PREFIX):].rsplit("/", 1)[-1].replace(".zip", "")
                    bronze_key = f"{BRONZE_PREFIX}{base_without_zip}/{fname}"

                    print(f"Uploading extracted file to s3://{bucket}/{bronze_key}")
                    s3.upload_fileobj(
                        Fileobj=fsrc,
                        Bucket=bucket,
                        Key=bronze_key,
                        ExtraArgs={
                            "Metadata": {
                                "source_zip_key": key,
                                "bronze_ingest": "true"
                            }
                        },
                    )
