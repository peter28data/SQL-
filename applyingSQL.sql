-- The folloing script applies SQL queries for specific business use cases. 

/* #1 Aggregating Finances: 
Difference of active/Non-active Users
The following query will return two records grouped by active status, 'false' or 'true'. The selected fields are active status, number of transactions in each active status, the average amount spent in each active status, and the total amount spend by active status. */

SELECT
  active,
  COUNT(payment_id) AS num_transactions,
  AVG(amount) AS avg_amount,
  SUM(amount) AS total_amount
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY active;



--#2 Aggregating Strings: 
Demonstrate family-friendly/multi-lingual films
The query below will return a column with a list of all the different languages following by a column including all the film titles that are available in that language. This query demonstrates only films released in 2010 with a 'G' rating by combining two tables on the primary key 'language_id'.
SELECT
  name,
  STRING_AGG(title, ',') AS film_titles
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
WHERE release_year = 2010
  AND rating = 'G'
GROUP BY name;



--#3 Navigating Database
A database can have hundreds of tables and individually selecting all columns from each table would be an inefficient way to scrub through the tables for the right data to answer a business question. An efficient way is to query the list of tables by querying a specific system table such as Postgres or Oracle. This returns schema name, table name, and table owner such as Postgres
SELECT *
FROM pg_catalog.pg_tables
WHERE schemaname = 'public';

--# SQL Server - TSQL
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

--# MySQL
SHOW TABLES;

--#4 VIEW columns from tables
CREATE VIEW table_columns AS 
SELECT 
  table_name,
  STRING_AGG(column_name, ', ') AS columns
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name;
SELECT *
FROM table_columns



-- #5 Aggregate Film Lenths
The query returns a report of the average length of films grouped by categories, joined by two tables on a unique identifier for the films.
SELECT category,
  AVG(length) AS average_length
FROM film AS f
INNER JOIN category AS c
ON f.film_id = c.film_id
GROUP BY category
ORDER BY average_length;



/*#6 Aggregate Film Rentals
Returning number of rentals in each city to identify business opportunities for the best customer contrasting the potential detractors.
Join the 'rental' table and 'address' table for city information.
Problem: There is no common key between these tables so we use the 'customer' table because it has a field in 'rental' and address'. Visually connected the three tables is a process called
*/

/*
--#7 Which Films are most Rented?
'films' table has rental duration. 
'rental' table has which customer rented the films.
There is no common id.
'inventory' table has film_id from 'films' and inventory_id from 'rental'.
*/
SELECT
  title,
  COUNT(title)
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
INNER JOIN rental AS r
ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER BY count DESC;



--#8 Change Data Type
--Convert to new data type for the duration of the query. This can be done with the casting function of double notation. Converting to integer will results in losing the decimals of each point of data.
SELECT 
  CAST(total_column AS integer)
FROM prices
SELECT total_column::integer
FROM prices


--#9 Data Type
SELECT
  revenues_change::integer,
  COUNT(*)
FROM fortune500
GROUP BY revenues_change::integer
ORDER BY revuenes_change;


--#10 Count Positive 
--How many of the Fortune 500 companies had revenues increase in 2017
SELECT 
  COUNT(*)
FROM fortune500
WHERE revenues_change > 0;



--#11 Validating
--Check 'unanswered_pct' by trying to recreate the data
SELECT
  unanswered_count/question_count::numeric AS computed_pct,
  unanswered_pct
FROM stackoverflow
WHERE question_count !=0
LIMIT 10;



--#12 Truncate and Group
--The query groups values in the 'unanswered_count' column intro three groups based on digits in the tens place of the number, due to the second argument of the truncate function being -1.
SELECT
  TRUNC(unanswered_count, -1) AS trunc_ua,
  COUNT(*)
FROM stackoverflow
WHERE tag='amazon-ebs'
GROUP BY trunc_ua
ORDER BY trunc_ua



