SET SERVEROUTPUT ON;


DECLARE
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    SELECT first_name, last_name, salary INTO v_fname, v_lname, v_salary 
    FROM employees WHERE employee_id = 107;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname || ' | Salary: ' || v_salary);
END;
/


DECLARE
    v_employee_id employees.employee_id%TYPE := 9999;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN 
    SELECT first_name, last_name, salary INTO v_fname, v_lname, v_salary 
    FROM employees WHERE employee_id = v_employee_id;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname || ' | Salary: ' || v_salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee not found.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple Employees returned.');
END;
/
    
DECLARE
    v_employee_id employees.employee_id%TYPE;
    v_salary employees.salary%TYPE;
    v_increment employees.salary%TYPE;
BEGIN
    SELECT employee_id, salary INTO v_employee_id, v_salary FROM employees WHERE employee_id = 104;
    IF v_salary < 5000 THEN
        v_increment := 800;
    ELSIF v_salary <= 8000 THEN
        v_increment := 500;
    ELSIF v_salary <= 12000 THEN
        v_increment := 300;
    ELSE
        v_increment := 100;
    END IF;
    UPDATE employees
    SET salary = v_salary + v_increment
    WHERE employee_id = v_employee_id;
    DBMS_OUTPUT.PUT_LINE('Employee ' || v_employee_id || ' salary updated to: ' || (v_salary + v_increment));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee Not Found.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple employees returned.');
END;
/

DECLARE
    v_employee_id employees.employee_id%TYPE;
    v_salary employees.salary%TYPE;
    v_bonus employees.salary%TYPE := 0;
    v_dept_id employees.department_id%TYPE;
BEGIN
    SELECT employee_id, salary, department_id
    INTO v_employee_id, v_salary, v_dept_id
    FROM employees
    WHERE employee_id = 200;
    CASE v_dept_id
        WHEN 10 THEN
            v_bonus := 1000;
        WHEN 20 THEN
            v_bonus := 750;
        WHEN 50 THEN
            v_bonus := 500;
        WHEN 90 THEN
            v_bonus := 1500;
        ELSE
            DBMS_OUTPUT.PUT_LINE('No bonus applicable.');
    END CASE;
    IF v_bonus > 0 THEN
        UPDATE employees
        SET salary = (v_salary + v_bonus)
        WHERE employee_id = v_employee_id;
        DBMS_OUTPUT.PUT_LINE('Employee ' || v_employee_id || ' in dept' || v_dept_id
            || ' gets bonus. New salary: ' || (v_salary + v_bonus));
    END IF;
END;
/

DECLARE
    v_raise NUMBER;
BEGIN
    FOR rec IN (
        SELECT employee_id, first_name, salary FROM employees
        WHERE department_id = 50
    ) LOOP
        
        IF rec.salary < 3000 THEN
            v_raise := 1.15;
        ELSIF rec.salary < 6000 THEN
            v_raise := 1.10;
        ELSE
            v_raise := 1;
        END IF;
        IF v_raise > 1 THEN
            DBMS_OUTPUT.PUT_LINE( rec.first_name || ' got a '|| ((v_raise - 1)*100) || '% raise. New salary: ' || (rec.salary * v_raise));
            UPDATE employees
            SET salary = rec.salary * v_raise
            WHERE employee_id = rec.employee_id;
        ELSE
            DBMS_OUTPUT.PUT_LINE(rec.first_name || ' needs no raise.');
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Done. All employees processed.');
END;
/

CREATE OR REPLACE PROCEDURE Get_Employee_Details (
    p_emp_id IN employees.employee_id%TYPE
)
IS
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT e.first_name, e.last_name , d.department_name
    INTO v_fname, v_lname, v_dname
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.employee_id = p_emp_id;
    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_fname || ' ' || v_lname || ' | Department: ' || v_dname);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No employee found with that ID.');
END;
/

EXEC Get_Employee_Details(101);

CREATE OR REPLACE PROCEDURE Get_Annual_Salary (
    p_emp_id IN employees.employee_id%TYPE,
    p_annual_salary OUT NUMBER
)
IS
    v_sal employees.salary%TYPE;
BEGIN
    SELECT salary INTO v_sal FROM employees WHERE employee_id = p_emp_id;
    p_annual_salary := v_sal * 12;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee not found.');
END;
/

DECLARE
    v_annual_sal NUMBER;
    v_emp_id employees.employee_id%TYPE := 104;
BEGIN
    Get_Annual_Salary(v_emp_id, v_annual_sal);
    IF v_annual_sal IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Annual salary for employee ' || v_emp_id || ': ' || v_annual_sal);
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE Apply_Bonus(
    p_emp_id IN employees.employee_id%TYPE,
    p_salary IN OUT employees.salary%TYPE
) IS
    v_dept_id employees.department_id%TYPE;
    v_bonus NUMBER;
BEGIN
    SELECT department_id INTO v_dept_id FROM employees WHERE employee_id = p_emp_id;
    v_bonus := 1.05;
    CASE v_dept_id 
        WHEN 90 THEN
            v_bonus := 1.20;
        WHEN 50 THEN
            v_bonus := 1.15;
        WHEN 80 THEN
            v_bonus := 1.10;
    END CASE;
    p_salary := (p_salary * v_bonus);
    DBMS_OUTPUT.PUT_LINE('Bonus applied. Updated salary: ' || p_salary);
END;
/

DECLARE
    v_emp_id employees.employee_id%TYPE := 100;
    v_salary employees.salary%TYPE;
BEGIN
    SELECT salary INTO v_salary FROM employees WHERE employee_id = v_emp_id;
    Apply_Bonus(v_emp_id, v_salary);
    UPDATE employees
    SET salary = v_salary
    WHERE employee_id = v_emp_id;
    DBMS_OUTPUT.PUT_LINE('Employee ' || v_emp_id || ' salary updated in DB to: ' || v_salary); 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee not found.');
END;
/


