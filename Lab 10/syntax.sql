-- Basic PL/SQL structure - Only BEGIN & END is manadtory
SET SERVEROUTPUT ON;   -- always run this first!

DECLARE
  -- variables, constants, cursors declared here
BEGIN
  -- actual logic goes here
EXCEPTION
  -- error handling goes here
END;
/

-- Minimal working example
DECLARE
  v_msg VARCHAR2(50) := 'Hello from PL/SQL!';
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

-- :=  Assignment  (e.g. x := 5)
-- ||  Concatenation  (e.g. 'Hi '||name)
-- %TYPE  Borrow a column's type
-- =  Comparison (not ==!)
-- <> or !=  Not equal

-- Declaring & Using variables
DECLARE
  v_name   VARCHAR2(30);           -- no initial value (NULL)
  v_salary NUMBER      := 50000;    -- with initial value
  v_age    INTEGER     := 25;
  c_tax    CONSTANT NUMBER := 0.15; -- constant (cannot change)
BEGIN
  v_name := 'Alice';
  DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
  DBMS_OUTPUT.PUT_LINE('Net: ' || (v_salary - v_salary * c_tax));
END;
/

-- %TYPE — borrow column type from a table
DECLARE
    v_eid employees.EMPLOYEE_ID%TYPE;
    v_fname employees.FIRST_NAME%TYPE;
    v_sal employees.SALARY%TYPE;
BEGIN
    v_eid := 101;
END;
/

-- Variable scope (global vs local)
DECLARE
  x NUMBER := 10;   -- outer (global) block
BEGIN
  DBMS_OUTPUT.PUT_LINE('Outer x: ' || x);  -- prints 10
  DECLARE
    x NUMBER := 99;  -- inner block — shadows outer x
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inner x: ' || x);  -- prints 99
  END;
  DBMS_OUTPUT.PUT_LINE('Outer x again: ' || x);  -- prints 10
END;
/

-- SELECT INTO
DECLARE
    v_fname employees.FIRST_NAME%TYPE;
    v_sal employees.SALARY%TYPE;
BEGIN
    SELECT first_name, salary
    INTO v_fname, v_sal
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_fname);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_sal);
END;
/

-- SELECT INTO with JOIN
DECLARE
  v_eid    employees.EMPLOYEE_ID%TYPE;
  v_fname  employees.FIRST_NAME%TYPE;
  v_dname  departments.DEPARTMENT_NAME%TYPE;
BEGIN
  SELECT e.EMPLOYEE_ID, e.FIRST_NAME, d.DEPARTMENT_NAME
    INTO v_eid, v_fname, v_dname
    FROM employees e
    JOIN departments d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
   WHERE e.EMPLOYEE_ID = 100;

  DBMS_OUTPUT.PUT_LINE(v_fname || ' works in ' || v_dname);
END;
/

-- Exception handling with SELECT INTO
DECLARE
  v_sal employees.SALARY%TYPE;
BEGIN
  SELECT SALARY INTO v_sal FROM employees WHERE EMPLOYEE_ID = 9999;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Multiple rows returned!');
END;
/

-- IF - THEN
IF v_salary >= 5000 THEN
  DBMS_OUTPUT.PUT_LINE('High earner');
END IF;

-- IF - THEN - ELSIF - ELSE
IF v_sal <= 15000 THEN
  UPDATE employees SET salary = v_sal + 300 WHERE EMPLOYEE_ID = v_id;
ELSIF v_sal <= 20000 THEN
  UPDATE employees SET salary = v_sal + 200 WHERE EMPLOYEE_ID = v_id;
ELSIF v_sal <= 25000 THEN
  UPDATE employees SET salary = v_sal + 100 WHERE EMPLOYEE_ID = v_id;
ELSE
  UPDATE employees SET salary = v_sal + 400 WHERE EMPLOYEE_ID = v_id;
END IF;

