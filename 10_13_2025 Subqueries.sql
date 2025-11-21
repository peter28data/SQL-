--------------------------------------------------------------------------

SELECT
  p1.date,
  p1.player_name AS home_pl1,
  p2.player_name AS home_pl2

FROM (
  SELECT m.id, p.player_name, m.date
  FROM match AS m
  INNER JOIN players AS p
  ON m.home_player_1 = p.player_id) AS p1

INNER JOIN (
  SELECT m.id, p.player_name
  FROM match AS m
  INNER JOIN players AS p
  ON m.home_player_2 = p.player_id ) AS p2

ON p1.id = p2.id
LIMIT 5;




------------------------------------------------------------------

-- Nested Subquery to Find Number of Matches with double the average goals scored for Each Year

SELECT season, COUNT(id)
FROM (
  SELECT season, id
  FROM match 
  WHERE home_goal > (
    SELECT AVG(home_goal + away_goal) * 2
    FROM match)) AS abc
GROUP BY season
LIMIT 3;





-----------------------------------------------------------------

-- Subquery
-- Calculate the Average of Goals Scored in 2012/2013 season
SELECT c.name AS country,
  AVG(CASE WHEN season = '2012/2013'
  THEN m.home_goal END) AS home_avg
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY c.name
LIMIT 3;




------------------------------------------------------------------

-- Subquery
-- Difference between the Number of Rides Started at the Station and the Number of Rides that Ended at the Station?

SELECT
  start_station,
  COUNT(start_station) AS start_trips,
  COUNT(start_station) - (SELECT COUNT(*)
    FROM trip AS t1
    WHERE t.start_station = 
          t1.end_station) AS trips_diff
FROM trip AS t
GROUP BY start_station
ORDER BY start_station DESC 
LIMIT 5;




-----------------------------------------------------------------

-- Subquery
SELECT
  l.name AS league,
  m.date,
  m.home_goal,
  m.away_goal
FROM league AS l
INNER JOIN
  (SELECT country_id, date, home_goal, away_goal
  FROM match
  WHERE home_goal > away_goal+5) AS m
ON l.id = m.country_id
LIMIT 5;







-----------------------------------------------------------------






