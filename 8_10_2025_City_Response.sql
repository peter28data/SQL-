---------------------------------------------

-- City Response Database
-- Goal: Find the total sum of inquires related to noise complaints in the description. 

-- Limitation: WITHOUT the context of Noise/Loud being in the category title.

SELECT category, COUNT(*)
FROM evanston311 
WHERE (description ILIKE '%noise%'
  OR description ILIKE '%loud%')
  
-- Below is the Limitation
  AND category NOT LIKE '%Noise%'
  AND category NOT LIKE '%Loud%'
  
-- Below Counts by Category
GROUP BY category
ORDER BY COUNT DESC
LIMIT 10;

---------------------------------------------

-- Standardize Values
-- Goal: Remove unwanted characters such as #, /, ., spaces, or any numbers to return the street name.

SELECT DISTINCT
street,
TRIM(street, '0123456789 #/.') AS cleaned_streetname
  
FROM evanston311
ORDER BY street;

-- Combine Strings
-- Goal: Combine the first name and last name in a seperate column.

-- Use Case #1: House number + Street, Cities + Countries

SELECT
LTRIM( CONCAT(first_name, ' ', last_name)) AS full_name 
FROM evanston311

-- Explanation: The LTRIM function will remove any spaces from the left side of the value, Concat will combine strings.

-----------------------------------------------

-- Split Strings
-- Goal: Extract the first word of the street names to find the most common streets regardless of the suffix afterwards such as 'Avenue', 'Road', or 'Street'.
  
-- Use Case #1: Emails Brand Counts, City/Country Counts
  
SELECT
SPLIT_PART(street, ' ', 1) AS street_name,
  
COUNT(*)
FROM evanston311
GROUP BY street_name
  
ORDER BY COUNT DESC
LIMIT 20;

-- Explanation: The SPLIT_PART function will need a delimiter, in this case an empty space, and the first or second part of the argrument based on the delimiter. 

-----------------------------------------------

-- Database Management
-- Shorten Strings to 50 Characters

-- Goal: Limit the description column to 50 characters displayed to improve scanability.

SELECT
CASE
WHEN LENGTH(description) > 50 THEN LEFT(description, 50) || '...'

ELSE description
END
FROM evanston311
WHERE description LIKE 'I %'
ORDER BY description;

-----------------------------------------------

-- Recode Values
-- Goal: Which category of City Requests are most common?

-- Explanation: Start by clearing the database cache for any temporary table, then creating a temporary table to aggregate by the main category. 

DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS 
  SELECT DISTINCT
  category,

  -- Below code splits values before '-'
  RTRIM(SPLIT_PART(category, '-', 1)) AS standardized
  FROM evanston311;

SELECT DISTINCT
standardized
FROM recode

-- Below filters values in category
WHERE standardized LIKE 'Noise%Complaint%'
OR standardized LIKE 'Snow%Removal%';

-- Explanation: The SPLIT_PART() function separates what is in the category column with the delimiter '-'. For example, 'Noise Complaint,Loud Neighbors - Resolved' would return 'Noise Complaint,Loud Neighbors'.

-----------------------------------------------

-- Update Values
-- Goal: After creating a temporary table we can safely change the selected values. 

UPDATE recode
SET standardized = 'Snow Removal'
WHERE standardized LIKE 'Snow%Removal%';

-- Now we update the records for for Trash Cart categories to standardize those values as well.

UPDATE recode
SET standardized = 'Noise Complaint'
WHERE standardized LIKE 'Noise%Complaint%';

-- Validate Data
-- Check to make sure there are only two values 
SELECT DISTINCT
standardized
FROM recode
WHERE standardized LIKE 'Noise%Complaint%'
OR standardized LIKE 'Snow%Removal%';

-----------------------------------------------

-- Handle Outliers
-- The goal is to standardize values of category, however, there are odd inputs such as the ones below. These will be grouped together using the update, set, where IN clause.

UPDATE recode
SET standardized = 'UNUSED'
WHERE standardized IN (
  'THIS REQUEST IS INACTIVE...Trash Cart',
  '(DO NOT USE) WATER Bill',
  'NO LONGER IN USE');

-----------------------------------------------

-- Join the 'evanston311' and 'recode' tables
-- We will only keep values that have a match in the recode table because it is cleaned but do
SELECT 
standardized,
COUNT(*)
FROM evanston311
LEFT JOIN recode
ON evanston311.category = recode.category
GROUP BY standardized
ORDER BY COUNT DESC;

-- Explanation: After cleaning the data and standardizing outliers, we can return an accurate description of the count and proportion of inquires. 'Broken Parking Meter' has 6092 inquiries whereas 'Trash' has 3699 as second most.

-- Insight: Snow Removal has 195 inquiries and 'UNUSED' inquiries have 679, meaning a sizable portion of complaints go inactive. 
-----------------------------------------------

-- Indicator Variables
-- The goal is to determine whether medium or high priority requests in the table are more likely to contain requester's contact information. 

-- Using LIKE and delimiters such as '%' and '_' allow us to match any number of characters or a single character. 

DROP TABLE IF EXISTS indicators;
CREATE TEMP TABLE indicators AS 
SELECT
id,
CAST(description LIKE '%@%' AS INTEGER) AS email,
CAST(description LIKE '%___-___-____%' AS INTEGER) AS phone
FROM evanston311;

-- Explanation: LIKE function produces TRUE or FALSE. Therefore, by casting a TRUE/FLASE to integer with the CAST() function, we can summarize how many inquiries included their contact information. 

-----------------------------------------------

-- Proportion of Contacts by Priority
-- Goal: Investigate database for high priority complaints for contact information and compare to medium priority complaints.

SELECT 
priority,
  
SUM(email)/COUNT(*)::numeric AS email_prop,
SUM(phone)/COUNT(*)::numeric AS phone_prop
  
FROM evanston311
LEFT JOIN indicators
ON evanston311.id = indicators.id
GROUP BY priority;

-- Explanation: since email was turned to integers 0 or 1, we can use the sum() function and divide by the count of all rows. By casting this as a numeric we can see a percentage. Grouping by priority will give us the insight that medium complaints have 2% of email and 1.8% phone numbers as contact information. High priority has 1.1% for emails and 2.3% for phone numbers. 

-- Insight: Medium and High priority requests do contain contact information more frequently, hovering about 2% of the time, whereas Low priority requests have email 0.6% and phone numbers 0.2%. In other words 6 or 2 times out of 1000 requests compared to higher priority calls that have it about 20 out of 1000 requests. 



