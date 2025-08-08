--1 You want to detect invalid values within the sales table. How would you identify customers that do not meet the specified regular expreseeion pattern?
SELECT *
FROM sales
WHERE customer NOT LIKE '^CDX[0-9]+';  -- or '<>' instead of not like, or NOT SIMILAR TO?


--2 Find all of the credit lines with promo codes that start with a number
WHERE promoCode ~ '^[0-9]';

--Explanation: instead of writing 'LIKE 1% OR LIKE 2%' over and over to cover each number 0-9 we can use the tilda for a string that starts with a carrot symbol and a range of numbers.



--6 How do you query the data type for a column
SELECT
  pg_typeof(name)



--7 Alter the table to update column from CHAR to VARCHAR
ALTER TABLE employee
ALTER COLUMN employee_name TYPE VARCHAR



--9 write a sql query to ensure that for each project_id, the review_date is always after the end_date of the lastest end_date for that project_id. the query should have a subquery in the WHERE clause.
-- Query to validate that review_date is after the latest end_date for each project_id
SELECT *
FROM projects p1
WHERE p1.review_date > (
    SELECT MAX(p2.end_date)
    FROM projects p2
    WHERE p2.project_id = p1.project_id
);

-- Alternative version with more explicit column selection
SELECT project_id, review_date, end_date
FROM projects p1
WHERE p1.review_date > (
    SELECT MAX(p2.end_date)
    FROM projects p2
    WHERE p2.project_id = p1.project_id
);



--14 identify users whose username ends iwth a digit
WHERE username ~ '[0-9]$';



--29 Calculate the Pearson's first coefficient of skewness using the mode
WITH base_table AS (
  SELECT
  MODE() WITHIN GROUP (ORDER BY player_score ASC) AS mode,
  AVG(player_score) AS mean,
  STDDEV(player_score) AS std_dev
  FROM sports)
SELECT 
  (mean - mode)/std_dev AS pearson_firstcoefficient
FROM base_table;



--










-- Format date/time to a string
SELECT TO_CHAR(order_date, 'YYYY-MM-DD') AS formatted_date
FROM orders;

-- Parse a string into a date
SELECT TO_DATE('2025-08-08', 'YYYY-MM-DD') AS converted_date;

-- Convert a string into a timestamp
SELECT TO_TIMESTAMP('2025-08-08 14:30:00', 'YYYY-MM-DD HH24:MI:SS');
