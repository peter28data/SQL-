/*
Implement a methodical approach known as Statistical Process Control (SPC).
This approach uses statistics to determine the quality of a process. Processes are adjusted when outside of 3 standard deviations. 

Create an alert column to be a boolean flag if the height of a product is outside 3 standard deviations. Use a window function to calculate the positive and negative standard deviations otherwise known as upper and lower control limits. */

-- Flag whether the height of a product is within the control limits
SELECT
	b.*,
	CASE
		WHEN 
			b.height NOT BETWEEN b.lcl AND b.ucl
		THEN TRUE
		ELSE FALSE
	END as alert
-- Main Query: Has only SELECT above and FROM below:
FROM (
	select
		a.*, 
		a.avg_height + 3*a.stddev_height/SQRT(5) AS ucl, 
		a.avg_height - 3*a.stddev_height/SQRT(5) AS lcl  
	from (
		select 
			operator,
			ROW_NUMBER() OVER w AS row_number, 
			height, 
			AVG(height) OVER w AS avg_height, 
			STDDEV(height) OVER w AS stddev_height
		from manufacturing_parts 
		WINDOW w AS (
			PARTITION BY operator 
			ORDER BY item_no 
			ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
		)
	) AS a
	where a.row_number >= 5
) AS b;

----------------------------------------------------------------------------------

-- Window Functions
-- MIN/MAX can are available as window functions. In the case of retail, creating a new column with the minimum and maximum discount for different product IDs can be helpful for at-a-glance analysis.
SELECT
order_id,
product_id,
discount,
MIN(discount) over (partition by product_id) as min_discount,
MAX(discount) over (partition by product_id) as max_discount,
AVG(discount) over (partition by product_id) as avg_discount,

---------------------------------------------------------------------------------------
	
-- PARTITION BY
-- What if we want to compare each product's price with the average of that year? to do that we use the avg() window function and partition by the model year as such
SELECT
	model_year,
	product_name,
	list_price,
	AVG(list_price) OVER (partition by model_year) as avg_price
FROM products_table

-- Explanation: Notice how the avg_price of 2018 is exactly the same whether we use the partition by clause or the group by clause. Both of these queries return the same results but the Window functions free up the GROUP BY clause for other uses.
SELECT
	model_year,
	product_name,
	list_price,
	AVG(list_price) as avg_price
FROM products_table
GROUP BY model_year

	
-----------------------------------------------------------------------------------------

-- ORDER BY
SELECT
	product_name,
	list_price,
	ROW_NUMBER() over (order by list_price) as row_num,
	
	DENSE_RANK() over (order by list_price) as dense_rank,
	RANK() over (order by list_price desc) as rank,
	PERCENT_RANK() over (order by list_price) as pct_rank,
	
	NTILE(75) over (order by list_price) as ntile,
	CUME_DIST() over (order by list_price) as cume_dist
	
FROM products

---------------------------------------------------------------------------------------

-- Value Window Functions
SELECT
	product_name,
	list_price,
	FIRST_VALUE(list_price) over (order by list_price ROWS BETWEEN UNBOUNDED PRECEDING 
		AND UNBOUNDED FOLLOWING) as cheapest_price,

	LAST_VALUE(list_price) over (order by list_price ROWS BETWEEN UNBOUNDED PRECEDING
		AND UNBOUNDED FOLLOWING) as highest_price,

	NTH_VALUE(list_price,4) over (order by list_price ROWS BETWEEN UNBOUNDED PRECEDING
		AND UNBOUNDED FOLLOWING) as 4th_cheapest
FROM products

	

---------------------------------------------------------------------------------------
	
-- WINDOW Keyword
-- To reuse the same window with several window functions, defining a named window using the WINDOW keyword will appear after the HAVING section and before the ORDER BY section.
   SELECT
    window_function() OVER(window_name)
    FROM table_name

    WINDOW window_name AS (
         PARTITION BY partition_expression
         ORDER BY order_expression
         window_frame_extent
    )
  

---------------------------------------------------------------------------------------

-- WINDOW keyword




















