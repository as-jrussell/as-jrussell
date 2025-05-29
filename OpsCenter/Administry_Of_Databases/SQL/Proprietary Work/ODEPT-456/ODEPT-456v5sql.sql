DECLARE @HostName VARCHAR(255)
DECLARE @sql VARCHAR(4000)
DECLARE @units VARCHAR(10) = 'GB'
DECLARE @RetentionDays INT = 30
DECLARE @DryRun TINYINT = 1


--by default it will take the current server name, we can the set the server name as well
-- Need to swap this to an if contains take the left of charIndex('\') and then use @HostName
SELECT @HostName = CONVERT(VARCHAR(255), Serverproperty('MachineName'))


IF NOT EXISTS (SELECT *
           FROM   sys.databases
           WHERE  name = 'rdsadmin')
  BEGIN
SET @sql = 'powershell.exe -c "Get-WmiObject -ComputerName '
           + Quotename(@HostName, '''')
           + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,label,capacity,freespace | foreach{$_.name+$_.label+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'

--creating a temporary table
IF Object_id('tempdb..#output') IS NOT NULL
  DROP TABLE #output;

CREATE TABLE #output
  (
     line VARCHAR(255)
  )

--inserting disk name, total space and free space value in to temporary table
INSERT #output
EXEC Xp_cmdshell
  @sql

IF( @units = 'MB' )
  BEGIN
      --script to retrieve the values in MB from PS Script output
      SET @sql = 'select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX(''|'',line) -1))) as drivename
							,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
							(CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2)),0) as ''capacity(MB)''
							,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
							(CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)) )) as DECIMAL(18,2)),0) as ''freespace(MB)''
							,round(round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
							(CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)) )) as DECIMAL(18,2)),0)/
							round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
							(CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2)),0),2)*100 as ''percentFree'',
							 CASE WHEN (round(
						   round(
						   cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
						   (CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)
						   ) )) 
						   as DECIMAL(18,2)) /1024. ,2)/
						   round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) 
						   )
						  ) 
						   as DECIMAL(18,2))/1024,0),4)*100) > 20 THEN ''Resource already has 20%''
			ELSE  CASE WHEN (round(
						   round(
						   cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
						   (CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)
						   ) )) 
						   as DECIMAL(18,2)) /1024. ,2)/
						   round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) 
						   )
						  ) 
						   as DECIMAL(18,2))/1024,0),4)*100) < 19 THEN CAST
			(.22 *(CAST((CONVERT(DECIMAL(18,2),cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2))/1024.,0)) as DECIMAL(18,0)))  - (CAST( (CONVERT(DECIMAL(18,2),
						   cast(
						   
						   rtrim
						   (ltrim
						   (SUBSTRING
						   (line,CHARINDEX
						   (''%'',line)+1,
						   (CHARINDEX
						   (''*'',line) 
						   -1)-CHARINDEX
						   (''%'',line)
						   ) 
						   )
						   ) 
						   as DECIMAL(18,2)) 
						   /1024)) as DECIMAL(18,0)) ) AS nvarchar(100)) + '' GB''
			ELSE  CAST
			(.22 *(CAST((CONVERT(DECIMAL(18,2),cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2))/1024.,0))*1024 as DECIMAL(18,0)))  - (CAST( (CONVERT(DECIMAL(18,2),
						   cast(
						   
						   rtrim
						   (ltrim
						   (SUBSTRING
						   (line,CHARINDEX
						   (''%'',line)+1,
						   (CHARINDEX
						   (''*'',line) 
						   -1)-CHARINDEX
						   (''%'',line)
						   ) 
						   )
						   ) 
						   as DECIMAL(18,2)) 
						   /1024))*1024 as DECIMAL(18,0)) ) AS nvarchar(100)) + '' MB''
			END
			END AS  [SpaceIncreased]
						from #output
						where line like ''[A-Z][:]%''
						order by drivename'
  END
ELSE
  BEGIN
      --script to retrieve the values in GB from PS Script output
      SET @sql = '

						   
  SELECT 

  rtrim(ltrim(SUBSTRING(line,1,CHARINDEX(''|'',line) -1))) as drivename
						   ,CONVERT(DECIMAL(18,2),cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2))/1024.,0) as [capacity(GB)],

						   CONVERT(DECIMAL(18,2),
						   cast(
						   
						   rtrim
						   (ltrim
						   (SUBSTRING
						   (line,CHARINDEX
						   (''%'',line)+1,
						   (CHARINDEX
						   (''*'',line) 
						   -1)-CHARINDEX
						   (''%'',line)
						   ) 
						   )
						   ) 
						   as DECIMAL(18,2)) 
						   /1024)
						   as [freespace(GB)]
						   ,
						 round(
						   round(
						   cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
						   (CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)
						   ) )) 
						   as DECIMAL(18,2)) /1024. ,2)/
						   round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) 
						   )
						  ) 
						   as DECIMAL(18,2))/1024,0),4)*100 as [percentFree],
						   CASE WHEN (round(
						   round(
						   cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
						   (CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)
						   ) )) 
						   as DECIMAL(18,2)) /1024. ,2)/
						   round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) 
						   )
						  ) 
						   as DECIMAL(18,2))/1024,0),4)*100) > 20 THEN ''Resource already has 20%''
			ELSE  CASE WHEN (round(
						   round(
						   cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
						   (CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)
						   ) )) 
						   as DECIMAL(18,2)) /1024. ,2)/
						   round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) 
						   )
						  ) 
						   as DECIMAL(18,2))/1024,0),4)*100) < 19 THEN CAST
			(.22 *(CAST((CONVERT(DECIMAL(18,2),cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2))/1024.,0)) as DECIMAL(18,0)))  - (CAST( (CONVERT(DECIMAL(18,2),
						   cast(
						   
						   rtrim
						   (ltrim
						   (SUBSTRING
						   (line,CHARINDEX
						   (''%'',line)+1,
						   (CHARINDEX
						   (''*'',line) 
						   -1)-CHARINDEX
						   (''%'',line)
						   ) 
						   )
						   ) 
						   as DECIMAL(18,2)) 
						   /1024)) as DECIMAL(18,0)) ) AS nvarchar(100)) + '' GB''
			ELSE  CAST
			(.22 *(CAST((CONVERT(DECIMAL(18,2),cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2))/1024.,0))*1024 as DECIMAL(18,0)))  - (CAST( (CONVERT(DECIMAL(18,2),
						   cast(
						   
						   rtrim
						   (ltrim
						   (SUBSTRING
						   (line,CHARINDEX
						   (''%'',line)+1,
						   (CHARINDEX
						   (''*'',line) 
						   -1)-CHARINDEX
						   (''%'',line)
						   ) 
						   )
						   ) 
						   as DECIMAL(18,2)) 
						   /1024))*1024 as DECIMAL(18,0)) ) AS nvarchar(100)) + '' MB''
			END
			END AS  [SpaceIncreased]
						from #output
						where line like ''[A-Z][:]%''
						order by drivename'
  END
  END
  ELSE 
  BEGIN 
 SET @sql = '
SELECT
      vs.volume_mount_point AS Drive,
    CAST(vs.total_bytes / 1073741824.0 AS DECIMAL(10,2)) AS TotalGB,
    CAST(vs.available_bytes / 1073741824.0 AS DECIMAL(10,2)) AS FreeGB,
    CAST((1.0 - vs.available_bytes * 1.0 / vs.total_bytes) * 100.0 AS DECIMAL(10,2)) AS PercentUsed,
		CASE WHEN (  CAST((1.0 - vs.available_bytes * 1.0 / vs.total_bytes) * 100.0 AS DECIMAL(10,2))) > 20 THEN ''Resource already has 20%''
			ELSE  CASE WHEN (  CAST((1.0 - vs.available_bytes * 1.0 / vs.total_bytes) * 100.0 AS DECIMAL(10,2))) < 19 THEN 
			CAST(ABS(.22 *(CAST((CAST(vs.total_bytes / 1073741824.0 AS DECIMAL(10,2))) as DECIMAL(18,0)))  - (CAST( (CAST(vs.available_bytes / 1073741824.0 AS DECIMAL(10,2))) as DECIMAL(18,0)) )) AS nvarchar(100)) + '' GB''
			ELSE  CAST(ABS(.22 *(CAST((CAST(vs.total_bytes / 1073741824.0 AS DECIMAL(10,2)))*1024 as DECIMAL(18,0)))  - (CAST( (CAST(vs.available_bytes / 1073741824.0 AS DECIMAL(10,2)))*1024 as DECIMAL(18,0))) ) AS nvarchar(100)) + '' MB''
			END
			END AS [SpaceIncreasedToGetBackto20Percent] 

FROM sys.dm_os_volume_stats(DB_ID(), 1) AS vs;
'
  END
IF Object_id('tempdb..#DriveUsage') IS NOT NULL
  DROP TABLE #DriveUsage;

CREATE TABLE #DriveUsage
  (
     [Path]    [VARCHAR](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
     [TotalGB] DECIMAL(18,2),
     [FreeGB]  DECIMAL(18,2),
     [FreePct] DECIMAL(18,2),
	 [SpaceIncreasedToGetBackto20Percent]  [VARCHAR](128)
  ) -- WITH (DATA_COMPRESSION = PAGE);

  IF NOT EXISTS (SELECT *
           FROM   sys.databases
           WHERE  name = 'rdsadmin')
  BEGIN
INSERT INTO #DriveUsage
EXEC(@sql)


  END
  ELSE 
  BEGIN 
  INSERT INTO #DriveUsage
  EXEC(@sql)
  END


IF( @dryRun = 0 )
  BEGIN
      MERGE [info].[DriveUsage] AS old
      USING (SELECT [Path],
                    [TotalGB],
                    [FreeGB],
                    [FreePct]
             FROM   #DriveUsage) AS new ( [Path], [TotalGB], [FreeGB], [FreePct] )
      ON new.[Path] = old.[Path]
      WHEN MATCHED AND ( old.[TotalGB] <> new.[TotalGB] OR old.[FreeGB] <> new.[FreeGB] OR old.[FreePct] <> new.[FreePct] ) THEN
        UPDATE SET old.[TotalGB] = new.[TotalGB],
                   old.[FreeGB] = new.[FreeGB],
                   old.[FreePct] = new.[FreePct]
      WHEN NOT MATCHED THEN
        INSERT( [Path],
                [TotalGB],
                [FreeGB],
                [FreePct])
        VALUES( new.[Path],
                new.[TotalGB],
                new.[FreeGB],
                new.[FreePct],
                new.[HarvestDate] )
      WHEN NOT MATCHED BY SOURCE THEN
        DELETE;
  END;
ELSE
  BEGIN

	        SELECT [Path],
             [TotalGB],
             [FreeGB],
             [FreePct],
			[SpaceIncreasedToGetBackto20Percent] 
      FROM   #DriveUsage;
  END; 
