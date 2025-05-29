
-- 3.0.0   Snowflake Data Objects and Models
--         This lab will take approximately 30 minutes to complete.
--         This lab covers the use of Snowflake data objects. This can be an
--         exhaustive list and we will cover the important highlights you should
--         know as a Snowflake database administrator.
--         - Learn how to use Snowflake extension commands.
--         - Create and use key Snowflake database objects.
--         - Use the SHOW command to list different object types and their
--         parameters.
--         - Identify and implement different types of tables within a database.
--         - Distinguish between views and view types as well as snowflake data
--         types.
--         - Learn about Snowflake operators

-- 3.1.0   Using Compute SHOW Commands to Explore Snowflake Parameters
--         The SHOW command is one of the most frequently used commands to
--         determine the various features and parameters of the the Compute
--         portion of Snowflake.

-- 3.1.1   Navigate to Worksheets and create a new worksheet.

-- 3.1.2   Label the new worksheet Lab Snowflake Objects.

-- 3.1.3   Set the following as warehouse context within this worksheet:

USE ROLE TRAINING_ROLE;
USE WAREHOUSE BADGER_QUERY_WH;
USE DATABASE TRAINING_DB;
USE SCHEMA TRAININGLAB;


-- 3.1.4   Use the SHOW command to display all parameters available at the
--         Account Level:

SHOW PARAMETERS IN ACCOUNT;

--         This command displays many parameters configured by Snowflake with
--         out-of-the-box default values. Many of these parameters can be
--         overridden and customized at session or object level, depending on
--         the use cases.

-- 3.1.5   Use the SHOW command again to display parameters set in the current
--         session:

SHOW PARAMETERS IN SESSION;

--         The previous command displays parameters available at the session
--         level. Over the course of this training, we will customize some of
--         the parameters such as USE_CACHED_RESULT (in the Caching lab), and
--         QUERY_TAG (in the Performance Troubleshooting lab).

-- 3.1.6   SHOW all the parameters available in a particular database, namely
--         the SNOWFLAKE_SAMPLE_DATA database:

SHOW PARAMETERS IN DATABASE SNOWFLAKE_SAMPLE_DATA;

--         The previous command displays one of the crucial parameters,
--         DATA_RETENTION_TIME_IN_DAYS, and is also available for schemas and
--         tables. This parameter plays an important role in Time Travel;
--         allowing data analysts to perform the following actions within a
--         defined period of time:

-- 3.2.0   Show Databases, Schemas, and Tables

-- 3.2.1   Display all databases in your accessible account(s) by running the
--         following statements:

SHOW DATABASES;

--         The previous command lists the databases to which you have access
--         privileges across your entire account. In our training account, this
--         will include databases created by other users on the account. In
--         general, this command will also display any dropped databases that
--         are still within the Time Travel retention period.

-- 3.2.2   Show all of the SCHEMAS in the SNOWFLAKE_SAMPLE_DATA database:

SHOW SCHEMAS IN DATABASE SNOWFLAKE_SAMPLE_DATA;

--         This command lists schemas for the SNOWFLAKE_SAMPLE_DATA database.
--         The output returns schema metadata and properties, ordered
--         lexicographically by schema name. This is important to note if you
--         wish to filter the results using the provided filters.

-- 3.2.3   Show all tables in the TPCH_SF1 schema of the SNOWFLAKE_SAMPLE_DATA
--         database:

SHOW TABLES IN SCHEMA SNOWFLAKE_SAMPLE_DATA.TPCH_SF1;


-- 3.2.4   Show the details on the TRAINING_DB.TRAININGLAB.LINEITEM table:

SHOW PARAMETERS IN TABLE TRAINING_DB.TRAININGLAB.LINEITEM;
SHOW COLUMNS IN TABLE TRAINING_DB.TRAININGLAB.LINEITEM;
DESC TABLE TRAINING_DB.TRAININGLAB.LINEITEM;

--         These commands display key attributes for each important object. For
--         instance, in the case of the table, the property,
--         DATA_RETENTION_TIME_IN_DAYS, is important for performing Time Travel
--         queries and undropping tables due to mistakes.

-- 3.2.5   Display and provide details on views:

USE SCHEMA INFORMATION_SCHEMA;
SHOW views;
SHOW terse views;
SHOW views LIKE 'tables';


-- 3.3.0   Show Objects and Warehouse Information

-- 3.3.1   Display information about additional objects including the following
--         subsets:

SHOW objects;
SHOW functions;
SHOW user functions;
SHOW pipes;
SHOW stages;
SHOW transactions;
SHOW variables;
SHOW shares;


