-- Trimming
-- The goal here is to return the street name without any numbers, #, /, ., and spaces from the beginning and end of street.

SELECT DISTINCT
street,
trim(street, '0123456789 #/.') AS cleaned_streetname
FROM evanston311
ORDER BY street;

--------------------------------------------------------------------------

-- Unstructured Text
-- The goal is to find the total sum of inquires that mention trash or garbarge in the description WITHOUT the context of trash/garbage being in the category.

SELECT category, count(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
  
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY category
 ORDER BY count DESC
 LIMIT 10;

-------------------------------------------------------------------------

-- Combine Strings
-- Goal: Combine the house number and the street name that are in a seperate column.
-- Use Case #1: Adresses, Cities, Countries
SELECT
ltrim(concat(house_num, ' ', street)) AS address 
FROM evanston311

-- Explanation: the LTRIM function will remove any spaces from the start of the concatenated value. 

-------------------------------------------------------------------------

-- Split Strings
-- Goal: Extract the first word of the street names to find the most common streets regardless of the suffix afterwards such as 'Avenue', 'Road', or 'Street'.
-- Use Case #1: Emails Brand Counts, City/Country Counts
select
SPLIT_PART(street, ' ', 1) as street_name,
count(*)
from evanston311
group by street_name
order by count DESC
limit 20;

-- Explanation: The SPLIT_PART function will need a delimiter, in this case an empty space, and the first or second part of the argrument based on the delimiter. 

------------------------------------------------------------------------

-- Shorten Strings to 50 Characters
-- The goal is to to edit the description column so that only 50 characters are displayed for each record to quickly scan the column.

SELECT
CASE
WHEN length(description) > 50 THEN left(description, 50) || '...'
ELSE description
END
FROM evanston311
WHERE description LIKE 'I %'
ORDER BY description;

-------------------------------------------------------------------------

-- Recode Values
-- The goal is to get a sense of what requests are common, to do this we can aggregate by the main category. 

DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS 
  SELECT DISTINCT
  category,
  RTRIM(SPLIT_PART(category, '-', 1)) AS standardized
  FROM evanston311;

SELECT DISTINCT
standardized
FROM recode
WHERE standardized LIKE 'Trash%Cart'
OR standardized LIKE 'Snow%Removal%';

-- Explanation: The SPLIT_PART() function separates what is in the category column with the delimiter '-'. For example, 'Trash Cart,Recycling Cart - Missing' would return 'Trash Cart,Recycling Cart' since it is before the delimiter.

-- Explanation: The LTRIM() function will remove white spaces from the right side

---------------------------------------------------------

-- Update Values
-- The goal is to further the standardization of category values. In the previous exercise we removed everything after the '-' delimiter such as 'Trash Cart - Missing' and removed the white spaces on the right side. 

-- Now we are left with some values such as 'Trash Cart, Recylcing Cart' and 'Snow Removal/Concerns'. 
WHERE standardized LIKE 'Snow%Removal'
-- This line of code would not affect the 'Concerns' part of the string 'Snow Removal/Concerns'. For that, we need to add another delimiter after removal to ensure any strings that have values after Snow Removal are also changed to a standardized value 'Snow Removal' as below.

UPDATE recode
SET standardized = 'Snow Removal'
WHERE standardized LIKE 'Snow%Removal%';

-- Now we update the records for for Trash Cart categories to standardize those values as well.

UPDATE recode
SET standardized = 'Trash Cart'
WHERE standardized LIKE 'Trash%Cart%';

-- Validate Data
-- Check to make sure there are only two values 
SELECT DISTINCT
standardized
FROM recode
WHERE standardized LIKE 'Trash%Cart%'
OR standardized LIKE 'Snow%Removal%';

--------------------------------------------------------

-- Handle Outliers
-- The goal is to standardize values of category, however, there are odd inputs such as the ones below. These will be grouped together using the update, set, where IN clause.

UPDATE recode
SET standardized = 'UNUSED'
WHERE standardized IN (
  'THIS REQUEST IS INACTIVE...Trash Cart',
  '(DO NOT USE) WATER Bill',
  'NO LONGER IN USE');

--------------------------------------------------------

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
--------------------------------------------------------

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

--------------------------------------------------------

-- Proportion of Contacts by Priority
-- The goal is to see if high priority complaints have contact information to compare to medium priority complaints.
SELECT 
priority,
sum(email)/count(*)::numeric AS email_prop,
sum(phone)/count(*)::numeric AS phone_prop
FROM evanston311
LEFT JOIN indicators
ON evanston311.id = indicators.id
GROUP BY priority;


-- Explanation: since email was turned to integers 0 or 1, we can use the sum() function and divide by the count of all rows. By casting this as a numeric we can see a percentage. Grouping by priority will give us the insight that medium complaints have 2% of email and 1.8% phone numbers as contact information. High priority has 1.1% for emails and 2.3% for phone numbers. 

-- Insight: Medium and High priority requests do contain contact information more frequently, hovering about 2% of the time, whereas Low priority requests have email 0.6% and phone numbers 0.2%. In other words 6 or 2 times out of 1000 requests compared to higher priority calls that have it about 20 out of 1000 requests. 



