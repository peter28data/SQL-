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
AND date_created < '2017-03-13'::DATE + 1;
