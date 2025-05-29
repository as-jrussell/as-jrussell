DECLARE @TargetName VARCHAR(128) = '';
DECLARE @newname NVARCHAR(128)= '';
DECLARE @DryRun INT = 0 ---0 = executes script and 1 shows the script

IF @DryRun = 0
  BEGIN
      IF EXISTS (SELECT *
                 FROM   sys.databases
                 WHERE  name = @TargetName)
        BEGIN
            -- Rename the Test_PROD database to the new name


			     BEGIN TRY   
				---Next phase of this place this in a try, fail 
            EXEC Sp_renamedb
              @TargetName,
              @newname;  END TRY  
    BEGIN CATCH  
		PRINT  'FAIL: The ' + @TargetName
                  + ' database has NOT been renamed to ' + @newname
                  + '.';
   RETURN
    END CATCH  


            PRINT 'SUCCESS: The ' + @TargetName
                  + ' database has been renamed to ' + @newname
                  + '.';
        END
  END
ELSE
  BEGIN
      SET @TargetName =(SELECT TOP 1 name
                        FROM   sys.databases
                        WHERE  name = +@TargetName);

      SELECT Concat('EXEC sp_renamedb ', NAME, ', ', Replace(name, @TargetName, @newname), '')
      FROM   sys.databases
      WHERE  name = @TargetName 

  END 
