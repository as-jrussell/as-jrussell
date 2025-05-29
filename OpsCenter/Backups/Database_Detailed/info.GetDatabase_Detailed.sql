USE [DBA]

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[info].[Getdatabase_Detailed]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [info].[Getdatabase_Detailed] AS RETURN 0;';
  END;

GO

ALTER PROC info.Getdatabase_detailed (@Name     VARCHAR(50) = '',
                                      @TYPE     VARCHAR(10) = '',
                                      @Variable VARCHAR(MAX) = '',
                                      @DryRun   INT=1,
                                      @Verbose  INT = 0)
AS
    ---Stale data
			---exec info.Getdatabase_detailed  @DryRun =1,  @Name='DBA', @type = 'ROWS'
			---exec info.Getdatabase_detailed  @DryRun =1,  @Name='DBA', @type = 'LOG'
			---exec info.Getdatabase_detailed  @DryRun =1,  @Name='', @type = 'ROWS'
			---exec info.Getdatabase_detailed  @DryRun =1,  @Name='', @type = 'LOG'
			---exec info.Getdatabase_detailed  @Name='DBA', @type = 'ROWS'
			---exec info.Getdatabase_detailed  @Name='DBA', @type = 'LOG'
			---exec info.Getdatabase_detailed  @Name='', @type = 'ROWS'
			---exec info.Getdatabase_detailed  @Name='', @type = 'LOG'
			---exec info.Getdatabase_detailed  @DryRun =1
			---exec info.Getdatabase_detailed
    ---Live data
			---exec info.Getdatabase_detailed  @DryRun =1,  @Name='DBA'
			---exec info.Getdatabase_detailed  @Name='DBA'
    ---Data Capture (all other variables will be ignored) 
			---exec info.Getdatabase_detailed  @DryRun =0


    DECLARE @SQLcmd VARCHAR(MAX)
    DECLARE @data VARCHAR(MAX)

    --For Disabled AutoGrowth or Unlimited Autogrowth it is set stats are mathematical expression is to the Current Size with the Unlimited it will grow as needed. 
    SELECT @SQLcmd = 'SELECT  [Database_Name] = DB_NAME(),[Logical_Name] = name
		 ,[Path] = physical_name 
		,[TYPE] = A.TYPE_DESC
		  ,  [FileGrowth]    = CASE growth / 128
                              WHEN 0 THEN ''By %''
                              ELSE ''By '' + Cast(growth/128 AS VARCHAR(10))
                                   + '' MB''
                            END
	 
,[Growth Enabled/Disabled] =CASE WHEN growth = 0 THEN ''Autogrowth is off'' ELSE CASE WHEN max_size = -1 THEN ''Enabled'' ELSE ''Disabled'' END END
,[Max Grow MB] =CASE WHEN growth = 0 THEN ''Autogrowth is off'' ELSE CASE WHEN max_size = -1 THEN ''Unlimited'' ELSE CAST(max_size/128 AS VARCHAR(10))    + '' MB'' END END 
		, [CurrentSizeMB ] =  size/128.0
		,  [SpaceUsedMB] =CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0
		,[FreeSpaceMB] =  CASE WHEN max_size = -1 THEN size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 ELSE max_size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 END
		, [Free Space %] = CASE WHEN max_size = -1 THEN CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), size/128.0)*100 -100)) ELSE CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), max_size/128.0)*100 -100)) END
		,[Create_Date] = GETDATE()
		FROM sys.database_files A 
	  order by [SpaceUsedMB] desc'

    SELECT @data = 'USE [?]  ' + @SQLcmd + ''

    IF @Verbose = 0
      BEGIN
          IF @DryRun = 0
            BEGIN
                IF Object_id(N'DBA.info.Database_Detailed') IS NOT NULL
                  TRUNCATE TABLE DBA.info.Database_Detailed

                INSERT INTO DBA.info.Database_Detailed
                EXEC Sp_msforeachdb
                  @data
            END
          ELSE
            BEGIN
                IF @TYPE <> ''
                   AND @Name = ''
                  BEGIN
                      SELECT *
                      FROM   DBA.info.Database_Detailed
                      WHERE  TYPE = @type
                      ORDER  BY [SpaceUsedMB] DESC
                  END
                ELSE IF @TYPE = ''
                   AND @Name <> ''
                  BEGIN
                      SELECT @data = ' USE [' + @Name + ']  ' + @SQLcmd + ''

                      EXEC ( @data)
                  END
                ELSE IF @TYPE <> ''
                   AND @Name <> ''
                  BEGIN
                      SELECT *
                      FROM   DBA.info.Database_Detailed
                      WHERE  TYPE = @type
                             AND DatabaseName = @Name
                      ORDER  BY [SpaceUsedMB] DESC
                  END
                ELSE IF @Variable <> ''
                  BEGIN
                      EXEC ('SELECT * FROM  DBA.info.Database_Detailed WHERE '+ @Variable + '  ORDER  BY  [SpaceUsedMB]  DESC')
                  END
                ELSE
                  BEGIN
                      SELECT *
                      FROM   DBA.info.Database_Detailed
                      ORDER  BY [SpaceUsedMB] DESC
                  END
            END
      END
    ELSE
      BEGIN
          IF @TYPE <> ''
             AND @Name = ''
            BEGIN
                PRINT( 'SELECT *
                      FROM   DBA.info.Database_Detailed
                      WHERE  TYPE = '''
                       + @type
                       + '''
                      ORDER  BY [SpaceUsedMB] DESC' )
            END
          ELSE IF @TYPE = ''
             AND @Name <> ''
            BEGIN
                PRINT( 'SELECT *
                      FROM   DBA.info.Database_Detailed
                      WHERE  DatabaseName = '''
                       + @Name
                       + '''
                      ORDER  BY [SpaceUsedMB] DESC ' )
            END
          ELSE IF @TYPE <> ''
             AND @Name <> ''
            BEGIN
                PRINT( ' SELECT *
                      FROM   DBA.info.Database_Detailed
                      WHERE  TYPE =  '''
                       + @type
                       + '''
                             AND DatabaseName =  '''
                       + @Name
                       + '''
                      ORDER  BY [SpaceUsedMB] DESC' )
            END
          ELSE IF @Variable <> ''
            BEGIN
                PRINT ( 'SELECT * FROM  DBA.info.Database_Detailed WHERE '
                        + @Variable
                        + '  ORDER  BY  [SpaceUsedMB]  DESC' )
            END
          ELSE
            BEGIN
                PRINT ( @data )

                PRINT( ' 
				
				SELECT *
                      FROM   DBA.info.Database_Detailed
                      ORDER  BY [SpaceUsedMB] DESC ' )
            END
      END 
