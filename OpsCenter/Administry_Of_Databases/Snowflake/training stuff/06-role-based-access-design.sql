
-- 6.0.0   Role-Based Access & Design
--         This lab will take approximately 30 minutes to complete.
--         Managing Users, Roles, and Privileges can be a challenging task. If
--         well planned and executed, it can produce a highly secure system
--         that’s easy to maintain. If poorly executed, it can be (at best)
--         confusing and (at worst) completely unmanageable. This lab takes the
--         user through the steps needed to identify the role-based requirements
--         and implement them in Snowflake.
--         - The overall methodology describing a suggested approach to role
--         management.
--         - Summarizing the assumed deployment requirements.
--         - A walk through of the remaining scripts.
--         - You have been granted SYSADMIN and SECURITYADMIN roles.
--         - You have access to the file containing the scripts.
--         - You can edit the scripts; meaning multiple individuals can run the
--         lab on a single account without clashing with others.

-- 6.1.0   Preparation Steps

-- 6.1.1   Identify the virtual warehouses, databases, and schemas required.

-- 6.1.2   Identify the roles and responsibilities (e.g., DBA, ANALYST).

-- 6.1.3   Decide what privileges are needed for each role. For example:

-- 6.1.4   Determine which Databases and Schemas each role will have authority
--         to use. (They will require USAGE privilege on these.)

-- 6.1.5   Decide for each leading role (e.g., DBA) whether they require the
--         ability to grant their own role or if other users should have that
--         ability. (These leading roles will need to own that particular role.)

-- 6.1.6   Identify which role will go to each user and then verify each
--         person/role has the correct privileges to perform their tasks.

-- 6.1.7   If required, reorganize the roles by dividing responsibilities into
--         other roles

-- 6.1.8   Create a role hierarchy. (e.g., a power analyst with update access
--         and a sub-set of ANALYST with Read Only access to data).

-- 6.2.0   Creating Databases and Schemas
--         While it’s not necessary to create every securable object (e.g.,
--         Tables, Views, etc.), at this point you should create the Virtual
--         warehouses, Databases, and Schemas. It also may be sensible to create
--         a few test tables in each schema to test the deployment.

-- 6.3.0   Creating Roles, Users, and Privileges

-- 6.3.1   Use the role SYSADMIN to create database objects (Database,
--         Schema(s), Virtual Warehouses).

-- 6.3.2   Grant the privileges needed by each role to perform their duties
--         including usage on objects.

-- 6.3.3   Create the User(s) for each role.

-- 6.3.4   Where relevant, transfer ownership of each role as needed.

-- 6.3.5   For each role who owns securable objects, switch into the role (use
--         role), and create database objects as required.

-- 6.4.0   Requirements
--         This section summarizes the assumed requirements for this deployment.
--         This will normally be achieved by either analyzing the existing
--         systems roles, users and permissions, or through discussion with user
--         management.
--         Standard Snowflake requirements assume every custom role must be
--         accessible from SYSADMIN.

-- 6.5.0   Role Requirements
--         A PROD_DBA_ROLE will be responsible for:
--         A PROD_ANALYST_ROLE will be responsible for:

-- 6.6.0   Deployment Scripts
--         This section includes scripts which will be used to deploy the system
--         and create the roles.

-- 6.6.1   Create PROD Roles and Database Objects
--         Note the following items in the subsequent script:
--         This script creates the primary PROD roles.

-- *********************************************************************
-- Deploy the PROD objects
-- Primarily owned and controlled by PROD_DBA_ROLE
-- *********************************************************************

-- =====================================================================
-- 1.  Create PROD roles
-- =====================================================================
USE ROLE securityadmin;

CREATE ROLE BADGER_prod_dba_role;
CREATE ROLE BADGER_prod_analyst_role;

GRANT ROLE BADGER_prod_dba_role to role sysadmin;
GRANT ROLE BADGER_prod_analyst_role  to role sysadmin;


-- 6.6.2   Grant correct privileges to the PROD roles.
--         Note the following items in the subsequent script:

-- 6.6.3   This script grants privileges to the PROD roles:

-- =====================================================================
-- 2. Grant privileges to PROD roles
-- =====================================================================

USE ROLE securityadmin;

