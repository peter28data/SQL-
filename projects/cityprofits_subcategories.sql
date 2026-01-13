-------------------------- Task 1: Analyze Profit by City ------------------

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

--------------------- Task 2: Number of Customer Orders---------------------

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



------------------ Task 3:  Profitability of Sub-Categories-----------------

SELECT
  "Sub-Category",
  SUM(profit) AS total_profit
FROM retail_stores
GROUP BY "Sub-Category"
HAVING SUM(profit) > 5000
ORDER BY total_profit DESC;

--------------------------------------------------------------------------

-- Python Code
sub_category_profit = df.groupby("Sub-Category")["Profit"].sum()
profitability_sub_categories = sub_category_profit[sub_category_profit > 50000]

profitability_sub_categories = profitability_sub_categories.sort_values(ascending=False)
print(profitability_sub_categories)

------------------ Task 4: Sales Trend Over Time ---------------------------

SELECT
  FORMAT_DATE('%Y-%m', "Order Date") AS order_month,
  SUM(sales) AS total_sales
FROM retail_stores
GROUP BY order_month
ORDER BY order_month;

--------------------------------------------------------------------------

-- Python Code
df['Order Date'] = pd.to_datetime(df['Order Date'])
df['Order Date'] = df['Order Date'].dt.to_period('M')
monthly_sales = df.groupby('Order Month')['Sales'].sum()
print(monthly_sales)

-- Simple Line Chart
import matplotlib.pyplot as plt

plt.figure(figsize=(15,7))
monthly_sales.plot(kind='line', marker='o')

-- Adding plot title and label
plt.title('Monthly Sales Trend Over Time')
plt.xlabel('Order Month')
plt.ylabel('Total Sales')
plt.xticks(rotation=45)
plt.tight_layout()

plt.show()

--------------------------------------------------------------------------

-- Created on 9.18.2025





















