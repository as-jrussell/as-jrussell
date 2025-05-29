EXEC [DBA].[deploy].[CreateDatabase] @TargetDB = 'IVOS_tools', @debug = 0, @DryRun = 0
EXEC dba.deploy.SetDatabaseMembership @TargetDB = 'IVOS_tools', @DryRun = 1
EXEC [DBA].[deploy].[SetDatabasePermission] @TargetDB = 'IVOS_tools', @DryRun = 0




EXEC [DBA].[deploy].[ApplicationDatabase] @TargetDB = 'IVOS_Tools', @AppName = 'IVOS', @Debug = 0, @DryRun = 0