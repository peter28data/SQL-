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

-- Explanation: To create filters for date ranges we need to be able to add date intervals to dates.

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
  select genereate_series('2018-01-23 09:00:00', 
                          '2018-04-23 15:00:00', 
                          '3 hours'::INTERVAL) AS lower,
  generate_series('2018-04-23 12:00:00', 
                  '2018-04-23 18:00:00', 
                  '3 hours'::INTERVAL) AS upper)

-- Join Bins to the Sales Data
SELECT
lower, 
upper,
count(date)
FROM bins
LEFT JOIN sales
  
ON date >= lower
AND date < upper
  
GROUP BY lower, upper
ORDER BY lower;

-- Explanation: This will return one column 'lower' with 9am, noon, and 3pm records to display the count of requests during that block of time. 

-------------------------------------------------------------------

-- Average Time between Sales
-- How do you find out how much time has passed between events when the dates or timestamps are all saved in the same column?
-- The lead() and lag() functions allow us to offset the orderded values in a column by 1 row by default. 

SELECT 
AVG(gap)
FROM (
  SELECT
  date - lag(date) OVER (ORDER BY date) AS gap
  FROM sales) AS gaps;

-- Explanation: This returns the average time between sales is 00:32:15.56 which mean 32 minutes. The subquery is necessary because window functions cannot be used inside of aggregate functions such as AVG().

-------------------------------------------------------------------

-- Longest gap between Requests
-- Compute the gaps
WITH request_gaps AS (
        SELECT date_created,
               -- lead or lag
               lag(date_created) OVER (ORDER BY date_created) AS previous,
               -- compute gap as date_created minus lead or lag
               date_created - lag(date_created) OVER (ORDER BY date_created) AS gap
          FROM evanston311)
-- Select the row with the maximum gap
SELECT *
  FROM request_gaps
-- Subquery to select maximum gap from request_gaps
 WHERE gap = (SELECT max(gap) 
                FROM request_gaps);

-------------------------------------------------------------------

-- Investigate Delays
-- Requests in the category "Rodents-Rats" average over 64 days to resolve. Why?
SELECT date_trunc('day', date_completed - date_created) AS completion_time,
       count(*) 
  FROM evanston311
 WHERE category = 'Rodents- Rats'

 GROUP BY completion_time
 ORDER BY completion_time;

-- Checks the distribution of completion times. The above query returns a column of completion times such as 1 day, two days and a count of how many requests were completed in that duration of time. 

SELECT category, 

       avg(date_completed - date_created) AS avg_completion_time
  FROM evanston311

 WHERE date_completed - date_created < 

         (SELECT percentile_disc(0.95) WITHIN GROUP (ORDER BY date_completed - date_created)
            FROM evanston311)
 GROUP BY category

 ORDER BY avg_completion_time DESC;

-- Above we have computed the average complettion time per Category excluding the outliers which are the longest 5% of requests. Trash Cart, Sanitation billing questions, and rodents take the longest on average 12 days compared to others taking 2-10 days. 

SELECT corr(avg_completion, count)
  FROM (SELECT date_trunc('month', date_created) AS month, 
              
               avg(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, 
            
        count(*) AS count
        FROM evanston31
        WHERE category='Rodents- Rats' 
        GROUP BY month) 
        
        AS monthly_avgs;

-- Above we computed the correlation between average completion time and monthly requests. There is a .23 or 23% correlation so very weak. 


WITH created AS (
       SELECT date_trunc('month', date_created) AS month,
              count(*) AS created_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month),

      completed AS (
       SELECT date_trunc('month', date_completed) AS month,
              count(*) AS completed_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month)

SELECT created.month, 
       created_count, 
       completed_count
  FROM created
       INNER JOIN completed
       ON created.month=completed.month
 ORDER BY created.month;

-- By month, the number of requests created and completed.
-- Insight: There is a disproportionally large number of requests completed in Nov 2017. 

-------------------------------------------------------------------------------












