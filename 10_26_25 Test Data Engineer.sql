-----------------------------------------------------------------

-- An investing app is collecting data from its user app to provide 
-- Personalized Investment Recommendations

-- To process this data efficiently which amazon tool is most suitable to create and manage a data pipeline? S3, DynamoDB, EC2, or Kinesis?




-----------------------------------------------------------------

--which aws service is most appropriate to automatically move objects between storage classess based on access patterns? S3 Intelligent-Tiering



-----------------------------------------------------------------

--which google cloud platform is most suitable to migrate a relational database stored in house to a system that is able to hangle millions of reads and writes while keeping the relational model they had? Google Cloud Spanner



-----------------------------------------------------------------

--what is an example of cloud-based real time data pipeline service offered by aws
-- Kinesis, it allows to collect streaming data in real time and designed to handle large scale continuous data.



-----------------------------------------------------------------

--which normal form when designing a database for a retail store that sells various products to ensure the product data minimizes redundancy and maintains data integrity is best
--A table is 3NF if it is in 2NF and all non-key attributes depend only on the primary key, and not on other non-key attributes.

-- Example: using a unique number for "categoryID" instead of "Apparel" or "Appliances" for "CategoryName". This ensures no redudant category info and is easy to update category details in one place.



-----------------------------------------------------------------

-- a team models business logic directly in the data warehouse using SQL, which tool is designed for this approach?
-- Data Build Tool for Transformations
-- It enables engineers to transform raw data inside the warehouse (BigQuery,Snowflake,Redshift), use SQL for transformations and apply software engineering best practices like version control, testing, and documentation to data modeling



-----------------------------------------------------------------

--the 'day' column is currently stores as a string in the format day-month year convert to a column of data type called incident_date which is year-month-date?
TO_CHAR(day, 'DD-MM-YYYY') AS incident_date

-- Explain: Confusing becased the function says day-month-year but the output is year-month-day



-----------------------------------------------------------------

-- remove numbers from usernames
UPDATE accounts
SET username = REGEXP_REPLACE(username, '[0-9]', '', 'g');



-----------------------------------------------------------------

--you want to identify columns that are not following a specific regex pattern for the date. how would you first ensure the column is Cast into a text type?
SELECT *
FROM employees
WHERE hire_date::TEXT !~ '^\d{4}-\d{2}-\d{2}$'



-----------------------------------------------------------------

-- write a sql query to return the month part of the event_trime in letter format (October)



-----------------------------------------------------------------

--how would you identify customers that do not meet the specified regular expression pattern 'CDX[0-9]+'?

WHERE customer_code NOT SIMILAR TO 'CDX[0-9]+';

-- [0-9]+ means one or more digits
-- NOT LIKE only supports wildcards (% and _) not full regex so it will return any string starting with CDX even if no digits follow
WHERE customer_code NOT LIKE 'CDX%';

-- NOT IN checks membership in a list of specific values not patterns
WHERE customer_code NOT IN ('CDX1','CDX2','CDX3');

-- <> compares exact values not patterns, filtering out a single value
WHERE customer_code <> 'CDX1';



-----------------------------------------------------------------

-- which of the following queries provide the dat types of each column in a table called cars, "select schema cars" "show types cars" "\d cars" or "\schema cars"

-- \d cars descrives the table strucure including columns and their data types



-----------------------------------------------------------------

-- PART 2 DATA ENGINEER EXAM



-----------------------------------------------------------------

-- Check for Non-Integer Values
-- The user_id column cannot have missing values so we must check for missing values and any duplicates

-- If user_id is stored as a text or varchar, regular expression can be used to find non-integer entries
SELECT user_id
FROM user
WHERE user_id !~ '^[0-9]+$'

-- To find user_id that are Duplicates
SELECT user_id,
COUNT(*) AS occurences
FROM users
GROUP BY user_id
HAVING COUNT(*) > 1

-- If user_id is an INT data type and need to check for missing values
SELECT * 
FROM users
WHERE user_id IS NULL



  
-----------------------------------------------------------------

-- Task 1: Replace Missing Values
-- Convert Values Between Data Types
-- Clean Categorical and Text Data by Manipulating Strings
  
-- The following query is to update an exisiting table, however the second query cleans the data without modifying the table
UPDATE users
SET age = (
  SELECT ROUND(AVG(age))
  FROM users
  WHERE age IS NOT NULL
)
WHERE age IS NULL

  
-- Without modifying Table
SELECT
  COALESCE(age, ROUND(AVG(age) OVER ())) AS age_filled,
  COALESCE(CAST(registration_date AS DATE), '2024-01-01'::DATE) AS registration_date_filled,
  COALESCE(email, 'Unknown') AS email_filled,
  COALESCE(LOWER(workout_frequency), 'flexible') AS workout_frequency_filled,
FROM users



  
  
-- If you'll reuse this 'cleaned' version, creating a view 
CREATE VIEW users_cleaned AS
SELECT
  COALESCE(age, ROUND(AVG(age) OVER ())) AS age_filled,
  COALESCE(registration_date, DATE '2024-01-01') AS registration_date_filled,
  COALESCE(email, 'Unknown') AS email_filled,
  COALESCE(workout_frequency, 'flexible') AS workout_frequency_filled,
FROM users


-- Wrong: Mismatch Error, Requires all arguments to be of the same data type

