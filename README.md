
# Medallion Architecture on AWS (Terraform + Glue + Athena)

## Background Context

Jozi Pizza Co. has been experiencing inconsistent delivery times and a recent increase in customer complaints. As a delivery‑only store, the business is concerned that operational bottlenecks—particularly within the preparation and dispatch processes during peak hours—are impacting customer satisfaction and reducing repeat sales. The company currently lacks a data analytics capability and is interested in investing in one.

The objective is to build a data analytics platform on AWS that will enable business intelligence analysts to diagnose internal operations using the company’s existing operational data. With this platform, Jozi Pizza Co. will be able to identify the root causes of delays, inefficiencies, and quality issues, and implement targeted, data‑driven improvements.


This project implements a **Bronze → Silver → Gold** data lake on AWS using **Terraform**, **AWS Glue**, and **Amazon Athena**.

<img src="jozzi_pizza_medallion_architecture.png" alt="Project architecture" width="1200">


## Layers
- **Bronze**: Raw landing zone (no transforms)
- **Silver**: Cleaned, validated, conformed datasets (Parquet + partitions)
- **Gold**: Curated aggregates for BI/ML

## Deploy (dev)
1. Edit `environments/dev/backend.tf` to configure your remote state (or comment the block to use local state).
2. Edit `environments/dev/terraform.tfvars` with your region/project.
3. `./scripts/init.sh` → `./scripts/plan.sh` → `./scripts/apply.sh`
4. Upload Glue scripts to `s3://{project}-{env}-lake/scripts/` (created by the S3 module).
5. Run Glue crawlers for Bronze/Silver/Gold, then trigger the jobs.

## Operate
- Use **AWS Glue Crawlers** to register tables in the Glue **Data Catalog**.
- Trigger jobs on demand or via **Step Functions**/**EventBridge** + **Lambda**.
- Query curated data using **Athena**.

## Security & Governance
- Tighten IAM policies to bucket/table ARNs (defaults are permissive for quick start).
- Consider **Lake Formation** for fine-grained access control.
- For ACID tables and easier schema evolution, evaluate **Apache Iceberg** with Glue Catalog.

## Structure
See repository tree in the project root for details.
