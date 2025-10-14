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




--------------------------------------------------------------------------

