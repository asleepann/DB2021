CREATE TABLE lab10 (
	user_id SERIAL PRIMARY KEY,
	username VARCHAR NOT NULL,
	fullname VARCHAR NOT NULL,
	balance INT NOT NULL,
	group_id INT NOT NULL
);

INSERT INTO lab10 (username, fullname, balance, group_id)
VALUES
('jones', 'Alice Jones', 82, 1),
('bitdiddl', 'Ben Bitdiddle', 65, 1),
('mike', 'Michael Dole', 73, 2),
('alyssa', 'Alyssa P. Hacker', 79, 3),
('bbrown', 'Bob Brown', 100, 3);
