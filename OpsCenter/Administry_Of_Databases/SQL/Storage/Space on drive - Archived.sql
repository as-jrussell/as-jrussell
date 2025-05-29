DECLARE @SQLcmd VARCHAR(MAX)
DECLARE @Name NVARCHAR(50) = 'tempdb'
DECLARE @TYPE NVARCHAR(10) = ''
DECLARE @DryRun INT = 1

IF @DryRun = 0
   AND @Name <> ''
  BEGIN
      SELECT @SQLcmd = '
USE ' + @Name
                       + '
SELECT 
--         
 @@servername as ServerName, DB_NAME() [Database Name]
		 ,[FileName_Name] = name
		,[TYPE] = A.TYPE_DESC
		  ,  [FileGrowth]    = CASE growth / 128
                              WHEN 0 THEN ''By %''
                              ELSE ''By '' + Cast(growth/128 AS VARCHAR(10))
                                   + '' MB''
                            END 
	 ,  [Max Growth]    =      CASE growth
        WHEN 0 THEN ''Autogrowth is off.''
        ELSE ''Autogrowth is on.''
		END
,[Able to Grow] =CASE WHEN growth = 0 THEN ''Autogrowth is off'' ELSE CASE WHEN max_size = -1 THEN ''Unlimited'' ELSE CASE WHEN max_size/128 <= size/128 THEN ''WARNING: Cannot Grow Please address immediately '' ELSE CAST(max_size/128 AS VARCHAR(10))    + '' MB'' END END END
		, [CurrentSizeMB ] =  size/128.0
		,[Space Used] =CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0
		,[FreeSpaceMB] =  size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0
		, [Free Space %] = CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), size/128.0)*100 -100))
			FROM sys.database_files A 
		order by CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), size/128.0)*100 -100)) desc'

      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      SELECT @SQLcmd = '
USE [?]
SELECT 


		 @@servername as ServerName, DB_NAME()
		 ,[Database_Name] = name
		,[TYPE] = A.TYPE_DESC
		  ,  [FileGrowth]    = CASE growth / 128
                              WHEN 0 THEN ''By %''
                              ELSE ''By '' + Cast(growth/128 AS VARCHAR(10))
                                   + '' MB''
                            END
	 ,  [Max Growth]    =      CASE growth
        WHEN 0 THEN ''Autogrowth is off.''
        ELSE ''Autogrowth is on.''
		END
,[Able to Grow] =CASE WHEN growth = 0 THEN ''Autogrowth is off'' ELSE CASE WHEN max_size = -1 THEN ''Unlimited'' ELSE CASE WHEN max_size/128 <= size/128 THEN ''WARNING: Cannot Grow Please address immediately '' ELSE CAST(max_size/128 AS VARCHAR(10))    + '' MB'' END END END
		, [CurrentSizeMB ] =  size/128.0
		,CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0
		,[FreeSpaceMB] =  size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0
		, [Free Space %] = CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), size/128.0)*100 -100))
		FROM sys.database_files A 
	  order by CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), size/128.0)*100 -100)) desc'

      IF Object_id(N'tempdb..#DatafileSize') IS NOT NULL
        DROP TABLE #DatafileSize

      CREATE TABLE #DatafileSize
        (
           [ServerName]    NVARCHAR(100),
           [DatabaseName]  NVARCHAR(250),
           [FileName_Name] VARCHAR(250),
           [TYPE]          NVARCHAR(10),
           [FileGrowth]    NVARCHAR(1000),
           [MaxGrowMB]     VARCHAR(1000),
           [Growth]  VARCHAR(100),
           [CurrentSizeMB] INT,
           [SpaceUsedMB]   INT,
           [FreeSpaceMB]   INT,
           [Free Space %]  INT
        );

      INSERT INTO #DatafileSize
      EXEC Sp_msforeachdb
        @SQLcmd

      IF @DryRun = 0
         AND @TYPE <> ''
        BEGIN
            SELECT *
            FROM   #DatafileSize
            WHERE  TYPE = @type
            ORDER  BY [Growth] ASC,
                      [Free Space %] ASC
        END
      ELSE
        BEGIN
            SELECT *
            FROM   #DatafileSize
            ORDER  BY [Growth] ASC,
                      [Free Space %] ASC
        END
  END
/*

	      SELECT  
		  [ServerName],
           F.[DatabaseName] ,
		   CASE WHEN MAX(TimeStampUTC) is null THEN 'Never been access' ELSE
		CAST(MAX(TimeStampUTC)AS nvarchar(255)) END [Last time DB access],
           [FileName_Name] ,
           [TYPE]          ,
           [FileGrowth]   ,
           [MaxGrowMB]     ,
           [Able to Grow]  ,
           [CurrentSizeMB] ,
           [SpaceUsedMB]   ,
           [FreeSpaceMB]   ,
           [Free Space %]  
      FROM   #DatafileSize F
	  JOIN  Sys.databases D ON F.DATABASENAME = d.NAME
		LEFt JOIN dba.info.AuditLogin A on D.name = A.DatabaseName
		WHERE  D.Database_ID >= '5'
		GROUP BY [ServerName],
           f.[DatabaseName] ,
           [FileName_Name] ,
           [TYPE]          ,
           [FileGrowth]   ,
           [MaxGrowMB]     ,
           [Able to Grow]  ,
           [CurrentSizeMB] ,
           [SpaceUsedMB]   ,
           [FreeSpaceMB]   ,
           [Free Space %]  
		HAVING MAX(TimeStampUTC)  <= '2022-06-01 '



	  where [DatabaseName] in (	select  D.name 
		--select *
		from sys.databases D 
		LEFt JOIN dba.info.AuditLogin A on D.name = A.DatabaseName
		
			WHERE  D.Database_ID >= '5'
		GROUP BY D.name 
		HAVING MAX(TimeStampUTC)  <= '2021-10-19 ')
      ORDER  BY [CurrentSizeMB] DESC,
	  [Able to Grow] ASC,
                [Free Space %] ASC





	*/


