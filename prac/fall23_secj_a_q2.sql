
-- 1. Write a query to retrieve employees who have been employed in multiple departments, including their start and end dates in each department.
SELECT e.first_name || ' ' || e.last_name AS employee_name, j.start_date, j.end_date, 
d.department_name, e.department_id FROM employees e
JOIN job_history j ON e.employee_id = j.employee_id
JOIN departments d ON d.department_id = e.department_id
WHERE e.employee_id IN (
    SELECT employee_id FROM job_history
    GROUP BY employee_id
    HAVING COUNT(DISTINCT department_id) > 1
);

-- 2. Write a query to update department_id of all employees to be equal to the one with state province Texas, given that its initial value is NULL.
UPDATE employees
SET department_id = (
    SELECT department_id FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    WHERE l.state_province = 'Texas'
)
WHERE department_id IS NULL;

-- 3. Write a query to find the departments with the highest and lowest salary payouts, along with the total number of employees in each department.
SELECT *
FROM (
    SELECT e.department_id, d.department_name, 
           SUM(e.salary) AS total_payout,
           COUNT(e.employee_id) AS total_employees
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY e.department_id, d.department_name
    ORDER BY SUM(e.salary) DESC
    FETCH FIRST 1 ROW ONLY
)
UNION
SELECT *
FROM (
    SELECT e.department_id, d.department_name, 
           SUM(e.salary) AS total_payout,
           COUNT(e.employee_id) AS total_employees
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY e.department_id, d.department_name
    ORDER BY SUM(e.salary) ASC
    FETCH FIRST 1 ROW ONLY
);

-- 4. Write a query to identify the ten most senior employees and display their tenure periods.
SELECT e.first_name, e.last_name, ROUND(SYSDATE - hire_date,3) AS tenure_period
FROM employees e
ORDER BY hire_date
FETCH FIRST 10 ROWS ONLY;

-- 5. List employees whose salaries, after a 20% increment, are still below 3000.
SELECT * FROM employees 
WHERE (salary * 120/100) < 3000;

-- 6. Write a query to display Department ID, Department Name, Mariager Name, Manager Salary, and Department City.
SELECT d.department_name, d.department_id, 
e.first_name || ' ' || e.last_name AS manager_name, 
e.salary AS manager_salary, l.city AS department_city
FROM departments d
JOIN employees e ON e.employee_id = d.manager_id
JOIN locations l ON d.location_id = l.location_id;


-- 7. Write a query to display all employee information for those whose salary falls within the range of the lowest salary and 2500.
SELECT * FROM employees 
WHERE salary <= 2500 AND salary >= (
    SELECT MIN(salary) FROM employees
);

-- 8. Write a query to retrieve the names of employees whose salary exceeds 50% of their department's total salary expenditure.
SELECT e.first_name || ' ' || e.last_name AS employee_name
FROM employees e
WHERE salary > (
    SELECT SUM(salary)/2 FROM employees inner_e
    WHERE e.department_id = inner_e.department_id
);

-- 9. SQL query to retrieve the full name, job title, start date, and end date of the most recent job held by employees who did not receive any commission.
SELECT e.first_name || ' ' || e.last_name AS full_name, j.job_title, 
jh.start_date, jh.end_date
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
JOIN job_history jh ON jh.employee_id = e.employee_id
WHERE e.commission_pct IS NULL;

-- 10. Query to calculate the total salary for each state where the second letter of the state name is 'a'
SELECT SUM(salary) AS total_salary, l.state_province FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
WHERE l.state_province LIKE '_a%'
GROUP BY l.location_id, l.state_province;