-- 3.3.2   Show warehouses and other SHOW commands to display warehouse
--         information:

SHOW WAREHOUSES;
SHOW PARAMETERS IN WAREHOUSE BADGER_QUERY_WH;
SHOW WAREHOUSES LIKE '%QUERY_WH';


-- 3.3.3   Using the RESULT_SCAN function with SHOW command output.
--         The RESULT_SCAN function returns the result set of a previous command
--         (provided the result is still in the cache, which typically is within
--         24 hours of when you executed the query) as if the result were a
--         table. This is useful if you need to process command output, such as
--         the SHOW command and other metadata query statements; e.g., DESCRIBE
--         commands and Information Schema queries.

-- 3.3.4   Run a show table command and process the output for details regarding
--         any tables created within the last week:

USE SCHEMA TRAININGLAB;

SHOW TABLES;

SELECT "database_name", "schema_name", "name" AS table_name, "rows", "created_on"
FROM TABLE(result_scan(last_query_id()))
WHERE "created_on" < dateadd(day, -1, current_timestamp())
ORDER BY "created_on";


-- 3.4.0   Set Session Result Parameter
--         There are many parameters you can set at the session level and object
--         level. In this step you will adjust the ROWS_PER_RESULTSET at the
--         session level. This is a parameter that functions at both the account
--         and session levels.

-- 3.4.1   Run a simple query that returns 20 rows from the lineitem table:

USE ROLE TRAINING_ROLE;
SELECT * FROM TRAINING_DB.TRAININGLAB.LINEITEM LIMIT 20;


-- 3.4.2   Set the session variable ROWS_PER_RESULTSET to 10:

ALTER SESSION SET ROWS_PER_RESULTSET=10;


-- 3.4.3   Rerun the query:

SELECT * FROM TRAINING_DB.TRAININGLAB.LINEITEM LIMIT 20;

--         Note that only ten (10) rows were returned. The limit clause is
--         different from limiting the ROWS_PER_RESULT parameter. The limit
--         clause affects the execution of the query. The ROWS_PER_RESULT
--         parameter executes the full query only limiting the rows returned to
--         the client.

-- 3.4.4   Reset the ROWS_PER_RESULTSET parameter. Be certain to run the next
--         step, or the following labs may not work correctly:

ALTER SESSION SET ROWS_PER_RESULTSET=0;


-- 3.4.5   Run the query again:

SELECT * FROM TRAINING_DB.TRAININGLAB.LINEITEM LIMIT 20;

--         The ROWS_PER_RESULTSET parameter is useful in performance testing. It
--         limits the amount of data returned over a network and reduces the
--         likelihood that your performance test is just measuring network time.

-- 3.5.0   Create a Database and Three (3) Types of Tables
--         This lab will cover the three (3) distinct types of tables within
--         Snowflake;

-- 3.5.1   Create a database for future lab exercises named BADGER_DB:

CREATE DATABASE IF NOT EXISTS BADGER_DB;


-- 3.5.2   Create a Permanent Table.
--         Use the PUBLIC schema in your database for most of your labs.

-- 3.5.3   Create a table inside the PUBLIC schema with the following column
--         definitions with a data retention period of 10 days:

USE SCHEMA BADGER_DB.Public;
CREATE OR REPLACE TABLE BADGER_TBL (
     ID NUMBER(38,0)
   , NAME STRING(10)
   , COUNTRY VARCHAR (20)
   , ORDER_DATE DATE
   ) 
   DATA_RETENTION_TIME_IN_DAYS = 10
   COMMENT = 'CUSTOMER INFORMATION';


-- 3.5.4   Create transient and temporary tables.
--         The key idea for transient and temporary tables is that they cannot
--         have their retention period last longer than one (1) day. This
--         ensures storage (and cost) savings and is intended for use cases
--         where clients can benefit from the storage savings.

-- 3.5.5   Run the following statements to set the context:

USE SCHEMA BADGER_DB.PUBLIC;
USE ROLE TRAINING_ROLE;


-- 3.5.6   Create a temporary table and insert some rows.
--         We are setting the retention period property to 0, from the standard
--         default of 1.

CREATE OR REPLACE TEMPORARY TABLE TEMP_TBL(
    C1 INTEGER, C2 INTEGER
    )  DATA_RETENTION_TIME_IN_DAYS = 0;
INSERT INTO TEMP_TBL VALUES (1,1),(2,2);
SELECT * FROM TEMP_TBL;


-- 3.5.7   Create a transient table and insert some rows:

