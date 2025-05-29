

DEClare @FirstName varchar(100) = 'Darrin', @LastName varchar(100) = 'Test1', @TempPassword varchar(100) = 'S0m3th1ng!',  @AccountType varchar(2) = 'ad', @DryRun int = 0, @notify int = 0

	IF( @AccountType not in ('db','qa','sa', 'ad') ) -- no real permissions for QA 
	BEGIN
		 raiserror('invalid value: AccountType', 18, 0)
    return
	END

	IF OBJECT_ID('tempdb..#GrantPermission', 'U') IS NOT NULL
		DROP TABLE #GrantPermission

    /*Source Table*/
    CREATE TABLE #GrantPermission
    (
        [Command] VARCHAR(MAX),
		[PROCESSED] int
    )
    WITH (DATA_COMPRESSION = PAGE);

DECLARE @ServerENV varchar(1000), @ServerName varchar(1000), @sqlCMD varchar(MAX), @currentPermission varchar(max)
DECLARE @UserName varchar(100) = 'RFPL'+ LOWER(@AccountType) + @FirstName +'.'+ @LastName, @RecipientEmail varchar(100) = @FirstName +'.'+ @LastName +'@AlliedSolutions.net'
DECLARE @EmailBody varchar(max), @EmailSubject varchar(max)

DECLARE @CurrentUser varchar(100), @CurrentType varchar(100),@CurrentDatabase varchar(100), @CurrentDBType varchar(100), @CurrentPermissions varchar(100)

SELECT  @ServerName = @@Servername,
		@ServerENV = CASE WHEN @@SERVERNAME like '%-DEVTEST%' THEN 'DEV' 
						  WHEN @@SERVERNAME like '%-PREPROD%' THEN 'TEST'
						  WHEN @@SERVERNAME like '%-PROD%' THEN 'PROD'
						  ELSE 'UKNOWN' 
					 END



IF OBJECT_ID('tempdb..#sqlLogins', 'U') IS NOT NULL
	DROP TABLE #sqlLogins

CREATE TABLE #sqlLogins(
	AccountName varchar(100), 
	AccountType varchar(100),
	IsProcessed bit
)	

IF OBJECT_ID('tempdb..#DatabaseList', 'U') IS NOT NULL
	DROP TABLE #DatabaseList

CREATE TABLE #DatabaseList(
	DatabaseName varchar(100), 
	DatabaseType varchar(100),
	IsProcessed bit
)

INSERT INTO #DatabaseList
SELECT name, CASE WHEN name like '%_DEV' THEN 'DEV'
					WHEN name like '%_QA' THEN 'QA'
					WHEN name like '%_STG' THEN 'STG'
					WHEN name like '%_uat' THEN 'UAT'
					WHEN name like '%storage' THEN 'DEV'
					ELSE 'PROD'
				END , 0 -- SELECT *
FROM sys.databases where name like 'PRL%' or name like '%Storage'

IF( @DryRun = 1 )
	BEGIN
		PRINT '[DryRun] Displaying Permisions for: '+ @ServerENV
	END
ELSE
	BEGIN
		PRINT 'Setting Permisions for: '+ @ServerENV
	END

IF( @FirstName = '' AND @LastName = '' )
	BEGIN
		PRINT '[] Resetting all permissions';
		SET @notify = 0

		INSERT INTO #sqlLogins
		SELECT name, CASE When CharIndex('dbDeploy', name) > 0 THEN 'DEPLOY_'+ Upper(REPLACE(REPLACE(REPLACE(name, LEFT(name, CharIndex('-', name) ), ''),'Staging','STG'),'Production','PROD'))
						  When CharIndex('-', name) > 0 THEN 'APP_'+ Upper(REPLACE(REPLACE(REPLACE(name, LEFT(name, CharIndex('-', name) ), ''),'Staging','STG'),'Production','PROD'))
						  WHEN (name like 'RFPLsa%' AND name != 'RFPLSaraswati.Subedi') THEN 'ADMIN'
						  WHEN (name like 'RFPLad%' ) THEN 'SERVICE'
						  WHEN (name like 'RFPLqaAutomation%') THEN 'AUTOMATION'
						  ELSE 'USER'
					 END, 0 -- SELECT *
		FROM sys.syslogins where loginname like 'RFPL%'
	END
