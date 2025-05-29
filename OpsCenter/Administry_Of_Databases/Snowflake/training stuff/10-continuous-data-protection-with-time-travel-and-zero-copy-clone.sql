
-- 10.0.0  Continuous Data Protection with Time Travel and Zero Copy Clone
--         This lab will take approximately 15 minutes to complete.
--         The activities of taking a physical backup can now be replaced by
--         making a clone, which is significantly faster, requires less storage
--         cost ($0 at best). Combined with Snowflake’s Time Travel feature,
--         daily backups are no longer needed as Snowflake makes the normally
--         hard task of doing Point In Time Recovery (PITR) a simple matter.
--         Continuous Data Protection encompasses a comprehensive set of
--         features that help protect data stored in Snowflake against human
--         error, malicious acts, and software or hardware failure. At every
--         stage within the data lifecycle, Snowflake enables your data to be
--         accessible and recoverable in the event of accidental or intentional
--         modification, removal, or corruption.
--         - Understand the purpose and function of Time Travel.
--         - Identify how Zero Copy Clone works.
--         - Use both Time Travel and Zero Copy Cloning to restore data.

-- 10.1.0  Setup Lab Environment
--         In this exercise you will setup a database, schema and tables that
--         will be used for all the exercises in this lab.

-- 10.1.1  Set the worksheet context for the lab:

USE ROLE TRAINING_ROLE;
USE WAREHOUSE BADGER_LOAD_WH;


-- 10.2.0  Create a Database and HR Schema.
--         Use your worksheet and SQL to create a database.

-- 10.2.1  Create a database named BADGER_LAB9_DB using SQL:

CREATE DATABASE BADGER_LAB9_DB;
CREATE SCHEMA HR;


-- 10.2.2  Check your worksheet context.
--         You should be using your load warehouse, TRAINING_ROLE, and the
--         database and schema you just created.

-- 10.2.3  Create a table named employee, in the HR schema, with the following
--         columns:
--         Employee Table

-- 10.2.4  Run the following SQL to create the EMPLOYEE table:

CREATE OR REPLACE TABLE hr.employee (
     emp_id     NUMBER,
     dept_id    NUMBER,
     first_name VARCHAR(50),
     last_name  VARCHAR(50),
     salary     NUMBER(12,2),
     bonus      NUMBER(12,2)
     );


-- 10.2.5  Insert the following four (4) rows into the EMPLOYEE table:

INSERT INTO hr.employee VALUES
    (100, 1, 'Josephine', 'Jones', 84000.00, 0),
    (200, 2, 'Art', 'Dawson', 65000.00, 0),
    (300, 1, 'Peter', 'Burch', 76000.00, 0),
    (400, 2, 'Tony', 'Brown', 62000.00, 0);


-- 10.3.0  Continuous Data Protection with Time Travel
--         This exercise demonstrates how Time Travel can restore tables that
--         are accidentally dropped. In other database platforms, dropping a
--         database, schema or table is disastrous and requires the database be
--         restored from backup (if one exists). But, in Snowflake, since
--         dropping objects is only a metadata-based operation, restoring from a
--         DROP statement can be completed in seconds by using the UNDROP
--         command.
--         The UNDROP command must be executed with the data retention time
--         (DATA_RETENTION_TIME_IN_DAYS) parameter value for the table. For
--         Standard/Premier Editions this can be 0 or 1 day (default 1). For
--         Enterprise Edition and above this can be 0 to 90 days for permanent
--         table and 0 or 1 day for temporary and transient tables (default 1
--         unless a different default value was specified at the schema,
--         database, or account level).

-- 10.3.1  Check the tables created in exercise 1 and the data retention time.

-- 10.3.2  Use the SHOW TABLES SQL command to validate:

SHOW TABLES;
SHOW PARAMETERS LIKE '%DATA_RETENTION_TIME_IN_DAYS%' IN ACCOUNT;


-- 10.3.3  Run the following SQL to drop the table:

DROP TABLE HR.EMPLOYEE;


-- 10.3.4  Confirm the table was deleted by querying it and running a SHOW
--         TABLES command:

SELECT * FROM HR.EMPLOYEE;
SHOW TABLES;


