--question 1 a.
SELECT omp_customer_organization_id, SUM(omp_order_total_base)::int as total_sales
FROM sales_orders
GROUP BY omp_customer_organization_id
ORDER BY total_sales DESC

--question 1 b. How has the volume of work changed for each customer over time? Are there any seasonal patterns? How have the number of estimated hours per customer changed over time? Estimated hours are in the jmo_estimated_production_hours columns of the job_operations_2023/job_operations_2024 tables

--2. Analyze parts. The part can be identified by the jmp_part_id from the jobs table or the jmp_part_id from the job_operations_2023/job_operations_2024 tables. Here are some questions to get started:    
 --   a. Break down parts by volume of jobs. Which parts are making up the largest volume of jobs? Which ones are taking the largest amount of production hours (based on the jmo_actual_production_hours in the job_operations tables)?  
  --  b. How have the parts produced changed over time? Are there any trends? Are there parts that were prominent in 2023 but are no longer being produced or are being produced at much lower volumes in 2024? Have any new parts become more commonly produced over time?  
 --   c. Are there parts that frequently exceed their planned production hours (determined by comparing the jmo_estimated_production_hours to the jmo_actual_production_hours in the job_operations tables)?  
  --  d. Are the most high-volume parts also ones that are generating the most revenue per production hour?  

SELECT jmo_process_short_description as job_description, SUM(jmo_actual_production_hours) as production_hours
FROM job_operations_2023
GROUP BY jmo_process_short_description
ORDER BY production_hours DESC

SELECT jmo_process_short_description as job_description,  SUM(jmo_actual_production_hours) as production_hours
FROM job_operations_2023
GROUP BY jmo_process_short_description
ORDER BY production_hours DESC

SELECT jmo_job_operation_id, ROUND(SUM(jmo_actual_production_hours)::int,2) as actual_production_hours
FROM job_operations_2023
GROUP BY jmo_job_operation_id
ORDER BY actual_production_hours DESC

SELECT jmo_job_operation_id, ROUND(SUM(jmo_actual_production_hours)::int,2) as actual_production_hours
FROM job_operations_2024
GROUP BY jmo_job_operation_id
ORDER BY actual_production_hours DESC

SELECT jmo_job_operation_id, jmo_estimated_production_hours,
jmo_completed_production_hours, 
SUM(jmo_estimated_production_hours-jmo_completed_production_hours)::decimal as hours_difference
FROM job_operations_2023
GROUP BY jmo_job_operation_id, jmo_estimated_production_hours, jmo_completed_production_hours

SELECT j.jmp_customer_organization_id,j23.jmo_job_operation_id
FROM jobs as j
INNER JOIN job_operations_2023 as j23 ON j.jmp_job_id = j23.jmo_job_id


SELECT *
FROM jobs
INNER JOIN job_operations_2023 as j23 ON jobs.jmp_job_id = j23.jmo_job_id
INNER JOIN sales_order_job_links as sojl ON jobs.jmp_job_id = sojl.omj_job_id
INNER JOIN sales_orders as so ON so.omp_sales_order_id = sojl.omj_sales_order_id

-- Production hours vs Actual hours spent 2023
SELECT jmo_part_id, SUM(jmo_estimated_production_hours)::decimal as estimated_hours_2023, SUM(jmo_actual_production_hours)::decimal as actual_hours_2023, SUM(jmo_estimated_production_hours-jmo_actual_production_hours)::decimal as production_hours_difference_2023
FROM job_operations_2023
WHERE jmo_part_id IS NOT null AND jmo_actual_production_hours > jmo_estimated_production_hours
GROUP BY jmo_part_id
ORDER BY production_hours_difference_2023

-- Production hours vs Actual hours spend 2024
SELECT jmo_part_id, SUM(jmo_estimated_production_hours)::decimal as estimated_hours_2024, SUM(jmo_actual_production_hours)::decimal as actual_hours_2024, SUM(jmo_estimated_production_hours-jmo_actual_production_hours)::decimal as production_hours_difference_2024
FROM job_operations_2024
WHERE jmo_part_id IS NOT null AND jmo_actual_production_hours > jmo_estimated_production_hours
GROUP BY jmo_part_id
ORDER BY production_hours_difference_2024



SELECT jmo_part_id, COUNT(jmo_job_id) as total_parts, 
FROM job_operations_2023
GROUP BY jmo_part_id, jmo_actual_production_hours
ORDER By total_parts DESC

SELECT jmo_part_id, COUNT(jmo_part_id) as parts_count, jmo_completed_production_hours, jmo_actual_production_hours, omp_order_subtotal_base
FROM jobs
INNER JOIN job_operations_2023 as j23 ON jobs.jmp_job_id = j23.jmo_job_id
INNER JOIN sales_order_job_links as sojl ON jobs.jmp_job_id = sojl.omj_job_id
INNER JOIN sales_orders as so ON so.omp_sales_order_id = sojl.omj_sales_order_id
GROUP BY jmo_part_id, jmo_completed_production_hours,jmo_actual_production_hours,omp_order_subtotal_base
ORDER BY parts_count DESC

