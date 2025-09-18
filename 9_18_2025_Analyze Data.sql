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

----------------------------------------------------------------------------

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
