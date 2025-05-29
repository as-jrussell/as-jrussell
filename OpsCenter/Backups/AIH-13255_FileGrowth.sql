USE [master]


IF EXISTS (SELECT 1
           FROM   sys.master_files
           WHERE  name = 'Applog' AND growth/128 = 1)
BEGIN
			ALTER DATABASE [AppLog] MODIFY FILE ( NAME = N'AppLog', FILEGROWTH = 1GB )
			PRINT 'SUCCESS: FileGrowth increased to 1 GB'
END
	ELSE
BEGIN
			PRINT 'WARNING: FileGrowth was not altered please check your settings'
END
