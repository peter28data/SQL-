-- Window Functions
ROW_NUMBER()
RANK() OVER(ORDER BY salary DESC) AS row_num
LAG(sales_amount, 1) OVER(ORDER BY order_date) AS prev_day_sale


-- String Functions
TRIM()
LOWER()
REPLACE()

-- Date Functions
CURRENT_DATE()  /  NOW()         --current date/time
DATEDIFF()  /  TIMESTAMPDIFF()    --Difference between two dates
EXTRACT(MONTH FROM date_joined)   --Extract month number
LAST_DAY()                        --Last day of the month


-- Conditional Functions
IF()  / CASE()              -- Conditional logic
COALESCE()                  -- First non-null value in a list
NULLIF()                    -- Return NULL if two values are equal
IFNULL()  /   ISNULL()      -- Check if a value is NULL


-- Filtering Functions
IN() NOT IN()
WHERE EXISTS()
LIKE  /  NOT LIKE  /  ILIKE
BETWEEN  /  NOT BETWEEN


-------------------------------------------------------------------------------------------------
-- Q1: Identify VIP users for Netflix by identifying 
-- They are defined as the most active in terms of the number of hours of content they watch. Write a SQL query that will retrieve the top 10 users with the most watched hours in the last month.
SELECT
user_id,
SUM(hours_watched) AS watch_hours
FROM watching_activity
WHERE date_time > DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y-%M-01')
AND date_time < DATE_FORMAT(CURRENT_DATE, '%Y-%M-01')
GROUP BY user_id
ORDER BY watch_hours DESC
LIMIT 2;












