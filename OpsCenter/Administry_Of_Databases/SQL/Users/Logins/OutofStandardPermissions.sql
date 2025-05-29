-- Declare variables
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DatabaseName SYSNAME;
DECLARE @DryRun INT = 0; -- 1 for preview, 0 to execute
DECLARE @ExcludedRoles NVARCHAR(MAX) = '''db_datawriter'', ''db_executor'', ''db_datareader'', ''db_owner''';

-- Create a temporary table to store the databases
IF OBJECT_ID(N'tempdb..#TempDatabases') IS NOT NULL
    DROP TABLE #TempDatabases;

CREATE TABLE #TempDatabases
(
    DatabaseName SYSNAME,
    IsProcessed BIT
);

-- Insert into #TempDatabases (replace this with appropriate logic if DBA maintenance tables are unavailable)
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0
--select S.* 
      FROM   [DBA].[backup].[Schedule]  S
	  join sys.databases D on S.DatabaseName = D.name
WHERE state_desc = 'ONLINE' -- Only process online databases
AND DatabaseType = 'USER'
ORDER BY database_id;

-- Temporary table to store results
IF OBJECT_ID(N'tempdb..#RolePermissionCheckResults') IS NOT NULL
    DROP TABLE #RolePermissionCheckResults;

CREATE TABLE #RolePermissionCheckResults
(
    DatabaseName SYSNAME,
    UserName NVARCHAR(128),
    RoleName NVARCHAR(128) NULL,
    PermissionType NVARCHAR(128) NULL,
    PermissionState NVARCHAR(128) NULL
);

-- Loop through the remaining databases
WHILE EXISTS (SELECT * FROM #TempDatabases WHERE IsProcessed = 0)
BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT TOP 1 @DatabaseName = DatabaseName 
    FROM #TempDatabases 
    WHERE IsProcessed = 0;

    -- Prepare SQL Statement
    SET @SQL = '
    USE [' + @DatabaseName + '];

    -- Insert users and roles
    INSERT INTO #RolePermissionCheckResults (DatabaseName, UserName, RoleName, PermissionType, PermissionState)
    SELECT
        DB_NAME() AS DatabaseName,
        dp.name AS UserName,
        r.name AS RoleName,
        NULL AS PermissionType,
        NULL AS PermissionState
    FROM sys.database_principals dp
    INNER JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
    INNER JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
    WHERE dp.type_desc = ''SQL_USER''
      AND r.name NOT IN (' + @ExcludedRoles + ')
      AND r.name NOT LIKE ''%_APP_ACCESS%'';

    -- Insert explicit permissions
    INSERT INTO #RolePermissionCheckResults (DatabaseName, UserName, RoleName, PermissionType, PermissionState)
    SELECT
        DB_NAME() AS DatabaseName,
        dp.name AS UserName,
        NULL AS RoleName,
        perm.permission_name AS PermissionType,
        perm.state_desc AS PermissionState
    FROM sys.database_permissions perm
    INNER JOIN sys.database_principals dp ON perm.grantee_principal_id = dp.principal_id
    WHERE dp.type_desc = ''SQL_USER''
      AND perm.permission_name IN (''CONTROL'', ''ALTER'', ''VIEW DEFINITION'', ''TAKE OWNERSHIP'', ''IMPERSONATE'')
      AND dp.name NOT LIKE ''##%''; -- Exclude system-defined accounts (e.g., ##MS_ accounts)
    ';

    -- Execute or preview
    IF @DryRun = 0
    BEGIN
        PRINT ('Processing: ' + @DatabaseName);
        EXEC (@SQL);
    END
    ELSE
    BEGIN
        PRINT (@SQL);
    END;

    -- Update the database as processed
    UPDATE #TempDatabases
    SET IsProcessed = 1
    WHERE DatabaseName = @DatabaseName;
END;

-- Display results
SELECT 
    DatabaseName,
    UserName,
 ISNULL(RoleName, 'Not Role') [Role] ,
 ISNULL(PermissionType, 'Not Permission Level') [PermissionType] ,
 ISNULL(PermissionState, 'Not Permission Level') [PermissionState]
FROM #RolePermissionCheckResults
ORDER BY RoleName DESC;
