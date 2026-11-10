-- Athena / Trino SQL | Gold: daily_staffing_variability
-- Execute statements individually in Athena.
-- Metric field names confirmed in QuickSight: avg_daily_hprd,
-- stddev_daily_hprd, hprd_coefficient_of_variation.

-- 1. Coverage
SELECT COUNT(*) AS row_count, COUNT(DISTINCT facility_id) AS distinct_facilities
FROM healthcare_gold.daily_staffing_variability;

-- 2. Missing facility information
SELECT COUNT(*) AS missing_facility_records
FROM healthcare_gold.daily_staffing_variability
WHERE facility_id IS NULL OR facility_name IS NULL OR TRIM(facility_name) = '';

-- 3. Duplicate facility / reporting period records
SELECT facility_id, year, quarter, COUNT(*) AS duplicate_count
FROM healthcare_gold.daily_staffing_variability
GROUP BY facility_id, year, quarter
HAVING COUNT(*) > 1;

-- 4. Negative variability inputs
SELECT facility_id, facility_name, year, quarter,
       avg_daily_hprd, stddev_daily_hprd, hprd_coefficient_of_variation
FROM healthcare_gold.daily_staffing_variability
WHERE avg_daily_hprd < 0 OR stddev_daily_hprd < 0
   OR hprd_coefficient_of_variation < 0;

-- 5. Examine largest coefficients; high values require investigation, not automatic rejection
SELECT facility_id, facility_name, year, quarter,
       avg_daily_hprd, stddev_daily_hprd, hprd_coefficient_of_variation,
       CASE WHEN avg_daily_hprd > 0
            THEN stddev_daily_hprd / avg_daily_hprd
            ELSE NULL END AS calculated_cv_ratio,
       CASE WHEN avg_daily_hprd > 0
            THEN 100.0 * stddev_daily_hprd / avg_daily_hprd
            ELSE NULL END AS calculated_cv_percent
FROM healthcare_gold.daily_staffing_variability
ORDER BY hprd_coefficient_of_variation DESC NULLS LAST
LIMIT 25;

-- 6. Zero average staffing with positive standard deviation
SELECT facility_id, facility_name, year, quarter,
       avg_daily_hprd, stddev_daily_hprd, hprd_coefficient_of_variation
FROM healthcare_gold.daily_staffing_variability
WHERE avg_daily_hprd = 0 AND stddev_daily_hprd > 0;
