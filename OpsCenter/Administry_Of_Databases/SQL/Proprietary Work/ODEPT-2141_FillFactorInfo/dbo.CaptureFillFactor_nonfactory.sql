USE [PerfStats]

GO

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[CaptureFillFactor]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[CaptureFillFactor] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[CaptureFillFactor] (@FillFactor   NVARCHAR(100) = 0,
                                       @DatabaseName VARCHAR(100)='',
                                       @TableName    VARCHAR(255) ='',
                                       @IndexName    VARCHAR(255) ='',
                                       @SchemaName   VARCHAR(255) ='',
                                       @Verbose      BIT = 1,-- If 0, applies changes
                                       @WhatIf       BIT = 1-- If 0, applies changes
)
AS
  BEGIN
      /*
      ######################################################################
        Examples
      ######################################################################
      
      EXEC PerfStats.DBO.[CaptureFillFactor] @WhatIf  =1, @Verbose = 0 ---SHOWS CODE 
      EXEC PerfStats.DBO.[CaptureFillFactor] @WhatIf  =1, @Verbose = 1 ---RUN DATA
      EXEC PerfStats.DBO.[CaptureFillFactor] @WhatIf  =0---MERGE
      EXEC PerfStats.DBO.[CaptureFillFactor] @WhatIf  =0, @Verbose = 0 ---SHOWS ONLY THE MERGE CODE
      EXEC PerfStats.DBO.[CaptureFillFactor] @FillFactor=80 --Fill Factor Variable only works by itself 
      EXEC PerfStats.DBO.[CaptureFillFactor] @DatabaseName='DBA', @TableName = 'auditScanBatchData' ,@IndexName ='PK__auditSca__6031F9F82F426E0D',@SchemaName='dbo'
	  EXEC PerfStats.DBO.[CaptureFillFactor] @DatabaseName='DBA', @TableName = 'auditScanBatchData' ,@IndexName ='PK__auditSca__6031F9F82F426E0D',@SchemaName='dbo', @Verbose = 0 
      
      */
      SET NOCOUNT ON;

      /*
      ######################################################################
      Make Declares
      ######################################################################
      */
      DECLARE @DbName   SYSNAME,
              @SQL      NVARCHAR(MAX),
              @SQLMerge NVARCHAR(4000)

  /*
  ######################################################################
  Create and Populate Temp Table
  ######################################################################
  */
      -- Temp table to store index details
      CREATE TABLE #FillFactorCheck
        (
           DatabaseName      SYSNAME,
           SchemaName        SYSNAME,
           TableName         SYSNAME,
           IndexName         SYSNAME,
           CurrentFillFactor INT,
           CurrentTime       DATETIME DEFAULT Getdate()
        );

      -- Temp table to store databases
      CREATE TABLE #Databases
        (
           DatabaseName SYSNAME,
           IsProcessed  BIT
        );

      /*
      ######################################################################
      Data Gathering
      ######################################################################
      */
      INSERT INTO #Databases
                  (DatabaseName,
                   IsProcessed)
      SELECT name,
             0
      FROM   sys.databases
      WHERE  state_desc = 'ONLINE'
             AND database_id > 4; -- Change to use DBA.[info].[Database]
      --Loop
      WHILE EXISTS(SELECT *
                   FROM   #Databases
                   WHERE  IsProcessed = 0)
        BEGIN
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
                   ISNULL(i.name, ''NoIndex'') AS IndexName,
				   i.fill_factor, GETDATE()
            FROM sys.indexes i
            JOIN sys.objects o ON i.object_id = o.object_id
            WHERE o.type IN (''U'', ''V'');';

            /*
            ######################################################################
            Processing
            ######################################################################
            */
            IF @Verbose <> 0
              BEGIN
                  EXEC ( @SQL)
              END
            ELSE
              BEGIN
                  IF @WhatIf <> 0
                    BEGIN
                        PRINT ( @SQL )
                    END
              END

            UPDATE #Databases
            SET    IsProcessed = 1
            WHERE  DatabaseName = @DbName
        END;

      /*
      ######################################################################
      Merge
      ######################################################################
      */
				  SET @SQLMerge ='
			 MERGE [PerfStats].[FillFactor] AS Target
			USING #FillFactorCheck AS Source
			ON Target.DatabaseName = Source.DatabaseName
			   AND Target.SchemaName = Source.SchemaName
			   AND Target.TableName = Source.TableName
			   AND Target.IndexName = Source.IndexName
			WHEN MATCHED THEN UPDATE SET
				Target.CurrentFillFactor = Source.CurrentFillFactor,
				Target.CurrentTime = Source.CurrentTime  -- Update CurrentTime if needed
			WHEN NOT MATCHED THEN INSERT (
				DatabaseName,
				SchemaName,
				TableName,
				IndexName,
				CurrentFillFactor,
				CurrentTime
			)
			VALUES (
				Source.DatabaseName,
				Source.SchemaName,
				Source.TableName,
				Source.IndexName,
				Source.CurrentFillFactor,
				Source.CurrentTime
			);


			'

      IF @WhatIf = 0
        BEGIN
            IF @Verbose <> 0
              BEGIN
                  EXEC (@SQLMerge)
				  PRINT 'Data Inserted or Updated'
              END
            ELSE
              /*
              ######################################################################
              Merge P
              ######################################################################
              */
              BEGIN
                  PRINT ( @SQLMerge )
              END
        END
      /*
      ######################################################################
      Display information
      ######################################################################
      */
      ELSE
        BEGIN
		IF @Verbose <> 0
		BEGIN
          IF @DatabaseName <> ''
              BEGIN
                  SELECT *
                  FROM   #FillFactorCheck
                  WHERE  DatabaseName = @DatabaseName
                         AND [TableName] LIKE '%' + @TableName + '%'
                         AND [IndexName] LIKE '%' + @IndexName + '%'
                         AND [SchemaName] LIKE '%' + @SchemaName + '%'
              END 
            ELSE IF @SchemaName <> ''
              BEGIN
                  SELECT *
                  FROM   #FillFactorCheck
                  WHERE  [SchemaName] = @SchemaName
                         AND [TableName] LIKE '%' + @TableName + '%'
                         AND [IndexName] LIKE '%' + @IndexName + '%'
                         AND DatabaseName LIKE '%' + @DatabaseName + '%'
              END 
            ELSE IF @TableName <> ''
              BEGIN
                  SELECT *
                  FROM   #FillFactorCheck
                  WHERE  [TableName] = @TableName
                         AND DatabaseName LIKE '%' + @DatabaseName + '%'
                         AND [IndexName] LIKE '%' + @IndexName + '%'
                         AND [SchemaName] LIKE '%' + @SchemaName + '%'
              END
            ELSE IF @IndexName <> ''
              BEGIN
                  SELECT *
                  FROM   #FillFactorCheck
                  WHERE  [IndexName] = @IndexName
                         AND DatabaseName LIKE '%' + @DatabaseName + '%'
                         AND [TableName] LIKE '%' + @TableName + '%'
                         AND [SchemaName] LIKE '%' + @SchemaName + '%'
              END
            ELSE IF @FillFactor <> ''
              BEGIN
                  SELECT *
                  FROM   #FillFactorCheck
                  WHERE  [CurrentFillFactor] >= @FillFactor
              END
            ELSE IF @IndexName = ''
               AND @DatabaseName = ''
               AND @SchemaName = ''
               AND @TableName = ''
               AND @FillFactor = ''
               AND @Verbose <> 0
              BEGIN
                  SELECT *
                  FROM   #FillFactorCheck
              END
