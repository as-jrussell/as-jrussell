USE [master]


IF EXISTS (select 1 from sys.availability_groups  WHERE name = 'UTAG')
BEGIN 
IF EXISTS (select 1 from sys.databases WHERE name = 'IND_AlliedSolutions_157GIC109')
	BEGIN 
			ALTER AVAILABILITY GROUP [UTAG]
			REMOVE DATABASE [IND_AlliedSolutions_157GIC109];
			PRINT 'SUCCESS: Dropped from AG'
	END 
END 



IF EXISTS (select 1 from sys.databases WHERE name = 'IND_AlliedSolutions_157GIC109')
BEGIN 
		ALTER DATABASE [IND_AlliedSolutions_157GIC109] SET  OFFLINE
		PRINT 'SUCCESS: Set to Offline'
END










