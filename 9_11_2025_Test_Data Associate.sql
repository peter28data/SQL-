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

UPDATE accounts
  SET user_name = REGEXP_REPLACE(username, '[0-9]', '', 'g');   -- 'g' is a global flag that ensures all digits are removed, not just the first. 




-- Replace with Average
SELECT
  COALESCE(audience_score, (SELECT AVG(audience_score) FROM movies)) AS audience_score
FROM movies


-- Contains Underscore
SELECT 
  first_name, last_name
FROM users
  
WHERE username LIKE '%!_%' ESCAPE '!';

-- % Matches any number of characters
-- !_ Escapes the underscore to match a literal underscore
-- ESCAPE '!' Tells SQL that ! is the escape character


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

-- Combine Tables
-- Union ALL allows for two select statements and allows for duplicates which is important to count whether each song appears once or twice in two tables of popular tracks in Europe and North America.
SELECT name, COUNT(*) FROM
  (SELECT name FROM top_eu_tracks
  
  UNION ALL 
  
  SELECT song_name FROM top_na_tracks
  ORDER BY name DESC) AS all_tracks

GROUP BY name
ORDER BY all_tracks, name
LIMIT 5;


--------------------------------------------------------------------------------------------------------------


-- First Letter
-- Extract the name of artists that start with a vowel
SELECT DISTINCT name
FROM artists
WHERE LEFT(name, 1) IN ('A', 'E', 'I', 'O', 'U')

ORDER BY name
LIMIT 7;


--------------------------------------------------------------------------------------------------------------

  
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
  -- Combine Strings
  CONCAT(vendor_city,', ',vendor_state) AS location
  -- Number of Characters
  LENGTH(title) AS title_length
  -- Second Genre
  genre[2] as second_genre,
  -- 4 numbers total, 2 decimals
  credits::DECIMAL (4,2) AS mean_credit
  
FROM orders
WHERE vendor_city IN ('SEATTLE', 'AUSTIN') 
  OR installation_date NOT BETWEEN '2013-01-01' AND '2013-12-31'
  OR 'Reggaeton' = ANY(genre)    -- 'Reggaeton' appears in Any Element of the genre array
ORDER BY title_length DESC

--------------------------------------------------------------------------

-- Visualization Choice

-- Is a scatterplot, pivot table, or line graph best visualization to create an aggregation of numeric values across two categorical dimensions?

-- Pivot Table: One numeric measure such as sales, count, or profit, aggregated by SUM, AVG, COUNT, and broken down by two categorical dimensions such as Region and Product Type.

-- Bar Chart: Compares categories such as Region and Product Type

-- Histogram: Show the distribution of a numeric variable such as age, groups data into bins, and shows the frequency within each bin. By overlaying two histograms you can compare two populations or use Density Plots.


--------------------------------------------------------------------------

-- 9/16/2025

-- Analyze Customer Feedback
SELECT
  ROUND(AVG(rating),2) AS average_rating,
  ROUND(STDDEV(rating),2) AS standard_deviation
FROM customer_reviews;


--------------------------------------------------------------------------

-- Caloric Intake
SELECT
  ROUND(AVG(caloric_intake),2) AS average_caloric_intake,
  ROUND(STDDEV(rating),2) AS caloric_sd
FROM nutritional_study;


--------------------------------------------------------------------------

-- Education Analyst
-- To understand the overall variance var_pop is used, and var_samp can be used if you are analyzing for example, 50 randome selected students out of 100. A Low Variance means scores are clustered closely and show more consistent grading.
SELECT
  VAR_POP(score),
  VAR_SAMP(score
FROM exam_results;


--------------------------------------------------------------------------

-- Revies after End_date
-- This is to find rows where the condition is violated for validation or cleanup
SELECT project_id, review_date, end_date
FROM employee_projects AS ep
WHERE review_date <= (
  SELECT MAX(end_date)
  FROM employee_projects
  WHERE project_id = ep.project_id);

-- This table tracks the projects assigned to employees in a company. The query is to ensure that for each project id, the review date is always After the end date of the Latest end date for that project ID. 
--------------------------------------------------------------------------

-- Two Tables

WITH subquery AS (
  SELECT 
    movie_id,
    SUM(total_views) all_views,
    SUM(total_minutes) all_minutes
  FROM viewings
  GROUP BY movie_id
  WHERE ____) 

SELECT 
  a.movie_name,
  FLOOR(b.all_minutes / a.movie_length) AS full_views
FROM movies AS a
JOIN movie_views AS b
ON a.movie_id = b.movie_id
WHERE FLOOR(b.all_minutes / a.movie_length) < 600;








































