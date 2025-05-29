DECLARE @DryRun BIT = 0;  -- Set this to 1 for dry run (to print queries), 0 to execute them
DECLARE @LoginName NVARCHAR(100);
DECLARE @SQL NVARCHAR(MAX);

-- Check if the temporary table for login access already exists and drop it if necessary
IF OBJECT_ID('tempdb..#LoginDatabaseAccess') IS NOT NULL
    DROP TABLE #LoginDatabaseAccess;

-- Create a temporary table to store the results
CREATE TABLE #LoginDatabaseAccess (
    LoginName NVARCHAR(100),
    DatabaseName NVARCHAR(100)
);

-- Check if the temporary table for SQL logins already exists and drop it if necessary
IF OBJECT_ID('tempdb..#SQLLogins') IS NOT NULL
    DROP TABLE #SQLLogins;

-- Step 1: Get all SQL logins into a temp table
SELECT name AS LoginName
INTO #SQLLogins
FROM sys.server_principals
WHERE type IN ('S', 'E')  -- 'S' = SQL Login, 'E' = External User (for contained databases)
  AND name NOT LIKE '##%' -- Exclude system logins
  AND is_disabled = 0;

-- Step 2: Loop through each login and execute SQL in each database
WHILE EXISTS (SELECT 1 FROM #SQLLogins)
BEGIN
    -- Get the next login
    SELECT TOP 1 @LoginName = LoginName
    FROM #SQLLogins;

    -- Dynamic SQL for each login and database
    SET @SQL = '
    USE [?]; 
    INSERT INTO #LoginDatabaseAccess (LoginName, DatabaseName) 
    SELECT ''' + @LoginName + ''', DB_NAME()
    FROM sys.database_principals 
    WHERE name = ''' + @LoginName + ''';';

    -- Execute the dynamic SQL
    IF @DryRun = 0
        BEGIN
            EXEC sp_MSforeachdb @SQL;
        END
    ELSE
        BEGIN
            PRINT @SQL;  -- Dry run, print the SQL query
        END

    -- Remove the processed login
    DELETE FROM #SQLLogins WHERE LoginName = @LoginName;
END

-- Step 3: Show the results of SQL logins with corresponding database accounts
SELECT LoginName, DatabaseName, 'Login has corresponding DB user account' [Account Info]
FROM #LoginDatabaseAccess
--where DatabaseName is null 
UNION
SELECT sp.name AS LoginName, NULL,  'Login does not DB user account'
FROM sys.server_principals sp
WHERE sp.type IN ('S', 'E')
  AND sp.name NOT LIKE '##%'
  AND sp.is_disabled = 0
  AND sp.name NOT IN (SELECT DISTINCT LoginName FROM #LoginDatabaseAccess)
ORDER BY LoginName;

