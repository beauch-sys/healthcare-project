-- Athena / Trino SQL | Gold: nursing_hprd
-- Execute statements individually in Athena.
-- A zero count indicates the corresponding check passed.

-- 1. Table volume and coverage
SELECT COUNT(*) AS row_count,
       COUNT(DISTINCT facility_id) AS distinct_facilities,
       COUNT(DISTINCT CONCAT(CAST(year AS VARCHAR), '-', CAST(quarter AS VARCHAR))) AS reporting_periods
FROM healthcare_gold.nursing_hprd;

-- 2. Missing facility keys or names
SELECT COUNT(*) AS missing_facility_records
FROM healthcare_gold.nursing_hprd
WHERE facility_id IS NULL OR facility_name IS NULL OR TRIM(facility_name) = '';

-- 3. Duplicate facility / reporting period records
SELECT facility_id, year, quarter, COUNT(*) AS duplicate_count
FROM healthcare_gold.nursing_hprd
GROUP BY facility_id, year, quarter
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 4. Negative HPRD values or invalid denominator
SELECT facility_id, facility_name, year, quarter, nursing_hprd, valid_census_days
FROM healthcare_gold.nursing_hprd
WHERE nursing_hprd < 0 OR valid_census_days < 0;

-- 5. Investigate extreme HPRD values (review threshold; not automatically errors)
SELECT facility_id, facility_name, year, quarter, nursing_hprd
FROM healthcare_gold.nursing_hprd
WHERE nursing_hprd > 24
ORDER BY nursing_hprd DESC;
