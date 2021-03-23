ALTER TABLE account ADD COLUMN bank_name VARCHAR;
UPDATE account SET bank_name = 'SpearBank'
WHERE account_id = 0 OR account_id = 2;
UPDATE account SET bank_name = 'Tinkoff'
WHERE account_id = 1;

