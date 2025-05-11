/*
- Purpose: 
   1. Tracks customer return rate by cohort (from 01/2022 to 01/2025) over a 4-month period, based on their first purchase date.
   2. Measures how many users return in subsequent months to support analysis of customer loyalty and churn patterns.
- Output: cohort_date (yyyy-mm), month1, month2, month3, month4
- Analysis Steps (Divided into 5 main steps. Each step is wrapped in a CTE as a result for the subsequent steps)
   1. Identify Cohort Start: Determine each customer's first purchase date and select relevant fields.
   2. Calculate Time Index: Compute the number of months between each purchase and the customer’s cohort start date to track retention timing.
   3. Aggregate by Cohort and Index: Count distinct customers grouped by cohort month (cohort_date) and time index (index) to measure retention behavior.
   4. Reshape to Cohort Format: Use CASE-WHEN statements to present data like a Cohort Chart.
   5. Final Retention Table: Create the retention matrix to show returning customers (%) over time for each cohort. */

-- Step 1: Identify the first purchase date of each customer and select needed columns
-- Use Window function MIN() partitioned by user to determine the first purchase date

WITH T0 AS (
  SELECT
    order_id,
    product_id,
    sale_price,
    DATE(created_at) AS order_date,
    user_id
  FROM clean_data)

, T1 AS (
  SELECT
    user_id,
    sale_price,
    MIN(order_date) OVER (PARTITION BY user_id) AS first_purchase_date,
    order_date
  FROM T0
  ORDER BY user_id)

-- Step 2: Calculate the monthly difference between each purchase and the first purchase date
-- Use EXTRACT() function to calculate the monthly difference by taking the difference in years (multiplied by 12) and adding the difference in months

, T2 AS (
  SELECT
    user_id,
    sale_price,
    FORMAT_DATE('%Y-%m', first_purchase_date) AS cohort_date,
    order_date,
    (EXTRACT(YEAR FROM order_date) - EXTRACT(YEAR FROM first_purchase_date)) * 12 +
    (EXTRACT(MONTH FROM order_date) - EXTRACT(MONTH FROM first_purchase_date)) + 1 AS index
  FROM T1)

-- Step 3: Count distinct customers grouped by cohort_date and index

, T3 AS (
  SELECT
    cohort_date,
    index,
    COUNT(DISTINCT user_id) AS customer_count,
    ROUND(SUM(sale_price), 2) AS total_revenue
  FROM T2
  WHERE index <= 4
  GROUP BY cohort_date, index
  ORDER BY cohort_date)

-- Step 4: Present the data like a Cohort Chart with CASE-WHEN functions
-- Use CASE-WHEN functions to pivot the data, converting time index into labeled columns (m1-m4) for visual cohort representation

, T4 AS (
  SELECT
    cohort_date,
    SUM(CASE WHEN index = 1 THEN customer_count ELSE 0 END) AS m1,
    SUM(CASE WHEN index = 2 THEN customer_count ELSE 0 END) AS m2,
    SUM(CASE WHEN index = 3 THEN customer_count ELSE 0 END) AS m3,
    SUM(CASE WHEN index = 4 THEN customer_count ELSE 0 END) AS m4
  FROM T3
  GROUP BY cohort_date
  ORDER BY cohort_date)

-- Step 5: Retention Cohort Analysis
-- Determine customer retention rate over time by dividing the number of remaining customers in each month by the number in the first month (m1)

SELECT
  cohort_date,
  ROUND(m1/m1*100.00) AS m1,
  ROUND(m2/m1*100.00) AS m2,
  ROUND(m3/m1*100.00) AS m3,
  ROUND(m4/m1*100.00) AS m4
FROM T4
