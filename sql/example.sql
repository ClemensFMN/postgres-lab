-- Run with:  psql -f sql/example.sql
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id     serial PRIMARY KEY,
    name   text    NOT NULL,
    salary numeric(10,2) NOT NULL
);

INSERT INTO employees (name, salary) VALUES
    ('Alice', 5200.00),
    ('Bob',   4100.50),
    ('Carol', 6300.75);

SELECT id, name, salary,
       rank() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
