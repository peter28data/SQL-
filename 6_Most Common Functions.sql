-- Window Functions
ROW_NUMBER()
DENSE RANK() OVER(ORDER BY salary DESC) AS row_num
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
-- Q1: Identify VIP users for Netflix 
-- They are defined as the most active in terms of the number of hours of content they watch. Write a SQL query that will retrieve the top 10 users with the most watched hours in the last month.
SELECT
user_id,
SUM(hours_watched) AS watch_hours
FROM watching_activity
WHERE date_time > DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y-%M-01') --The previous month
  
AND date_time < DATE_FORMAT(CURRENT_DATE, '%Y-%M-01')                         --The current day, to not return future values most likely
GROUP BY user_id
ORDER BY watch_hours DESC
LIMIT 2;


-- Q2: Analyzing Ratings for Netflix Shows
-- Calculate the average rating for each show within a given month.
SELECT
user_id,
MONTH(review_date) AS 'Month',
AVG(stars) aS average_rating
FROM show_reviews
GROUP BY MONTH(review_date), show_id
GROUP BY MONTH(review_date), average_rating DESC;


-- Q3: Filter Netflix Users Based on Viewing History and Subscription Status
-- Find all active customers who watched more than 10 episodes of a show called 'Stranger Things' in the last 30 days. This gives 4 criterias for the list of users. 
SELECT
u.user_id,
FROM users AS u
JOIN viewing_history AS vh 
ON u.user_id = vh.user_id
WHERE u.active = TRUE
AND s.show_name = 'Stranger Things'
AND vh.watch_date > CURDATE() - INTERVAL 30 DAY      -- The last 30 days
GROUP BY u.user_id
HAVING COUNT(DISTINCT vh.episode_id) > 10; 




-- Q4: Filter and Match Customer's Viewing Records
-- You are tasked with analyzing the customer's viewing records. You have gathered requirments related to your task and confirmed that management is interested in customers who have viewed more than five 'Documentary' movies within the last month. Taking into account that 'Documentary' could be a part of a broader genre category in the genre field (for example: 'Documentary, History'). Therefore the matching pattern could occur anywhere within the string. 
SELECT
c.name,
c.email
FROM customer AS c
JOIN movies AS m 
ON c.last_movie_watched = m.movie_id
WHERE m.genre LIKE '%Documentary%'
AND c.date_watched > CURRENT_DATE - INTERVAL 1 MONTH
GROUP BY c.name, c.email
HAVING COUNT(*) > 5;       -- More than 5 documentary movies


-------------------------------------------------------------------------------------------------
-- Q5: Explain the difference between GROUP BY and HAVING.
-- Use GROUP BY to group data and HAVING to filter aggreagated results 
SELECT
department_id,
COUNT(*) AS employee_count
FROM employees
GROUP BY department_id      -- Groups data by categories in 'department_id' column
HAVING COUNT(*) > 5         -- Filters groups with more than 5 counts of employees in departments

-- Q6: Explain the difference between INNER JOIN and OUTER JOIN.
-- INNER JOIN returns only matching records from Both tables whereas OUTER JOIN returns all records from both tables, matches where possible, and includes NULL values
SELECT
e.name,
d.department_name
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.department_id


-- Q7: Detect and returen duplicate rows in a table
SELECT
column1,
column2,
COUNT(*) AS count
FROM table1
GROUP BY column1, column2
HAVING COUNT(*) > 1;


-- Q8: What is a window function in SQL?
-- A window function performs calculations across a set of table rows related to the current row - without collapsing rows like GROUP BY.
ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS row_num -- each employee within the same department gets a row number based on salary rank (highest first)
RANK() OVER(PARTITION BY department ORDER BY  salary DESC) as rank_num -- if 2 employees have the same salary, both get rank 1, and the next gets rank 3.


-- Q9: Rank the top 3 performing products based on sales
SELECT
product_id,
product_name,
total_sales
FROM (
  SELECT 
  *,
  RANK() OVER(ORDER BY total_sales DESC) AS rank_num
  FROM sales_data) ranked_sales
WHERE rank_num <=3;


-- Q10: What is the difference between UNION and UNION ALL?
-- UNION removes duplicates when you want distinct rows and UNION ALL performs faster at scale because it keeps all rows including duplicates.
SELECT
city
FROM customers
UNION            -- Unique lists of cities
SELECT 
city
FROM vendors


-- Q11: How do you use CASE statement in SQL?
SELECT 
name,
salary,
CASE
WHEN salary >=100000 THEN 'High'
WHEN salary >=50000 THEN 'Medium'
ELSE salary 'Low'
END AS salary_category
FROM employees



-- Q12: Calculate the cumulative sum of sales.
SELECT
order_date,
product_id, 
sales_amount,
SUM(sales_amount) OVER (PARTITION BY product_id ORDER BY order_date) AS cumulative_sales
FROM sales;



-- Q13: What is a CTE (Common Table Expression), and how is it used?
-- A temporary result set that you can reference in a SQL query. It improves readability and simplifies complex queries to avoid repeating subqueries. 
WITH high_earners AS (
  SELECT
  emp_id,
  name,
  salary
  FROM employees
  WHERE salary > 100000)
SELECT *
FROM high_earners

























