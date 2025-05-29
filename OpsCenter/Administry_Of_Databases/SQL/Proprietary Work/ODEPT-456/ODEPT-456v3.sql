DECLARE @HostName VARCHAR(255)
DECLARE @sql VARCHAR(4000)
DECLARE @units VARCHAR(10) = 'GB'
DECLARE @RetentionDays INT = 30
DECLARE @DryRun TINYINT = 1

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

IF( @units = 'MB' )
  BEGIN
      --script to retrieve the values in MB from PS Script output
      SET @sql = 'select rtrim(ltrim(SUBSTRING(line,1,CHARINDEX(''|'',line) -1))) as drivename
							,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
							(CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL),0) as ''capacity(MB)''
							,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
							(CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)) )) as DECIMAL),0) as ''freespace(MB)''
							,round(round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
							(CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)) )) as DECIMAL),0)/
							round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
							(CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as Float),0),2)*100 as ''percentFree'',
							CASE WHEN [FreePct] > 20.00 THEN ''Resource already has 20%''
			ELSE    CAST(ROUND(
			((CAST([TotalGB] as numeric) / 0.8) -  (CAST( [TotalGB] as numeric))),0) AS nvarchar(100))
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
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as DECIMAL)/1024.,0) as [capacity(GB)],

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
						   as DECIMAL) 
						   /1024)
						   as [freespace(GB)]
						   ,
						 round(
						   round(
						   cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
						   (CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)
						   ) )) 
						   as DECIMAL) /1024. ,2)/
						   round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
						   (CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) 
						   )
						  ) 
						   as Float)/1024,0),4)*100 as [percentFree]
						from #output
						where line like ''[A-Z][:]%''
						order by drivename'
  END

IF Object_id('tempdb..#DriveUsage') IS NOT NULL
  DROP TABLE #DriveUsage;

CREATE TABLE #DriveUsage
  (
     [Path]    [VARCHAR](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
     [TotalGB] [VARCHAR](20) NULL,
     [FreeGB]  [VARCHAR](20) NULL,
     [FreePct] [FLOAT] NULL,
	-- [SpaceIncreased]  [VARCHAR](128)NULL
  ) -- WITH (DATA_COMPRESSION = PAGE);

INSERT INTO #DriveUsage
EXEC(@sql)

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
             [FreePct]
		,
						   			CASE WHEN [FreePct] > 20.00 THEN 'Resource already has 20%'
			ELSE    CAST(ROUND(
			(.20 *(CAST(TotalGB as numeric))  - (CAST( FreeGB as numeric) )),0) AS nvarchar(100))
			END AS  [SpaceIncreased]
      FROM   #DriveUsage;
  END; 
