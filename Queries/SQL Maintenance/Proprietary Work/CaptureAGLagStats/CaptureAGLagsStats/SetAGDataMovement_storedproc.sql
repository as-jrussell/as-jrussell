USE [DBA]
GO
/****** Object:  StoredProcedure [action].[SetAGDataMovement]    Script Date: 3/15/2023 11:46:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[action].[SetAGDataMovement]') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [action].[SetAGDataMovement] AS RETURN 0;';
END;
GO
/*

--By Default DryRun is 1 and prints the code that would be inititated when it is run.. 
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'PAUSE' , @TargetDB = 'Bond_Main'
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'RESUME' , @TargetDB = 'Bond_Main'
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'PAUSE' , @TargetAG = 'BOND-STAGE-DBs'
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'RESUME' , @TargetAG = 'BOND-STAGE-DBs'



--DryRun = 0 and executes the following 
---Pauses the database
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'PAUSE' , @TargetDB = 'Bond_Main', @DryRun =0
--Resumes the database
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'RESUME' , @TargetDB = 'Bond_Main', @DryRun =0
---Pauses the AG
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'PAUSE' , @TargetAG = 'BOND-STAGE-DBs', @DryRun =0
--Resumes the AGs
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'RESUME' , @TargetAG = 'BOND-STAGE-DBs', @DryRun =0

--Shows all the databases that could be resumed
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'RESUME' 

--Shows all the databases that could be paused 
EXEC [DBA].[action].[SetAGDataMovement] @TargetStatus = 'PAUSE' 
*/

/* Alter Stored Procedure */
ALTER PROCEDURE [action].[SetAGDataMovement] (@TargetDB     VARCHAR(150) = '',
                                              @TargetAG     VARCHAR(150) = '',
                                              @TargetStatus VARCHAR(10) = '',
                                              @Dryrun       BIT = 1,
                                              @Debug        BIT = 0)
