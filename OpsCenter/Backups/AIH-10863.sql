--USE [INFORCRM]
--GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'CSH_2633';
DECLARE @RowsToDelete INT;

/* Step 1 - Calculate rows to be changed */
SELECT @RowsToDelete = count([INF_ACC_TEAMID])
FROM [sysdba].[INF_ACC_TEAM]
 where userid = 'U6UJ9A0000IY';

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM HDTStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN
		/* populate new Storage table from Sources */
		EXEC('SELECT * into HDTStorage..'+@Ticket+'_INF_ACC_TEAM
			FROM [sysdba].[INF_ACC_TEAM]
			 where userid = ''U6UJ9A0000IY''')
  
		/* Does Storage Table meet expectations */
		IF( @@RowCount = @RowsToDelete )
			BEGIN
				PRINT 'Storage table meets expections - continue'

				/* Step 3 - Perform table update */
				DELETE FROM [sysdba].[INF_ACC_TEAM] 
				 where userid = 'U6UJ9A0000IY';

				/* Step 4 - Inspect results - Commit/Rollback */
				IF ( @@ROWCOUNT = @RowsToDelete )
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
	--	COMMIT;
	END
