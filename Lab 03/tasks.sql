-- 1. Create a table Employees with columns
CREATE TABLE Employees (
	emp_id VARCHAR2(10) PRIMARY KEY,
	emp_name VARCHAR2(50),
	age NUMBER,
	salary NUMBER,
	join_date DATE
);
DESC Employees;

-- 2. Modify the emp_name column to allow 100 characters.
ALTER TABLE Employees MODIFY emp_name VARCHAR2(100);
DESC Employees;

-- 3. Add a new column email VARCHAR2(100) to the table.
ALTER TABLE Employees ADD email VARCHAR2(100);
DESC Employees;

-- 4. Add a UNIQUE constraint on the email column.
ALTER TABLE Employees ADD CONSTRAINT emp_unique_email UNIQUE (email);

-- 5. Add a CHECK constraint to ensure age is greater than or equal to 18
ALTER TABLE Employees ADD CONSTRAINT emp_adult_age CHECK (age >= 18);

-- 6. Insert 5 employees with different emp_id, emp_name, age, salary, and join_date.
INSERT INTO Employees (emp_id, emp_name, age, salary, join_date, email) VALUES
('E001', 'Ali Kashif', 20, 70000, TO_DATE('2020-01-15','YYYY-MM-DD'), 'ali@ismailco.com');
INSERT INTO Employees (emp_id, emp_name, age, salary, join_date, email) VALUES
('E002', 'Sara Khan', 22, 60000, TO_DATE('2022-05-10','YYYY-MM-DD'), 'sara@ismailco.com');
INSERT INTO Employees (emp_id, emp_name, age, salary, join_date, email) VALUES
('E003', 'Khan Bro', 28, 55000, TO_DATE('2021-09-20','YYYY-MM-DD'), 'khan@ismailco.com');
INSERT INTO Employees (emp_id, emp_name, age, salary, join_date, email) VALUES
('E004', 'Meow Baksh', 35, 70000, TO_DATE('2020-03-01','YYYY-MM-DD'), 'meow@ismailco.com');
INSERT INTO Employees (emp_id, emp_name, age, salary, join_date, email) VALUES
('E005', 'Ismail Silat', 20, 72000, TO_DATE('2020-02-06','YYYY-MM-DD'), 'ismail@ismailco.com');
SELECT * FROM Employees;

-- 7. Insert an employee with age = 16 and see the CHECK constraint fail.
INSERT INTO Employees (emp_id, emp_name, age, salary, join_date, email) VALUES
('E006', 'Ali Hussain', 16, 70000, TO_DATE('2020-04-15','YYYY-MM-DD'), 'ali@ismailco.com');

-- 8. Insert a new employee with an email that duplicates another employee and see the UNIQUE constraint fail.
INSERT INTO Employees (emp_id, emp_name, age, salary, join_date, email) VALUES
('E006', 'Ali Hussain', 18, 70000, TO_DATE('2020-04-15','YYYY-MM-DD'), 'ali@ismailco.com');

-- 9. Delete an employee with emp_id = 'E005' and use ROLLBACK to undo the deletion.
DELETE FROM EMPLOYEES WHERE emp_id = 'E005';
SELECT * FROM Employees;

ROLLBACK;
SELECT * FROM Employees;

-- 10. Remove all records from the table without deleting the table structure.
DELETE FROM EMPLOYEES;

SELECT * FROM Employees;