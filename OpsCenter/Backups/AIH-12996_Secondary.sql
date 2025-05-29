USE [master]




IF EXISTS (select 1 from sys.databases WHERE name = 'IND_AlliedSolutions_157GIC109')
BEGIN 
		ALTER DATABASE [IND_AlliedSolutions_157GIC109] SET  OFFLINE
		PRINT 'SUCCESS: Set to Offline'
END










