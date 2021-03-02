-- Ananlysis of query 1
EXPLAIN SELECT first_name, last_name, title FROM customer
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
);

/*
"SetOp Except  (cost=185509.87..187916.56 rows=224625 width=736)"
"  ->  Sort  (cost=185509.87..186111.54 rows=240669 width=736)"
"        Sort Key: ""*SELECT* 1"".first_name, ""*SELECT* 1"".last_name, ""*SELECT* 1"".title"
"        ->  Append  (cost=533.11..7702.04 rows=240669 width=736)"
"              ->  Subquery Scan on ""*SELECT* 1""  (cost=533.11..5673.90 rows=224625 width=32)"
"                    ->  Nested Loop  (cost=533.11..3427.65 rows=224625 width=28)"
"                          ->  Seq Scan on customer  (cost=0.00..14.99 rows=599 width=13)"
"                          ->  Materialize  (cost=533.11..605.78 rows=375 width=15)"
"                                ->  Hash Join  (cost=533.11..603.91 rows=375 width=15)"
"                                      Hash Cond: ((film.title)::text = (film_1.title)::text)"
"                                      ->  Seq Scan on film  (cost=0.00..64.00 rows=1000 width=15)"
"                                      ->  Hash  (cost=528.42..528.42 rows=375 width=15)"
"                                            ->  HashAggregate  (cost=524.67..528.42 rows=375 width=15)"
"                                                  Group Key: (film_1.title)::text"
"                                                  ->  Nested Loop  (cost=1.54..454.29 rows=28153 width=15)"
"                                                        ->  Seq Scan on customer customer_1  (cost=0.00..14.99 rows=599 width=0)"
"                                                        ->  Materialize  (cost=1.54..87.50 rows=47 width=15)"
"                                                              ->  Nested Loop  (cost=1.54..87.27 rows=47 width=15)"
"                                                                    ->  Hash Join  (cost=1.26..20.58 rows=125 width=2)"
"                                                                          Hash Cond: (film_category.category_id = category.category_id)"
"                                                                          ->  Seq Scan on film_category  (cost=0.00..16.00 rows=1000 width=4)"
"                                                                          ->  Hash  (cost=1.24..1.24 rows=2 width=4)"
"                                                                                ->  Seq Scan on category  (cost=0.00..1.24 rows=2 width=4)"
"                                                                                      Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Sci-Fi'::text))"
"                                                                    ->  Index Scan using film_pkey on film film_1  (cost=0.28..0.53 rows=1 width=19)"
"                                                                          Index Cond: (film_id = film_category.film_id)"
"                                                                          Filter: ((rating = 'R'::mpaa_rating) OR (rating = 'PG-13'::mpaa_rating))"
"              ->  Subquery Scan on ""*SELECT* 2""  (cost=227.05..824.80 rows=16044 width=32)"
"                    ->  Hash Join  (cost=227.05..664.36 rows=16044 width=28)"
"                          Hash Cond: (inventory.film_id = film_2.film_id)"
"                          ->  Hash Join  (cost=150.55..545.57 rows=16044 width=15)"
"                                Hash Cond: (rental.inventory_id = inventory.inventory_id)"
"                                ->  Hash Join  (cost=22.48..375.33 rows=16044 width=17)"
"                                      Hash Cond: (rental.customer_id = customer_2.customer_id)"
"                                      ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=6)"
"                                      ->  Hash  (cost=14.99..14.99 rows=599 width=17)"
"                                            ->  Seq Scan on customer customer_2  (cost=0.00..14.99 rows=599 width=17)"
"                                ->  Hash  (cost=70.81..70.81 rows=4581 width=6)"
"                                      ->  Seq Scan on inventory  (cost=0.00..70.81 rows=4581 width=6)"
"                          ->  Hash  (cost=64.00..64.00 rows=1000 width=19)"
"                                ->  Seq Scan on film film_2  (cost=0.00..64.00 rows=1000 width=19)"
*/

CREATE INDEX film1 ON film USING hash(film_id);

EXPLAIN SELECT first_name, last_name, title FROM customer
CROSS JOIN film
WHERE title IN
(
SELECT title FROM film
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
);

-- Analysis of query 1 after creating index on expensive step and rewriting the query, cost is lower.