--#13 Correlation
SELECT 
  CORR(assets, equity)
FROM fortune500;



--#14 Percentiles
--Discrete returns a real value, whereas Continuous may not return a real value.
SELECT
  PERCENTILE_DISC(.5) WITHIN GROUP(ORDER BY val),
  PERCENTILE_CONT(.5) WITHIN GROUP(ORDER BY val)
FROM nums;



--#15 Temporary tables
CREATE 
  TEMP TABLE top_companies AS 
SELECT 
  rank, 
  title
FROM fortune500
WHERE rank <= 10;
SELECT column1, column2
  INTO TEMP TABLE new_tablename
FROM table;



--#16 Add Data
--This adds all row data from ranking companies 11 through 20
INSERT INTO top_companies
SELECT
  rank, 
  title
FROM fortune500
WHERE rank BETWEEN 11 AND 20;



--#17 Delete Table
--This wont cause an error if the table does not exist.
DROP TABLE IF EXISTS top_companies;



--#18 Correlation Temp
CREATE TEMP TABLE correlations AS 
SELECT
  'profits';;vvarchar AS measure,
  corr(profits, profits) AS profits,
  corr(profits, profits_change) AS profits_change,
  corr(profits, revenues_change) AS revenues_change
FROM fortune500;



--#19  Add to Temp
INSERT INTO correlations
SELECT
  'profits_change'::varchar AS measure,
  corr(profits_change, profits) AS profits,
  corr(profits_change, profits_change) AS profits_change,
  corr(profits_change, revenues_change) AS revenues_change
FROM fortune500;
INSERT INTO correlations
SELECT
  'revenues_change'::varchar AS measure,
  corr(revenues_change, profits) AS profits,
  corr(revenues_change, profits_change) AS profits_change,
  corr(revenues_change, revenues_change) AS revenues_change
FROM fortune500;



--#20 Rounding
SELECT measure,
  round(profits::numeric, 2) AS profits,
  round(profits_change::numeric, 2) AS profits_change
  round(revenues_change::numeric, 2) AS revenues_change
FROM correlations;



--#21 Categorical Unstructured Text
--Cat values examples are responses in a survey question or days of the week whereas unstructured text are summaries for book reviews.



--#23 Count
/*
This is data on help requests submitted to the city of Evanston, IL.
How many distinct values of zip appear in at least 100 rows?
*/
SELECT 
  zip,
  count(*)
FROM evanston311
GROUP BY zip
HAVING count(*) >=100;



--#24 Most Common
--Find the five most common values of 'street' column and a count of each
SELECT
  street,
  count(*)
FROM evanston311
GROUP BY street
ORDER BY count(*) DESC
LIMIT 5;



--#25 Potential Problems
--Explore distinct values of 'street' column and count the number of rows. When sorting the results by street it will show similar values near each other. This identifies potential problems such as; The s



--#26 Without whitespace
--The following query will return values of 'apple' but will not return values that have whitespace before or after, and will not return plural versions of 'apple'.
SELECT *
FROM fruit_table
WHERE lower(fruit_column)='apple';



--#27 Case insensitive
--This query will return plural versions of 'apple' and is a scalable version of the 'like' function because it returns values that are upper and lower case whereas the 'like' function only returns lower case as in the query below.
SELECT *
FROM fruit_table
WHERE fruit_column LIKE '%apple%';
SELECT *
FROM fruit_table
WHERE fruit_colulmn ILIKE '%apple%';



--#28 Limits
--This will return values such as pineapple since apple is in the value. Another way to return values without whitespace is to use the trim function. This removes space from left and right side. 'rtrim' and 'ltrim' to specify sides.
SELECT trim(' abc '):



--#29 Limits
--The previous funcion only removes spaces but not tabs or new lines in the value. Using the second argument we can specify which characters to remove. This would return the value 'o' since all other characters were specified.
SELECT trim('Wow!', '!wW');