ELSE
	BEGIN
		SELECT @RecipientEmail = @RecipientEmail +';'+ email_address FROM MSDB.DBO.SysOperators WHERE name = 'dbAdmins'
		IF NOT EXISTS ( SELECT * from sys.syslogins where loginName = @userName )
			BEGIN
				SELECT @sqlCMD = 'USE [MASTER]; CREATE LOGIN ['+ @userName +'] WITH PASSWORD=N''S0m3th1ng!'', DEFAULT_DATABASE=[TempDB],  CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF'
				IF( @DryRun = 1 )
					BEGIN
						PRINT '[DryRun] Create Login Statement:  '+ @UserName 
						PRINT '	'+ @sqlCMD
					END
				ELSE
					BEGIN
						EXEC( @sqlCMD )
					END
			END
		ELSE
			BEGIN
				PRINT '[OK] Login exists'
			END
		INSERT INTO #sqlLogins
		SELECT @userName, CASE When CharIndex('dbDeploy', @userName) > 0 THEN 'DEPLOY_'+ Upper(REPLACE(@userName, LEFT(@userName, CharIndex('-', @userName) ), ''))
							   When CharIndex('-', @userName) > 0 THEN 'APP_'+ Upper(REPLACE(@userName, LEFT(@userName, CharIndex('-', @userName) ), ''))
							   WHEN (@userName like 'RFPLsa%' AND @userName like 'RFPLad%'  AND @userName != 'RFPLSaraswati.Subedi') THEN 'ADMIN'
							   WHEN (@userName like 'RFPLqaAutomation%') THEN 'AUTOMATION'
							   ELSE 'USER' 
						  END, 0
		
		SELECT @EmailSubject = 'New SQL authenticated account has been created on SQL instance: '+ @ServerName

		SELECT @EmailBody= '	The SQL authenticated account: '+ @UserName +' has been created on SQL instance: '+ @ServerName
		SELECT @EmailBody = @EmailBody +'
	This account will be given permissions for a '+ @ServerENV +' environment.'
	END;
		WHILE EXISTS ( SELECT TOP 1 * FROM #sqlLogins WHERE IsProcessed = 0 ORDER BY AccountType, AccountName )
			BEGIN
				PRINT ' ';
				SELECT TOP 1 @CurrentUser = AccountName, @CurrentType = AccountType FROM #sqlLogins WHERE IsProcessed = 0ORDER BY AccountType, AccountName
				PRINT '[] Processing: '+ @CurrentUser +' of Type: '+ @CurrentType

				IF( (@CurrentType like 'APP%') OR (@CurrentType like 'DEPLOY%') OR (@CurrentType like 'ADMIN%') )
					BEGIN
						IF( (@CurrentType like 'APP%') OR (@CurrentType like 'DEPLOY%') ) -- DROP databases that do not match account type
							BEGIN
								UPDATE #DatabaseList SET IsProcessed = 1 WHERE DatabaseName NOT LIKE REPLACE(REPLACE(@CurrentType, 'APP', '%'),'DEPLOY','%')
							END;

						--IF( (@CurrentUser like '%WEBAPP%') OR (@CurrentType like 'DEPLOY%') )
						--	BEGIN
								/* This should be a set role with limited access to required objects */
								SELECT @sqlCMD = 'USE [MASTER]; 
								IF NOT EXISTS( SELECT  pr.name AS LOGINNAME, pe.permission_name AS PERMISSIONNAME
												FROM sys.server_principals AS pr   
												JOIN sys.server_permissions AS pe ON pe.grantee_principal_id = pr.principal_id
												WHERE pr.name = '''+ @CurrentUser +''' AND  pe.permission_name = ''VIEW SERVER STATE'')
									BEGIN	
										SELECT ''USE [MASTER]; GRANT VIEW SERVER STATE TO ['+ @CurrentUser +'];'', 0 
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)
							--END
					END;

				WHILE EXISTS ( SELECT TOP 1 * FROM #DatabaseList WHERE IsProcessed = 0 ORDER BY DatabaseType, DatabaseName )
					BEGIN
						SELECT TOP 1 @CurrentDatabase = DatabaseName, @CurrentDBType = DatabaseType FROM #DatabaseList WHERE IsProcessed = 0 ORDER BY DatabaseType, DatabaseName

						IF( (@CurrentType like 'AUTOMATION%') AND (@CurrentDatabase like '%Storage') )
							BEGIN
								PRINT '	Skipping Storage Database' -- Skipping this database in an ugly way.
							END
						ELSE

							BEGIN
								PRINT '	Processing: '+ @CurrentDatabase
								SET @sqlCMD = 'USE ['+ @CurrentDatabase +'];
								IF NOT EXISTS (SELECT name FROM [sys].[database_principals] WHERE name = N'''+ @CurrentUser +''')
									BEGIN
										IF( '+ convert(varchar(10), @dryRun) +' = 1 )
											BEGIN
												PRINT ''	USE ['+ @CurrentDatabase +'];CREATE USER ['+ @CurrentUser +'] FOR LOGIN ['+ @CurrentUser +'] WITH DEFAULT_SCHEMA=[dbo]''
											END
										ELSE
											BEGIN
												CREATE USER ['+ @CurrentUser +'] FOR LOGIN ['+ @CurrentUser +'] WITH DEFAULT_SCHEMA=[dbo]
											END
									END;'
								--PRINT @SQLCMD
								EXEC (@sqlCMD)
							END

						IF( (@CurrentUser like '%winsvc%') AND ((@CurrentDatabase like '%DATAHUB%') OR (@CurrentDatabase like '%AllIEDSYS%')) )
							BEGIN
								SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
								IF NOT EXISTS( SELECT pr.principal_id, pr.name, pr.type_desc,   
													pr.authentication_type_desc, pe.state_desc,   
													pe.permission_name 
												FROM sys.database_principals AS pr  
												JOIN sys.database_permissions AS pe  
													ON pe.grantee_principal_id = pr.principal_id  
												where pr.name ='''+ @CurrentUser +''' and pe.permission_name = ''execute'')
									BEGIN	
										SELECT ''USE ['+ @CurrentDatabase +']; GRANT EXECUTE TO ['+ @CurrentUser +'];'', 0 
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)
							END

						IF( @CurrentType like 'APP%' )
							BEGIN
								IF( @CurrentUser like '%webapp%' )
									BEGIN
										SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
										IF NOT EXISTS( SELECT pr.principal_id, pr.name, pr.type_desc,   
															pr.authentication_type_desc, pe.state_desc,   
															pe.permission_name 
														FROM sys.database_principals AS pr  
														JOIN sys.database_permissions AS pe  
															ON pe.grantee_principal_id = pr.principal_id  
														where pr.name ='''+ @CurrentUser +''' and pe.permission_name = ''execute'')
											BEGIN	
												SELECT ''USE ['+ @CurrentDatabase +']; GRANT EXECUTE TO ['+ @CurrentUser +'];'', 0 
											END;'
										INSERT INTO #GrantPermission
										EXEC( @sqlcmd)
									END

								SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
								IF NOT EXISTS( SELECT
									dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
									FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
									where p.name ='''+ @CurrentUser +''' and pp.name = ''db_datareader'')
									BEGIN
										SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_datareader] ADD MEMBER ['+ @CurrentUser +'];'', 0
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)

								SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
								IF NOT EXISTS( SELECT
									dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
									FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
									where p.name ='''+ @CurrentUser +''' and pp.name = ''db_datawriter'')
									BEGIN	
										SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_datawriter] ADD MEMBER ['+ @CurrentUser +'];'', 0 
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)
							END
						ELSE IF( @CurrentType like 'DEPLOY%' ) -- DB_OWNER 
							BEGIN
								SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
								IF NOT EXISTS( SELECT
									dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
									FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
									where p.name ='''+ @CurrentUser +''' and pp.name = ''db_owner'')
									BEGIN
										SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_owner] ADD MEMBER ['+ @CurrentUser +'];'', 0
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)
							END
						ELSE IF( @CurrentType like 'AUTOMATION%' )  -- db_datareader 
							BEGIN
								IF( @CurrentDatabase NOT like '%Storage' )
									BEGIN
										SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
										IF NOT EXISTS( SELECT
											dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
											FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
											where p.name ='''+ @CurrentUser +''' and pp.name = ''db_datareader'')
											BEGIN
												SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_datareader] ADD MEMBER ['+ @CurrentUser +'];'', 0
											END;'
										INSERT INTO #GrantPermission
										EXEC( @sqlcmd)
									END
							END
						ELSE IF( (@CurrentType like 'ADMIN%')  ) -- DB_OWNER in DEV/QA
							BEGIN
								SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
								IF NOT EXISTS( SELECT
									dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
									FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
									where p.name ='''+ @CurrentUser +''' and pp.name = ''db_owner'')
									BEGIN
										SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_owner] ADD MEMBER ['+ @CurrentUser +'];'', 0
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)
							END
						ELSE -- no differences in developer OR QA permissions at this point.
							BEGIN
								IF( @CurrentDatabase like '%_DEV' )
									BEGIN
										SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
										IF NOT EXISTS( SELECT
											dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
											FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
											where p.name ='''+ @CurrentUser +''' and pp.name = ''db_owner'')
											BEGIN
												SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_owner] ADD MEMBER ['+ @CurrentUser +'];'', 0
											END;'
										INSERT INTO #GrantPermission
										EXEC( @sqlcmd)
									END;

								IF( @CurrentDatabase like '%_QA' )
									BEGIN
										SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
										IF NOT EXISTS( SELECT
											dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
											FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
											where p.name ='''+ @CurrentUser +''' and pp.name = ''db_datawriter'')
											BEGIN
												SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_datawriter] ADD MEMBER ['+ @CurrentUser +'];'', 0
											END;'
										INSERT INTO #GrantPermission
										EXEC( @sqlcmd)
									END;

								IF( (@CurrentDatabase like '%_QA') OR (@CurrentDatabase like '%_UAT') OR (@CurrentDatabase like '%_STG'))
									BEGIN
										SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
										IF NOT EXISTS( SELECT pr.principal_id, pr.name, pr.type_desc,   
															pr.authentication_type_desc, pe.state_desc,   
															pe.permission_name 
														FROM sys.database_principals AS pr  
														JOIN sys.database_permissions AS pe  
															ON pe.grantee_principal_id = pr.principal_id  
														where pr.name ='''+ @CurrentUser +''' and pe.permission_name = ''execute'')
											BEGIN	
												SELECT ''USE ['+ @CurrentDatabase +']; GRANT EXECUTE TO ['+ @CurrentUser +'];'', 0 
											END;'
										INSERT INTO #GrantPermission
										EXEC( @sqlcmd)
									END
								/* PROD PERMISSIONS */
								SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
								IF NOT EXISTS( SELECT
									dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
									FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
									LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
									where p.name ='''+ @CurrentUser +''' and pp.name = ''db_datareader'')
									BEGIN
										SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_datareader] ADD MEMBER ['+ @CurrentUser +'];'', 0
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)

								SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
								IF NOT EXISTS( SELECT pr.principal_id, pr.name, pr.type_desc,   
													pr.authentication_type_desc, pe.state_desc,   
													pe.permission_name 
												FROM sys.database_principals AS pr  
												JOIN sys.database_permissions AS pe  
													ON pe.grantee_principal_id = pr.principal_id  
												where pr.name ='''+ @CurrentUser +''' and pe.permission_name = ''View Definition'')
									BEGIN
										SELECT ''USE ['+ @CurrentDatabase +']; GRANT VIEW DEFINITION TO ['+ @CurrentUser +'];'', 0
									END;'
								INSERT INTO #GrantPermission
								EXEC( @sqlcmd)

								IF( @CurrentDatabase like '%Storage' )
									BEGIN
										SELECT @sqlCMD = 'USE ['+ @CurrentDatabase +']; 
										IF NOT EXISTS( SELECT
											dbname=db_name(db_id()),p.name as UserName, pp.name as PermissionLevel
											FROM sys.database_role_members roles  -- select * from sys.database_role_members roles LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
											LEFT JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
											where p.name ='''+ @CurrentUser +''' and pp.name = ''db_owner'')
											BEGIN
												SELECT ''USE ['+ @CurrentDatabase +']; ALTER ROLE [db_owner] ADD MEMBER ['+ @CurrentUser +'];'', 0
											END;'
										INSERT INTO #GrantPermission
										EXEC( @sqlcmd)
									END
	
							END

						UPDATE #DatabaseList SET IsProcessed = 1 WHERE DatabaseName = @CurrentDatabase AND DatabaseType = @CurrentDBType
					END
				
				PRINT '[] - Permissions to be Granted:'
				WHILE EXISTS ( SELECT * FROM #GrantPermission WHERE PROCESSED = 0 )
				BEGIN
					SELECT TOP 1 @currentPermission = Command FROM #GrantPermission WHERE PROCESSED = 0
					IF( @DryRun = 1 )
						BEGIN
							PRINT '	'+ @currentPermission
						END
					ELSE
						BEGIN
							EXEC( @currentPermission )
						END

					UPDATE #GrantPermission SET Processed = 1 WHERE Command = @currentPermission
				END;

				UPDATE #sqlLogins SET IsProcessed = 1 WHERE AccountName = @CurrentUser AND AccountType = @CurrentType
				UPDATE #DatabaseList SET IsProcessed = 0
			END


			 SELECT * FROM  #GrantPermission	
			 select @ServerName, @ServerENV
			 select * from  #sqlLogins
			 select * from #DatabaseList