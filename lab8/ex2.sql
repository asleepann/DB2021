CREATE TABLE ledger (
	ledger_id SERIAL PRIMARY KEY,
	from_id INT NOT NULL,
	to_id INT NOT NULL,
	fee INT NOT NULL,
	amount INT NOT NULL,
	transaction_date TIMESTAMP NOT NULL
);

-- ex.1
-- Transaction 1.1
START TRANSACTION;

UPDATE account
	SET credit = credit - 500
	WHERE account_id = 1;
	
UPDATE account
	SET credit = credit + 500
	WHERE account_id = 3;
	
ROLLBACK;
	
INSERT INTO ledger (from_id, to_id, fee, amount, transaction_date)
VALUES
(1, 3, 0, 500, NOW());

SELECT * FROM ledger;

-- Transaction 2.1
START TRANSACTION;

UPDATE account
	SET credit = credit - 700
	WHERE account_id = 2;
	
UPDATE account
	SET credit = credit + 700
	WHERE account_id = 1;
	
ROLLBACK;
	
INSERT INTO ledger (from_id, to_id, fee, amount, transaction_date)
VALUES
(2, 1, 0, 700, NOW());

SELECT * FROM ledger;

-- Transaction 3.1
START TRANSACTION;

UPDATE account
	SET credit = credit - 100
	WHERE account_id = 2;
	
UPDATE account
	SET credit = credit + 100
	WHERE account_id = 3;
	
ROLLBACK;
	
INSERT INTO ledger (from_id, to_id, fee, amount, transaction_date)
VALUES
(2, 3, 0, 100, NOW());

SELECT * FROM ledger;

-- ex.2
-- Transaction 1.2
START TRANSACTION;

UPDATE account
	SET credit = credit - 500
	WHERE account_id = 1;
	
UPDATE account
	SET credit = credit + 500
	WHERE account_id = 3;
	
ROLLBACK;
	
INSERT INTO ledger (from_id, to_id, fee, amount, transaction_date)
VALUES
(1, 3, 0, 500, NOW());

SELECT * FROM ledger;

-- Transaction 2.2
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
	
ROLLBACK;
	
INSERT INTO ledger (from_id, to_id, fee, amount, transaction_date)
VALUES
(2, 1, 30, 700, NOW());

SELECT * FROM ledger;

-- Transaction 3.2
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
	
ROLLBACK;
	
INSERT INTO ledger (from_id, to_id, fee, amount, transaction_date)
VALUES
(2, 3, 30, 100, NOW());

SELECT * FROM ledger;
