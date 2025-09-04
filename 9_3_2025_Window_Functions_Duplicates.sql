-- We can remove duplicates by using window functions to label a row number to each row based on conditions. 

-- In this case, if the email and the product name are the same then the assigned row number will be 2 and 3 and so on if the conditions are duplicate

SELECT *,
ROW_NUMBER() OVER (
  PARTITION BY LOWER(email), LOWER(product_name)
  ORDER BY order_id
  ) AS row_number    -- "rank"
FROM product_inventory_table

--------------------------------------------

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