-- Safer Way to Cast if registration_date is stored as text
SELECT
  COALESCE(age, ROUND(AVG(age) OVER ())) AS age_filled,
  COALESCE(TO_DATE(registration_date, 'YYYY-MM-DD'), DATE '2024-01-01') AS registration_date_filled,
  COALESCE(email, 'Unknown') AS email_filled,
  COALESCE(LOWER(workout_frequency), 'flexible') AS workout_frequency_filled
FROM users;



-- IF empty strings 
SELECT
  COALESCE(age, ROUND(AVG(age) OVER ())) AS age_filled,
  COALESCE(TO_DATE(registration_date, 'YYYY-MM-DD'), '2024-01-01'::DATE) AS registration_date_filled,
  COALESCE(email, 'Unknown') AS email_filled,
  COALESCE(LOWER(NULLIF(TRIM(workout_frequency), '')), 'flexible') AS workout_frequency_filled
FROM users




-- STILL WRONG
-- Clean Categorical and Text Data by Manipulating Strings

-- There may be spelling mistakes for the workout_frequency column
SELECT
  COALESCE(age, ROUND(AVG(age) OVER ())::INT) AS age_filled,
  COALESCE(TO_TIMESTAMP(NULLIF(TRIM(registration_date), ''), 'YYYY-MM-DD"T"HH24:MI:SS.MS'), '2024-01-01 00:00:00'::TIMESTAMP) AS registration_date_filled,
  COALESCE(LOWER(NULLIF(TRIM(email), '')), 'Unknown') AS email_filled,
  COALESCE(LOWER(NULLIF(TRIM(workout_frequency), '')), 'flexible') AS workout_frequency_filled,
	*
FROM users



-- CASE WHEN inside of COALESCE may fix issue
COALESCE(
  CASE 
    WHEN LOWER(TRIM(workout_frequency)) IN ('flexible', 'maximal', 'minimal')
      THEN LOWER(TRIM(workout_frequency))
    ELSE 'flexible'
  END,
  'flexible'
) AS workout_frequency_filled

-----------------------------------------------------------------

-- Task 2: Replace missing values before year 2021 with game_id for running
-- Conditional Logic, Type Casting, String Handling

-- Challenge: event_time is stored as Text, not timestamp so we use LEFT() to extract the number from a string then use CAST() to convert to Integer to compare to the year 2021, then use CASE WHEN to replace the game_id with 4 when the year is before 2021 with the COALESCE().
SELECT
    COALESCE(
        game_id,
        CASE
            WHEN CAST(LEFT(event_time, 4) AS INTEGER) < 2021 THEN 4
            ELSE game_id
        END
    ) AS game_id_filled,
    *
FROM events;


-- Problem: Missing values may be a dash (-), "missing", or others
SELECT
  CASE
  WHEN (
  game_id IS NULL
  OR TRIM(game_id) IN ('', '-', 'missing')
  OR NOT (game_id ~ '^[0-9]+$')
  )
  AND event_time < TO_DATE('2021-01-01', 'YYYY-MM-DD')
  THEN 4
  ELSE game_id::INTEGER
  END AS cleaned_game_id,
  *
  FROM events
  


-- Another way to filter for missing values before year 2021
AND TO_TIMESTAMP(event_time, 'YYYY-MM-DD-SSSS') < '2021-01-01'::DATE
THEN 4
ELSE game_id::INTEGER
END AS cleaned_game_id


-- To extract only the date and not seconds part
AND TO_DATE(SUBSTRING(event_time FROM 1 FOR 10), 'YYYY-MM-DD') <'2021-01-01'::DATE


-- This query is still wrong because the datapoints for event_time are 2020-10-24T14:59:44.000
SELECT
  CASE
  WHEN (
  game_id IS NULL
  )
  AND TO_TIMESTAMP(NULLIF(TRIM(event_time, ''), 'YYYY-MM-DD HH24:MI:SS') < '2021-01-01 00:00:00'::TIMESTAMP
	THEN 4
	ELSE game_id::INTEGER
	END AS events_with_game_id,
	*
FROM events


-- To fix this we use 
 AND TO_TIMESTAMP(NULLIF(TRIM(event_time), ''), 'YYYY-MM-DD"T"HH24:MI:SS.MS') < '2021-01-01 00:00:00'::TIMESTAMP



-----------------------------------------------------------------

--GOOD
-- Multi-Table Join with Foreign Key Relationships

-- users.user_id -> Primary Key
-- events.user_id -> Foreign Key to users.user_id
-- events.game_id -> Foreign Key to games.game_id
-- games.game_type -> Describes the type of game ("biking")

SELECT 
    u.user_id,
    e.event_time
FROM users AS u
JOIN events AS e
    ON u.user_id = e.user_id
JOIN games AS g
    ON e.game_id = g.game_id
WHERE g.game_type = 'biking';


-----------------------------------------------------------------

-- GOOD
-- Aggregation with Filtering and Grouping

SELECT
    g.game_type,
    e.game_id,
    COUNT(DISTINCT e.user_id) AS user_count
FROM events AS e
JOIN games AS g
    ON e.game_id = g.game_id
WHERE g.game_type IS NOT NULL
GROUP BY g.game_type, e.game_id
ORDER BY g.game_type, e.game_id;

