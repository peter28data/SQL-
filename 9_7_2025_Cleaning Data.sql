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

-- 2.1 Missing Data
-- It can present itself as 0, "0", blank fields, "Not Specified", "N/A", "#N/A", None, NaN, NULL, or Infinity.

-- Drop Rows where Null
DELETE FROM your_table
WHERE product_review IS NULL;

-- Create new Column
-- An empty "last_purchase_date" can be translated to a "purchased_recently" column, with values 0 for "no" and 1 for "yes".
ALTER TABLE your_table
ADD purchased_recently INT;

UPDATE your_table
SET purchased_recently = CASE WHEN last_purchase_date IS NULL THEN 0
ELSE 1
END;


-- Estimate Values with Rolling Averages or Forward Fils

-- Fill with Average
UPDATE your_table
SET temperature = (
  SELECT AVG(temperature)
  FROM your_table
  WHERE temperature IS NOT NULL
)
WHERE temperature IS NULL;


--






















