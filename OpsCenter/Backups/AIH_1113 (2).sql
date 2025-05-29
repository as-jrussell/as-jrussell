USE [CenterPointSecurity]
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH_1113';
DECLARE @RowsToChange INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(*)
FROM [CenterPointSecurity].[dbo].[CP_UserProfile]
WHERE Idp = 0 AND ClientId = '7740';

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM CenterPointHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT * into CenterPointHDStorage..'+@Ticket+'_CP_UserProfile
  		FROM [CenterPointSecurity].[dbo].[CP_UserProfile]
  		WHERE Idp = 0 AND ClientId = ''7740''')

    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			-- with(rowlock) DO NOT USE ROWLOCK let SQL handle locking
			
			UPDATE CP
			SET Idp = 1 
			--SELECT * 
			FROM  [CenterPointSecurity].[dbo].[CP_UserProfile] CP
			WHERE Idp = 0 AND ClientId = '7740';

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange )
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
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
		END
	END
ELSE
	BEGIN
		PRINT 'HD TABLE EXISTS - Stop work'
		COMMIT;
	END