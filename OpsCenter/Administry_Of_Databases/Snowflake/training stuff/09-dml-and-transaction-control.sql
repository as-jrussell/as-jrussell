
-- 9.0.0   DML and Transaction Control
--         This lab will take approximately 20-30 minutes to complete.
--         This lab will explore the Data Manipulation Language (DML) and
--         various commands for transaction controls. Pay close attention to the
--         separate worksheets and how they process data. Review the list of
--         items we will be covering and what the learning objectives are.
--         - Understand the transaction model and concurrency control.
--         - Explore autocommit default values.
--         - Change session values for the autocommit parameter.
--         - Explore multi-statement transactions.
--         - Monitor the SHOW LOCKS and LOCK_TIMEOUT parameters for concurrency
--         control.
--         - Use SYSTEM$ABORT_TRANSACTION to release locks and terminate
--         transactions.

-- 9.1.0   Transaction Model and Concurrency Control
--         This lab will use two (2) worksheets, Lab SHEET-A and Lab SHEET-B, to
--         run various DML statements in order to emulate two (2) different
--         transaction scopes working in a concurrent environment.

-- 9.1.1   Navigate to the first worksheet and load the script.

-- 9.1.2   Rename one worksheet to SHEET-B.

-- 9.1.3   You will only execute statements in this tab that are surrounded by
--         the SHEET-B comments:

-- SHEET-B --


-- 9.1.4   Navigate to the other worksheet and load the script.

-- 9.1.5   Rename the worksheet to SHEET-A.

-- 9.1.6   You will only execute statements in this tab that are surrounded by
--         the SHEET-A comments

-- SHEET-A --


-- 9.2.0   Explore the Autocommit Default Value

-- 9.2.1   Set the context for SHEET-A:

-- SHEET-A --
USE ROLE TRAINING_ROLE;
USE DATABASE BADGER_DB;
USE SCHEMA PUBLIC;
USE WAREHOUSE BADGER_LOAD_WH;
-- SHEET-A --


-- 9.2.2   Create a table and insert some records:

-- SHEET-A --
CREATE OR REPLACE TABLE t1 (
  c1    BIGINT,
  c2    STRING
);

INSERT INTO t1 (c1, c2)
    VALUES(1,'ONE'), (2, 'TWO'), (3,'THREE');
-- SHEET-A --


-- 9.2.3   Show the session is set to AUTOCOMMIT by default:

-- SHEET-A --
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN SESSION;
-- SHEET-A --


-- 9.2.4   Run query and confirm the data is available because the INSERT
--         statement has been autocomitted:

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --


-- 9.2.5   Rollback the above INSERT statement:

-- SHEET-A --
ROLLBACK;
-- SHEET-A --


-- 9.2.6   Re-run query to query from the table:

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --

--         You should see all three (3) records since AUTOCOMMIT is true. There
--         is nothing to roll back.

-- 9.3.0   Change the Session Value for the Autocommit Parameter

-- 9.3.1   Set parameter of AUTOCOMMIT to off:

-- SHEET-A --
ALTER SESSION SET AUTOCOMMIT = FALSE;
-- SHEET-A --


-- 9.3.2   Confirm that AUTOCOMMIT is set to FALSE:

-- SHEET-A --
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN SESSION;
-- SHEET-A --


-- 9.3.3   Insert some new records:

-- SHEET-A --
INSERT INTO T1 (C1, C2)
    VALUES(4,'FOUR'), (5, 'FIVE');
-- SHEET-A --


-- 9.3.4   Run a query to check for the new records. The two (2) new records are
--         uncommitted data but are visible to the current transaction.

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --

--         You should see five (5) rows. Confirm this is the case.

-- 9.3.5   SWITCH TO OTHER WORKSHEET WINDOW ——> SHEET-B

-- 9.3.6   Set the context:

-- SHEET-B --
USE ROLE TRAINING_ROLE;
USE DATABASE BADGER_DB;
USE SCHEMA PUBLIC;
USE WAREHOUSE BADGER_LOAD_WH;
-- SHEET-B --


-- 9.3.7   Run the following query in this Worksheet SHEET-B and show it cannot
--         see uncommitted data produced in Worksheet SHEET-A.

