SET SERVEROUTPUT ON;

-- Create a trigger that automatically updates an employee’s bonus table when a new record is  added to the employees table. The bonus is set to 10% of the inserted salary. Create a table  employee_bonus and populate it on each insert command. 
CREATE TABLE employee_bonus (
    employee_id INT,
    bonus NUMBER
);

CREATE OR REPLACE TRIGGER trgg_update_bonus
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_bonus VALUES (
        :NEW.employee_id,
        :NEW.salary * 0.01
    );
END;
/

-- Create a trigger that checks the new salary value being updated in the employees table. If the  new salary is greater than a threshold (say 10,000), display an error message to the user. 
CREATE OR REPLACE TRIGGER trgg_slr_hbound_chk
BEFORE UPDATE ON employyes
FOR EACH ROW
BEGIN 
    IF :NEW.salary > 10000 THEN
        RAISE_APPLICATION_ERROR(-200022, 'Cannot update salary > 10000');
    END IF;
END;
/

-- Create a trigger that logs every deleted record from the Employees table into a  Deleted_Employees_Log table. 
CREATE TABLE deleted_employees_logs (
    employee_id INT,
    first_name VARCHAR2(20),
    last_name VARCHAR2(20),
    email VARCHAR2(20),
    deleted_on DATE,
    deleted_by VARCHAR(20)
);
CREATE OR REPLACE TRIGGER trgg_delete_emps
AFTER DELETE ON employees
FOR EACH ROW
DECLARE
    v_user VARCHAR(20);
BEGIN
    SELECT USER INTO v_user FROM DUAL;
    INSERT INTO deleted_employees_logs VALUES (
        :OLD.employee_id,
        :OLD.first_name,
        :OLD.last_name,
        :OLD.email,
        SYSDATE,
        v_user
    );
END;
/

-- Create a trigger that logs every new table created in the database into an Audit_Log table,  including the table name, creation time and user name. 
CREATE TABLE audit_log_table (
    table_name VARCHAR2(30),
    creation_time DATE,
    user_name VARCHAR2(30)
);

CREATE OR REPLACE TRIGGER trgg_create_tbl
AFTER INSERT ON SCHEMA
DECLARE
    v_user VARCHAR(20);
BEGIN
    SELECT USER INTO v_user FROM DUAL;
    INSERT INTO audit_log_table VALUES (
        ora_dict_obj_name,
        SYSDATE,
        v_user
    );
END;
/

-- Create a trigger that prevents changes (ALTER statements) to the employees table after business  hours (e.g., 6 PM to 8 AM). 
CREATE OR REPLACE TRIGGER trgg_alt_time
BEFORE ALTER ON SCHEMA
BEGIN
    IF TO_NUMBER(TO_CHAR(SYSDATE, 'hh24')) >= 18 OR
        TO_NUMBER(TO_CHAR(SYSDATE, 'hh24')) < 8 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Changes not allowed after business hrs');
    END IF;
END;
/

-- Create a trigger that logs every DROP operation on any table in the database to a Drop_Log  table, recording the user who performed the action and the time it occurred. 
CREATE TABLE drop_log (
    object_name  VARCHAR2(50),
    dropped_by   VARCHAR2(30),
    dropped_on   DATE,
    dropped_time VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trgg_log_drop
AFTER DROP ON SCHEMA
DECLARE
    v_user VARCHAR2(30);
BEGIN
    SELECT USER INTO v_user FROM DUAL;
    INSERT INTO drop_log VALUES (
        ora_dict_obj_name,
        v_user,
        SYSDATE,
        TO_CHAR(SYSDATE, 'hh24:mi:ss')
    );
END;
/

-- Create a trigger that prevents dropping the Audit_Log table under any circumstance and display  a warning message instead. 
CREATE OR REPLACE TRIGGER trgg_protect_audit_log
BEFORE DROP ON SCHEMA
BEGIN
    IF ora_dict_obj_name = 'AUDIT_LOG' THEN
        RAISE_APPLICATION_ERROR(-20001, 'The Audit_Log table cannot be dropped!');
    END IF;
END;
/

-- Create a trigger that logs the time and status when the database starts into a System_Logs table. 
CREATE TABLE system_logs (
    event_type    VARCHAR2(30),
    logged_on     DATE,
    logged_time   VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trgg_usr_logs 
AFTER STARTUP ON DATABASE
BEGIN
    INSERT INTO system_logs VALUES (
        ora_sysevent,
        SYSDATE,
        TO_CHAR(SYSDATE, 'hh24:mi:ss')
    );
END;
/

-- Create a trigger that tracks the login attempts of users and logs unsuccessful attempts into a  Failed_Logins table. 
CREATE TABLE failed_logins (
    username      VARCHAR2(30),
    attempt_on    DATE,
    attempt_time  VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trgg_failed_logins
AFTER SERVERERROR ON DATABASE
BEGIN
    IF (IS_SERVERERROR(1017)) THEN
        INSERT INTO failed_logins VALUES (
            ora_login_user,
            SYSDATE,
            TO_CHAR(SYSDATE, 'hh24:mi:ss')
        );
    END IF;
END;
/

-- Create a trigger that logs every successful logout along with the session duration into a  User_Activity_Log table. 
CREATE TABLE session_log (
    username    VARCHAR2(30),
    login_time  DATE
);

CREATE TABLE user_activity_log (
    username          VARCHAR2(30),
    logout_time       DATE,
    session_duration  VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER trgg_record_login
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO session_log VALUES (
        ora_login_user,
        SYSDATE
    );
END;
/

CREATE OR REPLACE TRIGGER trgg_record_logout
BEFORE LOGOFF ON DATABASE
DECLARE
    v_login_time  DATE;
    v_duration    NUMBER;
BEGIN
    SELECT login_time INTO v_login_time
    FROM session_log
    WHERE username = ora_login_user;

    v_duration := ROUND((SYSDATE - v_login_time) * 24 * 60);

    INSERT INTO user_activity_log VALUES (
        ora_login_user,
        SYSDATE,
        v_duration || ' minutes'
    );

    DELETE FROM session_log WHERE username = ora_login_user;
END;
/

-- Create a view that joins Employees and Departments, and write an INSTEAD OF INSERT trigger  that correctly distributes new data into both the Employees and Departments tables. 
CREATE VIEW emp_deps AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_id, d.department_name, d.location_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

CREATE OR REPLACE TRIGGER trgg_emp_deps_view_insert
INSTEAD OF INSERT ON emp_deps
FOR EACH ROW
BEGIN
    INSERT INTO employees VALUES (
        :NEW.employee_id,
        :NEW.first_name,
        :NEW.last_name,
        :NEW.salary, 
        :NEW.department_id
    );
    INSERT INTO departments VALUES (
        :NEW.department_id,
        :NEW.department_name,
        :NEW.location_id
    );
END;
/

-- Create a view that shows employee salaries, and write an INSTEAD OF UPDATE trigger to  prevent any salary updates that reduce the employee’s salary by more than 20%.
CREATE VIEW emp_salaries AS
SELECT e.employee_id, e.first_name, e.last_name, s.salary
FROM employees e
FOR EACH ROW
JOIN salaries s ON e.employee_id = s.employee_id;

CREATE OR REPLACE TRIGGER trgg_upd_emp_salaries
INSTEAD OF UPDATE ON emp_salaries
BEGIN
    IF :NEW.salary < 0.8 * :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot decrease salary by more than 20%');
    ELSE
        UPDATE salaries
        SET salary = :NEW.salary
        WHERE employee_id = :NEW.employee_id;
    END IF;
END;
/