CREATE OR REPLACE TRANSIENT TABLE TRAN_TBL(
    C1 INTEGER, C2 INTEGER
    ) DATA_RETENTION_TIME_IN_DAYS = 2;

--         The previous CREATE TABLE command will generate an error. The key
--         idea for transient and temporary tables is that they cannot have a
--         retention period longer than one (1) day; again, this is to provide
--         storage (and cost) savings.

-- 3.5.8   Repeat the CREATE TRANSIENT TABLE statement with the default data
--         retention settings:

CREATE OR REPLACE TRANSIENT TABLE TRAN_TBL(
    C1 INTEGER, C2 INTEGER
    );
INSERT INTO TRAN_TBL VALUES (1,1),(2,2);
SELECT * FROM TRAN_TBL;


-- 3.5.9   Open a second worksheet and label it SECOND_WORKSHEET:
--         This exercise demonstrates that a transient table exists in both
--         sessions. This, however, is not the case for a temporary table. Each
--         session reverts back to its default settings unless specified.
--         Remember each worksheet is its own session. You need to specify the
--         context for each worksheet individually. Run the queries for that
--         particular worksheet on which the session depends.

USE ROLE TRAINING_ROLE;
USE WAREHOUSE BADGER_QUERY_WH;
USE DATABASE BADGER_DB;

SELECT * FROM TRAN_TBL;

SELECT * FROM TEMP_TBL;

--         Which one of the two (2) queries returned a result set?
--         Can you explain why?

-- 3.6.0   Constraints and Enforcement Properties
--         Snowflake supports and maintains many types of constraints but only
--         enforces the NOT NULL constraint.

-- 3.6.1   Create a NULL constraint by first creating a parent table with a NULL
--         constraint:

CREATE table parent(
    id integer primary key
  , v1 integer not null
  , v2 integer unique
  , v3 string
);


-- 3.6.2   Insert several rows and check the results:

INSERT INTO parent values(1,1,1,'first row');
INSERT INTO parent values(2,null,1,'second row');
INSERT INTO parent values(1,2,1,'third row');
SELECT * FROM parent;


-- 3.6.3   Create a referential constraint by creating a child table with
--         referential constraints to the PARENT table:

CREATE table child(
    v1 integer primary key references parent(id)
  , v4 integer unique
  , v5 string
);


-- 3.6.4   Insert additional rows into the PARENT table:

INSERT INTO parent VALUES
   (2,5,10,'fourth row'),
   (3,2,25,'fifth row'),
   (4,6,30,'sixth row');

SELECT * FROM parent;


-- 3.6.5   Insert rows into the CHILD table, using multiple insert statements:

INSERT INTO child values(1,4,'child 1');
INSERT INTO child values(1,5,'child 2');
INSERT INTO child values(2,9,'child 3');
INSERT INTO child values(10,1,'child 4');

SELECT * FROM parent;


-- 3.6.6   Demonstrate Snowflake does not enforce referential integrity:

SELECT * FROM CHILD;
SELECT P.ID, C.V1 AS "CHILD_KEY", P.V1, P.V2, P.V3, C.V4, C.V5
  FROM PARENT P JOIN CHILD C ON P.ID=C.V1;


-- 3.7.0   Views and View Types
--         In this exercise, you will create three (3) view types and then
--         examine the differences of each.

-- 3.7.1   Use the following context:

USE SCHEMA BADGER_DB.PUBLIC;
USE ROLE TRAINING_ROLE;


-- 3.7.2   Create a Standard View.

CREATE OR REPLACE VIEW V_LAB1 AS
 SELECT C.C_NAME, N_NAME, R_NAME
  FROM TRAINING_DB.TRAININGLAB.CUSTOMER C JOIN TRAINING_DB.TRAININGLAB.NATION N
     ON C.C_NATIONKEY = N.N_NATIONKEY
  JOIN TRAINING_DB.TRAININGLAB.REGION R
     ON N.N_REGIONKEY = R.R_REGIONKEY
  WHERE R.R_NAME IN ('AMERICA', 'AFRICA');

SELECT COUNT(*) FROM V_LAB1;


-- 3.7.3   Create a Standard View with aggregates:

