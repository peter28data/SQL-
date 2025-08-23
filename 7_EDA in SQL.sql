-----------------------------------------Ch.1--------------------------------------------------------------
/* The Coalesce function takes two or more values or column names as arguments. It returns the First Non-Null value in each row or even a blank value. In this query below, the column 'industry' has some missing values, in which case, the function will look in the 'sector' column as a second option. If both columns has missing values then the third argument specifies to return an 'Unknown' value. The goal of the query is to find the most common industry.  */
SELECT
COALESCE(industry, sector, 'Unknown') AS industry2,
COUNT(*)
FROM fortune500
GROUP BY industry2
ORDER BY COUNT DESC
LIMIT 1;

/* Foreign Key: Value that exists in the referenced column
Primary Key: Unique */
-- Change the data type with CAST function, INTs remove decimals and round
SELECT
CAST(3.7 AS INTEGER);      --4

-- A double colon will do the same function as CAST()
SELECT
3.7::INTEGER;              --4



-------------------------------Ch.2: Aggregating Numeric Data------------------------------------
-- Population Variance: divides by the number of values
-- Sample Variance: divides by the number of values minus one. 
SELECT var_pop(question_pct)
SELECT var_samp(question_pct)

SELECT stddev(question_pct)
SELECT stddev_pop(question_pct)

SELECT generate_series(1, 10, 2);     -- Group values into bins
-------------------------------------------------------------------------------------------------

with bins AS (
  SELECT
  generate_series(30,60,5) AS lower,
  generate_series(30,60,5) AS upper),
  ebs AS (
  SELECT unanswered_count
  FROM stackoverflow
  WHERE tag='amazon-ebs')
SELECT lower, upper, count(unanswered_count)
FROM bins
LEFT JOIN ebs
ON unanswered_count >= lower
AND unanswered_count < upper
GROUP BY lower, upper
ORDER BY lower;                 -- Groups count of unanswered questions into bins
-------------------------------------------------------------------------------------------------

SELECT corr(assets, equity)

SELECT percentile_disc(0.5) WITHIN GROUP (ORDER BY column_name) -- Median: value that exists
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY column_name) -- Average: interpolates between values


-- Creating temporary tables
CREATE TEMP TABLE newtablename AS
SELECT column1, column2
FROM table1;

-- Creating temporary tables pt.2
SELECT column1, column2
INTO TEMP TABLE newtablename
FROM table1;

-- Insert new rows into temp table
INSERT INTO top_companies
SELECT rank, title

-- Delete Table
DROP TABLE top_companies;
DROP TABLE IF EXISTS top_companies;     -- avoids error message

-- Explanation: This is helpful is we want to save calculations without changing the original data.

----------------------------------Ch.3: Categorical & Unstructured Text-------------------------
/* 
*/
SELECT 
zip,
COUNT(*)
GROUP BY zip            -- How many distinct values of zip?
HAVING COUNT(*) >= 100; -- In at least 100 rows?


SELECT
street,
COUNT(*)
FROM evanston311
GROUP BY street        -- Group streets to get count of streets
ORDER BY COUNT(*) DESC -- The 5 most common values of street
LIMIT 5;


-- Concatenate Strings
-- Use an outer l trim function to remove any spaces from the start of the concatenated value.
SELECT
LTRIM(CONCAT(house_num, ' ', street)) AS address
FROM evanston311;


-- Split Strings on a delimiter 
SELECT 
SPLIT_PART(street, ' ', 1) AS street_name,
COUNT(*)
GROUP BY street_name
ORDER BY COUNT DESC
LIMIT 20;

-- Shorten Long Strings
-- Concatenate '...' to the end of any shortened description when the string length is greater than 50. 
SELECT
CASE
WHEN LENGTH(description) > 50 THEN LEFT(description, 50) || '...'
ELSE description END
FROM evanston311
WHERE description LIKE 'I %'
ORDER BY description;

-------------------------------Ch.4: Date/Time Type and formats--------------------
-- Postgres write date time in ISO (International Organization for Standards) YYYY-MM-DD HH:MM:SS
--UTC (Coordinated Universal Time) will add +02 to indicate the timezone
SELECT
'2010-01-01':: date + 1;    -- Adding to date will add 1 day

SELECT
'2018-12-10'::date + '1 year'::interval;  -- Specify the date added to date

SELECT
'2018-12-10'::date + '1 year 2 days 3 minutes'::interval; 



















