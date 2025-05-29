
					DECLARE @permissionadd VARCHAR(max);
					DECLARE @accountcount INT; 
					DECLARE @TargetName VARCHAR(100); 
					DECLARE @DryRun INT = 0

IF EXISTS (SELECT 1 FROM sys.database_principals where  name like 'RFPLdb%' and name not like '%-%' and name not in ('RFPLdbJiayun.You','RFPLdbAston','RFPLdbAston.','RFPLdbJoseph.Russell'))

		SET @accountcount = (SELECT COUNT(*)FROM sys.database_principals where  name like 'RFPLdb%' and name not like '%-%' and name not in ('RFPLdbJiayun.You','RFPLdbAston','RFPLdbAston.','RFPLdbJoseph.Russell'))

						IF  @accountcount <> 0

						WHILE ( @accountcount  <> 0)
	
IF @DryRun = 0		
					BEGIN		
				
						SET @TargetName = (SELECT TOP 1 name FROM sys.database_principals where name like 'RFPLdb%' and name not like '%-%' and name not in ('RFPLdbJiayun.You','RFPLdbAston','RFPLdbAston.','RFPLdbJoseph.Russell'))
							SELECT @permissionadd = ' USE [?] 
							IF EXISTS (SELECT 1 FROM sys.database_principals where  name like ''RFPLdb%'' and name not like ''%-%'' and name not in (''RFPLdbJiayun.You'',''RFPLdbAston'',''RFPLdbAston.'',''RFPLdbJoseph.Russell''))
							USE [?] DROP USER ['+ @TargetName + ']						
							'


	 							 exec sp_MSforeachdb @permissionadd;	
						
								 SET @accountcount = @accountcount - 1;	
															
						END
ELSE 					

	BEGIN		
					
						SET @TargetName = (SELECT top 1 name FROM sys.database_principals where  name like 'RFPLdb%' and name not like '%-%' and name not in ('RFPLdbJiayun.You','RFPLdbAston','RFPLdbAston.','RFPLdbJoseph.Russell'))
							SELECT @permissionadd = 'USE [?] DROP USER ['+ @TargetName + ']'
	 
								PRINT (@permissionadd);	
							 	PRINT 'This account login will be dropped: ' +   (@TargetName);	
								 SET @accountcount = @accountcount - 1;	
						END					

