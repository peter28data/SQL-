-- Trimming
-- The goal here is to return the street name without any numbers, #, /, ., and spaces from the beginning and end of street.

SELECT DISTINCT
street,
trim(street, '0123456789 #/.') AS cleaned_streetname
FROM evanston311
ORDER BY street;