END
           ELSE  
              BEGIN
                  PRINT ( '      IF Object_id(N''tempdb..#FillFactorCheck'') IS NOT NULL
        DROP TABLE #FillFactorCheck;
      CREATE TABLE #FillFactorCheck
        (
           DatabaseName      SYSNAME,
           SchemaName        SYSNAME,
           TableName         SYSNAME,
           IndexName         SYSNAME,
           CurrentFillFactor INT
        )
     INSERT INTO #FillFactorCheck' )

                  IF @DatabaseName <> ''
                    BEGIN
                        PRINT ( '  SELECT *
                      FROM   #FillFactorCheck
                      WHERE  [DatabaseName] = '''
                                + @DatabaseName
                                + '''
                             AND TableName  LIKE ''%'
                                + @TableName
                                + '%''
                             AND [IndexName] LIKE ''%'
                                + @IndexName
                                + '%''
                             AND [SchemaName] LIKE ''%'
                                + @SchemaName + '%''' )
                    END
                  ELSE IF @SchemaName <> ''
                    BEGIN
                        PRINT ( '  SELECT *
                      FROM   #FillFactorCheck
                      WHERE  [SchemaName] = '''
                                + @SchemaName
                                + '''
                             AND DatabaseName LIKE ''%'
                                + @DatabaseName
                                + '%''
                             AND [IndexName] LIKE ''%'
                                + @IndexName
                                + '%''
                             AND [TableName] LIKE ''%'
                                + @TableName + '%''' )
                    END
                  ELSE  IF @TableName <> ''
                    BEGIN
                        PRINT ( '  SELECT *
                      FROM   #FillFactorCheck
                      WHERE  [TableName] = '''
                                + @TableName
                                + '''
                             AND DatabaseName LIKE ''%'
                                + @DatabaseName
                                + '%''
                             AND [IndexName] LIKE ''%'
                                + @IndexName
                                + '%''
                             AND [SchemaName] LIKE ''%'
                                + @SchemaName + '%''' )
                    END
                  ELSE  IF @IndexName <> ''
                    BEGIN
                        PRINT ( '  SELECT *
                      FROM   #FillFactorCheck
                      WHERE  [IndexName] = '''
                                + @IndexName
                                + '''
                             AND DatabaseName LIKE ''%'
                                + @DatabaseName
                                + '%''
                             AND [TableName] LIKE ''%'
                                + @TableName
                                + '%''
                             AND [SchemaName] LIKE ''%'
                                + @SchemaName + '%''' )
                    END
					                  ELSE IF @FillFactor <> '' 
                    BEGIN
                        PRINT ( '  SELECT *
                      FROM   #FillFactorCheck
                           WHERE  [CurrentFillFactor] = '''
                                + @FillFactor +'''')
                    END
                  ELSE IF @IndexName = ''
                     AND @DatabaseName = ''
                     AND @SchemaName = ''
                     AND @TableName = ''
                     AND @FillFactor = '0'
                    BEGIN
                        PRINT ( '   SELECT *
                      FROM   #FillFactorCheck ' )
                    END
              END

  END
  END
