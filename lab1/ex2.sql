--First view
CREATE VIEW Canada AS
SELECT first_name, last_name, email FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id
WHERE country = 'Canada';

--Query
SELECT first_name, last_name FROM Canada WHERE starts_with(canada.first_name, 'D');

--Second view
CREATE VIEW drama_actor AS
SELECT first_name, last_name, title FROM actor
LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
LEFT JOIN film ON film_actor.film_id = film.film_id
LEFT JOIN film_category ON film.film_id = film_category.film_id
LEFT JOIN category on film_category.category_id = category.category_id
WHERE category.name = 'Drama';

--Query
SELECT title FROM drama_actor GROUP BY title HAVING count(title) > 1;

--Trigger
CREATE OR REPLACE FUNCTION insertion_doubled_payment()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
BEGIN
	NEW.amount = NEW.amount * 2;
	RETURN NEW;
END;
$$;

CREATE TRIGGER doubled_payment
	BEFORE INSERT
	ON payment
	FOR EACH ROW
	EXECUTE PROCEDURE insertion_doubled_payment();

--Test for trigger
INSERT INTO payment (customer_id, staff_id, rental_id, payment_date, amount)
VALUES (1, 1, 1, '2021-02-09 22:22:22', 35);
