-----------------------------------------------------------------

-- Most Popular Bike Stations by Start & End

-- Start Stations
WITH s AS (
  SELECT start_station,
  COUNT(start_date) AS st
  FROM trip
  GROUP BY start_station),

  -- End Stations
e AS (
  SELECT end_station,
  COUNT(end_date) AS end
  FROM trip
  GROUP BY end_station)

-- Main Query
SELECT 
s.start_station AS station,
s.st AS starts,
e.end AS ends

-- Joins
FROM s
INNER JOIN e
ON s.start_station = e.end_station
ORDER BY starts DESC
LIMIT 3;




-----------------------------------------------------------------

-- Larger Market from Subscribers or Non-subscribers?






-----------------------------------------------------------------

-- CASE Statement inside a Window Function
-- Calcualte Running Total of Hot Days (75F+)

SELECT




-----------------------------------------------------------------

-- How many columns in the Outer Query were referenced in the Correlated Subquery?




-----------------------------------------------------------------

-- Nested Subquery
-- Total trips Lower than the Average 

SELECT
start_station,
COUNT(*) AS trips
FROM trip
GROUP BY start_station
HAVING COUNT(*) <
  (SELECT AVG(tr)
  FROM (
    SELECT start_station,
    COUNT(*) AS tr
    FROM trip
    GROUP BY start_station
    ) AS subquery)
LIMIT 5;




-----------------------------------------------------------------

















