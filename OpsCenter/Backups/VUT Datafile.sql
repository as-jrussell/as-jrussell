USE [master]
GO
ALTER DATABASE [VUT] MODIFY FILE ( NAME = N'VUT_Data', MAXSIZE = 404480000KB )
GO




/*

USE [VUT]
GO
DBCC SHRINKFILE (N'VUT_Data' , 372555)
GO


*/