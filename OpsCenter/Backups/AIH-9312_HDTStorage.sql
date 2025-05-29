
DECLARE @Database nvarchar(20) = 'HDTStorage'



IF EXISTS(SELECT 1 FROM sys.databases where name = @Database )
BEGIN
	
		ALTER DATABASE [HDTStorage] MODIFY FILE ( NAME = HDTStorage_log, FILENAME = 'E:\MSSQL\LOGS\HDTStorage_log.ldf')
		ALTER DATABASE [HDTStorage] MODIFY FILE ( NAME = HDTStorage, FILENAME = 'E:\MSSQL\Data\HDTStorage.mdf')
		PRINT 'SUCCESSFUL: '+   @Database + ' file path has been updated in database'
END
	ELSE
BEGIN
		PRINT 'WARNING: '+  @Database + ' has not been touched!'
END

IF EXISTS(SELECT 1 FROM sys.master_files where name = @Database  AND physical_name like '%HDTStorage%')
BEGIN
	ALTER DATABASE [HDTStorage] SET OFFLINE
	PRINT 'SUCCESSFUL: '+   @Database + ' is offline ready to be moved!'
END
	ELSE
BEGIN
		PRINT 'WARNING: '+  @Database + ' has not been touched!'
END




/* Once the files moved


DECLARE @Database nvarchar(20) = 'HDTStorage'

IF EXISTS (SELECT 1  FROM sys.databases f where name = @Database  and state_desc = 'OFFLINE')

BEGIN
	ALTER DATABASE [HDTStorage] SET ONLINE
	PRINT 'SUCCESSFUL: '+   @Database + ' is back online!'

END
	ELSE
BEGIN
		PRINT 'WARNING: '+  @Database + ' has not been touched!'
END

*/