-- SHEET-B --
-- With READ COMMITTED isolation support for table, a statement sees
-- only data that was committed before the statement began.
SELECT * FROM T1;
-- SHEET-B --

--         You should see only three (3) rows since the transaction for the
--         insert (of 2 rows) in the other worksheet, Lab SHEET-A, is still not
--         ye complete and those two (2) other rows are not visible to the new
--         transaction in this worksheet Lab SHEET-B.

-- 9.3.8   SWITCH BCK TO OTHER WORKSHEET WINDOW ——> SHEET-A

-- 9.3.9   Rollback the INSERT statement in the transaction originated in Lab
--         SHEET-A:

-- SHEET-A --
ROLLBACK;
-- SHEET-A --


-- 9.3.10  Run the query to select from the table. You should see only three (3)
--         rows as the two (2) new records have been rolled backed successfully:

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --


-- 9.3.11  Insert the two (2) rows again in Lab SHEET-A worksheet:

-- SHEET-A --
INSERT INTO T1 (C1, C2)
    VALUES(4,'FOUR'), (5, 'FIVE');
-- SHEET-A --


-- 9.3.12  Execute a COMMIT statement, and commit the two (2) extra rows:

-- SHEET-A --
COMMIT;
-- SHEET-A --


-- 9.3.13  Query the table again:

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --

--         You should be able to see five (5) rows; the two (2) new records are
--         made permanent to the table after the commit.

-- 9.4.0   Explore Multi-Statement Transactions

-- 9.4.1   Start a new multi-statement transaction in worksheet Lab SHEET-A:

-- SHEET-A --
BEGIN TRANSACTION;
-- SHEET-A --


-- 9.4.2   Execute two (2) insert statements in this transaction:

-- SHEET-A --
INSERT INTO t1 (c1, c2)  VALUES(6,'SIX');
INSERT INTO t1 (c1, c2)  VALUES(7,'SEVEN'), (8,'EIGHT');
-- SHEET-A --


-- 9.4.3   End the new multi-statement transaction by running the COMMIT
--         statement:

-- SHEET-A --
COMMIT;
-- SHEET-A --

--         The COMMIT statement ends the multi-statement transaction and commits
--         the two (2) extra rows.

-- 9.4.4   Query the table to see that new rows added by the two (2) INSERT
--         statements above:

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --

--         You should see eight (8) rows in the result.

-- 9.4.5   Insert a new row to the table:

-- SHEET-A --
INSERT INTO T1 (C1, C2)  VALUES(9,'NINE');
-- SHEET-A --


-- 9.4.6   Execute a ROLLBACK statement:

-- SHEET-A --
ROLLBACK;
-- SHEET-A --

--         This Rollback statement should rollback the INSERT statement which
--         was started in its own new transaction.

-- 9.4.7   Confirm that AUTOCOMMIT in current session is still set to FALSE:

-- SHEET-A --
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN SESSION;
-- SHEET-A --

--         Confirm Autocommit is off

-- 9.4.8   Query the table. You should see only eight (8) rows because the newly
--         started transaction was rolled back successfully.

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --


-- 9.5.0   Monitor Using SHOW LOCKS and LOCK_TIMEOUT Parameters for Concurrency
--         Control
--         Explore the transaction-related parameter, LOCK_TIMEOUT, which
--         controls the number of seconds to wait while trying to lock a
--         resource, before timing out and aborting the waiting statement:

-- SHEET-A --
SHOW PARAMETERS LIKE '%lock%';
-- SHEET-A --

--         By default, this parameter is set to 43200 seconds (i.e. 12 hours).
--         Show lock parameters

-- 9.5.1   Run a SELECT statement on table t1:

-- SHEET-A --
SELECT * FROM t1;
-- SHEET-A --


-- 9.5.2   Use the SHOW LOCKS command to show that SELECT does not place any
--         lock on underlying table:

-- SHEET-A --
SHOW LOCKS;
-- SHEET-A --

--         The SHOW command in this step should return no records as the query
--         does not place a lock on the underlying table.

-- 9.5.3   Confirm that AUTOCOMMIT in current session is still set to FALSE:

