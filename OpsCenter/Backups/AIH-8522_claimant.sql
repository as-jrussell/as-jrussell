USE [IVOS]
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH_8522_claimant';
DECLARE @RowsToChange INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(claimant_status_code)
FROM claimant
WHERE closed_date is null and delayed_decision_date is not null 
and delayed_decision_date > '2021-01-01 00:00:00';

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM IVOSHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT * into IVOSHDStorage..'+@Ticket+'_claimant
  		FROM claimant
  		WHERE closed_date is null and delayed_decision_date is not null 
			and delayed_decision_date > ''2021-01-01 00:00:00''')
  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			update claimant  -- with(rowlock) DO NOT USE ROWLOCK let SQL handle locking
			set claimant_status_code = 5, closed_date = delayed_decision_date 
			WHERE closed_date is null and delayed_decision_date is not null 
			and delayed_decision_date > '2021-01-01 00:00:00'

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
