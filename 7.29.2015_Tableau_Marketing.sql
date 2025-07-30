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
