-- 1. Display all employees whose salary is greater than 9000.
SELECT * FROM employees
WHERE salary > 9000;

-- 2. Show employees who were hired before 01-JAN-2010.
SELECT * FROM employees
WHERE hire_date < '01-JAN-2010';

-- 3. Display employees working in department 30 or 70.
SELECT * FROM employees
WHERE department_id = 30 OR department_id = 70;

-- 4. Show employees whose salary is between 4000 and 10000.
SELECT * FROM employees
WHERE salary BETWEEN 4000 AND 10000;

-- 5. Display employees whose commission_pct is NOT NULL.
SELECT * FROM employees
WHERE commission_pct IS NOT NULL;

-- 6. Show employees whose first_name starts with 'M';.
SELECT * FROM employees
WHERE first_name LIKE 'M%';

-- 7. Display employees whose first_name ends with 'y';.
SELECT * FROM employees
WHERE first_name LIKE '%y';

-- 8. Show employees whose first_name contains 'an';
SELECT * FROM employees
WHERE first_name LIKE '%an%';

-- 9. Display employees whose first_name has exactly 6 characters.
SELECT * FROM employees
WHERE LENGTH(first_name) = 6;

-- 10. Show employees whose first_name starts with 'J' and ends with 'n'.
SELECT * FROM employees
WHERE first_name LIKE 'J%n';

-- 11. Display employees whose salary is greater than 12000 and department_id is 80.
SELECT * FROM employees
WHERE salary > 12000 AND department_id = 80;

-- 12. Show employees whose salary is greater than 7000 or department_id is 40.
SELECT * FROM employees
WHERE salary > 7000 OR department_id = 40;

-- 13. Display employees whose salary is NOT greater than 6000.
SELECT * FROM employees 
WHERE NOT (salary > 6000);

-- 14. Show employees who are in department 30 or 90 and earn more than 5000.
SELECT * FROM employees
WHERE (department_id = 30 OR department_id = 90) AND salary > 5000;

-- 15. Display employees whose salary is less than 20000 and not in department 50.
SELECT * FROM employees
WHERE salary < 20000 AND department_id != 50;

-- 16. Show how many days each employee has worked till today.
SELECT employee_id, first_name, last_name, email, hire_date,
TO_DATE('13-FEB-2026', 'DD-MON-RR') - hire_date AS days_worked
FROM employees;

-- 17. Display each employee’s contract end date assuming 6 months after hire_date.
SELECT employee_id, first_name, last_name, email, hire_date,
ADD_MONTHS(hire_date, 6) AS end_date
FROM employees;

-- 18. Show today’s date without time.
SELECT CURRENT_DATE FROM dual;

-- 19. Extract the year and month from each employee’s hire_date.
SELECT employee_id, first_name, last_name, email, hire_date,
EXTRACT(MONTH FROM hire_date) AS hire_month, EXTRACT(YEAR FROM hire_date) AS hire_year
FROM employees;

-- 20. Display the difference in days between '2026-03-01' and '2026-02-20'.
SELECT TO_DATE('2026-03-01', 'YYYY-MM-DD') - TO_DATE('2026-02-20', 'YYYY-MM-DD') AS days_difference
FROM dual;

-- 21. Write a query that returns NULL if two numbers 80 and 80 are equal.
SELECT NULLIF(80,80) FROM dual;

-- 22. Return the first non-null value from: NULL, 500, 700.
SELECT COALESCE(NULL, 500, 700) AS first_non_null_value FROM dual;

-- 23. Display employee name and show 0 if commission_pct is NULL.
SELECT CONCAT(CONCAT(first_name, ' '), last_name) AS employee_name, NVL(commission_pct, 0) AS commission_pct
FROM employees;

-- 24. Return 999 if NULL is passed, otherwise return the value itself.
SELECT NVL(NULL, 999) AS value FROM dual;

-- 25. Display employee first_name and salary formatted with a dollar sign and commas
SELECT first_name, TO_CHAR(salary, '$99,999,999') AS salary FROM employees;