INSERT INTO account (account_id, customer_name, credit)
VALUES
(0, 'Anna', 1000),
(1, 'Andrew', 1000),
(2, 'Olga', 1000);

-- Transactioin 1
START TRANSACTION;

UPDATE account
	SET credit = credit - 500
	WHERE account_id = 0;
	
UPDATE account
	SET credit = credit + 500
	WHERE account_id = 2;
	
SELECT * FROM account;

ROLLBACK;

-- Transaction 2
START TRANSACTION;

UPDATE account
	SET credit = credit - 700
	WHERE account_id = 1;
	
UPDATE account
	SET credit = credit + 700
	WHERE account_id = 0;
	
SELECT * FROM account;

ROLLBACK;

-- Transaction 3
START TRANSACTION;

UPDATE account
	SET credit = credit - 1000
	WHERE account_id = 1;
	
UPDATE account
	SET credit = credit + 1000
	WHERE account_id = 2;
	
SELECT * FROM account;

ROLLBACK;
