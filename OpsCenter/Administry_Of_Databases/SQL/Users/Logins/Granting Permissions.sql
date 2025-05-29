DECLARE @TargetDB nvarchar(100) = 'HDTStorage' 
DECLARE @Acct nvarchar(100) = 'ELDREDGE_A\IT Development'
DECLARE @Permission1 nvarchar(100) = 'db_datareader'
DECLARE @Permission2 nvarchar(100) = 'db_datawriter'
DECLARE @sqlcmd nvarchar(MAX)
DECLARE @DryRun INT = 1

--SELECT @DBNAME = name from sys.databases WHERE database_id in (SELECT max(database_id) from sys.databases)

   SELECT @sqlcmd = 'USE ['+ @TargetDB +']


CREATE USER ['+ @Acct +'] FOR LOGIN ['+ @Acct +']

ALTER USER ['+ @Acct +'] WITH DEFAULT_SCHEMA=[dbo]

ALTER ROLE ['+ @Permission1 +'] ADD MEMBER ['+ @Acct +']

ALTER ROLE ['+ @Permission2 +'] ADD MEMBER ['+ @Acct +']
' 



    IF @DryRun = 0
        BEGIN
            EXEC ( @SQLcmd)
        END
      ELSE
        BEGIN
            PRINT ( @SQLcmd )
        END
