-- Table creation
CREATE TABLE account (
	account_id SERIAL PRIMARY KEY,
	customer_name VARCHAR NOT NULL,
	credit INT NOT NULL
);

-- Insertion of 3 accounts into the table
INSERT INTO account (customer_name, credit)
VALUES
('Anna', 1000),
('Andrew', 1000),
('Olga', 1000);

-- Transaction 1
START TRANSACTION;

UPDATE account
	SET credit = credit - 500
	WHERE account_id = 1;
	
UPDATE account
	SET credit = credit + 500
	WHERE account_id = 3;
	
SELECT * FROM account;

ROLLBACK;

-- Transaction 2
START TRANSACTION;

UPDATE account
	SET credit = credit - 700
	WHERE account_id = 2;
	
UPDATE account
	SET credit = credit + 700
	WHERE account_id = 1;
	
SELECT * FROM account;

ROLLBACK;

-- Transaction 3
START TRANSACTION;

UPDATE account
	SET credit = credit - 1000
	WHERE account_id = 2;
	
UPDATE account
	SET credit = credit + 1000
	WHERE account_id = 3;
	
SELECT * FROM account;

ROLLBACK;
