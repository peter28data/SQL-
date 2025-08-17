---------------------------------------------------------------------------------

-- Summer Olympic Games
-- #1 Number of athletes by Sport
SELECT
sport,
COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport
ORDER BY athletes DESC
LIMIT 3;

--------------------------------------------------------------------------------

-- Athletes (x) vs Events (y) Visual by Sport
SELECT
sport,
COUNT(DISTINCT event) AS events,
COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport;

-- Explanation: This query returns a column of sports then events and then athletes so we can create a visualization from the default dataset. 

--------------------------------------------------------------------------------

-- Most Gold Medals
SELECT
a.name AS athlet_name,
SUM(gold) as gold_medals
FROM summer_games as s
join athletes as a
on s.athlete_id = a.id
GROUP BY a.name
HAVING sum(gold) > 2
ORDER BY gold_medals DESC;

--------------------------------------------------------------------------------

-- WHERE vs HAVING 
-- this would work to filter the list for events that have athletes over the age of 40.
SELECT athletes
FROM summer_games
WHERE age > 40

-- Better option
-- Subqueries select ID in the where age > 40 clause works

-- Doesnt work
-- using the HAVING filter becuase it works after aggreagtions and that filters out entire events instead of individual athletes.
  
-------------------------------------------------------------------------------

-- UNION ALL
-- The goal is to create a report from summer and winter season events to find the unique number of events. 
SELECT
  'summer' as season,
  country,
  count(distinct event) as events
FROM summer_games as s
JOIN countries as c
ON s.country_id = c.id
GROUP BY country          -- column1: season, column2: country, col3: events

UNION ALL

SELECT
  'winter' as season,
  country,
  count(distinct event) as events
FROM winter_games as w
JOIN countries as c
ON w.country_id = c.id
GROUP BY country
ORDER BY events DESC;

------------------------------------------------------------------------------

-- CASE WHEN
-- Categorize players into three segments: tall female, tall male, or other
SELECT
  name,
  CASE
  WHEN gender = 'F' AND height >= 175 THEN 'Tall Female'
  WHEN gender = 'M' AND height >= 190 THEN 'Tall Male'
  ELSE 'Other' END AS segment
  FROM athletes;

-------------------------------------------------------------

-- CASE WHEN
-- BMI buckets
SELECT
  sport,
  CASE 
  WHEN 100 * weight/height^2 <.25 THEN '<.25'
  WHEN 100 * weight/height^2 <=.30 THEN '.25-.30'
  WHEN 100 * weight/height^2 >.30 THEN '>.30'
  END AS bmi_bucket,
  COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games as s
JOIN athletes as a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

------------------------------------------------------------------------------

-- Labeling Nulls
SELECT
  sport,
  CASE 
  WHEN 100 * weight/height^2 <.25 THEN '<.25'
  WHEN 100 * weight/height^2 <=.30 THEN '.25-.30'
  WHEN 100 * weight/height^2 >.30 THEN '>.30'
  ELSE 'no weight recorded'                    -- This covers NULL values
  END AS bmi_bucket,
  COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games as s
JOIN athletes as a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

------------------------------------------------------------------------------

-- Subquery to filter from Seperate table
SELECT
  SUM(bronze) AS bronze_medals,
  SUM(silver) AS silver_medals,
  SUM(gold) AS gold_medals
FROM summer_games
WHERE athlete_id IN
  (SELECT id
  FROM athletes
  WHERE age <= 16);

-------------------------------------------------------------------------------

-- Top Athletes in Nobel-Prized countries
SELECT 
  event,
  CASE
  WHEN event LIKE '%Women%' THEN 'female'
  ELSE 'male' END AS gender,
  COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games                    -- Summer Olympic Games
WHERE country_id IN (                -- Filters for Nobel-Prize Countries
  SELECT
  country_id
  FROM country_stats
  WHERE nobel_prize_winners > 0)
GROUP BY event

UNION
SELECT
  event,
  CASE 
  WHEN event LIKE '%Women%' THEN 'female'
  ELSE 'male' END AS gender,
  COUNT(DISTINCT athlete_id) AS athletes
FROM winter_games                  -- Winter Olympic Games
WHERE country_id IN (
  SELECT country_id
  FROM country_stats
  WHERE nobel_prize_winners > 0)
GROUP BY event
ORDER BY athletes DESC          -- Events with the most athletes appear first
LIMIT 10;

-- Explanation: The query combines data from Summer and Winter games and filters for countries with at least one nobel prized winner however this condition can be changed for other business cases with different requirements. The Insight from this query that the top 4 events with the most unique athletes are female dominated ranging from 56-50 women in the swimming women's 4x100 metres Medly Relay at 56. The first male dominated event is the men's 4x200 metres freestyle relay also for swimming. 
------------------------------------------------------------------------------













-- List of Events
SELECT DISTINCT event
FROM winter_games;

