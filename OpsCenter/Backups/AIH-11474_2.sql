DECLARE @sqlpermissions varchar(MAX) 
DECLARE @sqluser varchar(MAX)
DECLARE @sqlrole varchar(MAX)
DECLARE @AccountRoot varchar(100) = 'ELDREDGE_A\svc_idpm_dev01'
DECLARE @AppRole varchar(100) = 'IDPM_APP_ACCESS'
DECLARE @TargetDB varchar(100) = '?' 
DECLARE @TargetpermissionsDB varchar(100) ='^'
DECLARE @Target varchar(100) ='?'
DECLARE @Type varchar(10) = 'SL'
DECLARE @Permission varchar(100) 
DECLARE @DryRun INT = 0 

		SELECT @Permission = permission_name  FROM  fn_builtin_permissions(default)  WHERE type = @Type 

		SELECT @sqlrole = 'USE '+ @TargetDB +'; DECLARE @sqlCMD varchar(1000) = '''';
		IF NOT EXISTS (select * from sys.database_principals where name = '''+ @AppRole + ''')
		BEGIN
				CREATE ROLE ['+ @AppRole +']  AUTHORIZATION [dbo];
				PRINT ''SUCCESS: ROLE was created''
		END
			ELSE 
		BEGIN
				PRINT ''WARNING: ROLE ALREADY EXISTS''
		END;'

		select @sqluser =' USE [master]

		IF NOT EXISTS (SELECT * FROM sys.server_principals where name = '''+ @AccountRoot +''')
		BEGIN
				CREATE LOGIN ['+  @AccountRoot + '] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
				PRINT ''SUCCESS: LOGIN CREATED''
		END
			ELSE 
		BEGIN
				PRINT ''WARNING: USER ALREADY EXISTS''
		END

		USE '+ @TargetDB +'
		IF NOT EXISTS (SELECT * FROM sys.database_principals where name = '''+ @AccountRoot +''')
		BEGIN
				CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
				PRINT ''SUCCESS: USER CREATED'';
		END
			ELSE 
		BEGIN
				PRINT ''WARNING: PERMISSION ALREADY EXISTS DROPPING USER AND RE-ADDING''
				DROP USER ['+  @AccountRoot + '] 
				CREATE USER ['+  @AccountRoot + '] FOR LOGIN ['+  @AccountRoot + '] 
		END



		IF NOT EXISTS (select rp.name [Application Role Name] ,rp.type_desc, mp.name [Login Name], mp.type, mp.default_schema_name 
						from sys.database_role_members dm
						join  sys.database_principals rp on rp.principal_id = dm.role_principal_id
						join  sys.database_principals mp on mp.principal_id = dm.member_principal_id
						where mp.name = '''+ @AccountRoot +''')

		BEGIN
		
				ALTER ROLE ['+ @AppRole +']  ADD MEMBER ['+  @AccountRoot + '] ;
				PRINT ''SUCCESS: PERMISSION GIVEN TO USER''
		END
			ELSE 
		BEGIN
				PRINT ''WARNING: PERMISSION ALREADY EXISTS'' 
		END'


		SELECT @sqlpermissions = 'USE '+ @TargetpermissionsDB +'; EXEC sp_MSforeachtable @command1 ="
		IF DB_ID(''^'') != 2 
		BEGIN
				GRANT '+  @Permission + ' ON ' + @Target +' TO  ['+ @AppRole +']
				PRINT ''On the '+ @Target +' table the ' + @AppRole + ' role was given '+ @Permission + ' access on the ' + @TargetpermissionsDB  +' database''
			END"'
		
		

IF @DryRun = 1
	BEGIN 
		 EXEC sp_MSforeachdb @sqlrole 
		 EXEC sp_MSforeachdb @sqluser
		 EXEC sp_msforeachdb  @command1 =@sqlpermissions, @replacechar = '^'

	END
ELSE
	BEGIN 
		PRINT ( @sqlrole)
		PRINT ( @sqluser)
		PRINT (@sqlpermissions)
	END



