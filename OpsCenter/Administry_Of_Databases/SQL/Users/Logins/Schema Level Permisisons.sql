DECLARE @DatabaseName SYSNAME = '' -- Set your database name
DECLARE @SchemaName SYSNAME = '' -- Set your schema name
DECLARE @UserName SYSNAME = '' -- Set your user name
DECLARE @DryRun BIT = 1 -- Set to 1 to print SQL, 0 to execute
DECLARE @Revert BIT = 1 -- 0 to revert
DECLARE @SQL NVARCHAR(MAX);

IF @Revert <> 0
BEGIN
BEGIN TRY
    SET @SQL = 'USE [' + @DatabaseName
               + ']
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '''
               + @SchemaName
               + ''')
    BEGIN
        EXEC(''CREATE SCHEMA '
               + Quotename(@SchemaName)
               + ''' );
        PRINT ''Schema ' + @SchemaName
               + ' created.'' ;
    END
    ELSE
	BEGIN
        PRINT ''Schema ' + @SchemaName + ' already exists.'' ;
END
    ';

    IF @DryRun = 0
      BEGIN
          EXEC (@SQL);
      END
    ELSE
      BEGIN
          PRINT ( @SQL );
      END
END TRY
BEGIN CATCH
    PRINT 'Error occurred during schema creation: '
          + Error_message();
END CATCH

BEGIN TRY
    SET @SQL = 'USE [' + @DatabaseName
               + ']

	IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '''
               + @SchemaName
               + ''')
    BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::'
               + Quotename(@SchemaName) + ' TO '
               + Quotename(@UserName)
               + ';
    PRINT ''Granted read/write access on schema '
               + @SchemaName + ' to ' + @UserName
               + '.'' ;
			       END
    ELSE
	BEGIN
        PRINT ''Schema ' + @SchemaName + ' permissions already exists.'' ;
END
    ';

    -- Execute or print the SQL based on DryRun
    IF @DryRun = 0
      BEGIN
          EXEC (@SQL);
      END
    ELSE
      BEGIN
          PRINT ( @SQL );
      END
END TRY
BEGIN CATCH
    PRINT 'Error occurred during grant operation: '
          + Error_message();
END CATCH
END 
ELSE 
BEGIN

  BEGIN TRY
      SET @SQL = 'USE [' + @DatabaseName
                 + ']

     IF  EXISTS (SELECT * FROM sys.schemas WHERE name = '''
                 + @SchemaName
                 + ''')
    BEGIN
    REVOKE SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::'
                 + Quotename(@SchemaName) + ' FROM '
                 + Quotename(@UserName)
                 + ';
    PRINT ''Revoked read/write access on schema '
                 + @SchemaName + ' from ' + @UserName
                 + '.'' ;
			       END
    ELSE
	BEGIN
        PRINT ''Schema ' + @SchemaName
                 + ' permissions does not exists.'' ;
END
    IF  EXISTS (SELECT * FROM sys.schemas WHERE name = '''
                 + @SchemaName + ''')
    BEGIN
        EXEC(''DROP SCHEMA '
                 + Quotename(@SchemaName)
                 + ''' );
        PRINT ''Schema ' + @SchemaName
                 + ' dropped.'' ;
    END
    ELSE
	BEGIN
        PRINT ''Schema ' + @SchemaName + ' does not exist.'' ;
END
    ';

      IF @DryRun = 0
        BEGIN
            EXEC (@SQL);
        END
      ELSE
        BEGIN
            PRINT ( @SQL );
        END
  END TRY
  BEGIN CATCH
      PRINT 'Error occurred during schema creation: '
            + Error_message();
  END CATCH 
END