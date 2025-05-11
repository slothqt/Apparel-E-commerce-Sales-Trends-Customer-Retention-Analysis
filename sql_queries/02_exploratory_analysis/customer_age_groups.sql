/*
- Purpose: 
   1. Identify the youngest and oldest customers of each gender (from 01/2022-01/2025).
   2. Understand the age diversity of active users to support demographic-based analysis.
- Output: full_name, gender, age, tag (youngest-oldest)
- Analysis Steps:
   1. Find the youngest/oldest customers by each gender in two separate queries
   2. Combine them using the UNION ALL function  */

WITH age_segment AS (
  SELECT 
    first_name || ' ' || last_name AS full_name,
    gender,
    age,
    'youngest' AS tag
  FROM users as a
  WHERE age IN (SELECT MIN(age) FROM users GROUP BY gender)
    AND DATE(a.created_at) BETWEEN '2022-01-01' AND '2025-01-31'
  UNION ALL
  SELECT 
    first_name || ' ' || last_name AS full_name,
    gender,
    age,
    'oldest' AS tag
  FROM users as b
  WHERE age IN (SELECT MAX(age) FROM users GROUP BY gender)
    AND DATE(b.created_at) BETWEEN '2022-01-01' AND '2025-01-31')
  
-- Data is wrapped in a CTE for an additional analysis of number of customers for each segment    
  
SELECT DISTINCT tag, gender, age,
  COUNT(full_name) OVER (PARTITION BY gender, tag) AS count_customer
FROM age_segment
