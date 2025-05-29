USE [master]

DECLARE @permissionadd VARCHAR(max);
DECLARE @accountcount INT;
DECLARE @TargetName VARCHAR(100);
DECLARE @DryRun INT = 1 ---0 = executes script and 1 shows the script

IF EXISTS (SELECT 1
           FROM   sys.databases
           WHERE  ( Suser_sname(owner_sid) <> 'sa'
                     OR Suser_sname(owner_sid) IS NULL )
                  AND ( database_id >= 5
                       AND name not in ('DBA', 'Perfstats', 'HDTSTorage')))
  SET @accountcount = (SELECT Count(*)
                       FROM   sys.databases
                       WHERE  ( Suser_sname(owner_sid) <> 'sa'
                                 OR Suser_sname(owner_sid) IS NULL )
                              AND ( database_id >= 5
                                 AND name not in ('DBA', 'Perfstats', 'HDTSTorage')))

IF @accountcount <> 0
  WHILE ( @accountcount <> 0 )
    IF @DryRun = 0
      BEGIN
          SET @TargetName = (SELECT TOP 1 name
                             FROM   sys.databases
                             WHERE  ( Suser_sname(owner_sid) <> 'sa'
                                       OR Suser_sname(owner_sid) IS NULL )
                                    AND ( database_id >= 5 ))

          SELECT @permissionadd = 'ALTER AUTHORIZATION ON DATABASE:: ['
                                  + @TargetName + '] TO [SA]'

          EXEC (@permissionadd);

          PRINT 'The following database has been moved to the owner of SA: [' + ( @TargetName ) + ']';

          SET @accountcount = @accountcount - 1;
      END
    ELSE
      BEGIN
          SET @TargetName = (SELECT TOP 1 name
                             FROM   sys.databases
                             WHERE  ( Suser_sname(owner_sid) <> 'sa'
                                       OR Suser_sname(owner_sid) IS NULL )
                                    AND ( database_id >= 5 ))

          SELECT 'ALTER AUTHORIZATION ON DATABASE:: ['
                 + name + '] TO [SA]'
          FROM   sys.databases
          WHERE  ( Suser_sname(owner_sid) <> 'sa'
                    OR Suser_sname(owner_sid) IS NULL )
                 AND ( database_id >= 5 )

          SET @accountcount = @accountcount - @accountcount;
      END 