CREATE OR REPLACE VIEW V_LAB1_AGG AS
 SELECT R.R_NAME
    , N.N_NAME
    , SUM(O.O_TOTALPRICE) AS TOT_ORDER_DOLLARS
    , AVG(O.O_TOTALPRICE) AS AVG_ORDER_DOLLARS
    , COUNT(*) AS NUMB_ORDERS
  FROM TRAINING_DB.TRAININGLAB.ORDERS O 
     JOIN TRAINING_DB.TRAININGLAB.CUSTOMER C
       ON O.O_CUSTKEY = C.C_CUSTKEY
     JOIN TRAINING_DB.TRAININGLAB.NATION N 
       ON C.C_NATIONKEY = N.N_NATIONKEY
     JOIN TRAINING_DB.TRAININGLAB.REGION R
       ON N.N_REGIONKEY = R.R_REGIONKEY
  GROUP BY R.R_NAME, N.N_NAME
  ORDER BY R.R_NAME, N.N_NAME;


-- 3.7.4   Set a session parameter on the result set size:

ALTER SESSION SET ROWS_PER_RESULTSET=20;

SELECT * FROM V_LAB1_AGG;


-- 3.7.5   Create a Materialized View using the LINEITEM table:

CREATE OR REPLACE MATERIALIZED VIEW MV_LINEITEM_AGG
AS
  SELECT
     L_ORDERKEY
   , L_PARTKEY
   , L_SUPPKEY
   , AVG(L_QUANTITY) AS AVG_QTY
   , SUM(L_EXTENDEDPRICE) AS TOTAL_EXT_PRICE
   , SUM(L_TAX) AS TOT_TAX
   , SUM(L_DISCOUNT) AS TOT_DISC
  FROM TRAINING_DB.TRAININGLAB.LINEITEM
  GROUP BY L_ORDERKEY, L_PARTKEY, L_SUPPKEY;

SELECT * FROM MV_LINEITEM_AGG;


-- 3.7.6   Demonstrate how to use a materialized view in a query:

SELECT
   R.R_NAME AS REGION
 , N.N_NAME AS NATION
 , SUM(L.TOTAL_EXT_PRICE) AS TOT_DOLLARS
 , AVG(L.TOTAL_EXT_PRICE) AS AVG_DOLLARS
FROM MV_LINEITEM_AGG L
   JOIN TRAINING_DB.TRAININGLAB.ORDERS O
     ON L.L_ORDERKEY = O.O_ORDERKEY
   JOIN TRAINING_DB.TRAININGLAB.CUSTOMER C
     ON O.O_CUSTKEY = C.C_CUSTKEY
   JOIN TRAINING_DB.TRAININGLAB.NATION N
     ON C.C_NATIONKEY = N.N_NATIONKEY
   JOIN TRAINING_DB.TRAININGLAB.REGION R
     ON N.N_REGIONKEY = R.R_REGIONKEY
GROUP BY R.R_NAME, N.N_NAME;


-- 3.8.0   Snowflake Data Types
--         Many Snowflake data types conform to the ANSI standard. Their basic
--         definitional nature is covered in the slides to this course. This lab
--         does not cover that information; it does, however, explain how to use
--         Snowflake extensions such as the variant data types, time, and the
--         handling of binary data.

-- 3.8.1   Configure Date and Time Data Types by first configuring a new
--         worksheet and setting the context:

USE ROLE TRAINING_ROLE;
USE WAREHOUSE BADGER_QUERY_WH;
USE DATABASE TRAINING_DB;
USE SCHEMA TRAININGLAB;

--         As a Cloud-based solution, Snowflake servers may not reside in the
--         same timezone as the Snowflake client programs. Snowflake provides
--         time parameters at the account, session, and user level.

-- 3.8.2   List the time parameters for each of these:

SHOW PARAMETERS LIKE '%TIME%' IN ACCOUNT;
SHOW PARAMETERS LIKE '%TIME%' IN SESSION;
SHOW PARAMETERS LIKE '%TIME%' IN USER BADGER;

--         Notice that the TIMEZONE parameter is set to America/Los_Angeles and
--         the default time formats for the account.
--         Run a query to select the current time, and then change the session
--         time zone to America/Chicago (see Time Zone Wiki for a list of time
--         zones).

-- 3.8.3   Run the SELECT command on the current time again:

SELECT CURRENT_TIME();
ALTER SESSION SET TIMEZONE='America/Chicago';
SELECT CURRENT_TIME();


-- 3.8.4   Run the following command to obtain the current date and time:

SELECT CURRENT_DATE();
SELECT CURRENT_TIMESTAMP();


-- 3.8.5   Compare the three (3) TIMESTAMP types and the output of the following
--         query:

SELECT
  CURRENT_TIMESTAMP()::TIMESTAMP_TZ AS TZ
  , CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS NTZ
  , CURRENT_TIMESTAMP()::TIMESTAMP_LTZ AS LTZ;

