-- Purpose: Prepare data for analysis for two tables: orders, order_items
-- Steps:
--   1. Join two tables and extract needed columns
--   2. Check for null values and invalid entries
--   3. Remove duplicates

WITH check_valid AS (
  SELECT
    a.order_id AS order_id,
    b.product_id,
    a.user_id AS user_id,
    a.num_of_item AS num_of_item,
    a.created_at AS created_at,
    round(b.sale_price,2) AS sale_price,
  FROM orders AS a
  JOIN order_items AS b
    ON a.order_id=b.order_id
  WHERE a.user_id is not null 
    AND a.num_of_item>0 AND b.sale_price>0
    AND a.status='Complete')
, clean_data AS (
    SELECT * FROM (
      SELECT *,
        ROW_NUMBER() OVER (PARTITION BY order_id, product_id, num_of_item ORDER BY created_at) AS stt
      FROM check_valid) AS g
    WHERE stt=1)
