------------------------------------- Data Associate Test -------------------------------------

-- Pearson Coefficient
-- Using a CTE to find the average sales price for all the years in the retail table for multiple retail locations to calculate the Pearson coefficient in the main query.
WITH sub_table AS (
  SELECT
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY price ASC) AS median, -- Calculate Median

    AVG(price) AS mean,
    STDDEV(price) AS std_dev
  FROM retail
)

SELECT
  (3 * (mean - median))/std_dev AS Pearson_Coefficient
FROM sub_table;

--------------------------------------------------------------------------


-- Identify Usernames
-- Each username contains lowercase letters, digits, and some special characters, create a query to identify users whose username Ends with a digit given the possible characters
SELECT
  username, first_name, last_name
FROM users
WHERE username ~ '[0-9]$';     -- john9x would not work bc it ends with x, the '$'  matches the end

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


-- Online Gaming service
-- information about each usernames remaining credits and account creation, write a query to view the average amount of credits for users whose accounts were created in each year
SELECT 
  TO_CHAR(created, 'YYYY') AS year,
  credits::DECIMAL (4,2) AS mean_credit
from accounts
group by year    -- Can only group by year since it is a text data type
order by year;

---------------------------------------------------------------------------------------------------------------
  
-- 2 TYPES of Functions
SELECT 
  -- Letter Format: Converts to String
  TO_CHAR(created, 'Day') AS day    -- Returns: Friday
  -- Numer Format: PostgreSQL specific funtion
  DATE_PART('hour', date_created) AS hour,
  -- Number Format: Standard SQL function
  EXTRACT(month FROM date_created) AS month
  -- Extract Title: Can be done by splitting the string
  SPLIT_PART(title,':',1) AS name,    -- variable, delimiter, before or after
  
FROM orders

--------------------------------------------------------------------------








































