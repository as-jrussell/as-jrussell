--Set this up once per account----------------------------------------------------------
USE ROLE ACCOUNTADMIN;

CREATE ROLE READ_ALL COMMENT = 'Read role on all databases';
CREATE ROLE READ_ALL_DEV COMMENT = 'Read role on all development databases';
CREATE ROLE READ_ALL_TEST COMMENT = 'Read role on all test databases';
CREATE ROLE READ_ALL_PROD COMMENT = 'Read role on all production databases';

CREATE ROLE MONITOR_ALL COMMENT = 'Monitor role at account level';
GRANT MONITOR EXECUTION, MONITOR USAGE ON ACCOUNT TO ROLE MONITOR_ALL;
GRANT ROLE READ_ALL TO ROLE MONITOR_ALL;
GRANT ROLE MONITOR_ALL TO ROLE SYSADMIN;