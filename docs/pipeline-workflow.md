# Pipeline workflow

## End-to-end sequence

1. **Ingest:** An AWS Glue Python Shell job retrieves the latest file matching each of five source patterns from Google Drive and places files under S3 `data/`.
2. **Bronze:** Five AWS Glue conversion jobs transform source CSV files to Parquet in run-specific S3 Bronze paths and produce `_SUCCESS` markers.
3. **Catalog and inspect:** AWS Glue Data Catalog / Athena expose Bronze datasets for SQL inspection.
4. **Silver:** AWS Glue transformation jobs create a facility dimension, reporting interval dimension, and daily PBJ staffing fact.
5. **Gold:** AWS Glue jobs create four metrics: Nursing HPRD, Contract Labor Utilization, Daily Staffing Variability, and Weekend vs. Weekday Staffing.
6. **Analyze:** Athena queries the Gold datasets; QuickSight uses Direct Query to render the published dashboard.

## Scheduling

- Workflow: `healthcare_staffing_pipeline`
- Frequency: daily
- Scheduled time: 06:00 UTC
- Maximum concurrent workflow runs: 1
- Recorded processing baseline: `20261110T153545Z`

## Verified behavior

The workflow was tested with unchanged and changed source files. The recorded baseline supports change-aware processing. Additional operational failure/retry testing remains to be done.

## Implementation details to add

Before sharing the repository as a fully reproducible project, include the actual Glue job scripts, Glue job configuration, dependency packaging, and IAM policy templates with all sensitive identifiers removed. Document how to deploy and initialize the workflow from a clean AWS account.
