-- Add field bank_name
ALTER TABLE account ADD COLUMN bank_name VARCHAR;
UPDATE account SET bank_name = 'SpearBank'
WHERE account_id = 1 OR account_id = 3;
UPDATE account SET bank_name = 'Tinkoff'
WHERE account_id = 2;

INSERT INTO account (customer_name, credit)
VALUES
('Fees', 0);

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
	SET credit = credit - (700 + 30)
	WHERE account_id = 2;
	
UPDATE account
	SET credit = credit + 30
	WHERE account_id = 4;

UPDATE account
	SET credit = credit + 700
	WHERE account_id = 1;
	
SELECT * FROM account;

ROLLBACK;

-- Transaction 3
START TRANSACTION;

UPDATE account
	SET credit = credit - (100 + 30)
	WHERE account_id = 2;
	
UPDATE account
	SET credit = credit + 30
	WHERE account_id = 4;
	
UPDATE account
	SET credit = credit + 100
	WHERE account_id = 3;
	
SELECT * FROM account;

ROLLBACK;
