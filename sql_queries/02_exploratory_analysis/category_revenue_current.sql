/*
- Purpose: 
   1. Calculate how much revenue each category has generated daily over time (in the last 3 months until 10/02/2025)
   2. Evaluate and compare category performance and business focus.
- Output: product_category, dates (yyyy-mm-dd), revenue
- Analysis Steps:
   1. Join two tables: order_items and products to get needed fields
   2. Aggregate sale_price field with SUM() and GROUP BY to calculate revenue */

SELECT 
	b.category as product_category,
	DATE(a.created_at) as dates,
	ROUND(SUM(a.sale_price),2) as revenue
FROM order_items as a
INNER JOIN products as b
	ON a.product_id = b.id
WHERE DATE(a.created_at) BETWEEN date_sub('2025-02-10',interval 3 month) and '2025-02-10'
GROUP BY 2,1
ORDER BY 1,2
