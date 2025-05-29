USE [master]


DECLARE @old VARCHAR(128) ='_PROD' ;
DECLARE @new VARCHAR(128)= '_UAT';
DECLARE @newname NVARCHAR(128);
DECLARE @TargetName VARCHAR(128);
DECLARE @accountcount INT;
DECLARE @DryRun INT = 0 ---0 = executes script and 1 shows the script

-- Check if the Test_PROD database exists
IF EXISTS (SELECT 1
           FROM   sys.databases
           WHERE  name like '%' +@old +'')

  SET @accountcount = (SELECT Count(*)
                       FROM   sys.databases
                       WHERE  name LIKE '%' +@old +'');
IF @DryRun = 0
IF @accountcount <> 0
  WHILE ( @accountcount <> 0 )
  BEGIN
          SET @newname = Replace((SELECT TOP 1 name
                                  FROM   sys.databases
                                  WHERE  name like '%' +@old +''), @old, @new );
          SET @TargetName =(SELECT TOP 1 name
                            FROM   sys.databases
                            WHERE  name LIKE '%' +@old +'');

          -- Check if the new database name already exists
          IF EXISTS (SELECT *
                     FROM   sys.databases
                     WHERE  name = @newname)
            BEGIN
                PRINT 'The ' + @newname
                      + ' database already exists. Please drop it first before running this script.';
            END
          ELSE
            BEGIN
                -- Rename the Test_PROD database to the new name
                EXEC Sp_renamedb
                  @TargetName,
                  @newname;

                PRINT 'The ' + @TargetName
                      + ' database has been renamed to ' + @newname
                      + '.';

                SET @accountcount = @accountcount - 1;
            END
      END
    ELSE
      BEGIN
          PRINT 'The  ' + @TargetName
                + ' database does not exist.';
      END
ELSE
  BEGIN
     SET @TargetName =(SELECT TOP 1 name
                            FROM   sys.databases
                            WHERE  name LIKE '%' +@old +'');

      SELECT CONCAT('EXEC sp_renamedb ',NAME,', ', Replace(name, @old, @new) ,'')
      FROM   sys.databases
      WHERE  name LIKE '%' +@old +''

	
  END 



