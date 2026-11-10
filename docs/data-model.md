# Data model

## Bronze

Five source families are ingested from Google Drive into S3 `data/`, then converted to Parquet under `bronze/<dataset>/runs/<timestamp>/`. The source families are PBJ daily nurse staffing, data collection intervals, provider information, quality measures (MDS), and state/US averages.

## Silver

| Logical model | Description |
| --- | --- |
| Facility dimension | Facility identifier and provider attributes including ratings, beds, and location |
| Reporting interval dimension | Reporting quarter and four-quarter average metadata |
| PBJ daily staffing fact | Resident census, total nursing hours, employee hours, contract hours, and nursing HPRD |

## Gold

| Dataset | Key measures used in the dashboard |
| --- | --- |
| `nursing_hprd` | `nursing_hprd`, `facility_name` |
| `contract_labor_utilization` | `contract_utilization_rate`, `facility_name` |
| `daily_staffing_variability` | `avg_daily_hprd`, `stddev_daily_hprd`, `hprd_coefficient_of_variation` |
| `weekend_weekday_staffing` | `weekday_nursing_hprd`, `weekend_nursing_hprd`, `nursing_hprd_difference` |

The staffing-difference field is **weekend HPRD minus weekday HPRD**; negative values indicate lower staffing on weekends. This direction was checked against Athena query output.

## Modeling considerations

- HPRD is hours of nursing staffing per resident day.
- Coefficient of variation compares standard deviation of daily HPRD to its average. Verify whether the implemented metric is expressed as a ratio or percentage before labeling the chart axis.
- Gold tables can contain facility/year/quarter records. Aggregation choices in QuickSight should be interpreted in that context.

> The precise SQL/Glue transformation expressions and physical column schemas should be added from deployed job code rather than inferred from dashboard fields.
