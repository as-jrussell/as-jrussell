  
EXEC sp_MSforeachdb 'USE [?] IF EXISTS (select * FROM sys.database_principals where name = ''ELDREDGE_A\SQL_centerpoint_development_team'')
	BEGIN 
	DROP USER [ELDREDGE_A\SQL_centerpoint_development_team]
	END'





	  
EXEC sp_MSforeachdb 'USE [?] IF EXISTS (select * FROM sys.database_principals where name = ''ELDREDGE_A\IT Development'')
	BEGIN 
	DROP USER [ELDREDGE_A\IT Development]
	END'




IF EXISTS (select * FROM sys.server_principals where name = 'ELDREDGE_A\IT Development')
	BEGIN 
	DROP LOGIN [ELDREDGE_A\IT Development]
	END


IF EXISTS (select * FROM sys.server_principals where name = 'ELDREDGE_A\SQL_centerpoint_development_team')
	BEGIN 
	DROP LOGIN [ELDREDGE_A\SQL_centerpoint_development_team]
	END




