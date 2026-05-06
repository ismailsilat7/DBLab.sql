SET SERVEROUTPUT ON;

-- Scenario 1: A bank maintains an accounts table. Whenever a new account is inserted, 
-- the system must automatically create an entry in a welcome_bonus table giving that 
-- customer a bonus of 5% of their opening balance.

CREATE TABLE accounts (
    acc_id NUMBER PRIMARY KEY,
    cust_name VARCHAR2(30),
    balance NUMBER
);

CREATE TABLE welcome_bonus (
    acc_id NUMBER,
    cust_name VARCHAR2(30),
    bonus_amt NUMBER,
    created_on DATE
);

CREATE OR REPLACE TRIGGER record_welcome_bonus
AFTER INSERT ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO welcome_bonus VALUES(
        :NEW.acc_id, :NEW.cust_name, :NEW.balance * 0.05, SYSDATE
    );
END;
/

-- Scenario 2: A company has an employees table. Management wants to ensure that no 
-- employee's salary is ever decreased. If someone tries to update a salary to a 
-- lower value, the system must block the update and show the message: 
-- "Salary cannot be decreased!"

CREATE TABLE emp (
    emp_id    NUMBER PRIMARY KEY,
    emp_name  VARCHAR2(30),
    salary    NUMBER
);

CREATE OR REPLACE TRIGGER trgg_salary_lbound
BEFORE UPDATE ON emp
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'New salary cannot be lower than old salary!');
    END IF;
END;
/

-- Scenario 3: A company wants to keep a record of every employee that gets fired 
-- (deleted). Whenever a row is deleted from the employees table, that record must 
-- be saved into a fired_employees log table — along with the date they were removed 
-- and who deleted them.

CREATE TABLE emps (
    emp_id    NUMBER PRIMARY KEY,
    emp_name  VARCHAR2(30),
    salary    NUMBER
);

CREATE TABLE fired_emps (
    emp_id      NUMBER,
    emp_name    VARCHAR2(30),
    salary      NUMBER,
    fired_on    DATE,
    fired_by    VARCHAR2(30)
)

CREATE OR REPLACE TRIGGER trgg_fired_emp
BEFORE DELETE ON emps
FOR EACH ROW
DECLARE
    v_user VARCHAR2(30);
BEGIN
    SELECT USER INTO v_user FROM DUAL;
    INSERT INTO fired_emps VALUES (
        :OLD.emp_id,
        :OLD.emp_name,
        :OLD.salary,
        SYSDATE,
        v_user
    );
END;
/

-- Scenario 4: A hospital wants to track every change made to their doctors 
-- table — whether a doctor is added, updated, or removed. Every action must be 
-- logged into a doctors_audit table with what action was performed, who did it, 
-- and when.

CREATE TABLE doctors (
    doc_id    NUMBER PRIMARY KEY,
    doc_name  VARCHAR2(30),
    specialty VARCHAR2(30),
    salary    NUMBER
);

CREATE TABLE doctors_audit (
    action_type  VARCHAR2(10),
    doc_id       NUMBER,
    doc_name     VARCHAR2(30),
    actioned_by  VARCHAR2(30),
    actioned_on  DATE
);

CREATE OR REPLACE TRIGGER trgg_changes_doctors
AFTER INSERT OR UPDATE OR DELETE ON doctors
FOR EACH ROW
DECLARE
    v_user VARCHAR2(20);
BEGIN
    SELECT USER INTO v_user FROM DUAL;
    IF INSERTING THEN
        INSERT INTO doctors_audit VALUES (
            'INSERT',
            :NEW.doc_id,
            :NEW.doc_name,
            v_user,
            SYSDATE
        );
    ELSIF UPDATING THEN
        INSERT INTO doctors_audit VALUES (
            'UPDATE',
            :NEW.doc_id,
            :NEW.doc_name,
            v_user,
            SYSDATE
        );
    ELSIF DELETING THEN
        INSERT INTO doctors_audit VALUES (
            'DELETE',
            :OLD.doc_id,
            :OLD.doc_name,
            v_user,
            SYSDATE
        );
    END IF;
END;
/

-- Scenario 5: A university's DBA wants to monitor all new tables being created in 
-- the database. Whenever anyone creates a new table, the details must be 
-- automatically logged into a table_creation_log with the table name, 
-- who created it, and when.

CREATE TABLE table_creation_log (
    table_name   VARCHAR2(50),
    created_by   VARCHAR2(30),
    created_on   DATE
);

CREATE OR REPLACE TRIGGER trgg_tble_creat 
AFTER CREATE ON SCHEMA
DECLARE
    v_user VARCHAR2(20);
BEGIN
    SELECT USER INTO v_user FROM DUAL;
    INSERT INTO table_creation_log VALUES (
        ora_dict_obj_name,
        v_user,
        SYSDATE
    );
END;
/

-- Scenario 6: A company is worried about someone accidentally dropping critical 
-- tables. Write a trigger that completely prevents anyone from dropping the employees table 
-- and displays the message: "The employees table cannot be dropped!"

CREATE OR REPLACE TRIGGER trgg_drop_tbl
BEFORE DROP ON SCHEMA
BEGIN
    IF ora_dict_obj_name = 'EMPLOYEES' THEN
        RAISE_APPLICATION_ERROR(-20001, 'The employees table cannot be dropped!');
    END IF;
END;
/

-- Scenario 7: A company's IT security team wants to track every user that logs into 
-- the Oracle database. Whenever someone logs on, their username, date, and time 
-- must be recorded in a login_audit table.

CREATE TABLE login_audit (
    username     VARCHAR2(30),
    login_date   DATE,
    login_time   VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER trgg_track_login
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO login_audit VALUES (
        ora_login_user,
        SYSDATE,
        TO_CHAR(SYSDATE, 'hh24:mi:ss')
    );
END;
/
        
-- Scenario 8: A university has two tables — students and courses. A view called 
-- student_course_view joins them together. Since it's a joined view, it can't be 
-- updated directly. Write an INSTEAD OF INSERT trigger so that when someone 
-- inserts into the view, the data correctly goes into both underlying tables.

CREATE TABLE students (
    student_id    NUMBER PRIMARY KEY,
    student_name  VARCHAR2(30)
);

CREATE TABLE courses (
    course_id     NUMBER PRIMARY KEY,
    course_name   VARCHAR2(30),
    student_id    NUMBER
);

CREATE VIEW student_course_view AS
    SELECT s.student_id, s.student_name, c.course_id, c.course_name
    FROM students s, courses c
    WHERE s.student_id = c.student_id;

CREATE OR REPLACE TRIGGER trgg_scv_insert
INSTEAD OF INSERT ON student_course_view
FOR EACH ROW
BEGIN
    INSERT INTO students VALUES (
        :NEW.student_id,
        :NEW.student_name
    );
    INSERT INTO courses VALUES (
        :NEW.course_id,
        :NEW.course_name,
        :NEW.student_id
    );
END;
/

