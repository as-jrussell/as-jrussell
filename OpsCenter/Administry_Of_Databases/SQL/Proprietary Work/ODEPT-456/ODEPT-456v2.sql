DECLARE @HostName VARCHAR(255)
DECLARE @sql VARCHAR(4000)
DECLARE @units VARCHAR(10) = 'MB'
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
							,						    '''+ @units +'''
						   ,
							round(round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''%'',line)+1,
							(CHARINDEX(''*'',line) -1)-CHARINDEX(''%'',line)) )) as DECIMAL),0)/
							round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX(''|'',line)+1,
							(CHARINDEX(''%'',line) -1)-CHARINDEX(''|'',line)) )) as Float),0),2)*100 as ''percentFree''
						from #output
						where line like ''[A-Z][:]%''
						order by drivename'
  END

ELSE IF ( @units = 'TB' )
  BEGIN
      --script to retrieve the values in TB from PS Script output
      SET @sql = 'SELECT Rtrim(Ltrim(Substring(line,1,Charindex(''|'',line) -1))) AS drivename
						   ,CONVERT(DECIMAL(18,2),Cast(Rtrim(Ltrim(Substring(line,Charindex(''|'',line)+1,
						   (Charindex(''%'',line) -1)-Charindex(''|'',line)) )) AS DECIMAL)/1024/1024.,0) AS [capacity(GB)],
						   CONVERT(DECIMAL(18,2),Cast(Rtrim(Ltrim(Substring(line,Charindex(''%'',line)+1,(Charindex
						   (''*'',line)-1)-Charindex(''%'',line))))  AS DECIMAL) /1024/1024)  AS [freespace(GB)]
						   , '''+ @units +'''
						   ,
						 Round(
						   Round(
						   Cast(Rtrim(Ltrim(Substring(line,Charindex(''%'',line)+1,
						   (Charindex(''*'',line) -1)-Charindex(''%'',line)
						   ) ))
						   AS DECIMAL) /1024. ,2)/
						   Round(Cast(Rtrim(Ltrim(Substring(line,Charindex(''|'',line)+1,
						   (Charindex(''%'',line) -1)-Charindex(''|'',line))
						   )
						  )
						   AS FLOAT)/1024,0),4)*100 AS [percentFree]

						FROM #output
						WHERE line LIKE ''[A-Z][:]%''
						ORDER BY drivename'
  END
ELSE
  BEGIN
      --script to retrieve the values in GB from PS Script output
      SET @sql = 'SELECT Rtrim(Ltrim(Substring(line,1,Charindex(''|'',line) -1))) AS drivename
						   ,CONVERT(DECIMAL(18,2),Cast(Rtrim(Ltrim(Substring(line,Charindex(''|'',line)+1,
						   (Charindex(''%'',line) -1)-Charindex(''|'',line)) )) AS DECIMAL)/1024.,0) AS [capacity(GB)],
						   CONVERT(DECIMAL(18,2),Cast(Rtrim(Ltrim(Substring(line,Charindex(''%'',line)+1,(Charindex
						   (''*'',line)-1)-Charindex(''%'',line))))  AS DECIMAL) /1024)  AS [freespace(GB)]
						   , '''+ @units +'''
						   ,
						 Round(
						   Round(
						   Cast(Rtrim(Ltrim(Substring(line,Charindex(''%'',line)+1,
						   (Charindex(''*'',line) -1)-Charindex(''%'',line)
						   ) ))
						   AS DECIMAL) /1024. ,2)/
						   Round(Cast(Rtrim(Ltrim(Substring(line,Charindex(''|'',line)+1,
						   (Charindex(''%'',line) -1)-Charindex(''|'',line))
						   )
						  )
						   AS FLOAT)/1024,0),4)*100 AS [percentFree]

						FROM #output
						WHERE line LIKE ''[A-Z][:]%''
						ORDER BY drivename'
  END

IF Object_id('tempdb..#DriveUsage') IS NOT NULL
  DROP TABLE #DriveUsage;

CREATE TABLE #DriveUsage
  (
     [Path]    [VARCHAR](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
     [Total] [VARCHAR](20) NULL,
     [Free]  [VARCHAR](20) NULL,
	 [Size_Type]  [VARCHAR](20) NULL,
     [FreePct] [FLOAT] NULL
  ) -- WITH (DATA_COMPRESSION = PAGE);
INSERT INTO #DriveUsage
EXEC(@sql)

IF( @dryRun = 0 )
  BEGIN
      MERGE [info].[DriveUsage] AS old
      USING (SELECT [Path],
                    [Total],
                    [Free],
                    [FreePct]
             FROM   #DriveUsage) AS new ( [Path], [Total], [Free], [FreePct] )
      ON new.[Path] = old.[Path]
      WHEN MATCHED AND ( old.[Total] <> new.[Total] OR old.[Free] <> new.[Free] OR old.[FreePct] <> new.[FreePct] ) THEN
        UPDATE SET old.[Total] = new.[Total],
                   old.[Free] = new.[Free],
                   old.[FreePct] = new.[FreePct]
      WHEN NOT MATCHED THEN
        INSERT( [Path],
             [Total],
             [Free],
			 [Size_Type],
             [FreePct])
        VALUES( new.[Path],
                new.[Total],
                new.[Free],
                new.[FreePct] )
      WHEN NOT MATCHED BY SOURCE THEN
        DELETE;
  END;
ELSE
  BEGIN
      SELECT [Path],
             [Total],
             [Free],
			 [Size_Type],
             [FreePct]
      FROM   #DriveUsage;
  END; 
