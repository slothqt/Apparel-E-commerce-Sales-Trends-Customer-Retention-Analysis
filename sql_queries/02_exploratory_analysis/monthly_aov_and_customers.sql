/* 
- Purpose: 
   1. Analyze customer value and engagement by month (from 01/2022-01/2025)
   2. Identify trends in spending behavior
- Output: month_year (yyyy-mm), average_order_value, value_growth, total_user, customer_growth 
- Analysis Steps: Steps are conducted similar to that of monthly_orders_customers.sql */

WITH T1 AS (
  SELECT
    FORMAT_DATE('%Y-%m', DATE(created_at)) AS month_year,
    COUNT(DISTINCT user_id) AS total_user,
    ROUND(SUM(sale_price)/COUNT(order_id), 2) AS average_order_value
  FROM clean_data
  WHERE FORMAT_DATE('%Y-%m', DATE(created_at)) BETWEEN '2022-01' AND '2025-01'
  GROUP BY 1
  ORDER BY 1)

SELECT 
  month_year,
  average_order_value,
  COALESCE(ROUND(100.00 * (average_order_value - previous_avg_value) / previous_avg_value, 2), 0.00) AS value_growth,
  total_user,
  COALESCE(ROUND(100.00 * (total_user - previous_customer) / previous_customer, 2), 0.00) AS customer_growth
FROM (
  SELECT 
    month_year,
    average_order_value,
    LAG(average_order_value) OVER (ORDER BY month_year) AS previous_avg_value, 
    total_user,
    LAG(total_user) OVER (ORDER BY month_year) AS previous_customer
  FROM T1) AS T2
