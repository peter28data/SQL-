------------------------------- Part 1: Match Strings & Numbers -------------------------------------

-- Replace 
UPDATE accounts
  SET user_name = REGEXP_REPLACE(username, '[dog, cat, fish]', '***', 'g');

-- Goal: Replace any vulgar language before it is published in team chat to promote a friendlier user experience. 


--------------------------------------------------------------------------

-- Filtering, No changes to table
-- Match any string that starts with 'A' followed by a digit. Example A28
SELECT usernames,
FROM accounts
WHERE name SIMILAR TO 'A[0-9]%'
-- Match strings Ending in 'ing' or 'ed'
OR word SIMILAR TO '%(ing|ed)'

-- Goal: To investigate a username that is only known to start with A followed by a digit we can use 'A[0-9]%'. If we also know that this name ends in a certain pattern we can use '%(ing|ed)'. 

--------------------------------------------------------------------------

-- Full Regex Support
WHERE name ~ '^[A-Z]{3}[0-9]{2}$'
-- Case-Insensitive needs ~*
WHERE name ~* '^[a-z]+son$'


--------------------------------------------------------------------------

-- Titles only 4 letters

-- Ensure only letters ("Gone", not "A1B2") use regex
SELECT title,
FROM movies
WHERE title ~ '^[A-Za-z]{4}$'

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
  OR launch !~ '^d{4}-\d{2}-\{2}$' -- not in date format


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

-- Count Total D

  
--------------------------------------------------------------------------


ORDER BY price DESC
LIMIT 3 OFFSET 1

-- Explain: The DESC will order prices from highest to lowest, the LIMIT will allow only 3 records to be returned, and the offset will skip the first value, altogther returns the 2nd to 4th highest prices.

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
