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









