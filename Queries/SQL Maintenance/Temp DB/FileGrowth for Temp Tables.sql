

USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', FILEGROWTH = 10240KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', FILEGROWTH = 10240KB )
GO