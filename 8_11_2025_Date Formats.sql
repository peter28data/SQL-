-- Date Comparisons
-- The format will return either a 0 or 49 requests. 
SELECT COUNT(*)
FROM evanston311
WHERE date_created = '2018-01-01';

-- The query above will not return anything. Howevery when we convert the query to a timestamp it will return 49 requests.
SELECT '2018-01-02'::timestamp;

----------------------------------------------------------

-- Number of Requests
SELECT count(*) 
FROM evanston311
WHERE date_created::DATE = '2017-01-31';

-- Number of Requests
-- Greater than or equal to Feb 29 but less than March 1st queries 
SELECT count(*)
FROM evanston311
WHERE date_created >= '2016-02-29'
AND date_created < '2016-03-01';

---------------------------------------------------------

-- Specify the Upper Bound
SELECT COUNT(*)
FROM evanston311
WHERE date_created >= '2017-03-13'
AND date_created < '2017-03-13'::DATE + 1;  -- Adds One Day

-- Explanation: By adding + 1, it sets the upper limit to March 14. The < operator ensures that only requests created before March 14 are included. This way only requests created ON March 13 are counted. 

---------------------------------------------------------

-- Date Subtraction
SELECT
now() - '2015-01-01';    -- Returns: 1439 days 21:32:22

-- Date Addition
SELECT
'2018-12-10'::DATE + '1 year'::INTERVAL,  -- Adds One Year
'2018-12-10'::DATE + '1 year 2 days 3 minutes'::INTERVAL;


----------------------------------------------------------

-- Range of Dates 
SELECT 
MAX(date_created) - MIN(date_created)  -- 911 days, 16:33:39
FROM evanston311

-- How old the Most Recent request was created
SELECT now() - MAX(date_created)
FROM evanston311

-- Add 100 days to the Current Timestamp
SELECT
now() + '100 days'::INTERVAL

--------------------------------------------------------------

-- Avg completion Time
-- By Category
SELECT 
category,
AVG(date_completed - date_created) AS completion_time
FROM evanston311
GROUP BY category
ORDER BY completion_time DESC;

--------------------------------------------------------------

-- Truncate Dates
-- Useful when summarizes Sales by Month
SELECT
date_trunc('month', date) AS month,
SUM(sales_amount)
FROM sales
GROUP BY month
ORDER BY month;

-- Requests Count by Month for last 2 years
SELECT date_part('month', date_created) as month,
from evanston311
where date_created >= '2016-01-01'
and date_created < '2018-01-01'
GROUP BY month;

-- What hour of the day are most requets being created?
SELECT
datepart('hour', date_created) as hour,
count(*)
from evanston311
group by hour
order by count DESC
LIMIT 1;

-- What time of day are requests usually completed?
SELECT 
date_part('hour', date_completed) as hour,
count(*)
from evanston311
group by hour
order by hour;

-------------------------------------------------------------

-- Variation by Day of Week
-- Does the time required to complete a request vary by the day of the week on which the request was created?

TO_CHAR(date_created, 'day')  -- Name of the Day of Week

-- Problem: The to_char() function converts timestamps to character data and the sorting this data work be alphabetical, not chronological. 
-- Solution: The extract() with DOW "day of the week" gets the chronological order of days of the week with an integer value for each day.

SELECT
TO_CHAR(date_created, 'day') AS day,
AVG(date_completed - date_created) AS duration
FROM evanston311
GROUP BY day, EXTRACT(DOW FROM date_created  -- Needs both to work
ORDER BY EXTRACT(DOW FROM date_created);

-- Explanation: This does order from Sunday to to Saturday since sunday is given the integer value of 0 ascending to saturday as 6.

-- Insight: Requests created at the beginning of the work week such as monday and tuesday are closed sooner than the average time.
-------------------------------------------------------------

-- Avg Requests per Month
SELECT
date_trunct('month', day) AS month,  -- month from subquery
AVG(count)                  -- count from subquery
FROM (
  SELECT
  date_trunc('day', date_created) AS day,
  count(*) as count
  FROM evanston311
  GROUP BY day) AS daily_count

GROUP BY month
ORDER BY month;

-- Explanation: The subquery counts the number of requests per day. The group by clause ensures that the count is calculated for each distinct day. 

-- Insight: the main query truncates the month from the day column created in the subquery to allow us to group the daily counts by month. The average function then works as intended to calculate the average number of requests per day for each month. This is done by average the daily counts obtained from the subquery. The group by clause then extends the average function for each distinct month. 

-------------------------------------------------------------

-- How do you find periods of time with NO observations?
-- This is for rows without values.

SELECT
generate_series(from, to, interval);  -- The framework

-- The query below will generate a series of rows for every 2 days starting with january 1st to january 15.
SELECT
generate_series('2018-01-01', '2018-01-15', '2 days'::INTERVAL);

-- 2018-01-01
-- 2018-01-03
-- 2018-01-05     and so on...

---------------------------------------------------------------

-- How do we handle months with different amounts of days? 30, 31, 28
SELECT
generate_series('2018-02-01', '2019-01-01', '1 month'::INTERVAL) - '1 day'::INTERVAL;

-- Explanation: To correctly generate a series for the last day of each month, start from the beginnning, then subtract 1 day from the result.

-- 2018-01-31     This was feb 1st minus one day
-- 2018-2-28      This was march 1st minues one day

------------------------------------------------------------------


-- generate series to include hours with no sales
WITH hour_series AS (
  SELECT generate_series('2018-04-23 09:00:00', '2018-04-23 14:00:00', '1 hour'::INTERVAL) AS hours)

-- Join to sales date ON 
SELECT
hours,
count(date)
FROM hour_series
LEFT JOIN sales
ON hours= date_trunc('hour', date)
GROUP BY hours
ORDER BY hours;

-- Explanation: Mathcing the hours from the series TO the sales date truncatd to the hour. Count the date column, instead of counting the rows because we don't want to count null values.

-- Insight: We now can see there were no sales made during the hour of 11am whereas before the data skipped over the 11th hour for lack of data. 

-------------------------------------------------------------------

-- Aggregation with Bins
-- The benefit is to see the amount of sales generated in the morning compared to the afternoon.

WITH bins AS (
  select genereate_series('2018-01-23 09:00:00', '2018-04-23 15:00:00', '3 hours'::INTERVAL) AS lower,
  generate_series('2018-04-23 12:00:00', '2018-04-23 18:00:00', '3 hours'::INTERVAL) AS upper)



