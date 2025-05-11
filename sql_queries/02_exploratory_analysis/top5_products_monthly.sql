/*
- Purpose: 
   1. Ranks products by monthly profit and returns the top 5 per month (from 01/2022-01/2025)
   2. Identifies most popular items to help with inventory, marketing, and trend analysis.
- Output: month_year (yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
- Analysis Steps (Divided into 2 steps):
   1. Base metrics calculation:
    - month_year: format dates with FORMAT_DATE() function
    - sales, cost, profit: aggregate them with SUM() and GROUP BY, then use ROUND() function to round the numbers to 2 decimal places
    - rank_per_month: use DENSE_RANK() function without skips in the ranking
   2. Final filtering: Wrap Step 1 in CTE and filter top 5 products per month (rank <= 5) */

WITH rank_table AS (
  SELECT *,
    DENSE_RANK() OVER (PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month
  FROM (
    SELECT
      FORMAT_DATE('%Y-%m', DATE(a.created_at)) AS month_year,
      a.product_id, 
      b.name AS product_name,
      ROUND(SUM(a.sale_price), 2) AS sales,
      ROUND(SUM(b.cost), 2) AS cost,
      ROUND(SUM(a.sale_price - b.cost), 2) AS profit
    FROM order_items AS a
    INNER JOIN products AS b
      ON a.product_id = b.id
    WHERE a.created_at BETWEEN '2022-01-01' AND '2025-01-31'
    GROUP BY FORMAT_DATE('%Y-%m', DATE(a.created_at)), a.product_id, b.name) AS l
  ORDER BY month_year)

SELECT * FROM rank_table
WHERE rank_per_month <= 5
