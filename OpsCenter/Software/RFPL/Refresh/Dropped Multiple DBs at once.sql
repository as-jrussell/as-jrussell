USE [master]


DECLARE @new VARCHAR(128)= '_UAT'; --name of databases that you want dropped 
DECLARE @TargetName VARCHAR(max);
DECLARE @sqlcmd nvarchar(MAX)
DECLARE @accountcount INT;
DECLARE @Verbose INT = 0 ---0 = executes script and 1 shows the script (hidden) 
DECLARE @DryRun INT = 0 ---0 = executes script and 1 shows the script



/*
Job roughly take 20 minutes to execute
*/

-- Check if the Test_PROD database exists
IF EXISTS (SELECT 1
           FROM   sys.databases
           WHERE  name like '%' +@new +'')

IF @DryRun = 0
  SET @accountcount = (SELECT Count(*)
                       FROM   sys.databases
                       WHERE  name LIKE '%' +@new +'');

IF @accountcount <> 0
WHILE ( @accountcount <> 0 )
  BEGIN
          SET @TargetName =(SELECT TOP 1 name
                            FROM   sys.databases
                            WHERE  name LIKE '%' +@new +'');


			 SELECT @sqlcmd = '	EXEC sp_executesql N''DROP DATABASE '+@TargetName+'''';

			 IF @Verbose = 0
  BEGIN
      EXEC ( @SQLcmd)
		
  END
ELSE
  BEGIN
      PRINT ( @SQLcmd + '
	  
	  exec @sqlcmd')
  END

                PRINT 'The ' + @TargetName
                      + ' has been dropped'
                      + '.';

                SET @accountcount = @accountcount - 1;
            
      END
ELSE
  BEGIN



     select CONCAT('EXEC sp_executesql N''DROP DATABASE ', name,''';')
      FROM   sys.databases
      WHERE  name LIKE '%' +@new +''


	
  END 



