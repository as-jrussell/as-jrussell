
-- 15.0.0  (Optional) Stored Procedures
--         This lab will take approximately 15 minutes to complete.
--         Stored procedures are similar to functions. As with functions, a
--         stored procedure is created once and can be executed many times. A
--         stored procedure is typically created using a CREATE PROCEDURE
--         command and is executed with a CALL command.
--         A stored procedure also returns only a single value. Although you can
--         run SELECT statements inside a stored procedure, the results must be
--         used within the stored procedure or be narrowed to a single value to
--         be returned.
--         - Learn how to configure a stored procedure.
--         - Create stored procedure examples in various tables.
--         - Understand how to use secured views in stored procedures.

-- 15.1.0  Configuring Stored Procedures

-- 15.1.1  Navigate to Worksheets and create a new worksheet

-- 15.1.2  Give this worksheet the name Stored Procedures

-- 15.1.3  Set the following as context:

USE role training_role;
USE warehouse BADGER_load_wh;
USE database BADGER_db;
USE schema PUBLIC;


-- 15.2.0  Stored Procedures

-- 15.2.1  Create the source table:

CREATE or REPLACE  TABLE servicedetail (
RO VARCHAR,
    RODATE VARCHAR,
SERVICE VARCHAR,
REV VARCHAR,
COST VARCHAR
);


-- 15.2.2  INSERT data into the source table:

INSERT INTO servicedetail

VALUES ('183297',
        '2018-01-01',
        'DGR123|OIL543|FLT1241',
        '18.67|43.23|10.87',
        '11.17|22.11|4.45');

INSERT INTO servicedetail

VALUES('183298',
       '2018-01-02',
       'BFR432|BRK132',
       '11.43|41',
       '7.17|18.11');


-- 15.2.3  CREATE the target table:

CREATE or REPLACE TABLE rodetail (
RO NUMBER,
RODATE DATE,
SERVICE VARCHAR,
REVENUE FLOAT,
COST FLOAT
);


-- 15.2.4  Create the stored procedure
--         Please run the entire script from the top, starting with CREATE until
--         the $$; The Javascript starts after the first $$ delimiter and ends
--         at the enclosing $$ delimiter. Remember that Javascript is case
--         sensitive while SQL is not case sensitive.
--         This parseservedata() stored procedure demonstrates executing two SQL
--         statements. The first statement returns a result set. Next the stored
--         procedure walks the result set and dynamically creates an insert
--         statement that is executed with values from each row returned by the
--         first stored procedure.

-- 15.2.5  Run the stored procedure

CREATE OR REPLACE procedure parseservicedata()
    RETURNS varchar not null
    LANGUAGE javascript
    AS
    $$
// Get the input data and start a cursor

sql_cmd = "SELECT * from SERVICEDETAIL";

var stmt = snowflake.createStatement( {sqlText: sql_cmd} );
var rs = stmt.execute();

//Declare target variable for RO number and close date
var RO;
var RODate;

//Declare variables that will get each delimited cell of data before it is split.
var Service;
var Rev;
var Cost;

//Declare target arrays for the Service Codes and Revenue and Cost for each Service
var ServiceValues = [];
var RevValues = [];
var CostValues = [];

//Declare variables for creating the query for inserting data into our new table, RODETAIL
var appendstmt1 = "INSERT INTO RODETAIL VALUES ("
var appendstmt2;

//Iterate through the records in the input data
while (rs.next())
{
    RO = rs.getColumnValue('RO');
    RODate = rs.getColumnValue('RODATE');

 // Get an array of the different services performed.
    Service = rs.getColumnValue('SERVICE');
    ServiceValues = Service.split("|");
    Rev = rs.getColumnValue('REV');
    RevValues = Rev.split("|");

//Get an array of the revenue for the costs of the services performed.

    Cost = rs.getColumnValue('COST');
    CostValues = Cost.split("|");
//Loop through the Services array and add a record to a new table for each individual service, keeping the RO number and Date constant
    var arrayLength = ServiceValues.length;
    for (var i = 0; i < arrayLength; i++) {
appendstmt2 = RO
    + ", '"
    + RODate
    + "', '"
    + ServiceValues[i]
    + "', "
    + RevValues[i] + ","
    + CostValues[i] + ")";
snowflake.execute( {sqlText:
appendstmt1+appendstmt2} );
    }
}

return 1;

    $$
;


-- 15.2.6  Invoke the stored procedure

-- 15.2.7  Call the stored procedure which executes the two (2) queries

CALL parseservicedata();


-- 15.2.8  Query using the target table to view the results

-- 15.2.9  View the results of calling the parseservicedata() stored procedure
--         on the rodetail table you created

SELECT * from rodetail;

