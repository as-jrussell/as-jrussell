USE [OCR]
GO

/****** Object:  Login [ELDREDGE_A\magarwal]    Script Date: 3/22/2022 2:51:24 PM ******/

IF EXISTS (SELECT * FROM sys.database_principals where name = 'ELDREDGE_A\magarwal')
BEGIN
	DROP USER [ELDREDGE_A\magarwal]
	PRINT 'SUCCESS: USER for ELDREDGE_A\magarwal has been dropped!!!'
END
ELSE
BEGIN
	PRINT 'WARNING: Please check the user account'
END


USE [OCR]
GO

DECLARE @RoleName sysname
set @RoleName = N'Osprey_APP_ACCESS'

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

    BEGIN
        
		DROP ROLE [Osprey_APP_ACCESS]
		PRINT 'SUCCESS: ROLE for Osprey_APP_ACCESS has been dropped!!!'
    END;
END
 
ELSE

BEGIN 

 PRINT 'WARNING: Please check the Role'

END




USE [master]
GO




/****** Object:  Login [ELDREDGE_A\magarwal]    Script Date: 3/22/2022 2:51:24 PM ******/
IF EXISTS (SELECT * FROM sys.server_principals where name = 'ELDREDGE_A\magarwal')
BEGIN

		DECLARE @loginNameToDrop sysname
		SET @loginNameToDrop = 'ELDREDGE_A\magarwal';

		DECLARE sessionsToKill CURSOR FAST_FORWARD FOR
			SELECT session_id
			FROM sys.dm_exec_sessions
			WHERE login_name = @loginNameToDrop
		OPEN sessionsToKill

		DECLARE @sessionId INT
		DECLARE @statement NVARCHAR(200)

		FETCH NEXT FROM sessionsToKill INTO @sessionId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT 'Killing session ' + CAST(@sessionId AS NVARCHAR(20)) + ' for login ' + @loginNameToDrop

			SET @statement = 'KILL ' + CAST(@sessionId AS NVARCHAR(20))
			EXEC sp_executesql @statement

			FETCH NEXT FROM sessionsToKill INTO @sessionId
		END

		CLOSE sessionsToKill
		DEALLOCATE sessionsToKill

		PRINT 'Dropping login ' + @loginNameToDrop
		SET @statement = 'DROP LOGIN [' + @loginNameToDrop + ']'
		EXEC sp_executesql @statement
END
ELSE
BEGIN
	PRINT 'WARNING: Please check the login account'
END

