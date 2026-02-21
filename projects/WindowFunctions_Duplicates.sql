---------------------------------------------

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


-- Final Query
  
WITH cleaned_data AS (
  SELECT
  order_id,

  -- Clean customer name
  INITCAP(customer_name) AS customer_name,
  email,

  -- Standardize order_status
  CASE
    WHEN LOWER(order_status) LIKE '%deliver%' THEN "Delivered"
    WHEN LOWER(order_status) LIKE '%return%' THEN "Returned"
    WHEN LOWER(order_status) LIKE '%refund%' THEN "Refunded"
    WHEN LOWER(order_status) LIKE '%pend%' THEN "Pending"
    WHEN LOWER(order_status) LIKE '%ship%' THEN "Shipped"
    ELSE 'Other'
  END AS cleaned_order_status,

  --Standardize product_name
  CASE
    WHEN LOWER(product_name) LIKE '%apple watch%' THEN "Apple Watch"
    WHEN LOWER(product_name) LIKE '%samsung galaxy s22%' THEN "Samsung Galaxy S22"
    WHEN LOWER(product_name) LIKE '%google pixel%' THEN "Google Pixel"
    WHEN LOWER(product_name) LIKE '%macbook pro%' THEN "MacBook Pro"
    WHEN LOWER(product_name) LIKE '%iphone 14%' THEN "iPhone 14"
    ELSE 'Other'
  END AS cleaned_product_name,

  -- Clean quantity
  CASE
    WHEN LOWER(quantity) = 'two' THEN 2
    ELSE SAFE_CAST(quantity) AS INT64)
    END AS clean_quantity,

  --Standardize date
  COALESCE(
    SAFE.PARSE_DATE('%Y-%m-%d', CAST(order_date AS STRING)),
    SAFE.PARSE_DATE('%m/%d/%Y', CAST(order_date AS STRING))
  ) AS standardized_order_date

FROM product_inventory_table
WHERE customer_name IS NOT NULL
),

deduplicated_data AS (
  SELECT *,
    ROW_NUMER() OVER (
      PARTITION BY LOWER(email), LOWER(clean_product_name)
      ORDER BY order_id
    ) AS row_number
  FROM cleaned_data
),


  
final_table AS (
SELECT *
FROM deduplicated_data
WHERE row_number = 1
)

SELECT * FROM final_table


-------------------------------------

-- Created on 9.3.2025




