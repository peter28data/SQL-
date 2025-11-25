--------------------Step 1: Identify the Leak -----------------
-- 1.1 Identify the Data Leak

-- Check if th3ere are any rows or entire columns with no data.
SELECT * FROM your_table WHERE product_name IS NULL;


-- 1.2 Assess Data Distributions
-- Highlight outliers  to find the predominant groups or values within your data.
SELECT
  age,
  COUNT(*)
FROM your_table
GROUP BY age;


-- 1.3 Detect Irregularities
-- By using the NOT IN() function we can look for irregularities that are not NULL values such as "gender: 1995" or "postal code: ABCD". This would only work if the acceptable inputs are 'Male' or 'Female'
SELECT *
FROM your_table
WHERE gender NOT IN ('Male', 'Female');



-- 1.4 Check for Uniformity
-- One value make be upper case and in another lowercase. To check the data for inconsistent casing we use this function
SELECT DISTINCT product_name
FROM your_table
WHERE LOWER(product_name) = product_name OR
UPPER(product_name) = product_name;


--------------------Step 2: Fix the Leak -----------------

-- Missing Data
-- It can present itself as 0, "0", blank fields, "Not Specified", "N/A", "#N/A", None, NaN, NULL, or Infinity.

-- 2.1 Drop Rows where Null
DELETE FROM your_table
WHERE product_review IS NULL;

-- 2.2 Create new Column
-- An empty "last_purchase_date" can be translated to a "purchased_recently" column, with values 0 for "no" and 1 for "yes".
ALTER TABLE your_table
ADD purchased_recently INT;

UPDATE your_table
SET purchased_recently = CASE WHEN last_purchase_date IS NULL THEN 0
ELSE 1
END;


-- 2.3 Estimate Values with Rolling Averages or Forward Fils
-- Fill with Average
UPDATE your_table
SET temperature = (
  SELECT AVG(temperature)
  FROM your_table
  WHERE temperature IS NOT NULL
)
WHERE temperature IS NULL;



--------------------------------------------------------------------------

-- Outliers

-- Use Case: We detect grocery shoppers spending $0.05 annually which is unusually low and may affect the majority of the data when calculated averages.

-- 2.4 Remove Rows where purchase_amount is in the top 1% for extreme shoppers or bottom 1% such as 5 cents.
DELETE FROM your_table
WHERE purchase_amount > PERCENTILE_CONT(0.99)  --Top 1%, there is no 100th percentile

WITHIN GROUP (ORDER BY purchase_amount) OR

purchase_amount < PERCENTILE_CONT(0.01)
WITHIN GROUP (ORDER BY purchase_amount);


-- 2.5 Parition The Data
-- Segregate the standard entries from the outliers by creating a new column. 
-- This will create a new column that will label itself outlier fi the 'purchase_amount' column is greater than a threshold.
ALTER TABLE your_table ADD segment VARCHAR(50);
UPDATE your_table SET segment = CASE
WHEN purchase_amount > SOME_THRESHOLD THEN 'Outlier'
ELSE 'Standard'
END;


-- 2.6 Retain Outliers, Adapt Analysis 
-- Calculate a trimmed mean for 'purchase_amount', excluding the top and bottom 5%
SELECT AVG(purchase_amount)
FROM (
  SELECT purchase_amount
  FROM your_table
  ORDER BY purchase_amount
  LIMIT 5% OFFSET 5%
  ) AS trimmed_data;


--------------------------------------------------------------------------


-- Contaminated Data
-- Refers to the inclusion of incorrect, irrelevant, or outdated information that can distort results, leading to misleaing insights. 

-- Use Case: For a Retail business selling fine jewelry, we can spot that a gold necklace was sold for $12 which requires domain knowledge to spot the irregularly low price of fine jewelry.


-- Inconsistent Data
-- Different date formats are a common source for inconsistent data. When different departments from different managers merge their data together inconsistencies are inevitable. 

-- Use Case: A company's sales data from various branches across the world show a European date format "DD/MM/YYYY", the American branches use "MM/DD/YYYY".


-- Duplicate Data
-- 2.7 Identify and Retain only one 
SELECT DISTINCT *
FROM your_table


--------------------------------------------------------------------------