--
SELECT jmo_part_id, COUNT(jmo_part_id) as part_count, SUM(jmo_actual_production_hours)::decimal as total_production_hours, SUM(omp_order_subtotal_base)::decimal AS subtotal_base
FROM jobs
INNER JOIN job_operations_2023 as j23 ON jobs.jmp_job_id = j23.jmo_job_id
INNER JOIN sales_order_job_links as sojl ON jobs.jmp_job_id = sojl.omj_job_id
INNER JOIN sales_orders as so ON so.omp_sales_order_id = sojl.omj_sales_order_id
WHERE jmo_part_id IS NOT NULL
GROUP BY jmo_part_id, jmo_actual_production_hours, omp_order_subtotal_base

--3.  Jobs and Parts (Neal, Steven, Cameron, David, Hunter)

--Which Jobs are most common UNTIL OCTOBER 2023 ID COUNT

SELECT jmo_job_operation_id, COUNT(jmo_job_operation_id) as total_job_count_2023
FROM job_operations_2023
WHERE jmo_start_date >= '2023-01-01 00:00:00' AND jmo_start_date <= '2023-10-31 00:00:00'
GROUP BY jmo_job_operation_id
ORDER BY total_job_count_2023 DESC

--
SELECT jmo_job_operation_id, COUNT(jmo_job_operation_id) as total_job_count_2023
FROM job_operations_2023
WHERE jmo_start_date >= '2023-01-01 00:00:00' AND jmo_start_date <= '2023-10-31 00:00:00'
GROUP BY jmo_job_operation_id
ORDER BY total_job_count_2023 DESC

-- FULL 2023 ID COUNT
SELECT jmo_job_operation_id, COUNT(jmo_job_operation_id) as total_job_count_2023
FROM job_operations_2023
GROUP BY jmo_job_operation_id
ORDER BY total_job_count_2023 DESC

-- Until OCTOBER 2024 ID COUNT
SELECT jmo_job_operation_id, COUNT(jmo_job_operation_id) as total_job_count_2024
FROM job_operations_2024
WHERE jmo_start_date<= '2024-10-31 00:00:00'
GROUP BY jmo_job_operation_id
ORDER BY total_job_count_2024 DESC

-- Until FULL 2024 ID COUNT
SELECT jmo_job_operation_id, COUNT(jmo_job_operation_id) as total_job_count_2024
FROM job_operations_2024
GROUP BY jmo_job_operation_id
ORDER BY total_job_count_2024 DESC

--JOB DESCRIPTION COUNT OCTOBER 2023 SHORT DESCRIPTION COUNT
SELECT jmo_process_short_description, COUNT(jmo_process_short_description) as total_process_count_2023
FROM job_operations_2023
WHERE jmo_start_date>= '2023-01-01 00:00:00' AND jmo_start_date<= '2023-10-31 00:00:00'
GROUP BY jmo_process_short_description
ORDER BY total_process_count_2023 DESC

-- FULL 2023  SHORT DESCRIPTION COUNTS
SELECT jmo_process_short_description, COUNT(jmo_process_short_description) as total_process_count_2023
FROM job_operations_2023
GROUP BY jmo_process_short_description
ORDER BY total_process_count_2023 DESC

--UNTIL OCTOBER 2024 SHORT DESCRIPTION COUNTS
SELECT jmo_process_short_description, COUNT(jmo_process_short_description) as total_process_count_2024
FROM job_operations_2024
WHERE jmo_start_date<= '2024-10-31 00:00:00'
GROUP BY jmo_process_short_description
ORDER BY total_process_count_2024 DESC

--FULL 2024
SELECT jmo_process_short_description, COUNT(jmo_process_short_description) as total_process_count_2024
FROM job_operations_2024
GROUP BY jmo_process_short_description
ORDER BY total_process_count_2024 DESC

--------------------

SELECT jmo_job_operation_id, jmo_process_short_description
FROM job_operations_2023


SELECT y23.jmo_job_operation_id, y24.jmo_job_operation_id
FROM job_operations_2023 as y23
LEFT JOIN job_operations_2024 as y24 ON y23.jmo_job_id = y24.jmo_job_id

-- 10 - Laser Cutting/Laser Cut Print, 20 - Powder Coating/WELD/Manual Press Brake 30 - HOT DIPS Galvanizing/WRAP/Standard Inspection


SELECT *
FROM job_operations_2024
--Which Parts are most common
--Find completion time for top x jobs - Distribution (Boxplot)
--Find Jobs/Parts bottleneck if possible


SELECT jmo_job_id, jmo_process_id, jmo_process_short_description,jmo_created_date, jmo_inspection_status, jmo_inspection_complete, jmo_start_date, ujmo_pfmrelease_date
FROM job_operations_2023

SELECT jmo_process_long_description_text
FROM job_operations_2023
