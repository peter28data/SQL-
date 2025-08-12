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
