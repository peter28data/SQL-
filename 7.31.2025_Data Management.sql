--2
select
category,
item,
avg(price) as avg_price
from fruit_2022
group by category, item
having avg(price) > 3

--3 which item in the veg cat has an avg price more than 2
select
item,
category
from fruit_2022
where category = ' veg'
having avg(price) 2



--4 Join table but keep all the records no mater whether they a match
SELECT
  trip_id,
  duration,
  bike_id
  FROM bike_trips as t
  FULL JOIN bike as b
  on t.bike_id = b.bike_id

  

--6 return rows where the title contains 'k' or 'm' only in lowercase
WHERE title SIMILAR TO '%(k|m)%';    -- LIKE can be used for lowercase specific character
-- the LIKE operator does not support Regular expressions or pattern alternation using Parentheses and the pipe symbol ( (k|m) ).


--7 the title does Not only contain word characters(letters, numbers or underscores)
WHERE title NOT SIMILAR TO '\w*';



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



--15 return the movie titles which only includes four letters
-- Wrong--WHERE title LIKE length(title) =4;
WHERE title LIKE '____';    -- 4 underscores indicate 4 characters



