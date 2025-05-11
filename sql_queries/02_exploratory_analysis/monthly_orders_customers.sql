/*
- Purpose: 
   1. Analyze total unique customers and number of orders completed monthly (from 01/2022-01/2025)
   2. Calculate MoM growth rates for orders and customers
- Output: month_year (yyyy-mm) , total_user, customer_growth, total_order, order_growth
- Analysis Steps:
   1. Data is retrieved from CTE "clean_data" (from cleaning step in sql_analysis/data_preparation/orders and order_items tables.sql)
   2. LAG() window function adds previous month's customer/order counts
   3. This data is wrapped in subquery to calculate month-over-month percentage growth rates */

WITH T1 AS (
  SELECT
    FORMAT_DATE('%Y-%m',DATE(created_at)) AS month_year,
    COUNT(DISTINCT user_id) AS total_user,
    COUNT(DISTINCT order_id) AS total_order
  FROM clean_data
  WHERE FORMAT_DATE('%Y-%m',DATE(created_at)) BETWEEN '2022-01' AND '2025-01'
  GROUP BY 1
  ORDER BY 1)
  
SELECT 
  month_year,
  total_user,
  COALESCE(ROUND(100.00 * (total_user - previous_customer) / previous_customer,2), 0.00) AS customer_growth,
  total_order,
  COALESCE(ROUND(100.00 * (total_order - previous_order) / previous_order,2), 0.00) AS order_growth
FROM (
  SELECT
    month_year,
    total_user,
    LAG(total_user) OVER (ORDER BY month_year) AS previous_customer, 
    total_order,
    LAG(total_order) OVER (ORDER BY month_year) AS previous_order
  FROM T1) AS T2
