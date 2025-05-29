USE iqq_common
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH_17588';
DECLARE @SourceDatabase NVARCHAR(100) = 'iqq_common' /* This will be the schema in HDTStorage */;
DECLARE @RowsToChange INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(ID)
FROM [iqq_common].[dbo].[USERS]
WHERE ID IN(220093, 80, 92690);

/* Existence check for Storage tables - Exit if they exist */
	IF NOT EXISTS (SELECT *
	               FROM   HDTStorage.sys.tables
	               WHERE  schema_id IN (select schema_id from HDTStorage.sys.schemas
						  where name = @SourceDatabase)
	                      AND NAME LIKE @Ticket + '_%'
	                      AND TYPE IN ( N'U' ))

	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT * into HDTStorage.'+@SourceDatabase+'.'+@Ticket+'_USERS
		FROM [iqq_common].[dbo].[USERS]
			WHERE ID IN(220093, 80, 92690)')
  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE [iqq_common].[dbo].[USERS]
			  SET IDP_ENTITY_ID_TX = 'SAML2:https://auth.alliedsolutions.net:443', SSO_ENABLED_IN = 'Y'
			  WHERE ID IN (220093, 80, 92690)

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
