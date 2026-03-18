-- Q1: Display all employees whose salary is between 3000 and 7000.
SELECT * FROM employees WHERE salary BETWEEN 3000 AND 7000;

-- Q2: Display all employees whose first_name starts with 'A'.
SELECT * FROM employees WHERE first_name LIKE 'A%';

-- Q3: Display all employees whose department_id is 50 OR 80.
SELECT * FROM employees WHERE department_id = 50 OR department_id = 80;

-- Q4: Display all employees whose salary is greater than 5000 AND department_id is 60.
SELECT * FROM employees WHERE salary > 5000 AND department_id = 60;

-- Q5: Display all employees whose first_name does NOT start with 'S'.
SELECT * FROM employees WHERE first_name NOT LIKE 'S%';

-- Q6: Display all employees whose hire_date is between 01-JAN-2004 and 31-DEC-2008.
SELECT * FROM employees WHERE hire_date BETWEEN '01-JAN-2004' AND '31-DEC-2008';

-- Q7: Display all employees whose job_id is 'IT_PROG' OR salary is greater than 8000.
SELECT * FROM employees WHERE job_id = 'IT_PROG' OR salary > 8000;

-- Q8: Display all employees whose department_id is NOT between 30 and 90.
SELECT * FROM employees WHERE department_id < 30 OR department_id   > 90;

-- Q9: Display all employees whose first_name contains 'an'.
SELECT * FROM employees WHERE first_name LIKE '%an%';

-- Q10: Display all employees whose salary is less than 4000 AND first_name ends with 'n'.
SELECT * FROM employees WHERE salary < 4000 AND first_name LIKE '%n';