DECLARE @TargetDB varchar(100) = 'iqq_live' 
DECLARE @Username SYSNAME = 'IQQBILLS-QA'
DECLARE @Password SYSNAME  = 'Password in CyberArk'
DECLARE @SqlCheckLogin NVARCHAR(MAX)
DECLARE @SqlCreateLogin NVARCHAR(MAX)
DECLARE @DryRun INT = 0




SET @SqlCheckLogin = 'SELECT name FROM sys.sql_logins WHERE name = ' + QUOTENAME(@Username,'''')

SET @SqlCreateLogin = '

IF NOT EXISTS (' + @SqlCheckLogin + ')
    BEGIN
        CREATE LOGIN ' + QUOTENAME(@Username) + ' WITH PASSWORD = ' + QUOTENAME(@Password,'''') + '
    END
ELSE
    BEGIN
        ALTER LOGIN ' + QUOTENAME(@Username) + ' WITH PASSWORD = ' + QUOTENAME(@Password,'''') + '
    END
USE '+ @TargetDB +';
ALTER USER ' + QUOTENAME(@Username) + ' WITH LOGIN = ' + QUOTENAME(@Username,']''')


IF @DryRun = 0
	BEGIN 
		EXEC (@SqlCreateLogin)
	END
ELSE
	BEGIN 
		PRINT (@SqlCheckLogin)
		PRINT (@SqlCreateLogin)
	
	END




