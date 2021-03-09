-- Created function
CREATE OR REPLACE FUNCTION retrievecustomers(start_index integer, end_index integer)
RETURNS TABLE(customer_id integer, first_name varchar(45), last_name VARCHAR(45),
			  email VARCHAR(50), address_id smallint) AS
$$
BEGIN

IF start_index < 0 THEN
RAISE EXCEPTION 'start_index must be a positive number!';
END IF;
IF end_index < 0 THEN
RAISE EXCEPTION 'end_index must be a positive number!';
END IF;
IF start_index > 600 THEN
RAISE EXCEPTION 'start_index must be less than or equal to 600!';
END IF;
IF end_index > 600 THEN
RAISE EXCEPTION 'end_index must be less than or equal to 600!';
END IF;
IF start_index > end_index THEN
RAISE EXCEPTION 'start_index must be less than or equal to end_index!';
END IF;

RETURN QUERY
SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, 
customer.address_id
FROM customer
ORDER BY address_id
OFFSET start_index - 1	-- from start_index-th element of the query
LIMIT end_index - start_index + 1;	-- to end_index-th element of the query

END; $$

LANGUAGE plpgsql;

-- Tests
SELECT retrievecustomers(3, 20); -- no exceptions
SELECT retrievecustomers(-1, 20); -- start_index must be a positive number!
SELECT retrievecustomers(3, -10); -- end_index must be a positive number!
SELECT retrievecustomers(600, 700); -- end_index must be less than or equal to 600!
SELECT retrievecustomers(599, 600); -- no exceptions
SELECT retrievecustomers(800, 900); -- start_index must be less than or equal to 600!
SELECT retrievecustomers(10, 1); -- start_index must be less than or equal to end_index!
