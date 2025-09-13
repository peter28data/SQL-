------------------------------------- Data Associate Test -------------------------------------

-- Pearson Coefficient
-- Using a CTE to find the average sales price for all the years in the retail table for multiple retail locations to calculate the Pearson coefficient in the main query.
WITH sub_table AS (
  SELECT
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price ASC) AS median,
    AVG(price) AS mean,
    STDDEV(price) AS std_dev
  FROM retail
)

SELECT
  (3 * (mean - median))/std_dev AS Pearson_Coefficient
FROM sub_table;

--------------------------------------------------------------------------


-- Calculate Median
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Tenure) AS Median_Tenure
FROM customer;

--------------------------------------------------------------------------


-- Identify Usernames
-- Each username contains lowercase letters, digits, and some special characters, create a query to identify users whose username ends with a digit given the possible characters
SELECT
  username, first_name, last_name
FROM users
WHERE username ~ '[0-9]*';     --??

--------------------------------------------------------------------------


-- Get the Data Type
SELECT
  pg_typeof(amount_paid) AS "Data Type"    -- Double quotes perserves the space and proper case
FROM customers

--------------------------------------------------------------------------


-- Change the table
-- From CHAR data type to VARCHAR data type
ALTER TABLE employee
ALTER COLUMN employee_name TYPE VARCHAR

--------------------------------------------------------------------------


-- Return Month
-- In letter format such as september whereas extract would return the number format such as 9
TO_CHAR(event_time, 'Month') AS month_name

--------------------------------------------------------------------------


-- Return Month
-- In number format
EXTRACT(MONTH FROM sale_date)

--------------------------------------------------------------------------


-- oneline gaming service
-- information about each usernames remaining credits and account creation, write a query to view the average amount of credits for users whose accounts were created in each year
SELECT 
  TO_CHAR(created, 'YYYY') AS year,
  credits::DECIMAL (4,2) AS mean_credit
from accounts
group by year
order by year;

---------------------------------------------------------------------------------------------------------------
  

-- 2 TYPES of Functions
SELECT 
  DATE_PART('hour', date_created) AS hour,
  EXTRACT(month FROM date_created) AS month
FROM orders



































