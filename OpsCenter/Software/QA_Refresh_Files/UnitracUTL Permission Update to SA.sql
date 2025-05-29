USE [master]
					DECLARE @permissionadd VARCHAR(max);
					DECLARE @accountcount INT; 
					DECLARE @TargetName VARCHAR(100); 
					DECLARE @DryRun INT = 1

IF EXISTS (SELECT 1 FROM sys.databases where  (suser_sname( owner_sid ) <> 'sa' OR suser_sname( owner_sid ) IS NULL) AND (database_id >=5 AND  name != 'DBA') )

		SET @accountcount = (SELECT COUNT(*) FROM sys.databases where  (suser_sname( owner_sid ) <> 'sa' OR suser_sname( owner_sid ) IS NULL) AND (database_id >=5 AND  name != 'DBA') )

						IF  @accountcount <> 0

						WHILE ( @accountcount  <> 0)
	
IF @DryRun = 0		
					BEGIN		
					
						SET @TargetName = (SELECT TOP 1 name FROM sys.databases where  (suser_sname( owner_sid ) <> 'sa' OR suser_sname( owner_sid ) IS NULL) AND (database_id >=5))
							SELECT @permissionadd = 'ALTER AUTHORIZATION ON DATABASE:: ['+ @TargetName + '] TO [SA]'
	 
								EXEC (@permissionadd);	
							 	PRINT 'The following database has been moved to the owner of SA: ' +   (@TargetName);	
								 SET @accountcount = @accountcount - 1;	
						END								

ELSE 					

	BEGIN		
					
						SET @TargetName = (SELECT top 1 name FROM sys.databases where  (suser_sname( owner_sid ) <> 'sa' OR suser_sname( owner_sid ) IS NULL) AND (database_id >=5 ))
							SELECT @permissionadd = 'ALTER AUTHORIZATION ON DATABASE:: ['+ @TargetName + '] TO [SA]'
	 
								PRINT (@permissionadd);	
							 	PRINT 'The following database will be moved to the owner of SA: ' +   (@TargetName);	
								 SET @accountcount = @accountcount - 1;	
						END					


