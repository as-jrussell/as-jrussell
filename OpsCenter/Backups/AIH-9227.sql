USE [InforCRM]
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH_9227';
DECLARE @RowsToChange INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(ENDPOINTURL)
FROM sysdba.APPIDMAPPING
WHERE ENDPOINTURL IS NULL;

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM InforHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT * into InforHDStorage..'+@Ticket+'_ENDPOINTURL 
  		FROM sysdba.APPIDMAPPING
		WHERE ENDPOINTURL IS NULL')
  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE sysdba.APPIDMAPPING -- with(rowlock) DO NOT USE ROWLOCK let SQL handle locking
			SET ENDPOINTURL = 'http://localhost:3333/sdata/slx/gcrm/-/'
			WHERE ENDPOINTURL IS NULL

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
