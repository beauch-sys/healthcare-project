# Data quality and validation

The following checks were recorded during project implementation. These are historical validation results, not claims of continuous automated monitoring.

| Check | Recorded result |
| --- | --- |
| PBJ daily staffing Bronze rows | 1,325,324 |
| PBJ daily average HPRD | Approximately 3.8439 |
| Provider facilities | 14,814 |
| Provider records with valid bed counts | 14,814 |
| Provider records with resident counts | 14,766 |
| Provider records with overall ratings | 14,671 |
| Provider records with staffing ratings | 14,613 |
| Provider records with latitude and longitude | 14,814 |
| Silver nursing-hour mismatches | 0 |
| Silver invalid contract utilization rates | 0 |
| Silver invalid census with HPRD | 0 |

Other observed data characteristics include a maximum daily HPRD near 193.08 in the raw PBJ data. Very large daily staffing variability coefficients were also observed in the dashboard; these values should be traced to source records, census denominators, and the implemented formula before being treated as substantive staffing findings.

## Pipeline verification

- Bronze conversion jobs produced nonempty Parquet outputs and success markers.
- Provider processing dates were corrected and validated.
- Changed-input and no-change pipeline scenarios were exercised successfully.
- All four published QuickSight visualizations loaded successfully.

## Future work

- Persist reproducible validation queries under `sql/`.
- Establish automated thresholds for missing identifiers, implausible HPRD, and extreme variability.
- Add failure notifications, recovery exercises, and operational monitoring.
