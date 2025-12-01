-- #1 Navigating Databases
-- To navigate hundreds of tables for the right columns of data it would be inefficient to pull each file individually. An efficient way is to query the list of tables to return schema name, table name, and table owner such as Postgres.
SELECT *
FROM pg_catalog.pg.tables
WHERE schemaname = 'public';


-- VIEW columns from tables
CREATE VIEW table_columns AS 
SELECT
  table_name,
  STRING_AGG(column_name, ', ') AS columns
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name;
SELECT *
FROM table_columns

  
-- #2 Query for Student Performance
-- Group students by ranges of hours studied and calculate the average exam score for each group.
SELECT
CASE
WHEN hours_studied BETWEEN 1 AND 5 THEN '1-5 Hours'
WHEN hours_studied BETWEEN 1 AND 5 THEN '6-10 Hours'
WHEN hours_studied BETWEEN 1 AND 5 THEN '11-15 Hours'
ELSE '16+ Hours'
END AS hours_studied_range,
AVG(exam_score) AS avg_exam_score      -- Calculates the average exam score 
FROM student_performance
GROUP BY hours_studied_range           -- Groups by KPI (hours studied)
ORDER BY avg_exam_score DESC; 



-- #3 Ranking Exam Scores Based on Extracurricular activities
SELECT
attendance,
hour_studied,
sleep_hours,
tutoring_sessions
DENSE_RANK() OVER (ORDER BY exam_score DESC) AS exam_rank
FROM student_performance
ORDER BY exam_rank ASC
LIMIT 30;



-- #4 Who are our most Active Students?
--Calculate the average exam score of students who studied more than 10 hours and participated in extracurricular activities.
SELECT
hours_studied,
AVG(exam_score) AS avg_exam_score
WHERE hours_studied > 10
AND extracurricular_activites = 'Yes'
GROUP BY hours_studied
ORDER BY hours_studied DESC;




--------------------------------------------------------------------------------------------------

-- Q5: Aggregating Salary Range
-- Show employee names of people that have salaries less than the average.
SELECT
e.employee_name,
i.salary
FROM employee AS e, employee_info AS i
WHERE e.employee_id = i.employee_id
AND i.salary < (
  SELECT AVG(salary)         -- This is a subquery to filter for employee less than the average
  FROM employee_info);



-- Q6: Data Cleaning for Outliers
-- This query identifies outliers by selecting salaries outside of 3 standard deviation from the average. 
SELECT *
FROM employee_info
WHERE salary > (
  SELECT AVG(salary) + 3 * STDDEV(salary)
  FROM employee_info)
OR salary < (
  SELECT AVG(salary) - 3 * STDDEV(salary)
  FROM employee_info);




-- Find Peason correlation 
SELECT CORR(assets, equity)

-- Find Median / Average
SELECT percentile_disc(0.5) WITHIN GROUP (ORDER BY column_name) -- value that exists
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY column_name) -- interpolates between values

-- Skewness from avergage inventory volume
SELECT
VARIANCE(question_pct)      -- Returns sample variance
VAR_POP(question_pct)       -- Returns population variance



-- Creating temporary tables
CREATE TEMP TABLE newtablename 
SELECT
column1, column2
FROM table1;

-- Insert new rows into temp table
INSERT INTO top_companies
SELECT rank, title

-- Delete Table
DROP TABLE IF EXISTS top_companies;

-- Replace missing values
UPDATE top_companies
SET title = COALESCE(title, 'Other')
WHERE title IS NULL;

-- Replace data inconsistencies
UPDATE top_companies
SET title = 'maintenance worker'
WHERE title = 'factory worker'

-- Replace incorrect data formats
UPDATE top_companies
SET date = TO_DATE(date, 'YYYY-MM-DD')
WHERE date IS NOT NULL;


--------------------------------------------------------------------------------------------------
-- String Functions
-- Identify usernames that begin with apple
SELECT
username,
first_name,
last_name
FROM users
WHERE username LIKE 'apple%';


-- Case Insensitive
-- The LIKE function only returns lower case values whereas ILIKE is a scalable version that will return upper, lower, and plural versions of the value.
SELECT *
FROM fruit_table
WHERE fruit_column ILIKE '%apple%';

-- Lowercase Strings
SELECT *
FROM fruit_table
WHERE LOWER(fruit_column) = 'apple';


-- Remove whitespace
-- The TRIM function removes whitespace from the left and right side. 'ltrim' and 'rtrim' can also be used to use less computing power to only remove one side at a time.
SELECT
TRIM(' apple '),
LTRIM(' apple'),
RTRIM('apple ')

-- Remove Characters
-- The TRIM function can also be used to remove specific characters. An assumption the function makes is that uppercase and lowercase are different characters.
SELECT
TRIM('Wow!', 'W!')        -- This will only remove the uppercase 'W', not the lowercase
TRIM('Wow!', 'Ww!')       -- This will remove the uppercase and lowercase
TRIM(LOWER('Wow!'), 'w!') -- This will remove only lowercase but first lowercase the entire string




--------------------------------------------------------------------------------------------------
-- Correcting Catalogues
-- The goal of this query is to see how well the 'category' column captures what is in the description column. The method is to find inquires from the county department of complaints that mention trash or garbage in the description without the keywords 'trash' or 'garbage' in the category column. This will show us complaints regarding 'trash' or 'garbage' that were not correctly catalogued.
SELECT
category,
COUNT(*)
FROM county_complaints
WHERE (
  description ILIKE '%trash%'          -- Search for descriptions involving trash / garbage
  OR description ILIKE '%garbage%')
AND category NOT LIKE '%Trash%'        -- This will check Trash category
AND category NOT LIKE '%Garbage%'      -- This will check Garbage category
GROUP BY category
ORDER BY COUNT(*) DESC
LIMIT 10;



  
-- Change Data Type
SELECT
CAST(total_column AS integer)
FROM prices
-- Change Data Type 
SELECT
total_column :: INT
FROM prices








