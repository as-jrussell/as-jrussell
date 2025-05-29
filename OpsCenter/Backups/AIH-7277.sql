USE [IVOS]
GO

BEGIN TRAN;
/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'AIH_7278';
DECLARE @RowsToChange INT;

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @RowsToChange = count(claim_status_code)
--select *
FROM IVOS.dbo.claim c
 join IVOS.dbo.claimant cl on cl.claim_id = c.claim_id
where 
	 examiner2_status_code = 5
	and examiner1_status_code = 5
	and delayed = 1
	and pay_close = 1
	and claimant_reference1_code = 19
	and claim_status_code = 1
	and c.insurance_type = 6;

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM IVOSHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT C.* into IVOSHDStorage..'+@Ticket+'_claim
  		FROM IVOS.dbo.claim c
		 join IVOS.dbo.claimant cl on cl.claim_id = c.claim_id
		where 
			 examiner2_status_code = 5
			and examiner1_status_code = 5
			and delayed = 1
			and pay_close = 1
			and claimant_reference1_code = 19
			and claim_status_code = 1
			and c.insurance_type = 6')
  
    	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE C
			SET C.claim_status_code = '5'
			FROM IVOS.dbo.claim c
			join IVOS.dbo.claimant cl on cl.claim_id = c.claim_id
			WHERE examiner2_status_code = 5
			and examiner1_status_code = 5
			and delayed = 1
			and pay_close = 1
			and claimant_reference1_code = 19
			and claim_status_code = 1
			and c.insurance_type = 6

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