WITH EXECUTE AS OWNER /* Should be replaced with limited account */
AS
						DECLARE @permissionadd VARCHAR(max);
						DECLARE @accountcount INT;
						DECLARE @TargetName VARCHAR(100);
						DECLARE @sqlscript VARCHAR(MAX);
						DECLARE @count INT
	BEGIN
      SET ANSI_WARNINGS OFF
	  /*
	  IF THE @TargetStatus VARIABLE ISN'T SUPPLIED THEN THE STORED PROCEDURE WILL STOP AND THROW AN ERROR
	  */
		  IF @TargetStatus IN ('PAUSE', 'RESUME') 
		  	  BEGIN 
			  	  /*
	  IF THE @TargetStatus = PAUSE WILL PROVIDE ALL THE DATABASES THAT COULD BE PAUSED
	  WHEN EITHER DB or AG ADDED TO THE SCRIPT THEN PAUSE THE DATABASE OR AG WILL BE PAUSED
	  */
				IF @TargetStatus IN ('PAUSE') 
			  BEGIN 
				  IF (@TargetDB = '' AND @TargetAG = '' )
					  BEGIN
						IF EXISTS (SELECT 1
								   FROM   sys.dm_hadr_database_replica_states drs
										  JOIN sys.availability_replicas ar
											ON ar.replica_id = drs.replica_id
								   WHERE  ar.replica_server_name = @@SERVERNAME
										  AND drs.is_suspended = 0)
						SET @TargetName = (SELECT TOP 1 database_id
											 FROM   sys.dm_hadr_database_replica_states drs
													JOIN sys.availability_replicas ar
													  ON ar.replica_id = drs.replica_id
											 WHERE  ar.replica_server_name = @@SERVERNAME
													AND drs.is_suspended = 0)

						SELECT  Db_name(database_id)[TargetDB], AG.name [TargetAG], 'ONLINE' [Status]
							FROM   sys.dm_hadr_database_replica_states drs
							JOIN sys.availability_replicas ar
							ON ar.replica_id = drs.replica_id
							JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
							WHERE  ar.replica_server_name = @@SERVERNAME
							   AND drs.is_suspended = 0;

							  SET @accountcount = @accountcount - @accountcount;
					  END
				  	IF (@TargetAG <> ''AND @TargetDB='') 
												BEGIN
				
								IF EXISTS (SELECT 1
											  FROM   sys.dm_hadr_database_replica_states DRS 
												INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
												INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
												INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
												WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc != 'NO')

								  SET @accountcount = (SELECT Count(*)
															FROM   sys.dm_hadr_database_replica_states DRS 
												INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
												INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
												INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
												WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc != 'NO')



													set @count = (SELECT Count(@accountcount));

								IF @count >= 1
								  BEGIN

								IF @accountcount <> 0
								  WHILE ( @accountcount <> 0 )
									IF @DryRun = 0
									  BEGIN
										  SET @TargetName = (SELECT DISTINCT TOP 1 ar.replica_server_name
																  FROM   sys.dm_hadr_database_replica_states DRS 
												INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
												INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
												INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
												WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc != 'NO')


				
									SELECT DISTINCT @sqlscript = 'DECLARE @SQLCMD VARCHAR(1000);
	
								SELECT DISTINCT @SQLCMD = ''USE [MASTER]  ALTER AVAILABILITY GROUP ['+@TargetAG+'] MODIFY REPLICA ON N''''' + @TargetName + '''''WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = NO))''

									   EXEC (@SQLCMD)	
	   

	  
									   '

										  EXEC  ( @sqlscript);



										  SET @accountcount = @accountcount - 1;

										   PRINT 'SUCCESS:  Secondary Server: '+@TargetName +' PAUSED ON '''+ @TargetAG +''

									  END
									ELSE
									  BEGIN
												  SET @TargetName = (SELECT TOP 1 ar.replica_server_name
																  FROM   sys.dm_hadr_database_replica_states DRS 
												INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
												INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
												INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
												WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc != 'NO')

										  SELECT DISTINCT 'USE [MASTER] ALTER AVAILABILITY GROUP ['+@TargetAG+'] MODIFY REPLICA ON N''' + ar.replica_server_name + '''WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = NO))'
									   FROM   sys.dm_hadr_database_replica_states DRS 
												INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
												INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
												INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
												WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc != 'NO'

										  SET @accountcount = @accountcount - @accountcount;
									  END 

										END
										 ELSE 

															 BEGIN 
															  PRINT 'WARNING: ALL DATABASES ARE ALREADY OFFLINE'
															 END

				END
				  	IF (@TargetAG = ''AND @TargetDB<>'') 
				    BEGIN
						SELECT @sqlscript = ' USE [master] ALTER DATABASE [' + @TargetDB + '] SET HADR SUSPEND;'
					IF @DryRun = 0
					 						  BEGIN
						  IF (SELECT 1 FROM  sys.dm_hadr_database_replica_states drs
							where  Db_name(database_id) = @TargetDB AND is_primary_replica = 1 AND is_suspended= '0') = 1 
								BEGIN 
							  EXEC (@sqlscript )
							  PRINT 'SUCCESS: [' + @TargetDB + '] DATABASE HAS BEEN PAUSED'
								END 
							ELSE
								BEGIN
							  PRINT 'WARNING: [' + @TargetDB + '] DATABASE HAS ALREADY BEEN PAUSED'								
								END 
							   END
					ELSE
					  BEGIN
						  PRINT ( @sqlscript )
					  END
					END
				END
							  	  /*
	  IF THE @TargetStatus = RESUME WILL PROVIDE ALL THE DATABASES THAT COULD BE RESUMED
	  WHEN EITHER DB or AG ADDED TO THE SCRIPT THEN RESUME THE DATABASE OR AG WILL BE RESUMED
	  */
				IF @TargetStatus IN ('RESUME') 
			  BEGIN 
				IF (@TargetDB = '' AND @TargetAG = '' )
					  BEGIN
						IF EXISTS (SELECT 1
								   FROM   sys.dm_hadr_database_replica_states drs
										  JOIN sys.availability_replicas ar
											ON ar.replica_id = drs.replica_id
								   WHERE  ar.replica_server_name = @@SERVERNAME
										  AND drs.is_suspended = 1)
						SET @TargetName = (SELECT TOP 1 database_id
											 FROM   sys.dm_hadr_database_replica_states drs
													JOIN sys.availability_replicas ar
													  ON ar.replica_id = drs.replica_id
											 WHERE  ar.replica_server_name = @@SERVERNAME
													AND drs.is_suspended = 1)

						SELECT  Db_name(database_id)[TargetDB], ag.name [TargetAG], 'PAUSED' [Status]
							FROM   sys.dm_hadr_database_replica_states drs
							JOIN sys.availability_replicas ar
							ON ar.replica_id = drs.replica_id
							JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
							WHERE  ar.replica_server_name = @@SERVERNAME
							   AND drs.is_suspended = 1;

							  SET @accountcount = @accountcount - @accountcount;
					  END
				IF (@TargetAG <> ''AND @TargetDB='') 
					  BEGIN
																	IF EXISTS (SELECT 1
																  FROM   sys.dm_hadr_database_replica_states DRS 
																	INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
																	INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
																	INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
																	WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc = 'NO')

													  SET @accountcount = (SELECT Count(*)
																				FROM   sys.dm_hadr_database_replica_states DRS 
																	INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
																	INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
																	INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
																	WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc = 'NO')



													set @count = (SELECT Count(@accountcount));

													IF @count >= 1
													  BEGIN

													IF @accountcount <> 0
													  WHILE ( @accountcount <> 0 )
														IF @DryRun = 0
														  BEGIN
															  SET @TargetName = (SELECT DISTINCT TOP 1 ar.replica_server_name
																					  FROM   sys.dm_hadr_database_replica_states DRS 
																	INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
																	INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
																	INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
																	WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc = 'NO')


				
														SELECT DISTINCT @sqlscript = 'DECLARE @SQLCMD VARCHAR(1000);
	
													SELECT DISTINCT @SQLCMD = ''USE [MASTER]  ALTER AVAILABILITY GROUP ['+@TargetAG+'] MODIFY REPLICA ON N''''' + @TargetName + '''''WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = ALL))''

														   EXEC (@SQLCMD)	
	   

	  
														   '

															  EXEC  ( @sqlscript);



															  SET @accountcount = @accountcount - 1;

															   PRINT 'SUCCESS:  Secondary Server: '+@TargetName +' RESUMED ON '''+ @TargetAG +''

														  END
														ELSE
														  BEGIN
																	  SET @TargetName = (SELECT TOP 1 ar.replica_server_name
																					  FROM   sys.dm_hadr_database_replica_states DRS 
																	INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
																	INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
																	INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
																	WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc = 'NO')

															  SELECT DISTINCT 'USE [MASTER] ALTER AVAILABILITY GROUP ['+@TargetAG+'] MODIFY REPLICA ON N''' + ar.replica_server_name + '''WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = ALL))'
														   FROM   sys.dm_hadr_database_replica_states DRS 
																	INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
																	INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id AND AR.replica_id = HARS.replica_id 
																	INNER JOIN [sys].[availability_groups] AG on AG.group_id = AR.group_id
																	WHERE AG.name = @TargetAG AND role_desc != 'PRIMARY' AND secondary_role_allow_connections_desc = 'NO'

															  SET @accountcount = @accountcount - @accountcount;
														  END 

															END
															 ELSE 

															 BEGIN 
															  PRINT 'WARNING: ALL DATABASES ARE ALREADY ONLINE'
															 END
																				  END
				 IF (@TargetDB <> '' AND @TargetAG='') 
				    BEGIN
					SELECT @sqlscript = ' USE [master] ALTER DATABASE [' + @TargetDB + '] SET HADR RESUME;'
						IF @DryRun = 0
						  BEGIN
						  IF (SELECT 1 FROM  sys.dm_hadr_database_replica_states drs
							where  Db_name(database_id) = @TargetDB  AND is_primary_replica = 1 AND is_suspended= '1') = 1 
								BEGIN 
							  EXEC (@sqlscript )
							  PRINT 'SUCCESS: [' + @TargetDB + '] DATABASE HAS BEEN RESUMED'
								END 
							ELSE
								BEGIN
							  PRINT 'WARNING: [' + @TargetDB + '] DATABASE HAS ALREADY BEEN RESUMED'								
								END 
							   END
						ELSE
						  BEGIN
							  PRINT ( @sqlscript )
						  END
					END
				END
			      END 
			ELSE
			  BEGIN 
				  PRINT 'ERROR: YOU ARE NOT USING THE CORRECT VARIABLE PLEASE UPDATE YOUR TARGET STATUS WITH EITHER PAUSE OR RESUME' 
			  END
	END