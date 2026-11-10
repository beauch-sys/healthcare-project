-- Athena / Trino SQL | Gold: contract_labor_utilization
-- Execute statements individually in Athena.

-- 1. Row count and facilities
SELECT COUNT(*) AS row_count, COUNT(DISTINCT facility_id) AS distinct_facilities
FROM healthcare_gold.contract_labor_utilization;

-- 2. Missing facility identification
SELECT COUNT(*) AS missing_facility_records
FROM healthcare_gold.contract_labor_utilization
WHERE facility_id IS NULL OR facility_name IS NULL OR TRIM(facility_name) = '';

-- 3. Duplicate facility / reporting period records
SELECT facility_id, year, quarter, COUNT(*) AS duplicate_count
FROM healthcare_gold.contract_labor_utilization
GROUP BY facility_id, year, quarter
HAVING COUNT(*) > 1;

-- 4. Percentages outside expected 0-100 range
-- Percentages in this table are stored as whole percent values (e.g. 25 for 25%).
SELECT facility_id, facility_name, year, quarter,
       contract_utilization_rate, employee_utilization_rate, combined_utilization_rate
FROM healthcare_gold.contract_labor_utilization
WHERE contract_utilization_rate NOT BETWEEN 0 AND 100
   OR employee_utilization_rate NOT BETWEEN 0 AND 100
   OR combined_utilization_rate NOT BETWEEN 0 AND 100;

-- 5. Negative staffing hours and impossible staffing day counts
SELECT facility_id, facility_name, year, quarter,
       total_contract_hours, total_employee_hours, total_nursing_hours,
       total_staffing_days, zero_staffing_days
FROM healthcare_gold.contract_labor_utilization
WHERE total_contract_hours < 0 OR total_employee_hours < 0
   OR total_nursing_hours < 0 OR total_staffing_days < 0
   OR zero_staffing_days < 0 OR zero_staffing_days > total_staffing_days;

-- 6. Review 100% contract utilization facilities (not necessarily errors)
SELECT facility_id, facility_name, year, quarter, contract_utilization_rate
FROM healthcare_gold.contract_labor_utilization
WHERE contract_utilization_rate = 100
ORDER BY facility_name;
