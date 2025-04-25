DECLARE @SQLcmd VARCHAR(MAX);
DECLARE @data VARCHAR(MAX);
DECLARE @DatabaseName VARCHAR(100)='tempdb'
DECLARE @TYPE NVARCHAR(10) = '';
DECLARE @Variable VARCHAR(MAX) = '';
DECLARE @DryRun INT = 0;

-- For Disabled AutoGrowth or Unlimited Autogrowth, the stats are calculated based on the Current Size.
-- With Unlimited Autogrowth, the file will grow as needed. 
SELECT @SQLcmd = 'SELECT @@servername as ServerName,[Database_Name] = DB_NAME()
         ,[Logical_Name] = name
         ,[Path] = physical_name 
         ,[TYPE] = A.TYPE_DESC
         , [FileGrowth]  = CASE growth / 128
                                WHEN 0 THEN ''By %''
                                ELSE ''By '' + Cast(growth/128 AS VARCHAR(10)) + '' MB''
                            END
        ,[AutoGrowth] =CASE 
                            WHEN growth = 0 THEN ''Autogrowth is off'' 
                            ELSE 
                                CASE 
                                    WHEN (max_size = -1  OR growth >0) THEN ''Enabled'' 
                                    ELSE ''Disabled'' 
                                END 
                        END
        ,[Max Grow MB] =CASE 
                            WHEN growth = 0 THEN ''Autogrowth is off'' 
                            ELSE 
                                CASE 
                                    WHEN max_size = -1 THEN ''Unlimited'' 
                                    WHEN growth= 0 THEN ''Unlimited'' 
                                    WHEN max_size = 268435456 THEN ''2 TB''
                                    ELSE CAST(max_size/128 AS VARCHAR(10))  + '' MB'' 
                                END 
                         END 
         , [CurrentSizeMB ] =  size/128.0
         , [SpaceUsedMB] =CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0
         ,[FreeSpaceMB] =  CASE 
                                WHEN (max_size = -1  OR growth >0) THEN size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 
                                ELSE max_size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 
                            END
         , [Free Space %] = CASE 
                                WHEN (max_size = -1  OR growth >0) THEN CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), size/128.0)*100 -100)) 
                                ELSE CONVERT(INT,ABS(CONVERT(DECIMAL (10,2), CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/ CONVERT(DECIMAL (10,2), max_size/128.0)*100 -100)) 
                            END
        FROM sys.database_files A 
        order by [SpaceUsedMB] desc';

IF @DryRun = 0
  BEGIN
      -- Create the temporary table 
      IF Object_id(N'tempdb..#DatafileSize') IS NOT NULL
        DROP TABLE #DatafileSize;

      CREATE TABLE #DatafileSize
        (
           [ServerName]    NVARCHAR(100),
           [DatabaseName]  NVARCHAR(250),
           [Logical_Name]  VARCHAR(250),
           [File_Path]     VARCHAR(250),
           [TYPE]          NVARCHAR(10),
           [FileGrowth]    NVARCHAR(1000),
           [AutoGrowth]    VARCHAR(100),
           [MAX Growth MB] VARCHAR(100),
           [CurrentSizeMB] VARCHAR(15),
           [SpaceUsedMB]   VARCHAR(15),
           [FreeSpaceMB]   VARCHAR(15),
           [Free Space %]  INT
        );

      -- Use a WHILE loop to iterate through databases
      DECLARE @DbName SYSNAME;
      DECLARE @Counter INT = 1;

      -- Get the total number of databases
      SELECT @Counter = Count(*)
      FROM   sys.databases; -- You can filter this if needed
      WHILE @Counter > 0
        BEGIN
            -- Get the next database name
            SELECT TOP 1 @DbName = name
            FROM   sys.databases -- Add filtering here if needed
            WHERE  name NOT IN (SELECT TOP (@Counter - 1) name
                                FROM   sys.databases); -- ORDER BY name); 
            SET @data = 'USE [' + @DbName + '] ' + @SQLcmd;

            -- Insert data into the temporary table
            INSERT INTO #DatafileSize
            EXEC (@data);

            SET @Counter = @Counter - 1;
        END

      -- Rest of the code for filtering and displaying data from #DatafileSize (same as before)
      IF @TYPE <> ''
         AND @DatabaseName = ''
        BEGIN
            SELECT *
            FROM   #DatafileSize
            WHERE  TYPE = @type
            ORDER  BY CONVERT(INT, Abs([SpaceUsedMB])) DESC;
        END
      ELSE IF @DatabaseName <> ''
         AND @TYPE = ''
        BEGIN
            SELECT *
            FROM   #DatafileSize
            WHERE  DatabaseName = @DatabaseName
            ORDER  BY CONVERT(INT, Abs([SpaceUsedMB])) DESC;
        END
      ELSE IF @TYPE <> ''
         AND @DatabaseName <> ''
        BEGIN
            SELECT *
            FROM   #DatafileSize
            WHERE  TYPE = @type
                   AND DatabaseName = @DatabaseName
            ORDER  BY CONVERT(INT, Abs([SpaceUsedMB])) DESC;
        END
      ELSE IF @Variable <> ''
        BEGIN
            EXEC ('SELECT * FROM #DatafileSize WHERE ' + @Variable + ' ORDER BY CONVERT(INT, ABS([SpaceUsedMB])) DESC');
        END
      ELSE
        BEGIN
            SELECT *
            FROM   #DatafileSize
            ORDER  BY CONVERT(INT, Abs([SpaceUsedMB])) DESC;
        END
  END
