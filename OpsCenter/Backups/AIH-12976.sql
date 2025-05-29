USE [master]
					DECLARE @permissionadd VARCHAR(max);
					DECLARE @accountcount INT; 
					DECLARE @TargetName VARCHAR(100); 
					DECLARE @DryRun INT = 0

IF EXISTS (SELECT 1 FROM sys.sql_logins where name like 'RFPLsa%')

		SET @accountcount = (SELECT COUNT(*)FROM sys.sql_logins where name like 'RFPLsa%')

						IF  @accountcount <> 0

						WHILE ( @accountcount  <> 0)
	
IF @DryRun = 0		
					BEGIN		
					
						SET @TargetName = (SELECT TOP 1 name FROM sys.sql_logins where name like 'RFPLsa%')
							SELECT @permissionadd = 'DROP LOGIN ['+ @TargetName + ']'
	 
								EXEC (@permissionadd);	
							 	PRINT 'We have dropped this account login: ' +   (@TargetName);	
								 SET @accountcount = @accountcount - 1;	
						END								

ELSE 					

	BEGIN		
					
						SET @TargetName = (SELECT top 1 name FROM sys.sql_logins where name like 'RFPLsa%')
							SELECT @permissionadd = 'DROP LOGIN ['+ @TargetName + ']'
	 
								PRINT (@permissionadd);	
							 	PRINT 'This account login will be dropped: ' +   (@TargetName);	
								 SET @accountcount = @accountcount - 1;	
						END					




					
