-- Query 1
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

-- Query 2
SELECT store_id, city, MAX(foo.sales) OVER (PARTITION BY city) FROM
(
SELECT store_id, city, SUM(payment.amount) sales FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN payment ON store.manager_staff_id = payment.staff_id
WHERE payment.payment_date >= '2007-04-14'
GROUP BY store.store_id, city.city_id
) AS foo
