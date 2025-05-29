DECLARE @HostName VARCHAR(255)
DECLARE @sql VARCHAR(4000)
DECLARE @current_tracefilename VARCHAR(500);
DECLARE @0_tracefilename VARCHAR(500);
DECLARE @avgsql VARCHAR(4000)
DECLARE @indx INT;
DECLARE @units VARCHAR(10) = 'TB'
DECLARE @DriveLetter VARCHAR(3) =''---variable example C:\
DECLARE @DryRun TINYINT = 1



SELECT @current_tracefilename = path
FROM sys.traces
WHERE is_default = 1;
SET @current_tracefilename = REVERSE(@current_tracefilename);
SELECT @indx = PATINDEX('%\%', @current_tracefilename);
SET @current_tracefilename = REVERSE(@current_tracefilename);
SET @0_tracefilename = LEFT(@current_tracefilename, LEN(@current_tracefilename) - @indx) + '\log.trc';



IF 
  EXISTS (SELECT *
               FROM   sys.databases
               WHERE  name = 'rdsadmin')
BEGIN --1
--by default it will take the current server name, we can the set the server name as well
-- Need to swap this to an if contains take the left of charIndex('\') and then use @HostName
SELECT @HostName = CONVERT(VARCHAR(255), Serverproperty('MachineName'))
IF( @units = 'GB' )
 BEGIN  --2 
      SET @sql = '
SELECT
      vs.volume_mount_point AS Drive,
    CAST(vs.total_bytes / 1073741824.0 AS DECIMAL(10,2)) AS TotalGB,
    CAST(vs.available_bytes / 1073741824.0 AS DECIMAL(10,2)) AS FreeGB,
    CAST((1.0 - vs.available_bytes * 1.0 / vs.total_bytes) * 100.0 AS DECIMAL(10,2)) AS PercentUsed
FROM sys.dm_os_volume_stats(DB_ID(), 1) AS vs;
'
  END --2
ELSE --2
  BEGIN --2
      SET @sql = '
SELECT
      vs.volume_mount_point AS Drive,
    CAST(vs.total_bytes / 1073741824.0/1024 AS DECIMAL(10,2)) AS TotalTB,
    CAST(vs.available_bytes / 1073741824.0/1024 AS DECIMAL(10,2)) AS FreeTB,
    CAST((1.0 - vs.available_bytes * 1.0 / vs.total_bytes) * 100.0 AS DECIMAL(10,2)) AS PercentUsed
FROM sys.dm_os_volume_stats(DB_ID(), 1) AS vs;
'
  END --2
END --1
ELSE IF EXISTS (select * from sys.database_files  where physical_name like 'https%')  --1
BEGIN --1
--by default it will take the current server name, we can the set the server name as well
-- Need to swap this to an if contains take the left of charIndex('\') and then use @HostName
  SELECT @HostName = (select @@SERVERNAME)
IF( @units = 'GB' )
  BEGIN
      SET @sql = '
SELECT
      vs.volume_mount_point AS Drive,
    CAST(vs.total_bytes / 1073741824.0 AS DECIMAL(10,2)) AS TotalGB,
    CAST(vs.available_bytes / 1073741824.0 AS DECIMAL(10,2)) AS FreeGB,
    CAST((1.0 - vs.available_bytes * 1.0 / vs.total_bytes) * 100.0 AS DECIMAL(10,2)) AS PercentUsed
FROM sys.dm_os_volume_stats(DB_ID(), 1) AS vs;
'
  END
ELSE
  BEGIN
      SET @sql = '
SELECT
      vs.volume_mount_point AS Drive,
    CAST(vs.total_bytes / 1073741824.0/1024 AS DECIMAL(10,2)) AS TotalTB,
    CAST(vs.available_bytes / 1073741824.0/1024 AS DECIMAL(10,2)) AS FreeTB,
    CAST((1.0 - vs.available_bytes * 1.0 / vs.total_bytes) * 100.0 AS DECIMAL(10,2)) AS PercentUsed
FROM sys.dm_os_volume_stats(DB_ID(), 1) AS vs;
'
  END
END
  ELSE
  BEGIN
  --by default it will take the current server name, we can the set the server name as well
-- Need to swap this to an if contains take the left of charIndex('\') and then use @HostName
SELECT @HostName = CONVERT(VARCHAR(255), Serverproperty('MachineName'))

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

      IF( @units = 'TB' )
        BEGIN
            --script to retrieve the values in TB from PS Script output
            SET @sql = 'select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX(''|'',line) -1))) as drivename
							,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
							(CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2))/1024./1024,0) as ''capacity(TB)''
							,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
							(CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)) )) as DECIMAL(18,2))/1024./1024,0) as ''freespace(TB)''
							,round(round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
							(CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)) )) as DECIMAL(18,2)),0)/
							round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
							(CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL(18,2)),0),2)*100 as ''percentFree''
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
						   as DECIMAL(18,2))/1024,0),4)*100 as [percentFree]
						from #output
						where line like ''[A-Z][:]%''
						order by drivename'
        END
  END


      SET @avgsql = '
