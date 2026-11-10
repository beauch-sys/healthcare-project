-- Athena / Trino SQL | Gold: weekend_weekday_staffing
-- Execute statements individually in Athena.
-- Difference direction confirmed: weekend_nursing_hprd - weekday_nursing_hprd.

-- 1. Row count and facilities
SELECT COUNT(*) AS row_count, COUNT(DISTINCT facility_id) AS distinct_facilities
FROM healthcare_gold.weekend_weekday_staffing;

-- 2. Missing facility names
SELECT COUNT(*) AS missing_facility_records
FROM healthcare_gold.weekend_weekday_staffing
WHERE facility_id IS NULL OR facility_name IS NULL OR TRIM(facility_name) = '';

-- 3. Duplicate facility / reporting period records
SELECT facility_id, year, quarter, COUNT(*) AS duplicate_count
FROM healthcare_gold.weekend_weekday_staffing
GROUP BY facility_id, year, quarter
HAVING COUNT(*) > 1;

-- 4. Negative nursing HPRD
SELECT facility_id, facility_name, year, quarter,
       weekday_nursing_hprd, weekend_nursing_hprd
FROM healthcare_gold.weekend_weekday_staffing
WHERE weekday_nursing_hprd < 0 OR weekend_nursing_hprd < 0;

-- 5. Check stored difference against weekend minus weekday (allow tiny rounding error)
SELECT facility_id, facility_name, year, quarter,
       weekday_nursing_hprd, weekend_nursing_hprd, nursing_hprd_difference,
       weekend_nursing_hprd - weekday_nursing_hprd AS recomputed_difference
FROM healthcare_gold.weekend_weekday_staffing
WHERE weekday_nursing_hprd IS NOT NULL
  AND weekend_nursing_hprd IS NOT NULL
  AND nursing_hprd_difference IS NOT NULL
  AND ABS(nursing_hprd_difference - (weekend_nursing_hprd - weekday_nursing_hprd)) > 0.000001;

-- 6. Largest weekend reductions (most negative differences)
SELECT facility_id, facility_name, year, quarter,
       weekday_nursing_hprd, weekend_nursing_hprd, nursing_hprd_difference
FROM healthcare_gold.weekend_weekday_staffing
WHERE facility_name IS NOT NULL AND nursing_hprd_difference < 0
ORDER BY nursing_hprd_difference ASC
LIMIT 10;
