--2
select
category,
item,
avg(price) as avg_price
from fruit_2022
group by category, item
having avg(price) > 3




--6 return rows where the title contains 'k' or 'm' only in lowercase
WHERE title SIMILAR TO '%(k|m)%';    -- LIKE can be used for lowercase specific character
-- the LIKE operator does not support Regular expressions or pattern alternation using Parentheses and the pipe symbol ( (k|m) ).


--7 the title does Not only contain word characters(letters, numbers or underscores)
WHERE title NOT SIMILAR TO '\w*';



--15 return the movie titles which only includes four letters
-- Wrong--WHERE title LIKE length(title) =4;
WHERE title LIKE '____';    -- 4 underscores indicate 4 characters


--8 Pattern Matching is to prepare and clean a table, for this query, the goal is to retrieve the orders from Canada from the 'id' column. 


--9 return the rows with the second to fourth highest price 
ORDER BY price DESC
OFFSET 1
LIMIT 3;




--10 for each vendor_name: ->combine the vendor_city and vendor_state
SELECT
vendor_name,
CONCAT(vendor_city,', ', vendor_state) AS location
FROM vendors
LIMIT 3;




--11 return the number of rows that the speaker's price is higher than the average price from the speaker table.
SELECT
COUNT(*) AS above_avg
FROM speaker
WHERE price > (SELECT AVG(price) FROM speaker);  -- Wrong -> Aggregate functions cannot be used in the where clause because it is executed before aggregation happens. WHERE price > AVG(price);



--12 Return the difference between each month's highest and lowest price.
SELECT
EXTRACT(month FROM date::DATE) AS month,
MAX(price) - MIN(price) AS difference


---------------------------------------------------------------
  
--14 bike_stations contains newly built bike locations. bike_trips contains bike trips on new locations or previously existing ones. return each bike trip only started in newly built bike stations.
SELECT
trip_id,
station_id,
latitude,
longitude
FROM bike_trips as t
INNER JOIN bike_stations AS s    -- Wrong ->left join bike_stationsl as s
on t.stating_station = s.station_id;
-- The explanation is because a left join will return NULL for columns where there is no match with the right side. An inner join will return only matched records. 


--4 Join table but keep all the records no mater whether they a match
SELECT
  trip_id,
  duration,
  bike_id
  FROM bike_trips as t
  FULL JOIN bike as b
  on t.bike_id = b.bike_id

  

--------------------------------------------------------------------------------------------
--15 return number of duplicates records
SELECT
name,
city,
state,
COUNT(*) AS duplicates
FROM vendors
GROUP BY name, city, state    --by grouping by these and selecting the count it shows dups


--14 Return vendors from austin city
SELECT
vendor_name, 
vendor_city,
vendor_state
FROM vendors
WHERE vendor_city = 'AUSTIN';


--13 Return the number of rows in the 'launch' column where the value is NOT a date OR the value is missing
SELECT 
COUNT(*)
FROM speaker
WHERE launch = 'Null' OR launch IS NULL;    --Not a date is labeled 'Null'


--12 Validate the date and return the rows that the 'installation_date' is not a date in 2013
SELECT *
FROM station
WHERE installation_date NOT BETWEEN '2013-01-01' 
AND '2013-12-31';


--11 Validate the date there should not be any negative values
SELECT *
FROM trips
WHERE duration < 0;


--7 Join the table with another but keep all the records from one table no matter whether they have a match in the other
SELECT trip_id,
duration,
t.bike_id
FROM bike_trips as t
LEFT JOIN bike as b
ON t.bike_id = b.bike_id;


--6 Join the tables but keep only the matched records
SELECT trip_id,
duration,
t.bike_id
FROM bike_trips as t
INNER JOIN bike as b
ON t.bike_id = b.bike_id;


--5 Join the table with itself to return the pairs of the speaker model with the same launch date
SELECT
s1.model, 
s2.model,
s1.price,
s2.price
FROM speaker s1
INNER JOIN speaker s2
ON s1.productid <> s2.productid 
AND s1.launch = s2.launch;


--3 Return the day from the column and convert the day to numeric data type
SELECT
trip_id,
EXTRACT(DAY FROM start_time) :: NUMERIC AS start_day
FROM bike_trips;


--2 Return the first five rows that the title DOES NOT contain 'the' no matter the case of the string
SELECT *
FROM movie_budget
WHERE title NOT ILIKE '%the%'
LIMIT 5;


--1 Validate the data by returning the rows that the 'bike_available' column is out of range (each station has at least one bike and at most 10)
SELECT *
FROM status
WHERE bikes_available < 1 
OR bikes_available > 10;


-----------------------------------------------------------------------------


-- combine 2 columns with a comma and space into the new column
SELECT vendor_name,
CONCAT(vendor_city,', ',vendor_state) AS location
FROM vendors
LIMIT 3;


-- split the title into 2 parts
SELECT year,
SPLIT_YEAR(title,':',1) AS name,

SPLIT_YEAR(title,':',1) AS series
FROM movie_budget;


---------------------------------------------------------------------------


-- The movie with the longest title
SELECT year, title, budget,
LENGTH(title) AS title_len
FROM movie_budget
ORDER BY title_len DESC      -- This will ensure the longest title is returned
LIMIT 1;

---------------------------------------------------------------------------

-- Validate the date by Returning the rows that the installation_date is not a date in 2013
SELECT * 
FROM station
WHERE installation_date NOT BETWEEN '2013-01-01' AND '2013-12-31';

-------------------------------------


SELECT 
start_station,
subscription_type,
count(start_date) as trips,
(select count(start_date)
  from trip as t1
  where t.start_station = t1.start_station) as station_total
from trip as t
group by start_station, subscription_type
order by start_station
limit 3;



with s as (
  select
  start_station,
  count(start_date) as starts
  from trip 
  group by start_station)
select
t.end_station as station,
count(t.end_datae) as ends,
s.starts
from trip as t
inner join s
 on t.end_station = s.start_station
group by station, starts
limit 3;



--------------------------------------------------------------------------

-- Which of the questions require the Joining of two separate tables, one with station ID and locations, the other with starting station IDs and start times.

-- What Time of Day most users starts biking?
-- How many bike trips has started at station 3045?
-- Where is the bike station each trip has started? --> Correct
-- Where are the bike stations available in the city?





--------------------------------------------------------------------------

-- Return the Rows that only appears in the movie_2000, But Not movie_2010
SELECT *
FROM movie_2000
EXCEPT
  
SELECT *
FROM movei_2010
ORDER BY year;

-- Explanation: The advantage of using EXCEPT is that it removes duplicates by default and returns rows in the first query but not in the second query whereas LEFT JOIN combines rows.  











