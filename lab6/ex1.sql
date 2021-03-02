--query 1
SELECT first_name, last_name, title FROM customer
CROSS JOIN film
WHERE title IN
(
SELECT title FROM customer
CROSS JOIN film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE (film.rating = 'R' OR film.rating = 'PG-13')
AND (category.name = 'Horror' OR category.name = 'Sci-Fi')
)
EXCEPT
(
SELECT first_name, last_name, title FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
)
