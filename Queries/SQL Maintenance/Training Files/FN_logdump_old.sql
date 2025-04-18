-- Create a database to use
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
    FILENAME = N'C:\Downloads\SQLDATA\Company_data.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'C:\Downloads\SQLLOGS\Company_log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB);
GO
USE [Company];
GO
SET NOCOUNT ON;
GO
-- Create tables to play with
CREATE TABLE [RandomData1] (
    [c1] INT IDENTITY,
    [c2] DATETIME DEFAULT GETDATE (),
    [c3] CHAR (25) DEFAULT 'a');
CREATE TABLE [RandomData2] (
    [c1] INT IDENTITY,
    [c2] DATETIME DEFAULT GETDATE (),
    [c3] CHAR (25) DEFAULT 'a');
GO
INSERT INTO [RandomData1] DEFAULT VALUES;
GO 1000
-- Take initial backups
BACKUP DATABASE [Company]
TO DISK = N'C:\Downloads\DBBackup\Company_Full.bak'
WITH INIT;
GO
BACKUP LOG [Company]
TO DISK = N'C:\Downloads\DBBackup\Company_Log1.bak'
WITH INIT;
GO
INSERT INTO [RandomData2] DEFAULT VALUES;
GO 1000
-- Now simulate disaster
DROP TABLE [RandomData1];
GO
-- And more stuff happens in the database
INSERT INTO [RandomData2] DEFAULT VALUES;
GO 1000
-- Imagine we can't use the default trace
-- Find the point at which the table was dropped
-- using fn_dblog
SELECT
    [Current LSN],
    [Operation],
    [Context],
    [Transaction ID],
    [Description],
    [Begin Time],
    [Transaction SID]
FROM
    fn_dblog (NULL, NULL),
    (SELECT
        [Transaction ID] AS [tid]
    FROM
        fn_dblog (NULL, NULL)
    WHERE
        [Transaction Name] LIKE '%DROPOBJ%') [fd]
WHERE
    [Transaction ID] = [fd].[tid];
GO
-- Saved LSN of the LOP_BEGIN_XACT
-- log record: 0000002c:000005a0:0001
-- Who did it? (LOP_BEGIN_XACT SID)
SELECT SUSER_SNAME (0x0105000000000005150000006276D832539ED8B240BD881018100000);
GO
-- Now back up the log
BACKUP LOG [Company]
TO DISK = N'C:\Downloads\DBBackup\Company_Log2.bak'
WITH INIT;
GO
-- Now restore a copy of the database
RESTORE DATABASE [Company_Copy]
FROM DISK = N'C:\Downloads\DBBackup\Company_Full.bak'
WITH MOVE N'Company' TO N'C:\Downloads\SQLDATA\Company_copy.mdf',
MOVE N'Company_log' TO N'C:\Downloads\SQLLOGS\Company_copy_log.ldf',
REPLACE, NORECOVERY;
GO
RESTORE LOG [Company_Copy]
FROM DISK = N'C:\Downloads\DBBackup\Company_Log1.bak'
WITH NORECOVERY;
GO
RESTORE LOG [Company_Copy]
FROM DISK = N'C:\Downloads\DBBackup\Company_Log2.bak'
WITH STOPBEFOREMARK = 'lsn:0xSAVEDLSN', NORECOVERY;
GO
RESTORE DATABASE [Company_Copy] WITH RECOVERY;
GO
-- And is the table there?
SELECT COUNT (*) FROM [Company_Copy].[dbo].[RandomData1];
GO
-- What if we wanted to look in the log after the log had cleared?
-- For striped backups, all stripe files must be specified
SELECT
    COUNT (*)
FROM
    fn_dump_dblog (
        NULL, NULL, N'DISK', 1, N'C:\Downloads\DBBackup\Company_Log2.bak',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
GO
-- And the same query as we used originally
-- This might take a while...
SELECT
    [Current LSN],
    [Operation],
    [Context],
    [Transaction ID],
    [Description],
    [Begin Time],
    [Transaction SID]
FROM
    fn_dump_dblog (
        NULL, NULL, N'DISK', 1, N'C:\Downloads\DBBackup\Company_Log2.bak',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
    (SELECT
        [Transaction ID] AS [tid]
    FROM
        fn_dump_dblog (
            NULL, NULL, N'DISK', 1, N'C:\Downloads\DBBackup\Company_Log2.bak',
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
            DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT)
    WHERE
        [Transaction Name] LIKE '%DROPOBJ%') [fd]
WHERE [Transaction ID] = [fd].[tid];
GO
-- And then continue with the LSN conversion and restore sequence
-- Cleanup
USE [master];
GO
IF DATABASEPROPERTYEX (N'Company_Copy', N'Version') > 0
BEGIN
    ALTER DATABASE [Company_Copy] SET SINGLE_USER
        WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Company_Copy];
END
GO