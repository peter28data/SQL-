------------------------------- Part 1: Match Strings & Numbers -------------------------------------

-- Replace 
UPDATE accounts
  SET user_name = REGEXP_REPLACE(username, '[dog, cat, fish]', '***', 'g');

-- Goal: Replace any vulgar language before it is published in team chat to promote a friendlier user experience. 

-- Remove all digits
UPDATE
  SET user__name


--------------------------------------------------------------------------

-- Filtering, No changes to table
-- Match any string that starts with 'A' followed by a digit. Example A28
SELECT usernames,
FROM accounts
WHERE name SIMILAR TO 'A[0-9]%'
-- Match strings Ending in 'ing' or 'ed'
OR word SIMILAR TO '%(ing|ed)'r

-- Goal: To investigate a username that is only known to start with A followed by a digit we can use 'A[0-9]%'. If we also know that this name ends in a certain pattern we can use '%(ing|ed)'. 

--------------------------------------------------------------------------

-- Full Regex Support
WHERE name ~ '^[A-Z]{3}[0-9]{2}$'
-- Case-Insensitive needs ~*
WHERE name ~* '^[a-z]+son$'
-- Returns: Jackson, Anderson, but Not SON because the '+' operator means at least one letter character must come before the son at the end of the string.

-- {3} This is exactly 3 repetitions
-- {3,6} This is a range between 3 and 6 repetitions
WHERE name !~* '^[a-z]{3,6}' 
-- This query would filter usernames that do Not start with upper or lower case letters through a-z between 3 to 6 times

-- Example: tennis413
-- This would not be returned because there Are 6 letters and we are searching for usernames that do Not start with 3 to 6 letters. Therefore, tennisBall413 Would be returned because it begins with 10 letters. Note: becuase we used a '*' after the '~', we made the search case insensitive so the uppercase B in tennisBall413 would not affect the search match even though we did not specify it in the query with '[a-z]'.


--------------------------------------------------------------------------

-- Titles only 4 letters

-- Ensure only letters ("Gone", not "A1B2") use regex
SELECT title,
FROM movies
WHERE title ~ '^[A-Za-z]{4}$'
-- Ensures the whole string is only 4 letters, upper or lowercase

-- Underscore matches one wildcard characters so 4 underscores in the WHERE clause
SELECT title,
FROM movies
WHERE title LIKE '____'


  
--------------------------------------------------------------------------

-- Number of rows 'launch' column where the value is not a date OR missing value

-- Assuming 'launch' is stored as TEXT OR VARCHAR
SELECT COUNT(*)
FROM bike_stations
WHERE launch IS NULL
  OR launch = ''
  OR TRY_CAST(launch AS DATE) IS NULL;

-- NULL, Empty, or not in date format
SELECT COUNT(*)
FROM bike_stations
WHERE launch IS NULL
  OR launch = ''
  OR launch !~ '^\d{4}-\d{2}-\d{2}$' -- not in date format

--------------------------------------------------------------------------

-- Regex Functions
-- Regular Expressions refers to a method of searching and manipulating text using patterns instead of exact characters

-- ~   case sensitive
-- ~*  case insensitive
-- !~  does Not match case sensitive
-- !~* does Not match case insensitive

-- $  end of string
-- ^  start of string

-- gmail\.com$ Means must end with gmail.com

SELECT product_name
FROM products
WHERE product_name !~ '^[A-Z]'
-- A case sensitive operator is important here due to our investigation focused on product names that do Not start with a capital letter

  
--------------------------------------------------------------------------

-- How many Duplicates
-- it is (dup_count-1) because if A appears three times, then it is two duplicates
SELECT SUM(dup_count - 1) AS total_duplicates   -- Total number of duplicates rows
FROM (
  SELECT COUNT(*) AS dup_count
  FROM your_table
  WHERE duplicates IS NOT NULL
  GROUP BY duplicates
  HAVING COUNT(*) > 1
) AS dup_counts;

-- Unique values are duplicated
SELECT COUNT(*) AS duplicated_values
FROM (
  SELECT duplicates
  FROM your_table
  WHERE duplicates IS NOT NULL
  GROUP BY duplicates
  HAVING COUNT(*) > 1
) AS dup_list;


  
--------------------------------------------------------------------------


ORDER BY price DESC
LIMIT 3 OFFSET 1

-- Explain: The DESC will order prices from highest to lowest, the LIMIT will allow only 3 records to be returned, and the offset will skip the first value, altogther returns the 2nd to 4th highest prices.

--------------------------------------------------------------------------

-- Extract code from column
SELECT 
  code,
  SUBSTRING(code, FROM 3 FOR 4) AS code_part
FROM accounts;
  
--------------------------------------------------------------------------

-- Add Two weeks
SELECT NOW() + INTERVAL '2 weeks' AS interval_value

-- INTERSECT vs. INNER JOIN
-- Intersect only returns rows that are exactly the same. Inner join matches rows based on a column. 
-- Takeaway: If a name is changed, INTERSECT would not include that changed row but inner join would if joined on a primary key such as customer_id. 


  

--------------------------------------------------------------------------

-- Return records not in 2013
SELECT *
FROM bike_stations
WHERE EXTRACT(YEAR FROM installation_date) != 2013

-- Without function, Not in 2013
SELECT *
FROM bike_stations
WHERE installation_date < '2013-01-01'
  OR installation_date >= '2014-01-01'

--------------------------- Test Review   ------------------------------------

-- why answers were wrong

-- forgot parenthesis
ON (t.id = f.song_id) AND (t.dance = f.dance_level)

-- misread which column to look for missing values
WHERE nationality IS NULL

-- HAVING is for aggregations (AVG, SUMS), not (>,<)
WHERE followers > 500000

-- USING keeps one foreign key ON keeps both
FROM tracks
INNER JOIN artist_names
  USING(artist_id)

-- Order of Multiplication, object then multiplier
SELECT name,
  (revenue * 0.7) AS correct_revenue





