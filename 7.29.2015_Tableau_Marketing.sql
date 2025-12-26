-- Porfolio Goal for Portfolio Project

-- An end-to-end analytics project that tracks healthcare claims from submission through payment, identifies billing bottlenecks and denial drivers, and delivers Tableau dashboards.

-- Goals: Operaltional Analyctics, Stakeholder-Driven Reporting, Revenue cylcle Fluency
-- Deliverables: Translate messy data in its raw form from data collection to executive dashboards. This should improve timeliness, accuracy, and cash flow. 

-- Business Problem: Claims are delayed or denied due to data quality issues, process bottlenecks, and payer variability --- impacting cash flow and operational efficiency. 
-- Business Goal: Ensure every claim gets on file timely and accurately. To promote operational excellence and support decision-making dashboards should be optimized for readability and have clear directives. 

-------------------------------------



/*
Marketing Analytics
-The Process of analyzing data to understand performance
-Designing metrics that reflect performance
-Tracking performance over time
MA includes a range of activites such as Descriptive Statistics to investigate what percentage of people visiting our website maek a purchase or complex nueral networks to predict items a customer is most likely to buy next. 
*/

SELECT
customer_acquistion,
customer_retention

-- Marketing Campaign: Series of advertisements sharing a single idea or theme.
-- Goal: Reduct Cart Abandonment to drive customer acquistion
-- Goal: Personalizing Product Recommendations (Drive customer retention)

-- Web Data for Tableau
SELECT
COUNT(DISTINCT user_ID)    -- 498: user id assigned at account creation
COUNT(DISTINCT cookie_id)  -- 1120: some cookie id's can have multiple sessions
COUNT(DISTINCT session_id)   -- 2000 is level of granularity
-- Summary Insight: cookie_id give an identity to computers or phone that have not yet made an account and session_id give us insight as to how many different times they have visited the website whereas user id's only are creating if a visitor is fairly motivated and creates an account. 

-- Calculation in Tableau
{FIXED cookie_id: COUNT(DISTINCT session_id} -- put in ROWS shelf, then count distinct cookie id in columns


--Marketing Attribution: The process of identifying each touch point and then assigning value to each point based on how it contributed to the overall goal. 
--First Touch Attribution: Assigning all credit to the first touch in a journey.
-- Last Touch Attribution: Assigning all credit to the last touch in a journey. 
-- Multi Touch Atribution: Credit split even across touches OR split by calculated algorithm. 

--------------------------------------Ch.2: Email and Paid Social Marketing------------------------------------
-- Marketing Funnels: Includes email funnels that are measured by delivery rate which should be ~90%, Open Rate is 20%, and click through rates are 10-12%, assuming there was a call to action in the email. 


-- Paid social and A/B Testing
-- 

-------------------------------------Ch.4: LTV / CAC-----------------------------------------------------------
/*
Lifetime Value or CLTV (Customer Lifetime Value) is an estimation of how much a customer is worth to a company over the customer's lifetime. 
-If a customer spends an average of 5 years with our service at $100/year, the LTV is $500.
-LTV can also equal (Total Revenue/Total # of Customers)/Churn Rate

Customer Acquisition Cost (CAC): The cost of acquireing a customer. 
CHURN RATE: ~3-8% is the rate at which customers stop purchasing
COHORT Analysis: Groups of customers with similar behaviors such as a boutique fitness studio
*/
  
-- #0 Student Flag
(email, '.edu') THEN "Student" ELSE "Non-Student" END
  
-- #1 Last Purchase Date
{FIXED cookie_id: MAX(purchase_date)}
-- #2 Days Since Purchase
DATEDIFF('day', last_purchase_date, DATEPARSE("MM-DD-YYYY", "01-31-2023"))

-- #3 Churn Flag
IF days_since_last_purchase > 90 THEN 1 ELSE 0 END

-- #4 Average Order Size
-- If the number of customers and frequency of purchasing remains the same, LTV will as the average order size increases. 
--Tableau: Avg Order Size with purchase value and distinct count of order id
SUM(purchase_value)/COUNTD(order_id)

-- Tableau: Concatenate purchase id and session id to a string
STR(purchase_id) + " " + STR(session_id)

------------------------------------------------------------------------------------------------------------
-- Customer Acquisition Costs (CAC)
-- E-commerce or B2C (Business to Customer) is about 20-$30.
-- B2B such as corporate law, commercial real estate can be thousands of dollars 

-- 10% of Revenue on Marketing. Retail, consumer packaged goods and healthcare spend more CAC. <10% of revenue spend on marketing include industries such as education, energy, and transportation



--IFNULL
-- To combine these string fields, we use the ifnull function to use one ad group field and switch to the other if the first is null. 