-- CASE
CASE v_dept_id
  WHEN 80 THEN 
    UPDATE employees SET salary = v_sal + 100 WHERE EMPLOYEE_ID = v_id;
  WHEN 50 THEN 
    UPDATE employees SET salary = v_sal + 200 WHERE EMPLOYEE_ID = v_id;
  WHEN 40 THEN 
    UPDATE employees SET salary = v_sal + 300 WHERE EMPLOYEE_ID = v_id;
  ELSE 
    DBMS_OUTPUT.PUT_LINE('No matching dept');
END CASE;


-- NESTED IF
IF v_dept = 90 THEN
  IF v_sal BETWEEN 20000 AND 25000 THEN
    UPDATE employees SET salary = v_sal * (1 + v_com) WHERE EMPLOYEE_ID = v_id;
  ELSIF v_sal BETWEEN 15000 AND 20000 THEN
    UPDATE employees SET salary = (v_sal + 20) * (1 + v_com) WHERE EMPLOYEE_ID = v_id;
  END IF;
END IF;


-- FOR loop over a query result
BEGIN
    FOR rec IN (
        SELECT employee_id, first_name, salary
        FROM employees
        WHERE department_id = 90
    ) LOOP
        DBMS_OUTPUT.PUT_LINE (
            rec.first_name || ' earns $' || rec.salary
    );
    END LOOP;
END;
/

-- FOR loop with UPDATE inside
BEGIN
    FOR emp IN ( SELECT employee_id, salary FROM employees WHERE department_id = 50)
    LOOP
        IF emp.salary < 5000 THEN
            UPDATE employees
            SET salary = emp.salary * 1.10
            WHERE employee_id = emp.employee_d
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Done!');
END;
/

-- Creating a procedure
CREATE OR REPLACE PROCEDURE procedure_name (
    param1 IN VARCHAR2,
    param2 IN NUMBER
) IS
    v_local NUMBER;
BEGIN
-- logic
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Executing a procedure

-- Method 1: EXEC (short form)
EXEC procedure_name(arg1, arg2);

-- Method 2: inside an anonymous block
BEGIN
  procedure_name(arg1, arg2);
END;
/

-- INSERT LOCATION EXAMPLE
CREATE OR REPLACE PROCEDURE Insert_Location (
    p_city IN VARCHAR2,
    p_country IN CHAR
) 
IS
    v_new_id NUMBER;
BEGIN
    SELECT NVL(MAX(LOCATION_ID), 0) + 1 INTO v_new_id FROM LOCATIONS;
    INSERT INTO LOCATIONS (LOCATION_ID, CITY, COUNTRY_ID)
    VALUES (v_new_id, p_city, p_country);
    
    DBMS_OUTPUT.PUT_LINE('Inserted ID: ' || v_new_id);
END;
/

EXEC Insert_Location('Karachi', 'PK');



-- IN parameter - read-only input
CREATE OR REPLACE PROCEDURE Show_Employee (
    p_id IN NUMBER
)
IS
    v_name employees.first_name%TYPE;
BEGIN
    SELECT first_name INTO v_name FROM employees WHERE employee_id = p_id;
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
END;
/
EXEC Show_Employee(100);


-- OUT parameter — return a value
CREATE OR REPLACE PROCEDURE Get_Salary (
    p_id IN NUMBER,
    p_sal OUT NUMBER
)
IS
BEGIN
    SELECT salary INTO p_sal FROM employees WHERE employee_id = p_id;
END;
/
-- Must call it from a block (not EXEC) to capture the OUT value:
DECLARE
  v_salary NUMBER;
BEGIN
  Get_Salary(100, v_salary);
  DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
END;
/

-- IN OUT parameter — pass in and modify
CREATE OR REPLACE PROCEDURE Apply_Raise (
    p_salary IN OUT NUMBER
)
IS
BEGIN
    p_salary := p_salary * 1.10;
END;
/

DECLARE
    v_sal NUMBER := 5000;
BEGIN
    Apply_Raise(v_sal);
    DBMS_OUTPUT.PUT_LINE('After raise: ' || v_sal);
END;
/
