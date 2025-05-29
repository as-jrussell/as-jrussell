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
 
--PRINT 'Logical CPU count ' + CAST(@CORES AS NVARCHAR(100))
 
IF @CORES BETWEEN 9 AND 31 SET @CORES = @CORES / 2
IF @CORES = 32 SET @CORES = @CORES / 4
 
--Check and set tempdb files count are multiples of 4
IF @CORES = 8 SET @CORES = @CORES - (@CORES % 4)
 
--SET @BASEPATH = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'tempdb.mdf', LOWER(physical_name)) - 1) DataFileLocation
--FROM master.sys.master_files
--WHERE database_id = 2 AND FILE_ID = 1)
 
SET @FILECOUNT = (SELECT COUNT(*)
FROM master.sys.master_files
WHERE database_id = 2 AND TYPE_DESC = N'ROWS')
 
SELECT @SIZE = size FROM master.sys.master_files WHERE database_id = 2 AND FILE_ID = 1
SET @SIZE = @SIZE / 128
 
SELECT @GROWTH = growth FROM master.sys.master_files WHERE database_id = 2 AND FILE_ID = 1
SELECT @ISPERCENT = is_percent_growth FROM master.sys.master_files WHERE database_id = 2 AND FILE_ID = 1
 
IF @ISPERCENT = 0 SET @GROWTH = @GROWTH * 8
 
--Current situation
PRINT 'Needed ' + CAST(@CORES AS NVARCHAR(100)) + ' TempDB data files, now there is ' + CAST(@FILECOUNT AS NVARCHAR(100)) + CHAR(10) + CHAR(13)
 
--IF @check = 1 AND @CORES = @FILECOUNT PRINT 'Commands listed below will be executed' + CHAR(10) + CHAR(13)
--IF @check = 0 AND @CORES = @FILECOUNT PRINT 'Commands listed below will NOT be executed' + CHAR(10) + CHAR(13)
 
--WHILE @CORES = @FILECOUNT
--BEGIN
--                SET @SQL_SCRIPT = N'ALTER DATABASE tempdb
--                ADD FILE (
--                               FILENAME = ''' + @BASEPATH + 'tempdb' + RTRIM(CAST(@CORES AS NCHAR)) + '.ndf'',
--                               NAME = tempdev' + RTRIM(CAST(@CORES AS NCHAR)) + ',
--                               SIZE = ' + RTRIM(CAST(@SIZE AS NCHAR)) + 'MB,
--                               FILEGROWTH = ' + RTRIM(CAST(@GROWTH AS NCHAR))
--                IF @ISPERCENT = 1 SET @SQL_SCRIPT = @SQL_SCRIPT + '%' ELSE SET @SQL_SCRIPT = @SQL_SCRIPT + 'KB'         
--                SET @SQL_SCRIPT = @SQL_SCRIPT + ')'
--                IF @check = 1 EXEC(@SQL_SCRIPT)      
--                PRINT @SQL_SCRIPT
--                SET @CORES = @CORES - 1
--END






