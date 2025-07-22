----------------------------------Ch.1: Revenue, Cost, Profit----------------------------------------
-- Calculating Profit
SELECT
  order_id,
  SUM(meal_price * order_quantity) AS revenue   -- Multiply each meal's price by ordered quantity
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY order_id;

-- Working with dates
DATE_TRUNC('week', '2018-06-12') :: DATE     -- Changes date to start of week '2018-06-11'
DATE_TRUNC('month', '2018-06-12') :: DATE    -- Changes date to start of month '2018-06-01'
DATE_TRUNC('quarter', '2018-06-12') :: DATE  -- Changes date to start of quarter '2018-04-11'
DATE_TRUNC('year', '2018-06-12') :: DATE     -- Changes date to start of year '2018-01-01'

-- Common Table Expressions (CTEs) and Cost
WITH costs_and_quanitities AS (
  SELECT
    meals.meal_id,
    SUM(stocked_quantity) AS quantity,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY meals.meal_id)
/*
This query save results to only pull from data that meets the following conditions. In the next query, the meal ID, total stocked quantity, and total stocking costs of the otp 3 meals by stocking costs are selected from the CTE 'costs_and_quantities' as if it were any other table. The CTE is deleted after the query finishes running. 
*/
SELECT
  meal_id,
  quantity,
  cost
FROM costs_and_quantities
ORDER BY cost DESC
LIMIT 3; 

-- Key Performance Indicator (KPI)
-- Profit per user; to identify the best users
-- Profit per meal; to identify the most profitable meals
-- Profit per month; to track profit over time
/*
The following query will create two CTEs to calculate revenue and cost to identify the KPIs identified above. The third query will return the top 3 meals by profit. 
*/
WITH revenue AS (
  SELECT
  meals.meal_id,
  SUM(meal_price * meal_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meals_id
  GROUP BY meals.meal_id),
cost AS (
  meals.meal_id,
  SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY meals.meal_id)
SELECT
revenue.meal_id,
revenue,
cost,
revenue - cost AS profit
FROM revenue
JOIN cost ON revenue.meal_id = cost.meal_id
ORDER BY proft DESC
LIMIT 3;
