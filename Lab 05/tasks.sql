--1. Write a SQL statement to create a tasks table 
CREATE TABLE tasks1 (
    task_id NUMBER PRIMARY KEY,
    title VARCHAR(255) NOT NULL UNIQUE,
    "name" VARCHAR2(100),
    start_date DATE,
    due_date DATE,
    "priority" NUMBER (1) DEFAULT 3 NOT NULL,
    "description" CLOB
);

-- 2. Insert three tasks into the tasks table using a single INSERT ALL statement
INSERT ALL
    INTO tasks1 (task_id, title, "name", "priority")
        VALUES (1, 'Database Design', 'Ali Khan', 1)
    INTO tasks1 (task_id, title, "name", "priority")
        VALUES (2, 'API Development', 'Sara Khan', 2)
    INTO tasks1 (task_id, title, "name", "priority")
        VALUES (3, 'Frontend UI', 'Hamid Ali', 3)
SELECT * FROM dual;

-- 3. Insert a Task Using Employee Data
-- Insert a new task titled Prepare HR Report with priority 2, but use the employee name
-- from the employees table where employee_id = 101 as the name column value.
INSERT INTO tasks1 (task_id, title, "name", "priority")
VALUES (4, 'Prepare HR Report', (SELECT first_name FROM employees WHERE employee_id = 101), 2);

-- 4. Insert a Task with Partial Data
-- Insert a task titled Team Meeting with only the description column filled. Let the other
-- columns use default values or remain NULL where applicable.
INSERT INTO tasks1 (task_id, title, "description")
VALUES (5, 'Team Meeting', 'Have to attend a team meeting tonight');

-- 5. Write a SQL query to display all columns from the tasks table to verify all inserted data.
SELECT * FROM tasks1;

-- 6. Retrieve the title and priority of all tasks where priority = 2.
SELECT * FROM tasks1
WHERE "priority" = 2;

-- 7. Retrieve all tasks whose title contains the word 'Report'
SELECT * FROM tasks1
WHERE title LIKE '%Report%';

-- 8. Display all tasks ordered by title in ascending order.
SELECT * FROM tasks1
ORDER BY title;

-- 9. Display distinct priority values from the tasks table.
SELECT DISTINCT "priority" FROM tasks1;

-- 10. Update the priority of the task with task_id = 2 to 1.
UPDATE tasks1
SET "priority" = 1
WHERE task_id = 2;

--11. Change the title of the task with task_id = 5 to Update Employee Data.
UPDATE tasks1
SET title = 'Update Employee Data'
WHERE task_id = 5;

-- 12. Increase the priority of all tasks with priority 3 to 2.
UPDATE tasks1
SET "priority" = 2
WHERE "priority" = 3;

-- 13. Count the total number of tasks for each priority value.
SELECT COUNT(task_id), "priority"
FROM tasks1
GROUP BY "priority";

-- 14. Find the average priority of all tasks.
SELECT AVG("priority") FROM tasks1;

-- 15. Find the maximum priority among all tasks.
SELECT MAX("priority") FROM tasks1;

-- 16. Count the number of tasks whose title contains 'Report' for each priority.
SELECT COUNT(task_id) FROM tasks1
WHERE title LIKE '%Report%';

-- 17. Find the total number of tasks whose priority is greater than 1.
SELECT COUNT(task_id) FROM tasks1
WHERE "priority" > 1;

-- 18. Find priority levels with more than 2 tasks.
SELECT "priority" FROM tasks1
GROUP BY "priority" 
HAVING COUNT(task_id) > 2;

-- 19. Display all tasks ordered by title ascending.
SELECT * FROM tasks1
ORDER BY title;

-- 20. Display tasks ordered by priority descending and then title ascending.
SELECT * FROM tasks1
ORDER BY "priority" DESC, title;

-- 21. Display tasks ordered by priority ascending.
SELECT * FROM tasks1
ORDER BY "priority";

-- 22. Copy all tasks from tasks_archive table to tasks.
INSERT INTO tasks1
SELECT * FROM tasks_archive;

-- 23. Copy only tasks with priority = 2 from tasks_archive to tasks.
INSERT INTO tasks1
SELECT * FROM tasks_archive WHERE "priority" = 2;

-- 24. Insert a task into tasks using VALUES (SELECT …) to copy the name of the employee with employee_id = 101 from the employees table.
INSERT INTO tasks1 (task_id, title, "name", "priority")
VALUES (9, 'Call Client', (SELECT first_name FROM employees WHERE employee_id = 101), 4);

-- 25. Truncate the tasks table to remove all data.
-- BEFORE TRUNCATE
SELECT * FROM tasks1;

TRUNCATE TABLE tasks1;

-- AFTER TRUNCATE
SELECT * FROM tasks1;