/*
"SetOp Except  (cost=19543.35..19985.32 rows=28153 width=736)"
"  ->  Sort  (cost=19543.35..19653.85 rows=44197 width=736)"
"        Sort Key: ""*SELECT* 1"".first_name, ""*SELECT* 1"".last_name, ""*SELECT* 1"".title"
"        ->  Append  (cost=53.51..1779.69 rows=44197 width=736)"
"              ->  Subquery Scan on ""*SELECT* 1""  (cost=53.51..733.90 rows=28153 width=32)"
"                    ->  Nested Loop  (cost=53.51..452.37 rows=28153 width=28)"
"                          ->  Seq Scan on customer  (cost=0.00..14.99 rows=599 width=13)"
"                          ->  Materialize  (cost=53.51..85.59 rows=47 width=15)"
"                                ->  Nested Loop  (cost=53.51..85.35 rows=47 width=15)"
"                                      ->  HashAggregate  (cost=53.51..53.98 rows=47 width=15)"
"                                            Group Key: (film_1.title)::text"
"                                            ->  Nested Loop  (cost=1.26..53.39 rows=47 width=15)"
"                                                  ->  Hash Join  (cost=1.26..20.58 rows=125 width=2)"
"                                                        Hash Cond: (film_category.category_id = category.category_id)"
"                                                        ->  Seq Scan on film_category  (cost=0.00..16.00 rows=1000 width=4)"
"                                                        ->  Hash  (cost=1.24..1.24 rows=2 width=4)"
"                                                              ->  Seq Scan on category  (cost=0.00..1.24 rows=2 width=4)"
"                                                                    Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Sci-Fi'::text))"
"                                                  ->  Index Scan using film1 on film film_1  (cost=0.00..0.26 rows=1 width=19)"
"                                                        Index Cond: (film_id = film_category.film_id)"
"                                                        Filter: ((rating = 'R'::mpaa_rating) OR (rating = 'PG-13'::mpaa_rating))"
"                                      ->  Index Scan using film2 on film  (cost=0.00..0.66 rows=1 width=15)"
"                                            Index Cond: ((title)::text = (film_1.title)::text)"
"              ->  Subquery Scan on ""*SELECT* 2""  (cost=227.05..824.80 rows=16044 width=32)"
"                    ->  Hash Join  (cost=227.05..664.36 rows=16044 width=28)"
"                          Hash Cond: (inventory.film_id = film_2.film_id)"
"                          ->  Hash Join  (cost=150.55..545.57 rows=16044 width=15)"
"                                Hash Cond: (rental.inventory_id = inventory.inventory_id)"
"                                ->  Hash Join  (cost=22.48..375.33 rows=16044 width=17)"
"                                      Hash Cond: (rental.customer_id = customer_1.customer_id)"
"                                      ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=6)"
"                                      ->  Hash  (cost=14.99..14.99 rows=599 width=17)"
"                                            ->  Seq Scan on customer customer_1  (cost=0.00..14.99 rows=599 width=17)"
"                                ->  Hash  (cost=70.81..70.81 rows=4581 width=6)"
"                                      ->  Seq Scan on inventory  (cost=0.00..70.81 rows=4581 width=6)"
"                          ->  Hash  (cost=64.00..64.00 rows=1000 width=19)"
"                                ->  Seq Scan on film film_2  (cost=0.00..64.00 rows=1000 width=19)"
*/

-- Ananlysis of query 2
EXPLAIN SELECT store_id, city, MAX(foo.sales) OVER (PARTITION BY city) FROM
(
SELECT store_id, city, SUM(payment.amount) sales FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN payment ON store.manager_staff_id = payment.staff_id
WHERE payment.payment_date >= '2007-04-14'
GROUP BY store.store_id, city.city_id
) AS foo;

/*
"WindowAgg  (cost=471.31..492.31 rows=1200 width=45)"
"  ->  Sort  (cost=471.31..474.31 rows=1200 width=45)"
"        Sort Key: foo.city"
"        ->  Subquery Scan on foo  (cost=382.93..409.93 rows=1200 width=45)"
"              ->  HashAggregate  (cost=382.93..397.93 rows=1200 width=49)"
"                    Group Key: store.store_id, city.city_id"
"                    ->  Hash Join  (cost=18.09..356.67 rows=3501 width=23)"
"                          Hash Cond: (payment.staff_id = store.manager_staff_id)"
"                          ->  Seq Scan on payment  (cost=0.00..290.45 rows=3501 width=8)"
"                                Filter: (payment_date >= '2007-04-14 00:00:00'::timestamp without time zone)"
"                          ->  Hash  (cost=18.06..18.06 rows=2 width=19)"
"                                ->  Nested Loop  (cost=1.32..18.06 rows=2 width=19)"
"                                      ->  Hash Join  (cost=1.04..17.36 rows=2 width=8)"
"                                            Hash Cond: (address.address_id = store.address_id)"
"                                            ->  Seq Scan on address  (cost=0.00..14.03 rows=603 width=6)"
"                                            ->  Hash  (cost=1.02..1.02 rows=2 width=8)"
"                                                  ->  Seq Scan on store  (cost=0.00..1.02 rows=2 width=8)"
"                                      ->  Index Scan using city_pkey on city  (cost=0.28..0.35 rows=1 width=13)"
"                                            Index Cond: (city_id = address.city_id)"
*/

CREATE INDEX payment2 ON payment USING btree(payment_date);

-- Analysis of query 2 after creating index on expensive step (payment_date >= '2007-04-14 00:00:00'), cost is lower.
/*
"WindowAgg  (cost=403.21..424.21 rows=1200 width=45)"
"  ->  Sort  (cost=403.21..406.21 rows=1200 width=45)"
"        Sort Key: foo.city"
"        ->  Subquery Scan on foo  (cost=314.84..341.84 rows=1200 width=45)"
"              ->  HashAggregate  (cost=314.84..329.84 rows=1200 width=49)"
"                    Group Key: store.store_id, city.city_id"
"                    ->  Hash Join  (cost=88.68..288.58 rows=3501 width=23)"
"                          Hash Cond: (payment.staff_id = store.manager_staff_id)"
"                          ->  Bitmap Heap Scan on payment  (cost=71.42..223.18 rows=3501 width=8)"
"                                Recheck Cond: (payment_date >= '2007-04-14 00:00:00'::timestamp without time zone)"
"                                ->  Bitmap Index Scan on payment2  (cost=0.00..70.54 rows=3501 width=0)"
"                                      Index Cond: (payment_date >= '2007-04-14 00:00:00'::timestamp without time zone)"
"                          ->  Hash  (cost=17.24..17.24 rows=2 width=19)"
"                                ->  Nested Loop  (cost=0.00..17.24 rows=2 width=19)"
"                                      ->  Nested Loop  (cost=0.00..17.08 rows=2 width=8)"
"                                            ->  Seq Scan on store  (cost=0.00..1.02 rows=2 width=8)"
"                                            ->  Index Scan using city_address1 on address  (cost=0.00..8.02 rows=1 width=6)"
"                                                  Index Cond: (address_id = store.address_id)"
"                                      ->  Index Scan using city_address2 on city  (cost=0.00..0.08 rows=1 width=13)"
"                                            Index Cond: (city_id = address.city_id)"
*/
