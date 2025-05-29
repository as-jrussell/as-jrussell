USE [master]


IF EXISTS (SELECT * from sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
			join sys.databases D on D.database_id = A.database_id 
			WHERE A.type = '0' AND  max_size!='-1' AND D.name = 'PRL_DATAHUB_PROD') 
BEGIN
	ALTER DATABASE [PRL_DATAHUB_PROD] MODIFY FILE ( NAME = N'data_0', MAXSIZE = UNLIMITED)
		PRINT 'PRL_DATAHUB_PROD Successfully moved to unlimited'
END
ELSE 
BEGIN 
	PRINT 'WARNING: No database name PRL_DATAHUB_PROD exist or size already move to unlimited please check!'
END


IF EXISTS (SELECT * from sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
			join sys.databases D on D.database_id = A.database_id 
			WHERE A.type = '0' AND  max_size!='-1'  AND D.name = 'PRL_ALLIEDSYS_PROD')  
BEGIN
	ALTER DATABASE [PRL_ALLIEDSYS_PROD] MODIFY FILE ( NAME = N'data_0', MAXSIZE = UNLIMITED)

		PRINT 'PRL_ALLIEDSYS_PROD Successfully moved to unlimited'
END
ELSE 
BEGIN 
	PRINT 'WARNING: No database name PRL_ALLIEDSYS_PROD exist or size already move to unlimited please check!'
END


IF EXISTS (SELECT * from sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
			join sys.databases D on D.database_id = A.database_id 
			WHERE A.type = '0' AND  max_size!='-1' AND D.name = 'PRL_LENDER_PROD') 
BEGIN
	ALTER DATABASE [PRL_LENDER_PROD] MODIFY FILE ( NAME = N'data_0', MAXSIZE = UNLIMITED)
		PRINT 'PRL_LENDER_PROD Successfully moved to unlimited'
END
ELSE 
BEGIN 
	PRINT 'WARNING: No database name PRL_LENDER_PROD exist or size already move to unlimited please check!'
END




IF EXISTS (SELECT * from sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
			join sys.databases D on D.database_id = A.database_id 
			WHERE A.type = '0' AND  max_size!='-1' AND D.name = 'PRL_USERS_PROD') 
BEGIN
	ALTER DATABASE [PRL_USERS_PROD] MODIFY FILE ( NAME = N'data_0', MAXSIZE = UNLIMITED)
	ALTER DATABASE [PRL_USERS_PROD] MODIFY FILE ( NAME = N'log', MAXSIZE = UNLIMITED)
		PRINT 'PRL_USERS_PROD Successfully moved to unlimited'
END
ELSE 
BEGIN 
	PRINT 'WARNING: No database name PRL_USERS_PROD exist or size already move to unlimited please check!'
END