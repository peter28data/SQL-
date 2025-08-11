-- Trimming
-- The goal here is to return the street name without any numbers, #, /, ., and spaces from the beginning and end of street.

SELECT DISTINCT
street,
trim(street, '0123456789 #/.') AS cleaned_streetname
FROM evanston311
ORDER BY street;

--------------------------------------------------------------------------
-- Unstructured Text
-- The goal is to find the total sum of inquires that mention trash or garbarge in the description WITHOUT the context of trash/garbage being in the category.

SELECT category, count(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY category
 ORDER BY count DESC
 LIMIT 10;
