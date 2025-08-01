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

--6 return rows where the title contains 'k' or 'm' only in lowercase
WHERE title LIKE '%(k|m)%';    -- SIMILAR TO can be used for upper and lowercase

--7 the title does Not only contain word characters(letters, numbers or underscores)
WHERE title NOT SIMILAR TO '\w*';

--9 return the rows with the second to fourth highest price 
ORDER BY price DESC
GROUP BY price DESC
LIMIT 3 OFFSET 1;

--10 for each vendor_name: ->combine the vendor_city and vendor_state
SELECT
vendor_name,
CONCAT(vendor_city, ', ', vendor_state) AS location
FROM vendors
LIMIT 3;

--11 return the number of rows that the speaker's price is higher than the average price from the speaker table.
SELECT
COUNT(*) AS above_avg
FROM speaker
WHERE price > AVG(price);

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
left join bike_stationsl as s
on t.stating_station = s.station_id;

--15 return the movie titles which only includes four letters
-- Wrong--WHERE title LIKE length(title) =4;
WHERE title LIKE '____';    -- 4 underscores indicate 4 characters


