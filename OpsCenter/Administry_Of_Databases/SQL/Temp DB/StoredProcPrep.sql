DECLARE @check BIT
 
SET @check = 0 --For information set 0, for change 1
 
DECLARE @BASEPATH NVARCHAR(300)
DECLARE @SQL_SCRIPT NVARCHAR(1000)
DECLARE @CORES INT
DECLARE @FILECOUNT INT
DECLARE @SIZE INT
DECLARE @GROWTH INT
DECLARE @ISPERCENT INT
 
-- TempDB mdf count equal logical cpu count
SELECT @CORES = cpu_count FROM sys.dm_os_sys_info

 
IF @CORES BETWEEN 9 AND 31 SET @CORES = @CORES / 2
IF @CORES >= 32 SET @CORES = @CORES / 4
 
--Check and set tempdb files count are multiples of 4
IF @CORES > 8 SET @CORES = @CORES - (@CORES % 4)
 
SET @BASEPATH = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'tempdb.mdf', LOWER(physical_name)) - 1) DataFileLocation
FROM master.sys.master_files
WHERE database_id = 2 AND FILE_ID = 1)
 
SET @FILECOUNT = (SELECT COUNT(*)
FROM master.sys.master_files
WHERE database_id = 2 AND TYPE_DESC = N'ROWS')
 
SELECT @SIZE = size FROM master.sys.master_files WHERE database_id = 2 AND FILE_ID = 1
SET @SIZE = @SIZE / 128
 
SELECT @GROWTH = growth FROM master.sys.master_files WHERE database_id = 2 AND FILE_ID = 1
SELECT @ISPERCENT = is_percent_growth FROM master.sys.master_files WHERE database_id = 2 AND FILE_ID = 1
 
IF @ISPERCENT = 0 SET @GROWTH = @GROWTH * 8
 
--Current situation
IF @CORES > @FILECOUNT
BEGIN
DECLARE @EmailSubject AS VARCHAR(100)
DECLARE @body NVARCHAR(MAX)

	 SELECT @EmailSubject =  @@SERVERNAME +' needs more Temp DB data files'
	 SELECT @body = 'Needed ' + CAST(@CORES AS NVARCHAR(100)) + ' TempDB data files, now there is ' + CAST(@FILECOUNT AS NVARCHAR(100)) + CHAR(10) + CHAR(13)
 

		 EXEC msdb.dbo.sp_send_dbmail
						@recipients = 'joseph.russell@alliedsolutions.net',
						@subject = @EmailSubject,
						@body = @body

END

