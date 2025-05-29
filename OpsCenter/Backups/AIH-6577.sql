
IF EXISTS (select * from sys.server_principals where name = 'svcPIMStest')
BEGIN 
USE RepoPlusAnalytics
	ALTER SERVER ROLE [sysadmin] DROP MEMBER [svcPIMStest]

	

	ALTER ROLE [db_datareader] ADD MEMBER [svcPIMStest]

	

	ALTER ROLE [db_datawriter] ADD MEMBER [svcPIMStest]

	

	ALTER ROLE [db_owner] DROP MEMBER [svcPIMStest]

	
	grant execute to [svcPIMStest]

			PRINT 'svcPIMStest has been removed from SYSADMIN ROLE, and DB_OWNER on RepoPlusAnalytics DB. 
					svcPIMStest has been granted datawriter and datareader access'
END

ELSE

BEGIN

			PRINT 'svcPIMStest does not exist please check the logins'
END 

USE [RepoPlusAnalytics]
GO

IF EXISTS (SELECT * FROM sys.database_principals where name = 'REPO_APP_ACCESS')
	BEGIN
		DECLARE @RoleName sysname
		set @RoleName = N'REPO_APP_ACCESS'

		IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
		BEGIN
			DECLARE @RoleMemberName sysname
			DECLARE Member_Cursor CURSOR FOR
			select [name]
			from sys.database_principals 
			where principal_id in ( 
				select member_principal_id
				from sys.database_role_members
				where role_principal_id in (
					select principal_id
					FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

			OPEN Member_Cursor;

			FETCH NEXT FROM Member_Cursor
			into @RoleMemberName
    
			DECLARE @SQL NVARCHAR(4000)

			WHILE @@FETCH_STATUS = 0
			BEGIN
        
				SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
				EXEC(@SQL)
        
				FETCH NEXT FROM Member_Cursor
				into @RoleMemberName
			END;

			CLOSE Member_Cursor;
			DEALLOCATE Member_Cursor;
		END
		/****** Object:  DatabaseRole [REPO_APP_ACCESS]    Script Date: 7/28/2021 8:23:57 PM ******/
		DROP ROLE [REPO_APP_ACCESS]
	 PRINT 'REPO_APP_ACCESS has been removed'
END
	ELSE 
BEGIN
	PRINT 'REPO_APP_ACCESS does not exist please check the ROLES on RepoPlusAnalytics Database'
END 



USE [RepoPlusAnalytics]
IF EXISTS (select * from sys.server_principals where name = 'ELDREDGE_A\SvcClmIsoImport')
BEGIN
		DROP USER [ELDREDGE_A\SvcClmIsoImport]
		USE [master]
		DROP LOGIN [ELDREDGE_A\SvcClmIsoImport]
		PRINT 'ELDREDGE_A\SvcClmIsoImport User Dropped'
END
ELSE 
BEGIN
		PRINT 'ELDREDGE_A\SvcClmIsoImport does not exist please check the account name'
END 


