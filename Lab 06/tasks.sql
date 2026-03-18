DB LAB 6 - 24K0546
-- 1. Write a query to display the employee(s) who earn the maximum salary in the company.
SELECT * FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- 2. Display employees who earn more than the average salary of the company.
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 3. Find employees who earn the minimum salary in the company.
SELECT * FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- 4. Display employees whose salary is equal to the average salary of department 20.
SELECT * FROM employees
WHERE salary = (
    SELECT AVG(salary) FROM employees 
    WHERE department_id = 20
);

-- 5. Find the employee(s) who were hired on the latest hire date.
SELECT * FROM employees
WHERE hire_date = (SELECT MAX(hire_date) FROM employees);

-- 6. Display employees who work in departments located in location_id = 1700.
SELECT * FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments 
    WHERE location_id = 1700
);

-- 7. Find employees whose job_id is the same as any employee working in department 80.
SELECT * FROM employees
WHERE job_id IN (
    SELECT DISTINCT job_id FROM employees 
    WHERE department_id = 80
);

-- 8. Display employees who earn more than all employees with job_id = 'SH_CLERK'.
SELECT * FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees
    WHERE job_id = 'SH_CLERK'
);

-- 9. Display employees who earn less than any employee with job_id = 'IT_PROG'.
SELECT * FROM employees
WHERE salary < ANY (
    SELECT salary FROM employees
    WHERE job_id = 'IT_PROG'
);

-- 10. Find employees working in departments where the department name contains 'Sales'.
SELECT * FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments
    WHERE department_name LIKE '%Sales%'
);

-- 11. Display employees who earn more than the average salary of their own department.
SELECT * FROM employees e
WHERE salary > (
    SELECT AVG(salary) FROM employees
    WHERE department_id = e.department_id
);

-- 12. Find employees who earn the highest salary in their department.
SELECT * FROM employees e
WHERE salary = (
    SELECT MAX(salary) FROM employees
    WHERE department_id = e.department_id
);

-- 13. Display employees whose salary is greater than the average salary of employees with the same job_id.
SELECT * FROM employees e
WHERE salary > (
    SELECT AVG(salary) FROM employees
    WHERE job_id = e.job_id
);

-- 14. Missing... Task not provided

-- 15. Write a query to display the employee_id, first_name, hire_date, and department_id of employees who were hired after the earliest hired employee in their respective department.Display employees who are managers (i.e., employees who manage at least one employee).
SELECT employee_id, first_name, hire_date, department_id FROM employees e
WHERE hire_date > (
    SELECT MIN(hire_date) FROM employees
    WHERE department_id = e.department_id
);

-- 16. Display employees who are not managers.
SELECT * FROM employees
WHERE employee_id NOT IN (
    SELECT manager_id FROM employees
    WHERE manager_id IS NOT NULL
);

-- 17. Display departments that have no employees.
SELECT * FROM departments
WHERE department_id NOT IN (
    SELECT DISTINCT department_id FROM employees
    WHERE department_id IS NOT NULL
);

-- 18. Display departments that have at least one employee earning more than 10000.
SELECT * FROM departments
WHERE department_id IN (
    SELECT department_id FROM employees
    WHERE salary > 10000
);

-- 19. Display departments whose average salary is greater than 8000.
SELECT * FROM departments d
WHERE 8000 <= (
    SELECT AVG(salary) FROM employees
    WHERE department_id = d.department_id
);

-- 20. From an inline view, display the top 3 departments with highest average salary.
SELECT department_id FROM (
    SELECT DISTINCT department_id FROM employees e
    WHERE department_id IS NOT NULL
    ORDER BY ( 
        SELECT AVG(salary) FROM employees
        WHERE department_id = e.department_id
    ) DESC
)
FETCH FIRST 3 ROWS ONLY;