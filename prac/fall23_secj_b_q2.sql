-- 1. Write a query to determine the total count of employees categorized by country and city.
SELECT COUNT(employee_id) AS num_employees, c.country_name, l.city FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
JOIN countries c ON c.country_id = l.country_id
GROUP BY l.city, c.country_name;

-- 2. Write a query to calculate the count of employees in each region.
SELECT COUNT(e.employee_id) AS num_employees, r.region_name FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
JOIN countries c ON c.country_id = l.country_id
JOIN regions r ON r.region_id = c.region_id
GROUP BY r.region_name;

-- 3. Write a query to compute the average tenure period for each department from the Job History table.
SELECT department_id, ROUND(AVG(jh.end_date - jh.start_date), 2) AS AVG_TENURE FROM job_history jh
GROUP BY department_id;

-- 4. Write a query to identify the state with the fewest employees.
SELECT state_province FROM (
    SELECT l.state_province, COUNT(e.employee_id) AS emp_count FROM employees e
    JOIN departments d ON d.department_id = e.department_id
    JOIN locations l ON l.location_id = d.location_id
    WHERE l.state_province IS NOT NULL
    GROUP BY l.state_province
    ORDER BY emp_count ASC
    FETCH FIRST 1 ROW ONLY
);

-- 5. Write a query to retrieve information about the five least senior employees, along with their respective durations of employment.
SELECT e.first_name || ' ' || e.last_name AS full_name, 
ROUND(SYSDATE - hire_date, 2) AS duration from employees e
ORDER BY SYSDATE - hire_date
FETCH FIRST 5 ROWS ONLY;

-- 6. Write a query to retrieve details of all employees where the difference between their salary and the max salary of employees residing in Japan is greater than 5000.
SELECT * FROM employees
WHERE salary - (
    SELECT MAX(salary) FROM employees e
    JOIN departments d ON d.department_id = e.department_id
    JOIN locations l ON l.location_id = d.location_id
    JOIN countries c ON c.country_id = l.country_id
    WHERE c.country_name = 'Japan'
) > 5000;

-- 7. Write a query to identify employees who have worked in only one department, displaying their start and end dates within that department.
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS fullname, 
MIN(jh.start_date) as start_date, MAX(jh.end_date) as end_date
FROM employees e
JOIN job_history jh ON jh.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(DISTINCT jh.department_id) = 1;

-- 8. Write a query to calculate the total and average salaries for employees in each state.
SELECT l.state_province, SUM(salary) AS total_salary, AVG(salary) AS avg_salary
FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
GROUP BY l.state_province;

-- 9. Write a query to retrieve details of employees that were part of the company for over a period of more than 6 months, had a min_salary in range of 4000-10000, and belonged to department no 90.
SELECT distinct e.employee_id, e.first_name || ' ' || e.last_name AS full_name
FROM job_history jh
JOIN employees e ON e.employee_id = jh.employee_id
JOIN jobs j ON j.job_id = jh.job_id
WHERE jh.department_id = 90 AND MONTHS_BETWEEN(jh.end_date, jh.start_date) > 6
AND j.min_salary BETWEEN 4000 AND 10000;

-- 10. Write a query determine which state has the highest number of employees.
SELECT state_province FROM (
    SELECT l.state_province, COUNT(employee_id)
    FROM employees e
    JOIN departments d ON d.department_id = e.department_id
    JOIN locations l ON l.location_id = d.location_id
    GROUP BY l.state_province
    ORDER BY COUNT(employee_id) DESC
)
FETCH FIRST 1 ROW ONLY;