-- Needed to create other Users
GRANT create user
    on account 
    to role BADGER_prod_dba_role;

-- Needed to grantBADGER_PROD_DBA_ROLE to other DBA Users
GRANT manage grants
    on account
    to role BADGER_prod_dba_role;

USE ROLE sysadmin;

-- Needed to create a Virtual Warehouse to manage concurrency and performance
GRANT create warehouse
    on account
    to role BADGER_prod_dba_role;


-- 6.6.4   Create the Virtual Warehouse
--         This script creates the virtual warehouse and grants usage.

-- =====================================================================
-- 3. Create Virtual warehouse and grant to DBA
-- =====================================================================

USE ROLE sysadmin;

-- Create the Virtual Warehouse
CREATE warehouse BADGER_prod_main_vwh 
with
warehouse_size = 'XSMALL'
warehouse_type = 'STANDARD'
auto_suspend = 300
auto_resume = true
comment = 'Main PROD Warehouse';

GRANT usage
on warehouse BADGER_prod_main_vwh
to role BADGER_prod_dba_role;


-- 6.6.5   Create the PROD database
--         Note the following items in the subsequent script:

-- 6.6.6   This script creates the PROD database:

-- =====================================================================
-- 4. Create PROD database, schema(s) and Virtual Warehouse -
--    Ensuring database fully accessible to PROD DBA role
-- =====================================================================

-- Create the Database
USE ROLE sysadmin;
CREATE DATABASE BADGER_prod_db;

GRANT all privileges
    on database BADGER_prod_db
    to role BADGER_prod_dba_role;

-- Create the schemas within the database
USE DATABASE  BADGER_prod_db;
USE ROLE BADGER_prod_dba_role;

CREATE SCHEMA BADGER_prod_main_sc;
CREATE SCHEMA BADGER_prod_wrk_sc;

-- Set up some test tables
USE SCHEMA  BADGER_prod_main_sc;
CREATE table f_fact_table (fact_id number, dim_id number);

INSERT into f_fact_table (fact_id, dim_id)
    values (1, 1), (2,2);

USE SCHEMA   BADGER_prod_wrk_sc;
CREATE table w_working_table (id  varchar);

INSERT into w_working_table 
    values ('PROD Working table row 1'),
           ('PROD Working table row 2');

SHOW TABLES in database;


-- 6.6.7   Grant Privileges to the ANALYST role
--         The fully qualified table name is set using the DATABASE and SCHEMA
--         names rather than setting context with the USE command.

-- =====================================================================
-- 5. Grant privileges to ANALYST ROLE
-- ANALYST has read only access to all tables in the MAIN schema
-- but not the WORKING schema
-- Only select access to tables and views
-- =====================================================================

-- Database
GRANT USAGE
    on database BADGER_prod_db
    to role BADGER_prod_analyst_role;

-- Schema
GRANT USAGE
    on schema BADGER_prod_db. BADGER_prod_main_sc
    to role BADGER_prod_analyst_role;

-- Virtual Warehouse
GRANT USAGE
    on warehouse BADGER_prod_main_vwh
    to role BADGER_prod_analyst_role;

GRANT SELECT
    on all tables
    in schema BADGER_prod_db. BADGER_prod_main_sc
    to role BADGER_prod_analyst_role;

GRANT SELECT
    on all views
    in schema BADGER_prod_db. BADGER_prod_main_sc
    to role BADGER_prod_analyst_role;

USE ROLE BADGER_prod_analyst_role;

-- Test all is well
SHOW TABLES;

-- Note: We qualify both the Database and Schema, or we use it to set context
SELECT *
from BADGER_prod_db.BADGER_prod_main_sc.f_fact_table;


-- 6.6.8   Use the following script to GRANT roles and CREATE users.
--         Pay close attention the commands within the script as they do the
--         following:
--         When creating the ANALYST user, the default role is set. We must
--         therefore grant that role to avoid a failure when logging in.

-- =====================================================================
-- 6. Grant ANALYST role to DBA
--    This will be the default role to ensure DBAs do
--    not start from a super-powerful role
-- =====================================================================

USE ROLE BADGER_prod_dba_role;

GRANT ROLE BADGER_prod_analyst_role
    to role BADGER_prod_dba_role;

-- =====================================================================
-- 7. Create PROD USERS and grant them the role(s)
-- =====================================================================

