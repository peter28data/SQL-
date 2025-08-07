--1&2 join the tables find the pairing that goes with each wine and the price of wine

--3 the first and last names of directors are stored in separate tables. to create an invitation list for a marketing event, combine the two tables. 

--4 return month from the timestamp '2005-01-24'
SELECT
EXTRACT(month FROM timestamp '2005-01-24') AS month

--5 display all artists and the first genre listed in the 'genre' column if the 'genre' column contains an array with multiple values
SELECT
  SPLIT_PART(genre,',',1) AS main_genre  -- Wrong
  genre[1] AS main_genre                 -- Correct

--7 determine the highest count of bottles amongst all types with CTE
WITH type_count as (
  SELECT type, count(id) as bottle_count
  from wine
  group by type)
select MAX(bottle_count)
from type_count    -- max is 5


-- 8 using the 'accounts' table create a new column code_part that contains an extract of the 'code' column starting at position 3 with a total length of 4 characters
SELECT
  SUBSTR(code FROM 3 FOR 4) AS code_part  -- Wrong
  substring(code, 3, 4) AS code_part      -- Correct


--9 for each order id, calculate the total quantity of all products in the order. 
SELECT
  id,
  product,
  quantity,
  SUM(quantity) OVER(PARTITION BY id) AS total
FROM orders
ORDER BY id, product
LIMIT 5;

-- Explanantion: 



--10 average number of employees
SELECT AVG(count_employees)
FROM (
  SELECT manager_id,
  count(employee_id) AS count_employees
  FROM employees
  GROUP BY manager_id) AS employee_summary    -- returns avg


--12 Cast 2 weeks as a Time interval
SELECT CAST('2 weeks' AS INTERVAL); -- wrong ->INTERVAL 2 WEEK AS interval_value;    -- Returns 14 days 0:00:00
-- This statement converts the string '2 weeks' into an INTERVAL type. 

--14 Use a CTE to aggregate the date from current date to have a column for days overdue
-- Then filter that CTE with the final query in the where clause for 60+ days overdue
WITH ovedue AS (
  SELECT
  reference,
  date('2020-04-01') - due_date AS days_overdue
  FROM invoices)
SELECT count(*)
FROM overdue
WHERE days_overdue > 60
  


--15 Include a subquery in the WHERE clause
-- To identify rows where the rating for the client is higher than the average.
WHERE rating > (
  SELECT AVG(rating)    -- Subquery
  FROM ratings)

  ORDER BY show_id
LIMIT 10;




--QUESTIONS to go over
--3,4,5,8,9,12,13

--3 Create a new categorical variable to group prices into three levels
SELECT price_item
  CASE 
  WHEN price_item <= 50 THEN 'low'

  WHEN price_item > 50 AND price_item <=100 THEN 'medium'
 
  WHEN price_item > 100 THEN 'high'
  
  WHEN price_item IS NULL THEN 'undefined'
  END AS cost_level



--4 Extract a list of unique artists that start with a vowel letter
SELECT DISTINCT name
FROM artists

WHERE left(name, 1) IN ('A','E','I','O','U')    -- Here.
ORDER BY name
LIMIT 7;

-- Explanation: In this case, the left function returns the first character of the string because the argument is 1, however, since it is used with the IN() function it creates a filter to return values if the first character of the string in the column 'name' is a vowel letter specified in the list. 


--5 Display the previous order's quantity
LAG(quantity, 1) OVER() AS pre_quantity


--6 Change the values of the column 'item' to TITLE CASE
SELECT
initcap(item) AS item_title,    -- Capitalizes first letter & lowercase rest
energy,
protein
FROM food
ORDER BY energy, protein;

-- Explanation: Capitalizes the first letter of each word and converts the rest of the letters to lowercase.


--13 The 'pairing' table lists the recommended food items for certain wines. The goal is to return the style and price for all wines that have a pairing.
SELECT style, price
FROM wine_region
  
WHERE id IN (
  SELECT wine_id    --therefore, we filter based on the existence from 'pairing' table
  FROM pairing )

ORDER BY price, style
LIMIT 5;


--15 The purpose of using a subquery in the select clause is to return the average of two values from different tables in the same row. 
SELECT
AVG(energy) AS avg_energy                   -- energy is from 'food' table
(SELECT AVG(price) FROM wine) AS avg_price  --why?, bc price is from the 'wine' table
FROM food  





