CREATE TABLE IF NOT EXISTS table1 (
    id SERIAL PRIMARY KEY,
    column1 INTEGER,
    column2 TEXT,
    column3 NUMERIC,
    column4 DATE
);

CREATE TABLE IF NOT EXISTS table2 (
    id SERIAL PRIMARY KEY,
    column1 INTEGER,
    column2 TEXT,
    column3 NUMERIC,
    column4 DATE
);

INSERT INTO table1 (column1, column2, column3, column4) VALUES
(1, 'sample text', 12.34, '2023-01-01'),
(2, 'test', 45.67, '2023-02-01');

INSERT INTO table2 (column1, column2, column3, column4) VALUES
(1, 'sample text', 12.34, '2023-01-01'),
(2, 'different text', 45.00, '2023-02-15');

