# Athena SQL Validation Queries

These SQL scripts provide reproducible data-quality and reconciliation checks for the four Gold tables in `healthcare_gold` used by the Amazon QuickSight nursing home staffing dashboard.

## How to run

1. Open **Amazon Athena** in the correct AWS region and select the configured query result location/workgroup.
2. Choose the AWS Glue Data Catalog and database `healthcare_gold`.
3. Open one `.sql` file and execute **one statement at a time**.
4. Record the date, row counts, unexpected records, and any investigated exceptions. Athena does not necessarily execute all semicolon-separated statements as a batch in the console.

## Files

| File | Validations |
|---|---|
| `01_nursing_hprd_validation.sql` | Coverage, missing facilities, duplicate facility-periods, negative HPRD, extreme HPRD review |
| `02_contract_labor_utilization_validation.sql` | Coverage, missing facilities, duplicate facility-periods, percentage bounds, invalid hours, 100% utilization review |
| `03_daily_staffing_variability_validation.sql` | Coverage, missing facilities, duplicate facility-periods, negative values, high-CV investigation, zero-mean anomalies |
| `04_weekend_weekday_staffing_validation.sql` | Coverage, missing facilities, duplicate facility-periods, negative HPRD, difference reconciliation, weekend reductions |

## Interpretation

- Missing-key and duplicate queries should ideally return **zero rows**, unless the Gold table is intentionally at a different grain.
- Negative-value and calculation mismatch queries should ideally return **zero rows**.
- Extreme HPRD, 100% contract utilization, and high coefficients of variation are **investigation queries**, not proof of errors.
- `hprd_coefficient_of_variation` may be stored as a ratio or as a percentage; the variability script shows both recomputations for comparison.
- The weekend difference is defined as **weekend HPRD minus weekday HPRD**. Negative values indicate lower weekend staffing.
- The contract utilization rates are stored as **whole percentages** (e.g., 25 means 25%).
- The queries have been drafted against the field names discussed in this project, but have **not been executed against your Athena catalog**. Confirm the current schema before treating any check as passed.

## Portfolio guidance

Publish the scripts alongside the AWS Glue job source code. Do not publish secrets, credentials, private URLs, or real account-specific configuration. Add a separate sanitized validation-results document after executing the checks.
