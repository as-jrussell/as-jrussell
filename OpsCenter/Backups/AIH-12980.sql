USE [master]
					DECLARE @permissionadd VARCHAR(max);
					DECLARE @accountcount INT; 
					DECLARE @TargetName VARCHAR(100); 
					DECLARE @DryRun INT = 1

IF EXISTS (SELECT 1 FROM sys.sql_logins where name like 'RFPLdb%' and name not like '%-%')

		SET @accountcount = (SELECT COUNT(*) FROM sys.sql_logins where name like 'RFPLdb%' and name not like '%-%')

						IF  @accountcount <> 0

						WHILE ( @accountcount  <> 0)
	
IF @DryRun = 0		
					BEGIN		
					
						SET @TargetName = (SELECT TOP 1 name  FROM sys.sql_logins where name like 'RFPLdb%' and name not like '%-%')
							SELECT @permissionadd = 'DROP LOGIN ['+ @TargetName + ']'
	 
								EXEC (@permissionadd);	
							 	PRINT 'This account login have been dropped: ' +   (@TargetName);	
								 SET @accountcount = @accountcount - 1;	
						END								

ELSE 					

	BEGIN		
					
						SET @TargetName = (SELECT top 1 name  FROM sys.sql_logins where name like 'RFPLdb%' and name not like '%-%')
							SELECT @permissionadd = 'DROP LOGIN ['+ @TargetName + ']'
	 
								PRINT (@permissionadd);	
							 	PRINT 'This account login will be dropped: ' +   (@TargetName);	
								 SET @accountcount = @accountcount - 1;	
						END					