SELECT  Concat(vs.volume_mount_point, logical_volume_name),
	   	AVG( (IntegerData * 8.0 / 1024/1024)) AS ''Daily Avg in MB''
	  FROM ::fn_trace_gettable('''+@0_tracefilename+''', DEFAULT) t
     INNER JOIN sys.trace_events AS te ON t.EventClass = te.trace_event_id
	 INNER JOIN  sys.master_files AS f WITH (NOLOCK) ON f.name = Filename
CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.[file_id]) AS vs 
WHERE(trace_event_id >= 92
      AND trace_event_id <= 95)
GROUP BY  Concat(vs.volume_mount_point, logical_volume_name) '



IF Object_id('tempdb..#DriveUsage') IS NOT NULL
  DROP TABLE #DriveUsage;

CREATE TABLE #DriveUsage
  (
     [Path]    [VARCHAR](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
     [TotalGB] DECIMAL(18, 2),
     [FreeGB]  DECIMAL(18, 2),
     [FreePct] DECIMAL(18, 2)
  )

INSERT INTO #DriveUsage
EXEC(@sql)



IF Object_id('tempdb..#AverageUsage') IS NOT NULL
  DROP TABLE #AverageUsage;

CREATE TABLE #AverageUsage
  (
     [Path]    [VARCHAR](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
     [AverageGB] DECIMAL(18, 2)
  )

INSERT INTO #AverageUsage
EXEC(@avgsql)

IF( @dryRun = 0 )
  BEGIN
      MERGE [Perfstats].[dbo].[DriveUsage] AS old
      USING (SELECT @HostName [Hostname],
                    D.[Path],
                    [TotalGB],
                    [FreeGB],
                    [FreePct],
                    CASE --1
                      WHEN [FreePct] > 20 THEN 'Resource already over 20%'
                      ELSE
                        CASE
                          WHEN D.[Path] NOT LIKE ( 'C:%' ) --2
                        THEN
                            CASE
                              WHEN ( 0.205 * TotalGB - FreeGB ) <= '10' --4
                            THEN Cast(Cast((0.410 * TotalGB - FreeGB) AS DECIMAL(5, 0)) AS VARCHAR(100))
                                 + ' ' + @Units + ''
                              ELSE Cast(Cast((0.205 * TotalGB - FreeGB) AS DECIMAL(5, 0)) AS VARCHAR(100))
                                   + ' ' + @Units + ''
                            END --4
                          ELSE
                            CASE
                              WHEN (SELECT Count(*)
                                    FROM   dba.info.instance
                                    WHERE  sqlservername LIKE ( 'DBA%' )) = 1 --5
                            THEN
                                CASE
                                  WHEN ( 0.205 * TotalGB - FreeGB ) <= '10' --4
                                THEN Cast(Cast((0.410 * TotalGB - FreeGB) AS DECIMAL(5, 0)) AS VARCHAR(100))
                                     + ' ' + @Units + ''
                                  ELSE Cast(Cast((0.205 * TotalGB - FreeGB) AS DECIMAL(5, 0)) AS VARCHAR(100))
                                       + ' ' + @Units + ''
                                END --4
                            END --2
                        END --5
                    END       AS [SpacetobeAdded],--1
             CASE
               WHEN D.Path IN (SELECT DISTINCT Concat(vs.volume_mount_point, logical_volume_name)
                             FROM   sys.master_files AS f WITH (NOLOCK)
                                    CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS vs) THEN 	
									CASE WHEN ((FreeGB - AverageGB) / AverageGB) > 0 THEN CAST( CAST(((FreeGB - AverageGB) / AverageGB)  AS decimal(18,0)) AS varchar(100))
									ELSE 'Databases are not causing the drive to grow' END
               WHEN (SELECT 1
                     FROM   sys.databases
                     WHERE  name = 'rdsadmin') = 1
                    AND D.Path IN (SELECT DISTINCT Substring(physical_name, 1, 3)
                                 FROM   sys.master_files AS f WITH (NOLOCK)
                                        CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS vs) THEN 
									CASE WHEN ((FreeGB - AverageGB) / AverageGB) > 0 THEN CAST( CAST(((FreeGB - AverageGB) / AverageGB) AS decimal(18,0)) AS varchar(100)) 
									ELSE 'Databases are not causing the drive to grow' END
               ELSE 'Drive should not shrink as no datafiles on drive'
             END       AS [DaysToEmpty],
                    Getdate() AS [HarvestDate]
             FROM   #DriveUsage D
			 left join  #AverageUsage A on A.Path = D.Path) AS new ( [Hostname], [Path], [TotalGB], [FreeGB], [FreePct], [SpacetobeAdded], [DaysToEmpty], [HarvestDate] )
      ON new.[Path] = old.[Path]
      WHEN MATCHED AND ( old.[TotalGB] <> new.[TotalGB] OR old.[FreeGB] <> new.[FreeGB] OR old.[FreePct] <> new.[FreePct] ) THEN
        UPDATE SET old.[TotalGB] = new.[TotalGB],
                   old.[FreeGB] = new.[FreeGB],
                   old.[FreePct] = new.[FreePct]
      WHEN NOT MATCHED THEN
        INSERT( [Hostname],
                [Path],
                [TotalGB],
                [FreeGB],
                [FreePct],
                [SpacetobeAdded],
                [DaysToEmpty],
                [HarvestDate] )
        VALUES(new.[Hostname],
               new.[Path],
               new.[TotalGB],
               new.[FreeGB],
               new.[FreePct],
               new.[SpacetobeAdded],
               new.[DaysToEmpty],
               new.[HarvestDate] )
      WHEN NOT MATCHED BY SOURCE THEN
        DELETE;
  END;
ELSE
  BEGIN
      SELECT @HostName [Hostname],
             D.[Path],
             [TotalGB],
             [FreeGB],
             [FreePct],
             CASE --1
               WHEN [FreePct] > 20 THEN 'Resource already over 20%'
               ELSE
                 CASE
                   WHEN D.[Path] NOT LIKE ( 'C:%' ) --2
                 THEN
                     CASE
                       WHEN ( 0.205 * TotalGB - FreeGB ) <= '10'
                            AND @units = 'GB' --4
                     THEN Cast(Cast(Abs((0.410 * TotalGB - FreeGB)) AS DECIMAL(5, 0)) AS VARCHAR(100))
                          + ' ' + @Units + ''
                       ELSE Cast(Cast(Abs((0.205 * TotalGB - FreeGB)) AS DECIMAL(5, 0)) AS VARCHAR(100))
                            + ' ' + @Units + ''
                     END --4
                   ELSE
                     CASE
                       WHEN (SELECT Count(*)
                             FROM   dba.info.instance
                             WHERE  sqlservername LIKE ( 'DBA%' )) = 1 --5
                     THEN
                         CASE
                           WHEN ( 0.205 * TotalGB - FreeGB ) <= '10' --4
                         THEN Cast(Cast((0.410 * TotalGB - FreeGB) AS DECIMAL(5, 0)) AS VARCHAR(100))
                              + ' ' + @Units + ''
                           ELSE Cast(Cast((0.205 * TotalGB - FreeGB) AS DECIMAL(5, 0)) AS VARCHAR(100))
                                + ' ' + @Units + ''
                         END --4
                     END --2
                 END --5
             END       AS [SpacetobeAdded],--1
             CASE
               WHEN D.Path IN (SELECT DISTINCT Concat(vs.volume_mount_point, logical_volume_name)
                             FROM   sys.master_files AS f WITH (NOLOCK)
                                    CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS vs) THEN 	
									CASE 
									WHEN AverageGB = '0.00' THEN 'Databases are not causing the drive to grow'
									WHEN ((FreeGB - AverageGB) / AverageGB) > 0 THEN CAST( CAST(((FreeGB - AverageGB) / AverageGB)  AS decimal(18,0)) AS varchar(100))
									ELSE 'Databases are not causing the drive to grow' END
               WHEN (SELECT 1
                     FROM   sys.databases
                     WHERE  name = 'rdsadmin') = 1
                    AND D.Path IN (SELECT DISTINCT Substring(physical_name, 1, 3)
                                 FROM   sys.master_files AS f WITH (NOLOCK)
                                        CROSS APPLY sys.Dm_os_volume_stats(f.database_id, f.[file_id]) AS vs) THEN 
									CASE WHEN ((FreeGB - AverageGB) / AverageGB) < 0 THEN CAST( CAST(((FreeGB - AverageGB) / AverageGB) AS decimal(18,0)) AS varchar(100)) 
									ELSE 'Databases are not causing the drive to grow' END
               ELSE 'Drive should not shrink as no datafiles on drive'
             END       AS [DaysToEmpty],
             Getdate() [HarvestDate]
	--select CAST(AverageGB as DECIMAL(19,10)), *		
      FROM   #DriveUsage D
	left join  #AverageUsage A on A.Path = D.Path
      WHERE  D.[Path] LIKE '%' + @DriveLetter + '%'
  END; 