--         Take note of the differences between each of the time zones listed
--         here. How do they differ from each other?

-- 3.8.6   Snowflake Variant Data Types
--         Snowflake supports several semi-structured data types. This lab walks
--         you through the basics of the variant data type using JSON data. The
--         example data used in this lab is sourced out of the
--         TRAINING_DB.WEATHER schema.

-- 3.8.7   Create a new worksheet and set the context:

USE ROLE TRAINING_ROLE;
USE DATABASE TRAINING_DB;
USE SCHEMA WEATHER;
USE WAREHOUSE BADGER_QUERY_WH;
ALTER SESSION SET ROWS_PER_RESULTSET=10;


-- 3.8.8   Once you have set the context in your new worksheet, click on the
--         TRAINING_DB database and the WEATHER schema.

-- 3.8.9   Highlight the ISD_2019_TOTAL table, bring up the ellipticals, and
--         preview the data in the table:
--         Weather Data

-- 3.8.10  In the Result pane > Data Preview you should see returned rows with
--         JSON data.
--         Weather Data Preview

-- 3.8.11  Click on one (1) of the JSON fields in the result window and observe
--         an improved presentation of the JSON data.
--         Weather Data JSON drill

-- 3.8.12  Use the GET_DDL function to retrieve the DDL statement that was used
--         to create the weather table with VARIANT data type storing the JSON
--         data:

SELECT get_ddl('table', 'training_db.weather.isd_2019_total');

--         This functions produces the following output:
--         Weather Data Output

-- 3.8.13  Run a simple query against this table using a filter while isolating
--         selected columns from the JSON weather data:

SELECT T, V:STATION.COUNTRY::STRING, V
  FROM ISD_2019_TOTAL
  WHERE T >= TO_DATE('2019-07-04')
    and V:STATION:COUNTRY::STRING like 'US';

--         Did you get the results you expected?

-- 3.8.14  Try a different version of the query with slight changes to the case:

SELECT T, V:station.country::STRING, V
  FROM ISD_2019_TOTAL
  WHERE T >= TO_DATE('2019-07-04')
    and V:station:country::STRING like 'US';

--         As is evident in the two (2) differing results, the JSON schema is
--         case sensitive.
--         Snowflake also supports an Array Data type.

-- 3.8.15  Run the following SQL command and identify the functions and
--         capabilities of the ARRAY data type:

SELECT ARRAY_CONSTRUCT('E1','E2','E3','E4','E5','E6');
SELECT ARRAY_TO_STRING(ARRAY_CONSTRUCT('E1','E2','E3','E4'),'|');
SELECT ARRAY_SLICE(ARRAY_CONSTRUCT('E1','E2','E3','E4','E5','E6'),3,5);


-- 3.8.16  Data Type Conversions
--         Snowflake provides several approaches to cast and convert between
--         data types.

-- 3.8.17  Use the CAST function or the CAST operator ( CAST (source data as
--         target data type) or ::)

SELECT CAST(12.12345 AS FLOAT), CAST(12.12345 AS INTEGER), CAST(12.12345 AS STRING);


-- 3.8.18  Use the :: operator:

SELECT 12.12345::FLOAT, 12.12345::INTEGER, 12.12345::STRING;


-- 3.8.19  In addition to the two (2) ways of using casts, Snowflake supports
--         many conversion functions such as the following:

SELECT TO_NUMBER('11.543', 6, 2);
SELECT DATEDIFF(DAY, CURRENT_DATE(),TO_DATE('2019-07-04'));


-- 3.9.0   Operators
--         Snowflake supports several different operators; including numeric
--         operators, query operators, Boolean operators, set operators, and
--         subquery operators. You will work with a small number of the
--         available operators.

-- 3.9.1   Here are some examples of selected Arithmetic Operators:

SELECT 3.2 + 5;
SELECT '4' + 2;
SELECT MOD(3, 2) AS MOD1, MOD(4.5, 1.2) AS MOD2;


-- 3.9.2   Ran an example of a Query Operator:

USE SCHEMA BADGER_DB.Public;
CREATE OR REPLACE TABLE T1 (V VARCHAR);
CREATE OR REPLACE TABLE T2 (I INTEGER);
INSERT INTO T1 (V) VALUES ('Adams, Douglas');
INSERT INTO T2 (I) VALUES (42);

SELECT V FROM T1
  UNION
SELECT I FROM T2;

SELECT V::VARCHAR FROM T1
  UNION
SELECT I::VARCHAR FROM T2;

