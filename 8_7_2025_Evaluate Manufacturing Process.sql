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
FROM (
	SELECT
		a.*, 
		a.avg_height + 3*a.stddev_height/SQRT(5) AS ucl, 
		a.avg_height - 3*a.stddev_height/SQRT(5) AS lcl  
	FROM (
		SELECT 
			operator,
			ROW_NUMBER() OVER w AS row_number, 
			height, 
			AVG(height) OVER w AS avg_height, 
			STDDEV(height) OVER w AS stddev_height
		FROM manufacturing_parts 
		WINDOW w AS (
			PARTITION BY operator 
			ORDER BY item_no 
			ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
		)
	) AS a
	WHERE a.row_number >= 5
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

-- Returns the nth value in an ordered set of values



















