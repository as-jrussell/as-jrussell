
DECLARE @Database nvarchar(20) = 'Perfstats'



IF EXISTS(SELECT 1 FROM sys.databases where name = @Database )
BEGIN
		ALTER DATABASE [PerfStats] MODIFY FILE ( NAME = PerfStats, FILENAME = 'E:\MSSQL\Data\PerfStats.mdf')
		ALTER DATABASE [PerfStats] MODIFY FILE ( NAME = PerfStats_log, FILENAME = 'E:\MSSQL\LOGS\PerfStats_log.ldf')
		PRINT 'SUCCESSFUL: '+   @Database + ' file path has been updated in database'
END
	ELSE
BEGIN
		PRINT 'WARNING: '+  @Database + ' has not been touched!'
END

IF EXISTS(SELECT 1 FROM sys.master_files where name = @Database  AND physical_name like '%PerfStats%')
BEGIN
	ALTER DATABASE [PerfStats] SET OFFLINE
	PRINT 'SUCCESSFUL: '+   @Database + ' is offline ready to be moved!'
END
	ELSE
BEGIN
		PRINT 'WARNING: '+  @Database + ' has not been touched!'
END



/* Once the files moved


DECLARE @Database nvarchar(20) = 'Perfstats'

IF EXISTS (SELECT 1  FROM sys.databases f where name = @Database  and state_desc = 'OFFLINE')

BEGIN
	ALTER DATABASE [Perfstats] SET ONLINE
	PRINT 'SUCCESSFUL: '+   @Database + ' is back online!'

END
	ELSE
BEGIN
		PRINT 'WARNING: '+  @Database + ' has not been touched!'
END

*/