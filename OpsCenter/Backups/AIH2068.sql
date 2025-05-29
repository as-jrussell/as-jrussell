USE [UiPath]
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH2068';
DECLARE @RowsToChangeASP INT;
DECLARE @RowsToChangeUsers INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChangeASP = count(Id)
FROM UiPath.[identity].[AspNetUsers]
  		WHERE  Surname='Administrator'

SELECT @RowsToChangeUsers = count(Id)
FROM uipath.dbo.users
  		WHERE  Surname='Administrator'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM [UIPAHDStorage].sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT * into UIPAHDStorage..'+@Ticket+'_Users
  		FROM uipath.dbo.users
  		WHERE  Surname=''Administrator''')

		EXEC('SELECT * into UIPAHDStorage..'+@Ticket+'_AspNetUsers
  		FROM UiPath.[identity].[AspNetUsers]
  		WHERE  Surname=''Administrator''')

  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChangeASP )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE UiPath.[identity].[AspNetUsers] 
			Set PasswordHash='ALWTidnzgaDN04zwfIjlx3ogbXNNer7/QbO9y3Q4LV/MLY+2TaazMLEggpO8/b7/Kg==', IsFirstLogin='1'
			where Surname='Administrator'


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChangeASP )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			ROLLBACK;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
		END
	IF( @@RowCount = @RowsToChangeUsers )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE uipath.dbo.users 
			Set Password='ALWTidnzgaDN04zwfIjlx3ogbXNNer7/QbO9y3Q4LV/MLY+2TaazMLEggpO8/b7/Kg==', IsFirstLogin='1' 
			where Surname='Administrator'

		
        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChangeUsers)
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			COMMIT;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			ROLLBACK;
		  		END
		END

	END
ELSE
	BEGIN
		PRINT 'HD TABLE EXISTS - Stop work'
		COMMIT;
	END


	
/*
	select * from UIPAHDStorage.sys.tables
	order by modify_date DESC 

	drop table  UIPAHDStorage.dbo.AIH2068_AspNetUsers
drop table UIPAHDStorage.dbo.AIH2068_Users

*/