-------------------------- Part 1: Analyze Profit by City --------------------

-- Total Profit by City

SELECT city,
  SUM(profit) AS total_profit
FROM retail_stores
GROUP BY city
ORDER BY total_profit DESC

--------------------------------------------------------------------------

-- Python Code
profit_by_city = df.groupby("city")["profit"].sum()
profit_by_city = profit_by_city.sort_values(ascending=False)
print(profit_by_city)

--------------------- Part 2: Number of Customer Orders---------------------------

-- Number of Order per Customer
-- The Goal: Find the customers who order the most products.

SELECT customer_name,
  COUNT(DISTINCT order_id) AS number_of_orders
FROM retail_stores
GROUP BY customer_name
ORDER BY number_of_orders DESC

--------------------------------------------------------------------------

-- Python Code
order_per_customer = df.groupby("customer_name")["order_id"].nunique()
order_per_customer = profit_by_city.sort_values(ascending=False)
print(order_per_customer)

--------------------------------------------------------------------------

-- Tableau Summary
-- By putting customer name in the rows and the order id in the columns, you get all the order id's as column and nothing in the values. To fix this hover the order id to get a dropdown and select measure then count(distinct). Then we hover the order id again to select sort, by field, and descending. 



------------------ Part 3:  Profitability of Sub-Categories--------------------




