-- SHEET-A --
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN SESSION;
-- SHEET-A --

--         Confirm Autocommit is off

-- 9.5.4   Run UPDATE on table t1:

-- SHEET-A --
UPDATE t1
  SET c2='Second UPDATE'
  WHERE c1=8;
-- SHEET-A --


-- 9.5.5   Check that the UPDATE statement succeeds and verify the record has
--         indeed been updated.
--         Check Update

-- SHEET-A --
SELECT c2
FROM t1
WHERE c1 = 8;
-- SHEET-A --


-- 9.5.6   Run the SHOW LOCKS command to confirm that the UPDATE statement has
--         placed a partition lock on the target table t1 within the current
--         transaction, which is still active.

-- SHEET-A --
SHOW LOCKS;
-- SHEET-A --

--         The current transaction in worksheet Lab SHEET-A has a HOLDING status
--         with a lock on the target table, t1.
--         The SHOW command in this step should return one (1) record. See the
--         following example:
--         Show lock example

-- 9.5.7   SWITCH TO OTHER WORKSHEET WINDOW ——> SHEET-B

-- 9.5.8   Run the SHOW LOCK command here and you should see the same locking
--         output as in the previous step:

-- SHEET-B --
SHOW LOCKS;
-- SHEET-B --


-- 9.5.9   While remaining in worksheet Lab SHEET-B, run the following DELETE
--         statement to the same target table t1:

-- SHEET-B --
DELETE FROM t1
WHERE c1=7;
-- SHEET-B --

--         Your DELETE statement in worksheet Lab SHEET-B will be blocked from
--         completing because of the lock placed on the target table t1 by the
--         UPDATE statement in worksheet Lab SHEET-A.

-- 9.5.10  SWITCH TO OTHER WORKSHEET WINDOW ——> SHEET-A

-- 9.5.11  Run the SHOW LOCKS command:

-- SHEET-A --
SHOW LOCKS;
-- SHEET-A --

--         The SHOW command in this step should return two (2) records.
--         You should also still see your update statement in worksheet Lab
--         SHEET-A with a HOLDING status.
--         You should see your blocked (delete) statement from worksheet Lab
--         SHEET-B with a WAITING status.
--         Show locking example

-- 9.5.12  Execute the ROLLBACK statement to end the transaction and release the
--         lock:

-- SHEET-A --
ROLLBACK;
-- SHEET-A --


-- 9.5.13  Run the SHOW LOCKS command to show that the lock is released:

-- SHEET-A --
SHOW LOCKS;
-- SHEET-A --

--         The SHOW command in this step should return no record as the lock has
--         been released with the ROLLBACK statement.

-- 9.5.14  SWITCH TO OTHER WORKSHEET WINDOW ——> SHEET-B

-- 9.5.15  Check that the DELETE statement is completed now, as shown below,
--         because the lock on the target table t1 has been released by the
--         other transaction:

-- SHEET-B --
SHOW LOCKS;
-- SHEET-B --

--         Delete Successful

-- 9.6.0   Use SYSTEM$ABORT_TRANSACTION to Release Locks and Terminate
--         Transactions

-- 9.6.1   SWITCH TO OTHER WORKSHEET WINDOW ——> SHEET-A

-- 9.6.2   Execute DELETE statement on table t1:

-- SHEET-A --
DELETE FROM t1
WHERE c1=6;
-- SHEET-A --


-- 9.6.3   SWITCH TO OTHER WORKSHEET WINDOW ——> SHEET-B

-- 9.6.4   Execute the SHOW LOCKS statement:

-- SHEET-B --
SHOW LOCKS;
-- SHEET-B --

--         Show locks
--         The SHOW LOCKS output shows the target table t1 in HOLDING status.

-- 9.6.5   Review the transaction id associated with the DELETE statement.
--         An account administrator can use the system function
--         SYSTEM$ABORT_TRANSACTION to release any lock on any user’s
--         transactions by executing the function using the transaction ID from
--         the SHOW LOCKS output.

-- SHEET-B --
SELECT SYSTEM$ABORT_TRANSACTION(<transaction_id>);
-- SHEET-B --

--         Show aborted transaction
