
-- 1. Show full name of those employees whose name starts with A and ends with n.
SELECT e.first_name || ' ' || e.last_name AS fullname FROM employees e
WHERE first_name LIKE 'A%' AND last_name LIKE '%n';

-- 2. Show all employees' last three letters of last name
SELECT SUBSTR(last_name, LENGTH(last_name) - 2, LENGTH(last_name)) FROM employees;

-- 3. Display First_Name, job_id, salary of all the employees whose job is "ACCOUNTANT". Keeping this in mind that Accountant may be in capital, small or combination of small capital characters in the table.
SELECT e.first_name, e.job_id, e.salary FROM employees e
JOIN jobs j ON j.job_id = e.job_id
WHERE UPPER(j.job_title) = 'ACCOUNTANT';

-- 4. Display the Employee_ID, First_Name, salary of employees. In that, the highest paid employee should display first and lowest paid should display last.
SELECT employee_id, first_name, salary FROM employees
ORDER BY salary DESC;

-- 5. Write a query to display the employee Id, job name, job id, department id number of days worked in for all those jobs in department 90.
SELECT jh.employee_id, j.job_title, jh.job_id, jh.department_id, 
ROUND(jh.end_date - jh.start_date, 2) AS num_days
FROM job_history jh
JOIN departments d ON d.department_id = jh.department_id
JOIN jobs j ON j.job_id = jh.job_id
WHERE jh.department_id = 90;

--6. Generate new names of the employees by combining the first 3 characters of the First Name and last 3 characters of the Email.
SELECT SUBSTR(first_name, LENGTH(first_name) - 2, LENGTH(first_name)) || SUBSTR(email, LENGTH(email) - 2, LENGTH(email))
FROM employees;

-- 7. Write a query to List the department names and get the count of employees working in each department
SELECT d.department_name, COUNT(e.employee_id) AS num_employees
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 8. Write a query to display the first name, salary, phone number, hire date and department Id for those employees whose department is located in the city Toronto.
SELECT e.first_name, e.salary, e.phone_number, e.hire_date, e.department_id
FROM employees e
WHERE e.department_id IN (
    SELECT department_id FROM departments
    WHERE location_id IN (
        SELECT location_id FROM locations
        WHERE city = 'Toronto'
    )
);

-- 9. Display employee's full name along with the total number of years in the department.
SELECT e.first_name || ' ' || e.last_name, ROUND((jh.end_date - jh.start_date)/365, 2) AS num_years
FROM job_history jh
JOIN employees e ON e.employee_id = jh.employee_id;

-- 10. Display the Manager_ID and the salary of the lowest paid employee of that manager Exetude anyone whose manager is not known. Exclude any groups where the minimum salary is 2000. Sort the output is descending order of the salary.
SELECT e.manager_id, MIN(e.salary) AS min_salary FROM employees e
GROUP BY e.manager_id
HAVING MIN(salary) != 2000 AND e.manager_id IS NOT NULL;

-- 11. Display employee's full name along with the total number of years in the department.
-- done prev

-- 12. Write a query to display the country name, city, and number of those departments where at least 3 employees are working.
SELECT c.country_name, l.city, d.department_id
FROM departments d
JOIN locations l ON l.location_id = d.location_id
JOIN countries c ON c.country_id = l.country_id
WHERE d.department_id IN (
    SELECT e.department_id FROM employees e
    GROUP BY e.department_id
    HAVING COUNT(e.employee_id) >= 3
);

-- 13 Display the Department Name and average salary of those departments whose average salary is greater than 2500.
SELECT d.department_name, ROUND(AVG(e.salary), 2) FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING AVG(salary) > 2500;

-- 14. Write a query to display those employees who contain in last a letter y to their last name and also display their last name, department name, salary, manager id, and city.
SELECT e.first_name, e.last_name, d.department_name, e.salary, e.manager_id, l.city
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON l.location_id = d.location_id
WHERE e.first_name LIKE '%y';

-- 15. Write a query in SQL to display all the information of those employees who did not have any job in the past.
SELECT * FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id FROM job_history
);
