DB LAB 7 - 24K0546
-- Q1. Display the employee first name, last name, and department name for all employees using an INNER JOIN.
SELECT e.first_name, e.last_name, d.department_name FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Q2. Display employee first name, last name, and job title by joining the EMPLOYEES and JOBS tables.
SELECT e.first_name, e.last_name, j.job_title FROM employees e
JOIN jobs j ON j.job_id = e.job_id;

-- Q3. Display employee name and department location ID using the USING clause.
SELECT first_name, last_name, location_id FROM employees
JOIN departments USING (department_id);

-- Q4. Display employee name and department name using a NATURAL JOIN between EMPLOYEES and DEPARTMENTS.
SELECT first_name, last_name, department_name FROM employees
NATURAL JOIN departments;

-- Q5. Display employee name and manager name using a SELF JOIN on the EMPLOYEES table.
SELECT e.first_name || ' ' || e.last_name AS employee_name, 
m.first_name || ' ' || m.last_name AS manager_name FROM employees e 
JOIN employees m ON e.manager_id = m.employee_id;

-- Q6. Display all employees along with their department names, including employees who do not belong to any department.
SELECT e.first_name || ' ' || e.last_name AS employee_name, d.department_name FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- Q7. Display all departments and their employees, including departments without employees.
SELECT e.first_name || ' ' || e.last_name AS employee_name, d.department_name FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- Q8. Display all possible combinations of employee names and department names.
SELECT e.first_name || ' ' || e.last_name AS employee_name, d.department_name FROM employees e
CROSS JOIN departments d;

-- Q9. Display employee IDs from EMPLOYEES and JOB_HISTORY without duplicates using a set operator.
SELECT employee_id FROM employees
UNION
SELECT employee_id FROM job_history;

-- Q10. Display employee IDs that exist in both EMPLOYEES and JOB_HISTORY tables.
SELECT employee_id FROM employees
INTERSECT
SELECT employee_id FROM job_history;

-- Q11. Display employee name, department name, and city by joining EMPLOYEES, DEPARTMENTS, and LOCATIONS tables.
SELECT e.first_name || ' ' || e.last_name AS employee_name, d.department_name, l.city 
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON l.location_id = d.location_id;

-- Q12. Create a view named emp_dept_view that displays: ● EMPLOYEE_ID ● FIRST_NAME ● LAST_NAME ● DEPARTMENT_NAME 
-- by joining EMPLOYEES and DEPARTMENTS tables.
CREATE VIEW emp_dept_view AS 
SELECT e.employee_id, e.first_name, e.last_name, d.department_name FROM employees e
JOIN departments d ON e.department_id = d.department_id;

SELECT * FROM emp_dept_view;

-- Q13. Create a view that displays employees whose salary is greater than the average salary of the company using an inline view.
CREATE VIEW higher_than_avg_salary AS
SELECT * FROM (
    SELECT employee_id, first_name, last_name, salary FROM employees
) 
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

SELECT * FROM higher_than_avg_salary;

-- Q14. Display employees who never changed their job using EMPLOYEES and JOB_HISTORY tables with a set operator.
SELECT employee_id FROM employees
MINUS
SELECT employee_id FROM job_history;