ELSE
  BEGIN
  PRINT ('      IF Object_id(N''tempdb..#DatafileSize'') IS NOT NULL
        DROP TABLE #DatafileSize;

      CREATE TABLE #DatafileSize
        (
           [ServerName]    NVARCHAR(100),
           [DatabaseName]  NVARCHAR(250),
           [Logical_Name]  VARCHAR(250),
           [File_Path]     VARCHAR(250),
           [TYPE]          NVARCHAR(10),
           [FileGrowth]    NVARCHAR(1000),
           [AutoGrowth]    VARCHAR(100),
           [MAX Growth MB] VARCHAR(100),
           [CurrentSizeMB] VARCHAR(15),
           [SpaceUsedMB]   VARCHAR(15),
           [FreeSpaceMB]   VARCHAR(15),
           [Free Space %]  INT
        );
     INSERT INTO #DatafileSize'
)
      PRINT ( @sqlcmd );

      IF @TYPE <> ''
         AND @DatabaseName = ''
        BEGIN
            PRINT ( '
			SELECT * FROM #DatafileSize WHERE TYPE = '''
                    + @type
                    + ''' ORDER BY CONVERT(INT, ABS([SpaceUsedMB])) DESC' );
        END
      ELSE IF @DatabaseName <> ''
         AND @TYPE = ''
        BEGIN
            PRINT ( '
			SELECT * FROM #DatafileSize WHERE DatabaseName = '''
                    + @DatabaseName
                    + ''' ORDER BY CONVERT(INT, ABS([SpaceUsedMB])) DESC' );
        END
      ELSE IF @TYPE <> ''
         AND @DatabaseName <> ''
        BEGIN
            PRINT ( '
			SELECT * FROM #DatafileSize WHERE TYPE = '''
                    + @type + ''' AND DatabaseName = ''' + @DatabaseName
                    + ''' ORDER BY CONVERT(INT, ABS([SpaceUsedMB])) DESC' );
        END
      ELSE IF @Variable <> ''
        BEGIN
            PRINT ( '
		SELECT * FROM #DatafileSize WHERE '''
                    + @Variable
                    + ''' ORDER BY CONVERT(INT, ABS([SpaceUsedMB])) DESC' );
        END
      ELSE
        BEGIN
            PRINT ( '
				SELECT * FROM #DatafileSize  ORDER BY CONVERT(INT, ABS([SpaceUsedMB])) DESC' );
        END
  END 