--#30 Combining
--We can execute the lower function to the first argument of the trim function so that we do not have to specify the upper case 'W' in the second argument of the trim function.
SELECT trim(lower('Wow!'), '!w');



--#31 Frequent Categories
--The query goes through inquires from for help. The goal is to see how well the 'category' captures what is in the 'description'. The method is to find inquires that mention trash or garbage in the description without those keywords in the category. What is the most frequent categories for these constraints.
SELECT
  category, count(*)
FROM evanston311
WHERE (description ILIKE '%trash%'
OR description ILIKE '%garbage%')
AND category NOT LIKE '%Trash%'
AND category NOT LIKE '%Garbage%';
GROUP BY category
ORDER BY count DESC
LIMIT 10;



--#32 Extract Strings
--Specify the number of characters to extract parts of string from the left or right side.
SELECT
  left('abcde', 2),r



--SQL Test
--#1 Get the data type of the column 'category'
SELECT TYPEOF(category) AS data
FROM sales
LIMIT 1;


/*
#2 The 'day' column is currently stored as a string, day-month-year, convert to 



#3 Change whitespace to underscore



#4 Filter for customers with 4 or 5 previous transactions



#5 Datatype
From varchar  to integer



#6 Aggregate by Region



#7 Storage size of Column in bytes



#8 Num of Unique values 



#9 extract month



#10 top 5 books highest price

*/

--#11 sales between dates
SELECT 
  customer_id,
  customer_name,
  city_id
FROM customers
WHERE customer_id IN( SELECT customer_id FROM sales WHERE date BETWEEN '2022-10-05' AND '2022-10-20')



--#12 Replace Missing values



--#13 Mean, sum, count for banks
SELECT
  AVG(amount) :: DECIMAL(6,2) AS mean,
  SUM(amount) AS total,
  COUNT(amount) AS num_deposits
FROM deposits;


/*
#14 Truncate the column 'date_time' to hourly precision



#15 Truncate the column 'delivery_date' to minute precision



#16 Which clients have missing date of last holiday

*/

--#17 Identify users whose 'username' begins with apple
SELECT
  username, 
  first_name,
  last_name,
FROM users
WHERE username LIKE 'apple%';



--#18 Player info from certain players



--#19 Subquery in Where clause
--This retrieves the names of bakery products that have been sold. the subquery is needed to see if the bakery product appears in the sales table



--#20 Range of Amount Paid
MIN/MAX
SELECT 
  MIN(question_pct)
FROM stackoverflow;
SELECT
  MAX(question_pct)
FROM stackoverflow;



--#21 Replace missing values


--#29 Skewness from avg and median of inventory volume
SELECT
  VAR_POP(question_pct)
FROM stackoverflow
SELECT
  VAR_SAMP(question_pct)
FROM stackoverflow
SELECT
  VARIANCE(question_pct)
FROM stackoverflow
SELECT
  STDDEV(question_pct)
FROM stackoverflow



--#32 correlation between hours_studied and exam_score



--#33 No missing values



--#34 correlation between ratings and price


--### EXAM DA101
--show employee names of people that have salaries less than the average.
SELECT
  x.Employee_name, y.Salary
FROM 
  Employee x, Employee_info y
WHERE 
  x.Employee_id = y.Employee_id
  AND y.Salary < (SELECT AVG(Salary) FROM Employee_info);

# show employee salaries and name sof people that earn less than employee with id 4
SELECT
  x.Employee_name, y.Salary
FROM 
  Employee x, Employee_info y
WHERE
  x.Employee_id = y.Employee_id
  AND y.Salary < (SELECT Salary FROM Employee_info WHERE Employee_id=4);