-- 10.3.5  List all tables, including those tables that have been dropped.
--         Dropped tables are only shown if they are still within their
--         respective Time Travel retention period.

-- 10.3.6  Use the SHOW TABLES HISTORY command to see all the tables including
--         dropped tables:

SHOW TABLES HISTORY;


-- 10.3.7  Run the following command to UNDROP the employee table, i.e., restore
--         the table:

UNDROP TABLE HR.EMPLOYEE;


-- 10.3.8  Confirm that the table was restored by querying it again:

SELECT * FROM HR.EMPLOYEE;

--         This exercise demonstrates the UNDROP TABLE command. UNDROP DATABASE
--         and UNDROP SCHEMA restore databases and schemas to their previous
--         state.

-- 10.3.9  For extra credit repeat this exercise by dropping and un-dropping
--         your database and then the HR schema.
--         SCHEMA

SHOW SCHEMAS;
DROP SCHEMA HR;
SHOW SCHEMAS;
SHOW SCHEMAS HISTORY;
UNDROP SCHEMA HR;
SHOW SCHEMAS;

--         DATABASE

-- Make sure your BADGER is in ALL CAPS
SHOW DATABASES STARTS WITH 'BADGER';

DROP DATABASE BADGER_LAB9_DB;

-- Make sure your BADGER is in ALL CAPS
SHOW DATABASES HISTORY STARTS WITH 'BADGER';

UNDROP DATABASE BADGER_LAB9_DB;

-- Make sure your BADGER is in ALL CAPS
SHOW DATABASES HISTORY STARTS WITH 'BADGER';


-- 10.4.0  Use Time Travel and Zero Copy Cloning Together to Restore Data
--         This exercise uses Time Travel and Zero Copy Clone together to
--         restore data to a point-in-time.

-- 10.4.1  Use the CLONE option to restore a table to the point in time
--         immediately prior to an errant update.

-- 10.4.2  Update the new DEPT_ID column in HR.EMPLOYEE. You may need to reset
--         the context:

USE DATABASE BADGER_LAB9_DB;
USE SCHEMA HR;
UPDATE HR.EMPLOYEE SET DEPT_ID = 0
WHERE LAST_NAME = 'Jones';

--         Whoops, we made a mistake. We didn’t mean to move Jones to a
--         different department.

-- 10.4.3  Find the query ID that performed the UPDATE to HR.EMPLOYEE ID.
--         This can be done several ways including using the History tab in the
--         UI or using the LAST_QUERY_ID() function below or querying using the
--         QUERY_HISTORY function.
--         Option 1: LAST_QUERY_ID() function.

-- 10.4.4  If the query you want the ID for is the last query run, use the
--         function LAST_QUERY_ID().

SELECT LAST_QUERY_ID();

--         Option 2: Query a QUERY_HISTORY table function to find the query.

SELECT QUERY_ID, QUERY_TEXT
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY_BY_USER(USER_NAME=>'BADGER'));


-- 10.4.5  Restore the table to the state prior to updating the dept_id column.

-- 10.4.6  Create a clone of the HR.EMPLOYEE table, as it was before the UPDATE
--         statement, named HR.EMPLOYEE_RESTORE, using the Query ID that you
--         identified in task 2:

CREATE OR REPLACE TABLE HR.EMPLOYEE_RESTORE CLONE HR.EMPLOYEE
BEFORE (STATEMENT => <QueryID>);


-- 10.4.7  Query the HR.EMPLOYEE_RESTORE table to ensure that it was restored to
--         the point-in-time before the DEPT_ID column updates.
--         Employee_Restore Table

-- 10.4.8  Swap the HR.EMPLOYEE_RESTORE with HR.EMPLOYEE table:

ALTER TABLE HR.EMPLOYEE_RESTORE SWAP WITH HR.EMPLOYEE;


-- 10.4.9  Query the HR.EMPLOYEE table to confirm it now contains the restored
--         data:

SELECT * FROM HR.EMPLOYEE;

--         Employee Table

-- 10.4.10 Perform a clean up of your system by dropping the HR.EMPLOYEE_RESTORE
--         table:

DROP TABLE HR.EMPLOYEE_RESTORE;

