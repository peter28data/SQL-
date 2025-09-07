-- Removing Duplicates with Window Function ROW_NUMBER()

-- We can remove duplicates by using window functions to label a row number to each row based on conditions. 

-- In this case, if the email and the product name are the same then the assigned row number will be 2 and 3 and so on if the conditions are duplicate

SELECT *,
ROW_NUMBER() OVER (
  PARTITION BY LOWER(email), LOWER(product_name)
  ORDER BY order_id
  ) AS row_number    -- "rank"
FROM product_inventory_table

--------------------------------------------

-- Use Above as Subquery in FROM clause
  
-- Now to remove the duplicates, we use the WHERE clause to select only row numbers that are 1.

-- By putting the query above in the subquery in the FROM clause we can filter out duplictes with the Window Function ROW_NUMBER() that is beyond 1.

SELECT *
FROM (
  SELECT *,
ROW_NUMBER() OVER (
  PARTITION BY LOWER(email), LOWER(product_name)
  ORDER BY order_id
  ) AS row_number    
FROM product_inventory_table
  )
WHERE row_number = 1   -- Keep only Unique rows

--------------------------------------------

-- Use Common Table Expressions to Clean Data

-- INITCAP() will upper case the first letter in each word and lowercase the rest for clean customer names

-- CASE WHEN will lowercase all values in the order status to use the LIKE operater to return anything that may have misspelled as "deliver, return, refund, pend, or ship" and return each as a proper case.

WITH cleaned_data AS (
  SELECT
  order_id,
  INITCAP