--### Data Cleaning with SQL
-- Handle outliers outside of 3 standard deviations from the average
SELECT *
FROM you_table
WHERE
  column_name > (SELECT AVG(column_name) + 3 * STDDEV(column_name)
FROM your table)
OR
  column_name < (SELECT AVG(column_name - 3 * STDDEV(column_name)
FROM your_table

--Correct Data Inconsistencies such as renaming values
UPDATE your_table
SET column_name = 'correct_value'
WHERE column_name = 'incorrect_value';

--Ensure consistency in date formats
UPDATE your_table
SET date_column = TO_DATE(date_column, 'YYYY-MM-DD')
WHERE date_column IS NOT NULL;

--Missing values to replace
UPDATE your_table
SET column_name = COALESCE(column_name, 'default_value')
WHERE column_name IS NULL;

--Find missing values
SELECT *
FROM your_table 
WHERE column_name IS NULL;



--### Analyzing Motorcycle Part Sales
-- The results should be to find the net revenue for each product line generated per month per warehouse
SELECT product_line,
    CASE WHEN EXTRACT('month' from date) = 6 THEN 'June'
        WHEN EXTRACT('month' from date) = 7 THEN 'July'
        WHEN EXTRACT('month' from date) = 8 THEN 'August'
    END as month,
    warehouse,
	SUM(total) - SUM(payment_fee) AS net_revenue
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY product_line, warehouse, month
ORDER BY product_line, month, net_revenue DESC

--### Factors that Fuel Student Performance
--hours studied, sleep patterns, attendance, extracurricular activities, tutoring sessions, teacher quality, exam score. Categorize students into four groups based on 6-10 hours, 11-15, and 16+ hours studed per week. 
-- avg_exam_score_by_study_and_extracurricular
-- Paste code into first SQL cell

-- This query calculates the average exam score of students who studied more than 10 hours and participated in extracurricular activities.
SELECT Hours_Studied, AVG(Exam_Score) AS avg_exam_score
FROM student_performance
-- Filters the data to include only those who studied more than 10 hours and participated in extracurricular activities.
WHERE Hours_Studied > 10
  AND Extracurricular_Activities = 'Yes'
-- Groups the results by the number of hours studied to calculate the average exam score for each study group.
GROUP BY Hours_Studied
-- Orders the results by the number of hours studied in descending order.
ORDER BY Hours_Studied DESC;


-- avg_exam_score_by_hours_studied_range
-- paste code into second SQL cell

-- This query groups students by ranges of hours studied and calculates the average exam score for each group.
SELECT
    CASE
        -- Categorizes hours studied into specific ranges: 1-5, 6-10, 11-15, and 16+ hours.
        WHEN Hours_Studied BETWEEN 1 AND 5 THEN '1-5 hours'
        WHEN Hours_Studied BETWEEN 6 AND 10 THEN '6-10 hours'
        WHEN Hours_Studied BETWEEN 11 AND 15 THEN '11-15 hours'
        ELSE '16+ hours'
    END AS hours_studied_range,
    -- Calculates the average exam score for each range of hours studied.
    AVG(Exam_Score) AS avg_exam_score
-- Specifies the source of the data.
FROM student_performance
-- Groups the data by the newly created study ranges.
GROUP BY hours_studied_range
-- Orders the result by average exam score in descending order to see which range performs best.
ORDER BY avg_exam_score DESC;


-- student_exam_ranking
-- paste code into third SQL cell 
-- This query ranks students based on their exam scores, including other factors like attendance, study hours, sleep hours, and tutoring sessions.
SELECT 
    Attendance, 
    Hours_Studied, 
    Sleep_Hours, 
    Tutoring_Sessions, 
    -- Assigns a rank to each student based on their exam score, with the highest score ranked first.
    DENSE_RANK() OVER (ORDER BY Exam_Score DESC) AS exam_rank
-- Specifies the source of the data.
FROM student_performance
-- Orders the result by exam rank in ascending order so the highest-ranked students come first.
ORDER BY exam_rank ASC
-- Limits the result to the top 30 students.
LIMIT 30;



