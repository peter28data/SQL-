/* Case Study: DataBallers
Entity-Relationship (E:R) diagram: A visual representation of database structure. 
The company will be involved in hosting an Olympic games event and would like a report on both the winter and summer sports to be centralized. Create a query that shows a unique number of events held for each sport. The UNION functions will combine both datasets and exclude null values. The result will be a column for sports and the number of events that occur within each sport.  */
SELECT
sport,
COUNT(DISTINCT event) AS events
FROM summer_games
GROUP BY sport
UNION
SELECT 
sport,
COUNT(DISTINCT event) AS events
FROM winter_games
GROUP BY sport
ORDER BY events DESC;

---------------------------------------Ch.2 Creating Reports---------------------------------------
WHERE -- Used when filtering on a dimension
HAVING -- Used when filtering on an aggregation, such as SUM(revenue)

-- Option A: JOIN first, UNION second
SELECT
athlete_id,
gender,
age,
gold
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;
-----------------------------Now combine with UNION
UNION ALL
SELECT
athlete_id,
gender,
age,
gold
FROM winter_games AS wg
JOIN athletes AS a
ON wg.athlete_id = a.id;

-- Option B: UNION first, JOIN second
SELECT
athlete_id,
gold
FROM summer_games AS sg
UNION
SELECT
athlete_id,
gold
FROM winter_games AS wg;
--------------------------Now turn this into subquery
SELECT
athlete_id,
gender,
age,
gold
  
FROM (
  SELECT
  athlete_id,
  gold
  FROM summer_games AS sg
  UNION
  SELECT
  athlete_id,
  gold
  FROM winter_games AS wg) AS g
JOIN athletes AS a
ON g.athlete_id = a.id;





-----------------------------------------------------------------

-- Data Scientist
-- A small independent restaurant has been collecting data from their customers such as name, date, items orders, city of residence, total amount spent, and feedback for their meals through ratings.
-- A Data Scientist would be expected to build a model to **predict the rating** for new meals added to the menu
-- A Data Analyst would be tasked with building a dashboard to present historical findings. 
-- A Data Engineer would be overseeing the collection of data by assigning databases based on size and speed of data collected. 




-----------------------------------------------------------------
