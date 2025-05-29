DECLARE @SQLcmd NVARCHAR(max)
DECLARE @Role NVARCHAR(100) = 'SQL_RFPL_Development_Team'
DECLARE @DatabaseName SYSNAME
DECLARE @WhatIf BIT = 0

-- Create a temporary table to store the databases
IF Object_id(N'tempdb..#TempDatabases') IS NOT NULL
  DROP TABLE #TempDatabases
CREATE TABLE #TempDatabases
  (
     DatabaseName SYSNAME,
     IsProcessed BIT
  )
-- Insert the databases to exclude into the temporary table
INSERT INTO #TempDatabases (DatabaseName, IsProcessed)
SELECT name, 0 -- SELECT *
FROM   sys.databases
WHERE  name like 'PRL%'
ORDER  BY database_id

-- Loop through the remaining databases
WHILE EXISTS( SELECT * FROM #TempDatabases WHERE IsProcessed = 0 )
  BEGIN
    -- Fetch 1 DatabaseName where IsProcessed = 0
    SELECT Top 1 @DatabaseName = DatabaseName FROM #TempDatabases WHERE IsProcessed = 0 
    -- Prepare SQL Statement

SELECT @SQLcmd = 'USE [' + @DatabaseName + ']

SELECT DISTINCT pr.principal_id, pr.name, pr.type_desc, pe.state_desc, pe.permission_name
FROM sys.server_principals AS pr
JOIN sys.server_permissions AS pe
ON pe.grantee_principal_id = pr.principal_id
where name = ''' + @Role
                 + '''

SELECT DISTINCT DB_NAME(), pr.principal_id, pr.name, pr.type_desc, pr.authentication_type_desc, pe.state_desc, pe.permission_name
FROM sys.database_principals AS pr
JOIN sys.database_permissions AS pe
ON pe.grantee_principal_id = pr.principal_id
where name =  ''' + @Role
                 + '''


SELECT DP1.name AS DatabaseRoleName, isnull (DP2.name, ''No members'') AS DatabaseUserName
FROM sys.database_role_members AS DRM
RIGHT OUTER JOIN sys.database_principals AS DP1
ON DRM.role_principal_id = DP1.principal_id
LEFT OUTER JOIN sys.database_principals AS DP2
ON DRM.member_principal_id = DP2.principal_id
WHERE DP2.name =  ''' + @Role
                 + '''
ORDER BY DP1.name;'

IF @WhatIf = 0
  BEGIN
      EXEC (@SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @Sqlcmd )
  END 

     -- Update table
    UPDATE  #TempDatabases 
    SET IsProcessed = 1
    WHERE DatabaseName = @databaseName
  END