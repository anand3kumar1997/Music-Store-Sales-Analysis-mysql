--                                    SQL PROJECT- MUSIC STORE DATA ANALYSIS

-- --------------------------------------------------------------------------------------------------------------------------------
--                                            Question Set 1 - Easy

-- 1. Who is the 'senior most' 'employee' based on 'job title'?

SELECT last_name, first_name, title, MIN(birthdate) OVER(PARTITION BY title) AS DOB
FROM music_database.employee;

SELECT last_name, first_name, title, MIN(birthdate) AS DOB_of_senior_most
FROM music_database.employee
GROUP BY title;

-- Senior most employee based on level.
SELECT A.*
FROM (SELECT last_name, first_name, title, levels FROM employee ORDER BY levels DESC) AS A
GROUP BY A.title
ORDER BY A.levels DESC
LIMIT 1;


-- 2. Which countries have the most Invoices?

SELECT billing_country, COUNT(*) as invoice_count    -- or COUNT(invoice_id)
FROM music_database.invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;


-- 3. What are top 3 values of total invoice?

SELECT *, SUM(total) Top_3_values
FROM music_database.invoice
GROUP BY customer_id
ORDER BY Top_3_values DESC
LIMIT 3;


-- 4. Which city has the 'best customers'? We would like to throw a promotional Music 
-- Festival in the city we made the most money. Write a query that returns one city that 
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice 
-- totals

SELECT billing_city, SUM(total)
FROM music_database.invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC;



-- 5. Who is the best customer? The customer who has spent the most money will be 
-- declared the best customer. Write a query that returns the person who has spent the 
-- most money

SELECT customer.customer_id,customer.first_name, customer.last_name, SUM(invoice.total)
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY invoice.customer_id
ORDER BY SUM(invoice.total) DESC;


-- --------------------------------------------------------------------------------------------------------------------------------
--                                            Question Set 2 - Moderate

-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music 
-- 'listeners'. Return your list ordered alphabetically by email starting with A

SELECT DISTINCT(customer.email), customer.first_name, customer.last_name, genre.name
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
JOIN invoice_line
ON invoice.invoice_id = invoice_line.invoice_id

JOIN track
ON invoice_line.track_id = track.track_id
JOIN genre
ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'        -- or -- WHERE genre.name = 'Rock'
ORDER BY customer.email;

-- WHERE invoice_line.track_id IN (SELECT track.track_id FROM track
--                                 JOIN genre
--                                 ON track.genre_id = genre.genre_id
--                                 WHERE genre.name LIKE 'Rock')
-- ORDER BY customer.email;


-- 2. Let's invite the 'artists' who have written the 'most rock music' in our dataset. Write a 
-- query that returns the Artist name and 'total track count' of the 'top 10 rock bands'

SELECT artist.name, COUNT(artist.artist_id) AS No_of_albums  -- or COUNT(*)
FROM artist
JOIN album
ON artist.artist_id = album.artist_id
JOIN track
ON album.album_id = track.album_id
JOIN genre
ON track.genre_id = genre.genre_id    
WHERE genre.name ='Rock'                                   -- or -- WHERE track_id IN ( SELECT track.track_id FROM track JOIN genre ON track.genre_id = genre.genre_id WHERE genre.name ='Rock')
GROUP BY artist.artist_id                    -- NOTE POINT: Agar kuch samhj na aaye ki group by kispe lagaye to apne question wale pe hee lgadena group by.
ORDER BY No_of_albums DESC
LIMIT 10;


-- 3. Return all the 'track names' that have a 'song length' longer than the 'average song length'. 
-- Return the 'Name' and 'Milliseconds' for each track. Order by the 'song length' with the 
-- longest songs listed first

SELECT track.name, track.milliseconds
FROM track
WHERE track.milliseconds > (SELECT AVG(track.milliseconds) FROM track)
ORDER BY track.milliseconds DESC;

-- Sol acc to string length
SELECT track.name, track.milliseconds, LENGTH(track.name)
FROM track
WHERE LENGTH(track.name) > (SELECT AVG(LENGTH(track.name)) FROM track)    -- IMP NOTE -- Only this way expected result could be obtained
ORDER BY LENGTH(track.name) DESC;


-- --------------------------------------------------------------------------------------------------------------------------------
--                                            Question Set 3 - Advance

-- 1.1. Find how much 'amount' spent by 'each customer' on 'artists'? Write a query to return
-- customer name, artist name and total spent

SELECT customer.first_name, customer.last_name, artist.name AS artist_name , SUM(invoice.total) AS Amount_spent_on_each_artist
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN album ON track.album_id = album.album_id
JOIN artist ON album.artist_id = artist.artist_id
GROUP BY customer.customer_id , artist.artist_id
ORDER BY Amount_spent_on_each_artist DESC;    -- or -- GROUP BY 1,3 if customer_id is 1st in select statement & artist_id 3rd in select statement




-- 2. We want to find out the most popular music 'Genre' for each 'country'. We determine the 
-- most popular genre as the genre with the highest amount of purchases. Write a query 
-- that returns each country along with the top Genre. For countries where the maximum 
-- number of purchases is shared return all Genres

WITH cte AS (SELECT invoice.billing_country, genre.name, COUNT(invoice.total), ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY COUNT(invoice.total) DESC) AS row_no
FROM invoice
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY invoice.billing_country, genre.name
ORDER BY COUNT(invoice.total) DESC)

SELECT * FROM cte WHERE row_no = 1;

-- --------------------------------- or --------------------------------

WITH cte AS (SELECT invoice.billing_country, genre.name, COUNT(invoice.total)
FROM invoice
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY invoice.billing_country, genre.name
ORDER BY SUM(invoice.total) DESC)

SELECT *
FROM cte
GROUP BY cte.billing_country;

-- Recursive concept
WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;




-- 3. Write a query that determines the 'customer' that has 'spent the most on music' for each 
-- 'country'. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all 
-- customers who spent this amount

WITH cte AS (SELECT customer.first_name, customer.last_name, customer.country, SUM(invoice.total), ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY SUM(invoice.total) DESC) AS row_no
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY 1,2,3
ORDER BY 3)

SELECT * FROM cte WHERE row_no = 1;


-- Recursive method
WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;