USE ROLE BADGER_prod_dba_role;

-- DBA User

CREATE USER if not exists BADGER_prod_dba_bert
      password = 'rose-bud'
      default_warehouse  = BADGER_prod_main_vwh
      default_role       = BADGER_prod_dba_role
      default_namespace  = BADGER_prod_db. BADGER_prod_main_sc
      must_change_password = true
      comment = 'PROD DBA';

-- Specify the following in order to run subsequent exercises successfully.

USE ROLE INSTRUCTOR1_prod_dba_role;

-- Attempt to connect as BADGER_prod_dba_bert.
-- You get an error message:  'BADGER_PROD_DBA_ROLE' 
--     specified in the connect string is not granted to this user.
-- Contact your local system administrator, 
-- or attempt to login with another role

GRANT ROLE BADGER_prod_dba_role
    to user BADGER_prod_dba_bert;

-- Students should try to log on again as BADGER_prod_dba_bert

-- Analyst User
CREATE USER if not exists BADGER_prod_analyst_ernie
      password = 'rose-bud'
      default_warehouse  = BADGER_prod_main_vwh
      default_role       = BADGER_prod_analyst_role
      default_namespace  = BADGER_prod_db. BADGER_prod_main_sc
      must_change_password = true
      comment = 'PROD Analyst';

GRANT ROLE BADGER_prod_analyst_role
    to user BADGER_prod_analyst_ernie;

-- Students should attempt logging on as BADGER_prod_analyst_ernie


-- 6.6.9   This script transfers ownership of the DEV DBA and DEV roles as
--         appropriate.

-- 6.6.10  Note the following items in the subsequent script:

-- =====================================================================
-- 8. Transfer ownership of roles as needed
-- =====================================================================

USE ROLE sysadmin;

-- PROD DBAs can enroll new ANALYSTs 
GRANT ownership
    on role BADGER_prod_analyst_role
    to role BADGER_prod_dba_role
    copy current grants;


-- 6.6.11  This script grants each of the roles to the currently logged in user.

-- 6.6.12  Change the user ID to your own before executing this script.

-- =====================================================================
-- 9. Grant all roles to yourself
-- =====================================================================
GRANT ROLE BADGER_prod_dba_role
    to user BADGER;

GRANT ROLE BADGER_prod_analyst_role
    to user BADGER;


-- 6.6.13  Use the following script to verify the deployment was successful.

-- 6.6.14  Note the following items in the subsequent script:
--         Role Ownership

-- =====================================================================
-- 10. Verify setup
-- =====================================================================

-- a) Verify owner for each role
USE ROLE sysadmin;
SHOW roles like 'BADGER%';

-- b) Verify PROD DBA role OK
USE ROLE BADGER_prod_dba_role;
USE database BADGER_prod_db;
USE schema BADGER_prod_main_sc;
USE warehouse BADGER_prod_main_vwh;

SELECT *
from f_fact_table;

DROP table f_fact_table;
UNDROP table f_fact_table;

-- c) verify ANALYST role
USE role BADGER_prod_analyst_role;
USE database BADGER_prod_db;
USE schema BADGER_prod_main_sc;
USE warehouse BADGER_prod_main_vwh;

SELECT *
from f_fact_table;

DROP table f_fact_table;


-- 6.6.15  This section lists an approach to diagnose problems with Roles and
--         Privileges.

-- 6.6.16  If the object does not exist, this is typically caused by one of the
--         following reasons:

-- 6.6.17  Check your current context?

-- 6.6.18  Show the object details (e.g., SHOW databases like %XXX%).

-- 6.6.19  Execute Script in Web UI fails.
--         When a script fails, you’ll receive an error message, but no
--         indication of the source of the problem.
--         SQL compilation error: Object does not exist, or operation cannot be
--         performed.

-- 6.6.20  Click in the Open History link in the results pane, to view the
--         failing statement.

-- 6.6.21  Switch between the History Tab and the Worksheet tab to diagnose the
--         issue.

-- 6.7.0   Summary of Database Roles and Objects
--         This section lists the majority of roles and database objects used in
--         the exercise. Some items were not covered due to time, but can be
--         researched on the Snowflake documentation pages.
--         Database Roles and Objects
