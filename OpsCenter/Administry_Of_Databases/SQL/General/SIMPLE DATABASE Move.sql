USE [master]

DECLARE @permissionadd VARCHAR(max);
DECLARE @accountcount INT;
DECLARE @TargetName VARCHAR(100);
DECLARE @DryRun INT = 1 ---0 = executes script and 1 shows the script



IF EXISTS (SELECT 1
           FROM   sys.databases
       	where recovery_model_desc <> 'SIMPLE'
	AND (database_id >=1 AND  name != 'DBA'))
  SET @accountcount = (SELECT Count(*)
                       FROM   sys.databases
                       	where recovery_model_desc <> 'SIMPLE'
	AND (name NOT IN ('DBA', 'Perfstats', 'HDTStorage') ))

IF @accountcount <> 0
  WHILE ( @accountcount <> 0 )
    IF @DryRun = 0
      BEGIN
          SET @TargetName = (SELECT TOP 1 name
                             FROM   sys.databases
                            	where recovery_model_desc <> 'SIMPLE'
	AND (name NOT IN ('DBA', 'Perfstats', 'HDTStorage') ))

          SELECT @permissionadd = 'USE [MASTER]'+' '+'ALTER DATABASE'+' ['+@TargetName+'] '+'SET RECOVERY SIMPLE WITH NO_WAIT'

          EXEC (@permissionadd);

          PRINT 'The following database has been changed to the SIMPLE RECOVERY: [' + ( @TargetName ) + ']';

          SET @accountcount = @accountcount - 1;
      END
    ELSE
      BEGIN
          SET @TargetName = (SELECT TOP 1 name
                             FROM   sys.databases
                          	where recovery_model_desc <> 'SIMPLE'
	AND (name NOT IN ('DBA', 'Perfstats', 'HDTStorage')) )

          SELECT 'USE MASTER'+' '+'ALTER DATABASE'+' ['+name+'] '+'SET RECOVERY SIMPLE WITH NO_WAIT'
          FROM   sys.databases
        	where recovery_model_desc <> 'SIMPLE'
	AND (name NOT IN ('DBA', 'Perfstats', 'HDTStorage')) 

          SET @accountcount = @accountcount - @accountcount;
      END 
