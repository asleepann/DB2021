ALTER TABLE account ADD COLUMN bank_name VARCHAR;
UPDATE account SET bank_name = 'SpearBank'
WHERE account_id = 0 OR account_id = 2;
UPDATE account SET bank_name = 'Tinkoff'
WHERE account_id = 1;

INSERT INTO account (account_id, customer_name, credit)
VALUES
(3, 'Fees', 0);

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
	SET credit = credit - (700 + 30)
	WHERE account_id = 1;
	
UPDATE account
	SET credit = credit + 30
	WHERE account_id = 3;

UPDATE account
	SET credit = credit + 700
	WHERE account_id = 0;
	
SELECT * FROM account;

ROLLBACK;

-- Transaction 3
START TRANSACTION;

UPDATE account
	SET credit = credit - (1000 + 30)
	WHERE account_id = 1;
	
UPDATE account
	SET credit = credit + 30
	WHERE account_id = 3;
	
UPDATE account
	SET credit = credit + 1000
	WHERE account_id = 2;
	
SELECT * FROM account;

ROLLBACK;
