-- #1 Navigating Databases
-- To navigate hundreds of tables for the right columns of data it would be inefficient to pull each file individually. An efficient way is to query the list of tables to return schema name, table name, and table owner such as Postgres.
SELECT *
FROM pg_catalog.pg.tables
WHERE schemaname = 'public';



-- #2 Query for Student Performance
-- Group students by ranges of hours studied and calculate the average exam score for each group.
SELECT
CASE
WHEN hours_studied BETWEEN 1 AND 5 THEN '1-5 Hours'
WHEN hours_studied BETWEEN 1 AND 5 THEN '6-10 Hours'
WHEN hours_studied BETWEEN 1 AND 5 THEN '11-15 Hours'
ELSE '16+ Hours'
END AS hours_studied_range,
AVG(exam_score) AS avg_exam_score      -- Calculates the average exam score 
FROM student_performance
GROUP BY hours_studied_range           -- Groups by KPI (hours studied)
ORDER BY avg_exam_score DESC; 



-- #3 Ranking Exam Scores Based on Extracurricular activities
SELECT
attendance,
hour_studied,
sleep_hours,
tutoring_sessions
DENSE_RANK() OVER (ORDER BY exam_score DESC) AS exam_rank
FROM student_performance
ORDER BY exam_rank ASC
LIMIT 30;



-- #4 Who are our most Active Students?
--Calculate the average exam score of students who studied more than 10 hours and participated in extracurricular activities.
SELECT
hours_studied,
AVG(exam_score) AS avg_exam_score
WHERE hours_studied > 10
AND extracurricular_activites = 'Yes'
GROUP BY hours_studied
ORDER BY hours_studied DESC;



---------------------------------------------------------------------------------------------------
-- Q5: Aggregating Salary Range
-- Show employee names of people that have salaries less than the average.
SELECT
e.employee_name,
i.salary
FROM employee AS e, employee_info AS i
WHERE e.employee_id = i.employee_id
AND i.salary < (
  SELECT AVG(salary)         -- This is a subquery to filter for employee less than the average
  FROM employee_info);



-- Q6: Data Cleaning for Outliers
-- This query identifies outliers by selecting salaries outside of 3 standard deviation from the average. 
SELECT *
FROM employee_info
WHERE salary > (
  SELECT AVG(salary) + 3 * STDDEV(salary)
  FROM employee_info)
OR salary < (
  SELECT AVG(salary) - 3 * STDDEV(salary)
  FROM employee_info);



--










