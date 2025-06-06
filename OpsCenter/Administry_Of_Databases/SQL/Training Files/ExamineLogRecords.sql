USE [master];
GO

IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END
GO

CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company_data',
    FILENAME = N'C:\SQL2019\SQLData\Company_data.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'C:\SQL2019\SQLLog\Company_log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB);
GO

USE [Company];
GO
SET NOCOUNT ON;
GO

-- Make sure the database is in SIMPLE recovery model with no auto-stats
-- (to avoid unwanted log records)
ALTER DATABASE [Company] SET RECOVERY SIMPLE;
ALTER DATABASE [Company] SET AUTO_CREATE_STATISTICS OFF;
GO

-- Create a simple table to play with
CREATE TABLE [test] ([c1] INT, [c2] INT, [c3] INT);
GO

-- Insert a record to get the allocations done
INSERT INTO [test] VALUES (1, 1, 1);
GO

-- Clear out the log (more on this later...)
CHECKPOINT;
GO

-- Look in the log
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Implicit transaction to insert a new record
INSERT INTO [test] VALUES (2, 2, 2);
GO

-- Look at various fields, including locks being logged
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Explicit transaction to insert a new record
BEGIN TRAN;
GO
INSERT INTO [test] VALUES (3, 3, 3);
GO

SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Now roll it back
ROLLBACK TRAN;
GO

-- Look for COMPENSATION context
-- Look for LSN linkages
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- clear things out again
CHECKPOINT;
GO

-- Update a column
UPDATE [test] SET c1 = 4 WHERE c1 = 1;
GO

-- Look for before and after
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Now multiple columns
BEGIN TRAN;
GO
UPDATE [test] SET c1 = 8, c3 = 9;
GO

-- LOP_MODIFY_ROW becomes LOP_MODIFY_COLUMNS if multiple parts of record
-- updated, or multiple columns in fixed length > 16 bytes apart.

-- LOP_MODIFY_ROW: before, after, index keys, logged locks
-- LOP_MOFIFY_COLUMNS: before/after offsets array, lengths array
-- index keys, logged locks, before/after pairs
-- On 2012, before are in the 5th column and after are in the 6th column

-- Look for before and after
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- And roll it back
ROLLBACK TRAN;
GO

-- And look for just the after here
SELECT * FROM fn_dblog (NULL, NULL);
GO

-- Extra things if any interest...

-- create nonclustered index test_nc1 on test (c1)
-- and do an update of c2 and then c1

-- drop index test_nc1 on test
-- create nonclustered index test_nc1 on test (c1) include (c2)
-- and do an update of c2





	