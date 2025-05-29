USE PRL_PNC_6525_PROD

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'CSH6588';
DECLARE @RowsToChange INT;
DECLARE	@currentUTCDate datetime = GETUTCDATE()


/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(ID)
FROM REPORT
WHERE ID IN (1,3);

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDSTORAGE.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT ID, SCHEDULED_IN, UPDATE_DT, UPDATE_USER_TX, LOCK_ID into RFPLHDSTORAGE..'+@Ticket+'_REPORT
  		FROM REPORT WHERE ID IN (1,3)')
  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE [REPORT] -- with(rowlock) DO NOT USE ROWLOCK let SQL handle locking
			SET		SCHEDULED_IN = 'N'
				, UPDATE_DT = @currentUTCDate
				, UPDATE_USER_TX = 'szabinsky'
				, LOCK_ID = (LOCK_ID % 255) + 1
		WHERE	ID IN (1,3)
			AND	SCHEDULED_IN = 'Y'

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
