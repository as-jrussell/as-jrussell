DECLARE @SQLcmd VARCHAR(max)
DECLARE @TargetDB NVARCHAR(100) = 'UniTrac_Maintenance'
DECLARE @Account NVARCHAR(100) = 'ELDREDGE_A\svc_utrc_xlimp_prd01'
DECLARE @DryRun INT = 0

SELECT @SQLcmd = 'DECLARE @sqlCMD varchar(max) = '''';
IF EXISTS (SELECT 1
           FROM   sys.syslogins
           WHERE  name = ''' + @Account
                 + ''')
  BEGIN
      PRINT ''WARNING: Login ' + @Account
                 + ' already exists!''
  END
ELSE
  BEGIN
      USE [master]
           CREATE LOGIN [' + @Account
                 + '] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
      PRINT ''SUCCESS: Login Created '
                 + @Account + '''
  END

IF EXISTS(SELECT 1
          FROM   sys.databases
          WHERE  name = '''
                 + @TargetDB + ''')
  BEGIN

   BEGIN TRY  
     	    USE [' + @TargetDB
                 + ']
      CREATE USER [' + @Account
                 + '] FOR LOGIN [' + @Account
                 + ']
      ALTER ROLE [db_owner] ADD MEMBER ['
                 + @Account + ']
      PRINT ''SUCCESS:  '
                 + @Account + ' given permissions to  '
                 + @TargetDB
                 + '''
    END TRY  
    BEGIN CATCH  
         PRINT ''WARNING: There is a problem with '
                 + @TargetDB + ' database please check the configurations''
        RETURN
    END CATCH  

  END
ELSE
  BEGIN
      USE [master]
	  
      DROP LOGIN [' + @Account
                 + ']

      PRINT ''WARNING: There is a problem with '
                 + @TargetDB + ' database please check the configurations''
  END 
  '

IF @DryRun = 0
  BEGIN
      EXEC ( @SQLcmd)
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd )
  END 


