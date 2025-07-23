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

----------------------------------Ch.2: User Centric KPIs-------------------------------------------
-- Registration Date is the minimum order date because it is when the user first made a purchase
SELECT
user_id,
MIN(order_date) AS reg_date
FROM orders
GROUP BY user_id
ORDER BY user_id
LIMIT 3;
-- Store the previous query's results in a CTE to store each user's registration date. The next query will truncate the reg_date column we just created to extract the month in which each registratio occurs. Then, we count the distinct user IDs in each month. This will give us a count of how many customers are registering every month. Finally we will order by month ascending to give us the new customer registrations KPI for the first 3 months of the year. 
WITH reg_dates AS (
  SELECT
  user_id,
  MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id)
SELECT
DATE_TRUNC('month', reg_date) :: DATE aS delivr_month
COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY delivr_month
ORDER BY delivr_month ASC
LIMIT 3;

-- Active Users KPI: Counts the active users of a company's app over a time period by day or by month. (DAU or MAU). Your food delivery company, Delivr, would like to know the 'Stickiness' that measures how often users engage with an app on average. An example of this metric would be if users engage with the app 9 days over 30 days in a month's time on average, this would return a 'Stickiness' metric of 30% (DAU/MAU).
-- To get this metric, we would query how many different customers are using the delivery app every month, extract the month the order was placed and group by the extracted month. 
SELECT
DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY delivr_month
ORDER BY delivr_month ASC
LIMIT 3;

-- Window Functions for Running Totals
-- COALESCE( LAG(mau) OVER (ORDER BY delivr_month ASC) --> since the first month has no previous month, LAG will return a NULL value for it, so COALESCE will set that NULL to 1. 
-- SUM(regs) OVER (ORDER BY delivr_month ASC) 
-- The use case for window functions is to perform an operation across a set of rows related to the current row. The registrations KPI only counts registrations by month, but what if you want the registered users overall by month? You can't compare the current and previous months' monthly active users unless the two values are in one row. This is why window functions are useful.
-- Running Total: A cumulative sum of a variable's previous values. 
WITH reg_dates AS (
  SELECT
  user_id,
  MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id)

registrations AS (
  SELECT
  DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
  COUNT(DISTINCT user_id) AS regs
  FROM orders
  GROUP BY delivr_month)

SELECT
delivr_month,
regs,
SUM(regs) OVER (ORDER BY delivr_month ASC) AS regs_rt
FROM registrations
ORDER BY delivr_month ASC
LIMIT 3;

-- Delta is the absolute change where as the growth rate is a percentage that show the change in a variable over time relative to that variable's initial value. The first month's growth rate is meaningless as it has nothing to compare to. The sequential growth rates will steadily decline until a stable growth rate is reached. 
-- (Current value - previous value)/previous value is the formula for growth rate. 
WITH maus AS (...),
maus_lag AS (...)
SELECT 
delivr_month,
mau,
ROUND(
  (mau - last_mau) :: NUMERIC / last_mau,
  2) AS growth
FROM maus_lag
ORDER BY delivr_month
LIMIT 3; 

/* Monthly Active Users (MAU) Pitfalls
Case 1: 100 users register every month but only stay active for 1 month
Case 2: 100 users register the first month, stay active, but no new registrations afterwards.
Both Cases MAUs will be 100
Users who were not active the previous month but returned to activity this month are labeled 'Resurrected users'. 

Retention Rate: The CTE will store a list of months and the users that were active in these months by selecting the distinct order dates, truncated to the month, and the user IDs. The final query will select the previous month then, count the distinct active users in the current month and divide them by the count of distinct active users in the current month. By casting the numerator to NUMERIC and rounding the results, a cleaner output is returned. The GREATEST function is used to avoid dividing by zero, in case the previous month has zero active users. In case it does, it defaults to 1. Finally select from the CTE as 'previous' for previous month. Then, left join on the same CTE aliased as 'current'. The common key should be user ID and the previous month being equal to the current month minus an interval of one month. This way, you 'peek into' the future and see whether a user stayed in the month after the previous month.  
*/
WITH user_monthly_activity AS (
  SELECT DISTINCT DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
  user_id
  FROM orders)
SELECT
ROUND(COUNT(DISTINCT current.user_id) :: NUMERIC /
  GREATEST(COUNT(DISTINCT previous.user_id),1),2) AS retention_rate
FROM user_monthly_activity AS previous
LEFT JOIN user_monthly_activity AS current
ON previous.user_id = current.user_id
AND previous.delivr_month = (current.delivr_month - INTERVAL '1 month')
GROUP BY previous.delivr_month
ORDER BY previous.delivr_month ASC;

------------------------------------Ch.3: ARPU, Histograms, Percentiles ---------------------------
/* Unit Economics: Measures performance per unit, as opposed to overall performance
Example: Average Revenue Per User (ARPU): Overall revenue / Count of users
The Unit Economic ARPU measures a company's success in scaling its business model and can be useful to secure financial loans based on future projections at the current Unit Economics and other growth rates. The first query will be useful to track over time because it can be easily grouped by month. The second way is useful to see the distribution of revenue per users for a histogram. */
-- ARPU Query 1: returns total revenue and users column
WITH kpis AS (
  SELECT
  DATE_TRUNC('month', order_date) AS delivr_month,
  SUM(meal_price * order_quantity) AS revenue,
  COUNT(DISTINCT user_id) AS users
  FROM users
  JOIN orders ON m.meal_id = o.meal_id
  GROUP BY delivr_month)

SELECT 
delivr_month
ROUND(
  revenue :: NUMERIC / GREATEST(users, 1),
  2) AS arpu
FROM kpis
ORDER BY delivr_month ASC;

-- ARPU Query 2: returns list of user IDs and revenue for each 
WITH user_revenue AS (
  SELECT
  user_id,
  SUM(meal_price * order_quantity) AS revenue
  FROM meals 
  JOIN orders 
  ON meals.meal_id = orders.meal_id
  GROUP BY user_id)

SELECT 
ROUND(AVG(revenue) :: NUMERIC, 2) AS arpu
FROM user_revenues;

-- Histograms can be built from querying a frequency table where you have each user's count of orders. Count each user's distinct order IDs and store them in the CTE. Then, select the orders column and count the distinct user IDs for each order count. Lastly, sort the results by the orders column in ascending order. 
WITH user_orders AS (
  SELECT
  user_id,
  COUNT(DISTINCT order_id) AS orders
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
  GROUP BY user_id)

SELECT
orders,
COUNT(DISTINCT user_id) AS users
FROM user_orders
GROUP BY orders
ORDER BY orders ASC; 

