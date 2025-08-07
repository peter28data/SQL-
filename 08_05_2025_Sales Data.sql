
-- Find the top 5 products
-- Based on total sales
-- From each Category


---------------------------------------------------------------------------------------------

-- First SQL cell
-- top_five_products_each_category
-- Sorted by category in ascending order

SELECT * FROM (
SELECT products.category, 
	products.product_name,
  	ROUND(SUM(CAST(ord.sales AS NUMERIC)), 2) AS product_total_sales,
	ROUND(SUM(CAST(ord.profit AS NUMERIC)), 2) AS product_total_profit,
	
	RANK() OVER(PARTITION BY products.category ORDER BY SUM(ord.sales) DESC) AS product_rank
	FROM orders AS ordr
	INNER JOIN products
		ON ord.product_id = products.product_id
	GROUP BY products.category, products.product_name
) AS tmp
WHERE product_rank < 6;



---------------------------------------------------------------------------------------------

-- Second SQL cell
-- impute_missing_values
-- Calculate the Quantity for orders with Missing values
-- By determining the unit price

WITH missing AS (
	SELECT product_id,
		discount, 
		market,
		region,
		sales,
		quantity
	FROM orders 
	WHERE quantity IS NULL), 

unit_prices AS (SELECT o.product_id,
	CAST(o.sales / o.quantity AS NUMERIC) AS unit_price
FROM orders o
RIGHT JOIN missing AS m 
	ON o.product_id = m.product_id
	AND o.discount = m.discount
WHERE o.quantity IS NOT NULL)

	
SELECT DISTINCT m.*,    -- everything from 'missing' CTE
	ROUND(CAST(m.sales AS NUMERIC) / up.unit_price,0) AS calculated_quantity
FROM missing AS m
INNER JOIN unit_prices AS up
	ON m.product_id = up.product_id;


-- Summary: The sales data is written as 'double precision' data type so it is converted to numeric data type first then divided by the unit price from the final query's Inner Join clause. Even though unit_prices is a CTE, it is given an alias in the final query.
---------------------------------------------------------------------------------------------


-- How it Works: First we find rows with missing quantity and set that aside with a CTE. Then we use a second CTE to calculate the unit price from product id's that are not missing, this way we can calculate the unit price for product id's with quantity data missing. Lastly, in the third query we create a new column 'calculated_quantity' to divide the sales by the unit price and round to the whole number. 

-- Impute the NULL Quanitities
UPDATE orders
SET quantity = ROUND(o.sales / up.unit_price)
FROM (
	SELECT
	o1.product_id,
	ol.discount,
	AVG(CAST(o1.sales / o1.quantity AS NUMERIC)) AS unit_price
	FROM orders o1
	WHERE o1.quantity IS NOT NULL
	GROUP BY o1.product_id, o1.discount 
	) AS up
WHERE orders.quantity IS NULL
AND orders.product_id = up.product_id
AND orders.discount = up.discount;

---------------------------------------------------------------------------------------------
