# QuickSight dashboard

**Published dashboard:** Healthcare Nursing Home Staffing Dashboard  
**Analysis:** Healthcare Analysis  
**Data source:** Healthcare_Staffing_Athena  
**Database:** `healthcare_gold`  
**Query mode:** Athena Direct Query

| Chart | Visual type | Main field(s) | Selection |
| --- | --- | --- | --- |
| Top 10 Nursing Homes by Average Nursing HPRD | Horizontal bar | `facility_name`, AVG(`nursing_hprd`) | Top 10 by average HPRD |
| Top 10 Nursing Homes by Contract Labor Utilization (Under 100%) | Horizontal bar | `facility_name`, AVG(calculated utilization field) | Top 10 after excluding values >= 100 and missing/blank facility names in calculated field |
| Top 10 Nursing Homes by Daily Staffing Variability | Vertical column | `facility_name`, AVG(`hprd_coefficient_of_variation`) | Top 10 by average variability |
| Top 10 Nursing Homes with the Largest Weekend Staffing Reductions | Grouped vertical column | `facility_name`, AVG(`weekday_nursing_hprd`), AVG(`weekend_nursing_hprd`) | Bottom 10 by AVG(`nursing_hprd_difference`) |

## Important interpretation notes

- The contract labor utilization rate was displayed as a numeric percentage value because the source measure was already represented in percentage points.
- The contract chart's calculated field excludes null or blank names and utilization values at or above 100 **at the record level**; it does not necessarily exclude every facility that ever has a 100% record.
- `nursing_hprd_difference` = weekend HPRD − weekday HPRD, so negative values represent weekend reductions.
- The variability coefficient's scaling (ratio versus percent) should be confirmed against the actual Gold transformation before describing units.
- Only one quarter of data is currently available for the dashboard.

## Screenshot

Add a sanitized screenshot as `docs/dashboard.png`, then insert the image in the root README. Verify that the screenshot does not expose account identifiers or private information.
