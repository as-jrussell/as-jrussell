USE TestInv

GO

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[CheckAndAdjustFillFactor]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[CheckAndAdjustFillFactor] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [Checkandadjustfillfactor] (@FillFactor NVARCHAR(100) = 80,
												@DryRun     BIT = 1-- If 0, applies changes
												 ,@Verbose    BIT = 1 -- If 1, shows all indexes under 80%, else only affected ones
												--,@Force      BIT = 1,-- If 1, updates Fill Factor to 80%
												)
AS
  BEGIN
      SET NOCOUNT ON;

      DECLARE @DbName SYSNAME,
              @SQL    NVARCHAR(MAX);

      -- Temp table to store index details
      CREATE TABLE #FillFactorCheck
        (
           DatabaseName      SYSNAME,
           SchemaName        SYSNAME,
           TableName         SYSNAME,
           IndexName         SYSNAME,
           CurrentFillFactor INT
        );

      -- Temp table to store databases
      CREATE TABLE #Databases
        (
           DatabaseName SYSNAME,
           IsProcessed  BIT
        );

      INSERT INTO #Databases
                  (DatabaseName,
                   IsProcessed)
      SELECT name,
             0
      FROM   sys.databases
      WHERE  state_desc = 'ONLINE'
             AND database_id > 4; -- Excludes system DBs
      -- Loop through databases
      -- Loop through the remaining databases
      WHILE EXISTS(SELECT *
                   FROM   #Databases
                   WHERE  IsProcessed = 0)
        BEGIN
            -- Fetch 1 DatabaseName where IsProcessed = 0
            SELECT TOP 1 @DbName = DatabaseName
            FROM   #Databases
            WHERE  IsProcessed = 0

            SELECT @SQL = '
            USE ' + Quotename(@DbName)
                          + '

            INSERT INTO #FillFactorCheck
            SELECT 
                DB_NAME() AS DatabaseName,
                SCHEMA_NAME(o.schema_id) AS SchemaName,
                OBJECT_NAME(i.object_id) AS TableName,
                   ISNULL(i.name, ''NoIndexName'') AS IndexName,
                i.fill_factor
            FROM sys.indexes i
            JOIN sys.objects o ON i.object_id = o.object_id
            WHERE o.type IN (''U'', ''V'');';



            -- You know what we do here if it's 1 then it'll give us code and 0 executes it
            IF @DryRun = 0
              BEGIN
                  EXEC ( @SQL)
              END
            ELSE
              BEGIN
                  PRINT ( @SQL )
              END

            UPDATE #Databases
            SET    IsProcessed = 1
            WHERE  DatabaseName = @DbName
        END;

      IF @DryRun = 0
        BEGIN
	IF @Verbose = 0 
	BEGIN 
	            EXEC ('SELECT * FROM #FillFactorCheck WHERE currentfillfactor = ''' + @FillFactor + '''');


	END
	ELSE
	BEGIN
            SELECT *
            FROM   #FillFactorCheck
END
        END
	
	
 


  END;
/*

    -- Apply changes if @DryRun = 0 and @Force = 0
    IF @Force = 0 AND @DryRun = 0
    BEGIN
        -- Loop through indexes
        WHILE EXISTS ( SELECT * FROM #Databases WHERE IsProcessed = 0 )
        BEGIN
            SELECT TOP 1 
                @DbName = DatabaseName,
                @SQL = 'USE ' + QUOTENAME(DatabaseName) + ';
                    ALTER INDEX ' + QUOTENAME(IndexName) + ' ON ' + QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName) + ' REBUILD WITH (FILLFACTOR = 80);'
            FROM #FillFactorCheck;
	
	
	              IF @Force = 0 AND @DryRun = 0
              BEGIN
                  PRINT ( @DbName )

                  EXEC ( @SQL)
              END
            ELSE IF @Force = 0 AND @DryRun = 1
              BEGIN
                  PRINT ( @SQL )
              END
	-- Remove processed index
               UPDATE  #Databases 
    SET IsProcessed = 1
    WHERE DatabaseName = @DbName
       ;
    END
	*/
