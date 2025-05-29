


USE [UniTrac]
GO

REVOKE EXECUTE ON [dbo]. [Support_SaveUserForMaintenance] TO  [TBDELETED_APP_ACCESS] 
REVOKE EXECUTE ON [dbo]. [Support_GetUsersForMaintenance] TO  [TBDELETED_APP_ACCESS] 
ALTER ROLE [TBDELETED_APP_ACCESS]  drop MEMBER [ELDREDGE_A\svc_idnw_utrc_prd01] ;
ALTER ROLE [db_datareader]  drop  MEMBER [ELDREDGE_A\svc_idnw_utrc_prd01] ;
ALTER ROLE [db_datawriter]  drop  MEMBER [ELDREDGE_A\svc_idnw_utrc_prd01] ;
DROP USER [ELDREDGE_A\svc_idnw_utrc_prd01] 

DECLARE @RoleName sysname
set @RoleName = N'TBDELETED_APP_ACCESS'

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
/****** Object:  DatabaseRole [TBDELETED_APP_ACCESS]    Script Date: 2/8/2022 11:55:00 AM ******/
DROP ROLE [TBDELETED_APP_ACCESS]
GO



USE [master]
GO

/****** Object:  Login [ELDREDGE_A\svc_idnw_utrc_prd01]    Script Date: 2/8/2022 11:53:46 AM ******/
DROP LOGIN [ELDREDGE_A\svc_idnw_utrc_prd01]
GO
