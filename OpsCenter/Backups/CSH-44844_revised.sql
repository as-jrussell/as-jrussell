USE [PRL_FIFTHTHIRD_5309_PROD]
GO

IF OBJECT_ID('tempdb..#fpqueueIds') IS NOT NULL
		DROP TABLE #fpqueueIds

IF OBJECT_ID('tempdb..#fpdetailIds') IS NOT NULL
		DROP TABLE #fpdetailIds

IF OBJECT_ID('tempdb..#loanIds') IS NOT NULL
		DROP TABLE #loanIds

IF OBJECT_ID('tempdb..#documentIds') IS NOT NULL
		DROP TABLE #documentIds

IF OBJECT_ID('tempdb..#blobIds') IS NOT NULL
		DROP TABLE #blobIds

IF OBJECT_ID('tempdb..#productIds') IS NOT NULL
		DROP TABLE #productIds

IF OBJECT_ID('tempdb..#claimIds') IS NOT NULL
		DROP TABLE #claimIds

IF OBJECT_ID('tempdb..#proceedIds') IS NOT NULL
		DROP TABLE #proceedIds

IF OBJECT_ID('tempdb..#quoteIds') IS NOT NULL
		DROP TABLE #quoteIds

IF OBJECT_ID('tempdb..#borrowerIds') IS NOT NULL
		DROP TABLE #borrowerIds

IF OBJECT_ID('tempdb..#addressIds') IS NOT NULL
		DROP TABLE #addressIds

IF OBJECT_ID('tempdb..#workItemMetaDataIds') IS NOT NULL
		DROP TABLE #workItemMetaDataIds

IF OBJECT_ID('tempdb..#workItemIds') IS NOT NULL
		DROP TABLE #workItemIds

IF OBJECT_ID('tempdb..#productRefundWorkflowIds') IS NOT NULL
		DROP TABLE #productRefundWorkflowIds

IF OBJECT_ID('tempdb..#workItemTaskIds') IS NOT NULL
		DROP TABLE #workItemTaskIds

IF OBJECT_ID('tempdb..#interactionIds') IS NOT NULL
		DROP TABLE #interactionIds

IF OBJECT_ID('tempdb..#relatedDataIds') IS NOT NULL
		DROP TABLE #relatedDataIds

IF OBJECT_ID('tempdb..#notificationIds') IS NOT NULL
		DROP TABLE #notificationIds




BEGIN TRAN CLEAN_UP

/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'CSH_44844';
DECLARE	@clientCode	nvarchar(10) = N'5309';
DECLARE @fileprocessQueueId int = 162;
DECLARE @client_id int = (select id from AlliedClientTable where code_tx = @clientCode);  
DECLARE	@clientPurgeUTCDate datetime = GETUTCDATE();

DECLARE @FPQRowcount INT = 0
		, @FPQRowsBackedUp INT = 0
		, @FPQRowsUpdated INT = 0

		, @FPDetailRowcount INT = 0
		, @FPDetailRowsBackedUp INT = 0
		, @FPDetailRowsUpdated INT = 0

		, @searchFullTextRowcount INT = 0
		, @searchFullTextRowsBackedUp INT = 0
		, @searchFullTextRowsUpdated INT = 0

		, @addressRowcount INT = 0
		, @addressRowsBackedUp INT = 0
		, @addressRowsUpdated INT = 0

		, @borrowerRowcount INT = 0
		, @borrowerRowsBackedUp INT = 0
		, @borrowerRowsUpdated INT = 0

		, @proceedRowcount INT = 0
		, @proceedRowsBackedUp INT = 0
		, @proceedRowsUpdated INT = 0

		, @quoteRowcount INT = 0
		, @quoteRowsBackedUp INT = 0
		, @quoteRowsUpdated INT = 0

		, @claimRowcount INT = 0
		, @claimRowsBackedUp INT = 0
		, @claimRowsUpdated INT = 0

		, @loanRowcount INT = 0
		, @loanRowsBackedUp INT = 0
		, @loanRowsUpdated INT = 0

		, @productRowcount INT = 0
		, @productRowsBackedUp INT = 0
		, @productRowsUpdated INT = 0

		, @blobRowcount INT = 0
		, @blobRowsBackedUp INT = 0
		, @blobRowsUpdated INT = 0

		, @documentRowcount INT = 0
		, @documentRowsBackedUp INT = 0
		, @documentRowsUpdated INT = 0
		
		, @wimdRowcount INT = 0
		, @wimdRowsBackedUp INT = 0
		, @wimdRowsUpdated INT = 0
		
		, @notificationRowcount INT = 0
		, @notificationRowsBackedUp INT = 0
		, @notificationRowsUpdated INT = 0
		
		, @relatedDataRowcount INT = 0
		, @relatedDataRowsBackedUp INT = 0
		, @relatedDataRowsUpdated INT = 0
		
		, @interactionRowcount INT = 0
		, @interactionRowsBackedUp INT = 0
		, @interactionRowsUpdated INT = 0
		
		, @witRowcount INT = 0
		, @witRowsBackedUp INT = 0
		, @witRowsUpdated INT = 0
		
		, @prwRowcount INT = 0
		, @prwRowsBackedUp INT = 0
		, @prwRowsUpdated INT = 0
		
		, @wiRowcount INT  = 0
		, @wiRowsBackedUp INT = 0
		, @wiRowsUpdated INT = 0

CREATE TABLE #fpqueueIds (ID BIGINT , REPORT_HISTORY_ID BIGINT)  -- ID TABLE

INSERT INTO #fpqueueIds (ID, REPORT_HISTORY_ID)
SELECT ID , REPORT_HISTORY_ID FROM FILE_PROCESS_QUEUE     --- SELECT ID 
WHERE PURGE_DT IS NULL AND CLIENT_ID = @client_id AND ID = @fileprocessQueueId

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @FPQRowcount = count([ID])
FROM #fpqueueIds

PRINT CAST(@FPQRowCount AS nvarchar(5)) + ' rows in FILE_PROCESS_QUEUE'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_FILE_PROCESS_QUEUE%' AND type IN (N'U') )
	BEGIN
    	/* populate new Storage table from Sources */
		EXEC('SELECT FPQ.* into RFPLHDStorage..'+@Ticket+'_FILE_PROCESS_QUEUE
  		FROM [FILE_PROCESS_QUEUE] FPQ
		INNER JOIN #fpqueueIds FID ON FPQ.ID = FID.ID')

    	SET @FPQRowsBackedUp = @@ROWCOUNT

		PRINT CAST(@FPQRowsBackedUp AS nvarchar(5)) + ' rows backed up in FILE_PROCESS_QUEUE'
  
    	/* Does Storage Table meet expectations */
	IF( @FPQRowsBackedUp = @FPQRowcount )
		BEGIN
			PRINT @Ticket+'_FILE_PROCESS_QUEUE Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE  FPQ					-- UPDATE
				SET PURGE_DT = @clientPurgeUTCDate
				,UPDATE_DT = @clientPurgeUTCDate
				,UPDATE_USER_TX = @Ticket
				,LOCK_ID = (LOCK_ID % 255) + 1
				FROM  FILE_PROCESS_QUEUE FPQ 
				INNER JOIN #fpqueueIds FID ON FPQ.ID = FID.ID

				SET @FPQRowsUpdated = @@ROWCOUNT
								
				PRINT CAST(@FPQRowsUpdated AS nvarchar(5)) + ' rows updated in FILE_PROCESS_QUEUE'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @FPQRowsUpdated = @FPQRowcount )
		  		BEGIN
		    			PRINT 'SUCCESS - UPDATING FILE_PROCESS_QUEUE'
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE FILE_PROCESS_QUEUE - Performing Rollback'
		    			GOTO OUTER_ERROR;						
		  	END
		END
	ELSE
      		BEGIN
        		PRINT @Ticket+'FILE_PROCESS_QUEUE Storage does not meet expectations - rollback'
				GOTO OUTER_ERROR;
			END
	END
ELSE
	BEGIN
		PRINT @Ticket+'FILE_PROCESS_QUEUE TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #fpdetailIds (ID BIGINT, EXTERNAL_NO_TX NVARCHAR(18) )  -- ID TABLE

INSERT INTO #fpdetailIds (ID, EXTERNAL_NO_TX)
SELECT FPD.ID, FPD.EXTERNAL_NO_TX
	FROM FILE_PROCESS_DETAIL FPD
	INNER JOIN #fpqueueIds FPQ ON  FPD.FILE_PROCESS_QUEUE_ID = FPQ.ID
	WHERE FPD.PURGE_DT IS NULL 

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @FPDetailRowcount = count([ID])
FROM #fpdetailIds

PRINT CAST(@FPDetailRowcount AS nvarchar(5)) + ' rows in #fpdetailIds'


/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables -- Someday this will be the standard 
               WHERE name like  @Ticket+'_FILE_PROCESS_DETAIL%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT FPD.* into RFPLHDStorage..'+@Ticket+'_FILE_PROCESS_DETAIL
  		FROM [FILE_PROCESS_DETAIL] FPD
		INNER JOIN #fpdetailIds IDS ON FPD.ID = IDS.ID')

    	SET @FPDetailRowsBackedUp = @@ROWCOUNT

		PRINT CAST(@FPDetailRowsBackedUp AS nvarchar(5)) + ' rows backed up in [FILE_PROCESS_DETAIL]'
  
    	/* Does Storage Table meet expectations */
	IF( @FPDetailRowsBackedUp = @FPDetailRowcount )
		BEGIN
			PRINT @Ticket+'_FILE_PROCESS_DETAIL Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE  FPD
				SET PURGE_DT = @clientPurgeUTCDate
				,UPDATE_DT = @clientPurgeUTCDate
				,UPDATE_USER_TX = @Ticket
				,LOCK_ID = (LOCK_ID % 255) + 1
				FROM  FILE_PROCESS_DETAIL FPD 
				INNER JOIN #fpdetailIds IDS ON FPD.ID = IDS.ID

				SET @FPDetailRowsUpdated = @@ROWCOUNT

				PRINT CAST(@FPDetailRowsUpdated AS nvarchar(5)) + ' rows updated in FILE_PROCESS_DETAIL'	

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @FPDetailRowsUpdated = @FPDetailRowcount )
		  		BEGIN
		    			PRINT 'FILE_PROCESS_DETAIL UPDATE SUCCESS'		    		
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE FILE_PROCESS_DETAIL - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT @Ticket+'_FILE_PROCESS_DETAIL Storage does not meet expectations - rollback'
				GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_FILE_PROCESS_DETAIL HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #loanIds (ID BIGINT )  -- ID TABLE

INSERT INTO #loanIds (ID)
SELECT Distinct L.ID -- The control file might have 59 lines, but only 33 distinct loan numbers
	FROM LOAN L 
	INNER JOIN #fpdetailIds FPD ON L.LOAN_NO_TX = FPD.EXTERNAL_NO_TX 
	WHERE L.PURGE_DT IS NULL AND L.CLIENT_ID = @client_id

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @loanRowcount = count([ID])
FROM #loanIds

PRINT CAST(@loanRowcount AS nvarchar(5)) + ' rows in LOAN'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_LOAN%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT L.* into RFPLHDStorage..'+@Ticket+'_LOAN
  		FROM LOAN L
		INNER JOIN #loanIds IDS ON L.ID = IDS.ID')
  
    	SET @loanRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@loanRowsBackedUp AS nvarchar(5)) + ' rows backed up in LOAN'
  
    	/* Does Storage Table meet expectations */
	IF( @loanRowsBackedUp = @loanRowcount )
		BEGIN
			PRINT 'LOAN Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE LOAN 
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM LOAN L
					INNER JOIN #loanIds IDS ON L.ID = IDS.ID

				SET @loanRowsUpdated = @@ROWCOUNT

				PRINT CAST(@loanRowsUpdated AS nvarchar(5)) + ' rows updated in LOAN'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @loanRowsUpdated = @loanRowcount )
		  		BEGIN
		    			PRINT 'UPDATE SUCCESS FOR LOAN '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE LOAN - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'LOAN Storage does not meet expectations - rollback'
				GOTO OUTER_ERROR;
			END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_LOAN% HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #documentIds (ID BIGINT )  -- ID TABLE

INSERT INTO #documentIds (ID)
SELECT D.ID
	FROM DOCUMENT D
	INNER JOIN #fpqueueIds FPQ ON  D.RELATE_ID = FPQ.ID  AND  D.RELATE_CLASS_NM = 'ProductRefundLiabilityLib.BusinessObjects.FileProcessQueue'
	WHERE D.PURGE_DT IS NULL
	UNION
	SELECT D.ID
	FROM DOCUMENT D
	INNER JOIN #loanIds L ON  D.RELATE_ID = L.ID  AND  D.RELATE_CLASS_NM = 'ProductRefundLiabilityLib.BusinessObjects.Loan'
	WHERE D.PURGE_DT IS NULL


/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @documentRowcount = count([ID])
FROM #documentIds

PRINT CAST(@documentRowcount AS nvarchar(5)) + ' rows in DOCUMENT'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_DOCUMENT%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT D.* into RFPLHDStorage..'+@Ticket+'_DOCUMENT
  		FROM [DOCUMENT] D
		INNER JOIN #documentIds IDS ON D.ID = IDS.ID')
  
    	SET @documentRowsBackedUp = @@ROWCOUNT

		PRINT CAST(@documentRowsBackedUp AS nvarchar(5)) + ' rows backed up in DOCUMENT'
  
    	/* Does Storage Table meet expectations */
	IF( @documentRowsBackedUp = @documentRowcount )
		BEGIN
			PRINT 'DOCUMENT Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE  D
				SET PURGE_DT = @clientPurgeUTCDate
				,UPDATE_DT = @clientPurgeUTCDate
				,UPDATE_USER_TX = @Ticket
				,LOCK_ID = (LOCK_ID % 255) + 1
				FROM  DOCUMENT D 
				INNER JOIN #documentIds IDS ON D.ID = IDS.ID

				SET @documentRowsUpdated = @@ROWCOUNT

				PRINT CAST(@documentRowsUpdated AS nvarchar(5)) + ' rows updated in DOCUMENT'
				

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @documentRowsUpdated = @documentRowcount )
		  		BEGIN
		    			PRINT 'DOCUMENT UPDATE SUCCESS '
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'DOCUMENT FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'DOCUMENT Storage does not meet expectations - rollback'
				GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_DOCUMENT% HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #blobIds (ID BIGINT )  -- ID TABLE

INSERT INTO #blobIds (ID)
SELECT B.ID
	FROM BLOB B
	INNER JOIN #documentIds IDS ON  B.RELATE_ID_TX = IDS.ID  
	WHERE B.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @blobRowcount = count([ID])
FROM #blobIds
		
PRINT CAST(@blobRowcount AS nvarchar(5)) + ' rows in BLOB'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_BLOB%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT B.* into RFPLHDStorage..'+@Ticket+'_BLOB
  		FROM [BLOB] B
		INNER JOIN #blobIds IDS ON B.ID = IDS.ID')
  
    	SET @blobRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@blobRowsBackedUp AS nvarchar(5)) + ' rows backed up in BLOB'
  
    	/* Does Storage Table meet expectations */
	IF( @blobRowsBackedUp = @blobRowcount )
		BEGIN
			PRINT 'BLOB Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE  B
				SET PURGE_DT = @clientPurgeUTCDate
				,UPDATE_DT = @clientPurgeUTCDate
				,UPDATE_USER_TX = @Ticket
				,LOCK_ID = (LOCK_ID % 255) + 1
				FROM  BLOB B 
				INNER JOIN #blobIds IDS ON B.ID = IDS.ID

				SET @blobRowsUpdated = @@ROWCOUNT

				PRINT CAST(@blobRowsUpdated AS nvarchar(5)) + ' rows updated in BLOB'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @blobRowsUpdated = @blobRowcount )
		  		BEGIN
		    			PRINT 'BLOB UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'BLOB FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'BLOB Storage does not meet expectations - rollback'
				GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+' _BLOB HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #productIds(ID BIGINT)  -- ID TABLE

INSERT INTO #productIds (ID)
	SELECT P.ID
	FROM PRODUCT P
	INNER JOIN #loanIds IDS ON P.LOAN_ID = IDS.ID
	WHERE P.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @productRowcount = count([ID])
FROM #productIds

PRINT CAST(@productRowcount AS nvarchar(5)) + ' rows in PRODUCT'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables -- Someday this will be the standard 
               WHERE name like  @Ticket+'_PRODUCT%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT PR.* into RFPLHDStorage..'+@Ticket+'_PRODUCT
  		FROM PRODUCT PR
		INNER JOIN #productIds IDS ON PR.ID = IDS.ID')
  
    	SET @productRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@productRowsBackedUp AS nvarchar(5)) + ' rows backed up in PRODUCT'
  
    	/* Does Storage Table meet expectations */
	IF( @productRowsBackedUp = @productRowcount )
		BEGIN
			PRINT 'PRODUCT Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE P
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM PRODUCT P
					INNER JOIN #productIds IDS ON P.ID = IDS.ID

					SET @productRowsUpdated = @@ROWCOUNT

				PRINT CAST(@productRowsUpdated AS nvarchar(5)) + ' rows updated in PRODUCT'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @productRowsUpdated = @productRowcount )
		  		BEGIN
		    			PRINT 'PRODUCT UPDATE SUCCESS '	   			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'PRODUCT FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'PRODUCT Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT  @Ticket+'_PRODUCT HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #claimIds(ID BIGINT)  -- ID TABLE

INSERT INTO #claimIds (ID)
	SELECT CL.ID
	FROM CLAIM CL
	INNER JOIN #productIds IDS ON CL.PRODUCT_ID = IDS.ID
	WHERE CL.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @claimRowcount = count([ID])
FROM #claimIds
		
PRINT CAST(@claimRowcount AS nvarchar(5)) + ' rows in CLAIM'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables -- Someday this will be the standard 
               WHERE name like  @Ticket+'_CLAIM%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT CL.* into RFPLHDStorage..'+@Ticket+'_CLAIM
  		FROM CLAIM CL
		INNER JOIN #claimIds IDS ON CL.ID = IDS.ID')

    	SET @claimRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@claimRowsBackedUp AS nvarchar(5)) + ' rows backed up in CLAIM'
  
    	/* Does Storage Table meet expectations */
	IF( @claimRowsBackedUp = @claimRowcount )
		BEGIN
			PRINT 'CLAIM Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE CL
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM CLAIM CL
					INNER JOIN #claimIds IDS ON CL.ID = IDS.ID

				SET @claimRowsUpdated = @@ROWCOUNT

				PRINT CAST(@claimRowsUpdated AS nvarchar(5)) + ' rows updated in CLAIM'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @claimRowsUpdated = @claimRowcount )
		  		BEGIN
		    			PRINT 'CLAIM UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'CLAIM FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'CLAIM Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT 'CLAIM HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #proceedIds(ID BIGINT)  -- ID TABLE

INSERT INTO #proceedIds (ID)
	SELECT Pd.ID
	FROM PROCEED Pd
	INNER JOIN #productIds IDS ON Pd.PRODUCT_ID = IDS.ID
	WHERE Pd.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @proceedRowcount = count([ID])
FROM #proceedIds
		
PRINT CAST(@proceedRowcount AS nvarchar(5)) + ' rows in PROCEED'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables -- Someday this will be the standard 
               WHERE name like  @Ticket+'_PROCEED%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT PD.* into RFPLHDStorage..'+@Ticket+'_PROCEED
  		FROM PROCEED PD
		INNER JOIN #proceedIds IDS ON PD.ID = IDS.ID')
  
    	SET @proceedRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@proceedRowsBackedUp AS nvarchar(5)) + ' rows backed up in PROCEED'
  
    	/* Does Storage Table meet expectations */
	IF( @proceedRowsBackedUp = @proceedRowcount )
		BEGIN
			PRINT 'PROCEED Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE PD
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM PROCEED PD
					INNER JOIN #proceedIds IDS ON PD.ID = IDS.ID

				SET @proceedRowsUpdated = @@ROWCOUNT

				PRINT CAST(@proceedRowsUpdated AS nvarchar(5)) + ' rows updated in PROCEED'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @proceedRowsUpdated = @proceedRowcount )
		  		BEGIN
		    			PRINT 'PROCEED UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'PROCEED FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'PROCEED Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_PROCEED HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #quoteIds(ID BIGINT)  -- ID TABLE

INSERT INTO #quoteIds (ID)
	SELECT Q.ID
	FROM QUOTE Q
	INNER JOIN #productIds IDS ON Q.PRODUCT_ID = IDS.ID
	WHERE Q.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @quoteRowcount = count([ID])
FROM #quoteIds
		
PRINT CAST(@quoteRowcount AS nvarchar(5)) + ' rows in QUOTE'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_QUOTE%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT Q.* into RFPLHDStorage..'+@Ticket+'_QUOTE
  		FROM QUOTE Q
		INNER JOIN #quoteIds IDS ON Q.ID = IDS.ID')
  
    	SET @quoteRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@quoteRowsBackedUp AS nvarchar(5)) + ' rows backed up in QUOTE'
  
    	/* Does Storage Table meet expectations */
	IF( @quoteRowsBackedUp = @quoteRowcount )
		BEGIN
			PRINT 'QUOTE Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE Q
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM QUOTE Q
					INNER JOIN #quoteIds IDS ON Q.ID = IDS.ID

				SET @quoteRowsUpdated = @@ROWCOUNT

				PRINT CAST(@quoteRowsUpdated AS nvarchar(5)) + ' rows updated in QUOTE'
	

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @quoteRowsUpdated = @quoteRowcount )
		  		BEGIN
		    			PRINT 'QUOTE UPDATE SUCCESS '
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'QUOTE FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'QUOTE Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT  @Ticket+'_QUOTE HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #borrowerIds(ID BIGINT, ADDRESS_ID BIGINT)  -- ID TABLE

INSERT INTO #borrowerIds (ID , ADDRESS_ID )
	SELECT B.ID, B.ADDRESS_ID
	FROM BORROWER B
	INNER JOIN #loanIds IDS ON B.LOAN_ID = IDS.ID
	WHERE B.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @borrowerRowcount = count([ID])
FROM #borrowerIds
		
PRINT CAST(@borrowerRowcount AS nvarchar(5)) + ' rows in BORROWER'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_BORROWER%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT B.* into RFPLHDStorage..'+@Ticket+'_BORROWER
  		FROM BORROWER B
		INNER JOIN #borrowerIds IDS ON B.ID = IDS.ID')
  
    	SET @borrowerRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@borrowerRowsBackedUp AS nvarchar(5)) + ' rows backed up in BORROWER'
  
    	/* Does Storage Table meet expectations */
	IF( @borrowerRowsBackedUp = @borrowerRowcount )
		BEGIN
			PRINT @Ticket+'_BORROWER Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE B
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM BORROWER B
					INNER JOIN #borrowerIds IDS ON B.ID = IDS.ID

				SET @borrowerRowsUpdated = @@ROWCOUNT

				PRINT CAST(@borrowerRowsUpdated AS nvarchar(5)) + ' rows updated in BORROWER'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @borrowerRowsUpdated = @borrowerRowcount )
		  		BEGIN
		    			PRINT 'BORROWER UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'BORROWER FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'BORROWER Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_BORROWER HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #addressIds(ID BIGINT)  -- ID TABLE

INSERT INTO #addressIds (ID)
	SELECT A.ID
	FROM ADDRESS A
	INNER JOIN #borrowerIds IDS ON A.ID = IDS.ADDRESS_ID
	WHERE A.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @addressRowcount = count([ID])
FROM #addressIds

PRINT CAST(@addressRowcount AS nvarchar(5)) + ' rows in ADDRESS'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_ADDRESS%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT A.* into RFPLHDStorage..'+@Ticket+'_ADDRESS
  		FROM ADDRESS A
		INNER JOIN #addressIds IDS ON A.ID = IDS.ID')
  
    	SET @addressRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@addressRowsBackedUp AS nvarchar(5)) + ' rows backed up in ADDRESS'
  
    	/* Does Storage Table meet expectations */
	IF( @addressRowsBackedUp = @addressRowcount )
		BEGIN
			PRINT @Ticket+'_ADDRESS Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE A
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM ADDRESS A
					INNER JOIN #addressIds IDS ON A.ID = IDS.ID

				SET @addressRowsUpdated = @@ROWCOUNT

				PRINT CAST(@addressRowsUpdated AS nvarchar(5)) + ' rows updated in ADDRESS'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @addressRowsUpdated = @addressRowcount )
		  		BEGIN
		    			PRINT 'ADDRESS UPDATE SUCCESS'		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'ADDRESS FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_ADDRESS HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
	SELECT @searchFullTextRowcount = COUNT(*)
	FROM SEARCH_FULLTEXT S
	INNER JOIN #loanIds IDS ON S.LOAN_ID = IDS.ID AND S.CLIENT_ID = @client_id
		
PRINT CAST(@searchFullTextRowcount AS nvarchar(5)) + ' rows in SEARCH_FULLTEXT'
	
/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_SEARCH_FULLTEXT%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT S.* into RFPLHDStorage..'+@Ticket+'_SEARCH_FULLTEXT
  		FROM SEARCH_FULLTEXT S
		INNER JOIN #loanIds IDS ON S.LOAN_ID = IDS.ID AND S.CLIENT_ID = ' + @client_id)
  
    	SET @searchFullTextRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@searchFullTextRowsBackedUp AS nvarchar(5)) + ' rows backed up in SEARCH_FULLTEXT'
  
    	/* Does Storage Table meet expectations */
	IF( @searchFullTextRowsBackedUp = @searchFullTextRowcount )
		BEGIN
			PRINT 'SEARCH_FULLTEXT Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				DELETE SEARCH_FULLTEXT 
				FROM SEARCH_FULLTEXT S
				INNER JOIN #loanIds IDS ON S.LOAN_ID = IDS.ID 
				WHERE S.CLIENT_ID = @client_id

				SET @searchFullTextRowsUpdated = @@ROWCOUNT

				PRINT CAST(@searchFullTextRowsUpdated AS nvarchar(5)) + ' rows updated in SEARCH_FULLTEXT'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @searchFullTextRowsUpdated = @searchFullTextRowcount )
		  		BEGIN
		    			PRINT 'SEARCH_FULLTEXT UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'SEARCH_FULLTEXT FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'SEARCH_FULLTEXT Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT  @Ticket+'_SEARCH_FULLTEXT HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END


USE [PRL_ALLIEDSYS_PROD]

CREATE TABLE #workItemMetaDataIds(ID BIGINT)  -- ID TABLE

INSERT INTO #workItemMetaDataIds (ID)
	SELECT wimd.ID
	FROM WORK_ITEM_META_DATA wimd
	INNER JOIN #loanIds IDS ON wimd.LOAN_ID = IDS.ID AND wimd.CLIENT_ID = @client_id
	WHERE wimd.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @wimdRowcount = count([ID])
FROM #workItemMetaDataIds

PRINT CAST(@wimdRowcount AS nvarchar(5)) + ' rows in WORK_ITEM_META_DATA'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_WORK_ITEM_META_DATA%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT wimd.* into RFPLHDStorage..'+@Ticket+'_WORK_ITEM_META_DATA
  		FROM WORK_ITEM_META_DATA wimd
		INNER JOIN #workItemMetaDataIds IDS ON wimd.ID = IDS.ID')
  
    	SET @wimdRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@wimdRowsBackedUp AS nvarchar(5)) + ' rows backed up in WORK_ITEM_META_DATA'
  
    	/* Does Storage Table meet expectations */
	IF( @wimdRowsBackedUp = @wimdRowcount )
		BEGIN
			PRINT @Ticket+'_WORK_ITEM_META_DATA Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE wimd
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM WORK_ITEM_META_DATA wimd
					INNER JOIN #workItemMetaDataIds IDS ON wimd.ID = IDS.ID

				SET @wimdRowsUpdated = @@ROWCOUNT

				PRINT CAST(@wimdRowsUpdated AS nvarchar(5)) + ' rows updated in WORK_ITEM_META_DATA'	

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @wimdRowsUpdated = @wimdRowcount )
		  		BEGIN
		    			PRINT 'WORK_ITEM_META_DATA UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'WORK_ITEM_META_DATA FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'WORK_ITEM_META_DATA Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_WORK_ITEM_META_DATA HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #workItemIds(ID BIGINT,EXTERNAL_ID NVARCHAR(50) )  -- ID TABLE

INSERT INTO #workItemIds (ID, EXTERNAL_ID)
	SELECT wi.ID, wi.EXTERNAL_ID
	FROM WORK_ITEM wi
	INNER JOIN #workItemMetaDataIds IDS ON wi.RELATE_ID = IDS.ID 
	WHERE wi.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @wiRowcount = count([ID])
FROM #workItemIds
		
PRINT CAST(@wiRowcount AS nvarchar(5)) + ' rows in WORK_ITEM'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_WORK_ITEM' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT wi.* into RFPLHDStorage..'+@Ticket+'_WORK_ITEM
  		FROM WORK_ITEM wi
		INNER JOIN #workItemIds IDS ON wi.ID = IDS.ID')
  
    	SET @wiRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@wiRowsBackedUp AS nvarchar(5)) + ' rows backed up in WORK_ITEM'
  
    	/* Does Storage Table meet expectations */
	IF( @wiRowsBackedUp = @wiRowcount )
		BEGIN
			PRINT @Ticket+'_WORK_ITEM Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE wi
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM WORK_ITEM wi
					INNER JOIN #workItemIds IDS ON wi.ID = IDS.ID

				SET @wiRowsUpdated = @@ROWCOUNT

				PRINT CAST(@wiRowsUpdated AS nvarchar(5)) + ' rows updated in WORK_ITEM'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @wiRowsUpdated = @wiRowcount )
		  		BEGIN
		    			PRINT 'WORK_ITEM UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'WORK_ITEM FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'WORK_ITEM Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_WORK_ITEM HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END


CREATE TABLE #productRefundWorkflowIds(ID BIGINT)  -- ID TABLE

INSERT INTO #productRefundWorkflowIds (ID)
	SELECT PRW.ID
	FROM PRODUCT_REFUND_WORKFLOW PRW
	INNER JOIN #workItemIds IDS ON PRW.SYS_ID = IDS.EXTERNAL_ID
	WHERE PRW.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @prwRowcount = count([ID])
FROM #productRefundWorkflowIds

PRINT CAST(@prwRowcount AS nvarchar(5)) + ' rows in PRODUCT_REFUND_WORKFLOW'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables -- Someday this will be the standard 
               WHERE name like  @Ticket+'_PRODUCT_REFUND_WORKFLOW%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT PRW.* into RFPLHDStorage..'+@Ticket+'_PRODUCT_REFUND_WORKFLOW
  		FROM PRODUCT_REFUND_WORKFLOW PRW
		INNER JOIN #productRefundWorkflowIds IDS ON PRW.ID = IDS.ID')
  
    	SET @prwRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@prwRowsBackedUp AS nvarchar(5)) + ' rows backed up in PRODUCT_REFUND_WORKFLOW'
  
    	/* Does Storage Table meet expectations */
	IF( @prwRowsBackedUp = @prwRowcount )
		BEGIN
			PRINT @Ticket+'_PRODUCT_REFUND_WORKFLOW Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE PRW
					SET PURGE_DT = @clientPurgeUTCDate
					 , SYS_UPDATED_ON = @clientPurgeUTCDate      
					, SYS_UPDATED_BY = @Ticket
					, LOCK_ID = (LOCK_ID % 255) + 1
					FROM PRODUCT_REFUND_WORKFLOW PRW
					INNER JOIN #productRefundWorkflowIds IDS ON PRW.ID = IDS.ID

				SET @prwRowsUpdated = @@ROWCOUNT

				PRINT CAST(@prwRowsUpdated AS nvarchar(5)) + ' rows updated in PRODUCT_REFUND_WORKFLOW'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @prwRowsUpdated = @prwRowcount )
		  		BEGIN
		    			PRINT 'PRODUCT_REFUND_WORKFLOW UPDATE SUCCESS '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'PRODUCT_REFUND_WORKFLOW FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'PRODUCT_REFUND_WORKFLOW Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_PRODUCT_REFUND_WORKFLOW HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #workItemTaskIds(ID BIGINT)  -- ID TABLE

INSERT INTO #workItemTaskIds (ID)
	SELECT wit.ID
	FROM WORK_ITEM_TASK wit
	INNER JOIN #workItemIds IDS ON wit.WORK_ITEM_ID = IDS.ID 
	WHERE wit.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @witRowcount = count([ID])
FROM #workItemTaskIds
		
PRINT CAST(@witRowcount AS nvarchar(5)) + ' rows in WORK_ITEM_TASK'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_WORK_ITEM_TASK%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT wit.* into RFPLHDStorage..'+@Ticket+'_WORK_ITEM_TASK
  		FROM WORK_ITEM_TASK wit
		INNER JOIN #workItemTaskIds IDS ON wit.ID = IDS.ID')
  
    	SET @witRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@witRowsBackedUp AS nvarchar(5)) + ' rows backed up in WORK_ITEM_TASK'
  
    	/* Does Storage Table meet expectations */
	IF( @witRowsBackedUp = @witRowcount )
		BEGIN
			PRINT @Ticket+'_WORK_ITEM_TASK Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE wit
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM WORK_ITEM_TASK wit
					INNER JOIN #workItemTaskIds IDS ON wit.ID = IDS.ID

				SET @witRowsUpdated = @@ROWCOUNT

				PRINT CAST(@witRowsUpdated AS nvarchar(5)) + ' rows updated in WORK_ITEM_TASK'
	

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @witRowsUpdated = @witRowcount )
		  		BEGIN
		    			PRINT 'WORK_ITEM_TASK UPDATE SUCCESS '
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'WORK_ITEM_TASK FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'WORK_ITEM_TASK Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_WORK_ITEM_TASK HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #interactionIds(ID BIGINT)  -- ID TABLE

INSERT INTO #interactionIds (ID)
	SELECT I.ID
	FROM INTERACTION I
	INNER JOIN #workItemTaskIds IDS ON I.TASK_ID = IDS.ID 
	WHERE I.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @interactionRowcount = count([ID])
FROM #interactionIds

PRINT CAST(@interactionRowcount AS nvarchar(5)) + ' rows in INTERACTION'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_INTERACTION%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT I.* into RFPLHDStorage..'+@Ticket+'_INTERACTION
  		FROM INTERACTION I
		INNER JOIN #interactionIds IDS ON I.ID = IDS.ID')
  
    	SET @interactionRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@interactionRowsBackedUp AS nvarchar(5)) + ' rows backed up in INTERACTION'
  
    	/* Does Storage Table meet expectations */
	IF( @interactionRowsBackedUp = @interactionRowcount )
		BEGIN
			PRINT @Ticket+'_INTERACTION Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				UPDATE I
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM INTERACTION I
					INNER JOIN #interactionIds IDS ON I.ID = IDS.ID

				SET @interactionRowsUpdated = @@ROWCOUNT

				PRINT CAST(@interactionRowsUpdated AS nvarchar(5)) + ' rows updated in INTERACTION'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @interactionRowsUpdated = @interactionRowcount )
		  		BEGIN
		    			PRINT 'INTERACTION UPDATE SUCCESS '
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'INTERACTION FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'INTERACTION Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_INTERACTION HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #relatedDataIds(ID BIGINT)  -- ID TABLE

INSERT INTO #relatedDataIds (ID)
	SELECT RD.ID 
	FROM RELATED_DATA rd
	INNER JOIN #workItemTaskIds wi on  RD.relate_id = wi.id
	INNER JOIN RELATED_DATA_DEF rddef on RD.def_id = rddef.id 
	WHERE rddef.PURGE_DT IS NULL 
	AND rddef.NAME_TX in('QuoteInvestigationNotes','ProceedsInvestigationNotes')

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @relatedDataRowcount = count([ID])
FROM #relatedDataIds
		
PRINT CAST(@relatedDataRowcount AS nvarchar(5)) + ' rows in RELATED_DATA'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_RELATED_DATA%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT RD.* into RFPLHDStorage..'+@Ticket+'_RELATED_DATA
  		FROM RELATED_DATA RD
		INNER JOIN #relatedDataIds IDS ON RD.ID = IDS.ID')
  
    	SET @relatedDataRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@relatedDataRowsBackedUp AS nvarchar(5)) + ' rows backed up in RELATED_DATA'
  
    	/* Does Storage Table meet expectations */
	IF( @relatedDataRowsBackedUp = @relatedDataRowcount )
		BEGIN
			PRINT @Ticket+'_RELATED_DATA Storage table meets expections - continue'

			/* Step 3 - Perform table update */
				DELETE RELATED_DATA 
				FROM  RELATED_DATA  RD 
				INNER JOIN #relatedDataIds IDS ON RD.ID = IDS.ID

				SET @relatedDataRowsUpdated = @@ROWCOUNT

				PRINT CAST(@relatedDataRowsUpdated AS nvarchar(5)) + ' rows updated in RELATED_DATA'			 

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @relatedDataRowsUpdated = @relatedDataRowcount )
		  		BEGIN
		    			PRINT 'RELATED_DATA SUCCESS UPDATE '		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'RELATED_DATA FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'RELATED_DATA Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT @Ticket+'_RELATED_DATA HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

CREATE TABLE #notificationIds(ID BIGINT)  -- ID TABLE

INSERT INTO #notificationIds (ID)
SELECT N.ID 
FROM NOTIFICATION N
INNER JOIN REPORT_HISTORY RH ON N.RELATE_ID = RH.ID AND RELATE_CLASS_NM = 'PRLReportHistory'
INNER JOIN #fpqueueIds fpq ON RH.ID = fpq.REPORT_HISTORY_ID
WHERE N.PURGE_DT IS NULL AND RH.PURGE_DT IS NULL

/* Step 1 - Calculate rows to be changed - same query as populate Storage table */
SELECT @notificationRowCount = count([ID])
FROM #notificationIds

PRINT CAST(@notificationRowCount AS nvarchar(5)) + ' rows in NOTIFICATION'

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM RFPLHDStorage.sys.tables -- Someday this will be the standard 
               WHERE name like  @Ticket+'_NOTIFICATION%' AND type IN (N'U') )
	BEGIN

    	/* populate new Storage table from Sources */
    	EXEC('SELECT N.* into RFPLHDStorage..'+@Ticket+'_NOTIFICATION
  		FROM NOTIFICATION N
		INNER JOIN #notificationIds IDS ON N.ID = IDS.ID')
  
    	SET @notificationRowsBackedUp = @@ROWCOUNT
		
		PRINT CAST(@notificationRowsBackedUp AS nvarchar(5)) + ' rows backed up in NOTIFICATION'
  
    	/* Does Storage Table meet expectations */
	IF( @notificationRowsBackedUp = @notificationRowCount )
		BEGIN
			PRINT  @Ticket+'_NOTIFICATION Storage table meets expections - continue'

			/* Step 3 - Perform table update */
			UPDATE N
					SET PURGE_DT = @clientPurgeUTCDate
					,UPDATE_DT = @clientPurgeUTCDate
					,UPDATE_USER_TX = @Ticket
					,LOCK_ID = (LOCK_ID % 255) + 1
					FROM NOTIFICATION N
					INNER JOIN #notificationIds IDS ON N.ID = IDS.ID

				SET @notificationRowsUpdated = @@ROWCOUNT

				PRINT CAST(@notificationRowsUpdated AS nvarchar(5)) + ' rows updated in NOTIFICATION'

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @notificationRowsUpdated = @notificationRowCount )
		  		BEGIN
		    			PRINT 'NOTIFICATION UPDATE SUCCESS '
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'NOTIFICATION FAILED TO UPDATE - Performing Rollback'
		    			GOTO OUTER_ERROR;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'NOTIFICATION Storage does not meet expectations - rollback'
			GOTO OUTER_ERROR;
		END
	END
ELSE
	BEGIN
		PRINT  @Ticket+'_NOTIFICATION HD TABLE EXISTS - Stop work'
		GOTO OUTER_ERROR;
	END

/*
	SELECT @FPQRowcount AS FPQRowcount
		, @FPQRowsBackedUp AS FPQRowsBackedUp
		, @FPQRowsUpdated AS FPQRowsUpdated

		, @FPDetailRowcount AS FPDetailRowcount
		, @FPDetailRowsBackedUp AS FPDetailRowsBackedUp
		, @FPDetailRowsUpdated AS FPDetailRowsUpdated

		, @searchFullTextRowcount AS searchFullTextRowcount
		, @searchFullTextRowsBackedUp AS searchFullTextRowsBackedUp
		, @searchFullTextRowsUpdated AS searchFullTextRowsUpdated

		, @addressRowcount AS addressRowcount
		, @addressRowsBackedUp AS addressRowsBackedUp
		, @addressRowsUpdated AS addressRowsUpdated

		, @borrowerRowcount AS borrowerRowcount
		, @borrowerRowsBackedUp AS borrowerRowsBackedUp
		, @borrowerRowsUpdated AS borrowerRowsUpdated

		, @proceedRowcount AS proceedRowcount
		, @proceedRowsBackedUp AS proceedRowsBackedUp
		, @proceedRowsUpdated AS proceedRowsUpdated

		, @quoteRowcount AS quoteRowcount
		, @quoteRowsBackedUp AS quoteRowsBackedUp
		, @quoteRowsUpdated AS quoteRowsUpdated

		, @claimRowcount AS claimRowcount
		, @claimRowsBackedUp AS claimRowsBackedUp
		, @claimRowsUpdated AS claimRowsUpdated

		, @loanRowcount AS loanRowcount
		, @loanRowsBackedUp AS loanRowsBackedUp
		, @loanRowsUpdated AS loanRowsUpdated

		, @productRowcount AS productRowcount
		, @productRowsBackedUp AS productRowsBackedUp
		, @productRowsUpdated AS productRowsUpdated

		, @blobRowcount AS blobRowcount
		, @blobRowsBackedUp AS blobRowsBackedUp
		, @blobRowsUpdated AS blobRowsUpdated

		, @documentRowcount AS documentRowcount
		, @documentRowsBackedUp AS documentRowsBackedUp
		, @documentRowsUpdated AS documentRowsUpdated
		
		, @wimdRowcount AS wimdRowcount
		, @wimdRowsBackedUp AS wimdRowsBackedUp
		, @wimdRowsUpdated AS wimdRowsUpdated
		
		, @notificationRowcount AS notificationRowcount
		, @notificationRowsBackedUp AS notificationRowsBackedUp
		, @notificationRowsUpdated AS notificationRowsUpdated
		
		, @relatedDataRowcount AS relatedDataRowcount
		, @relatedDataRowsBackedUp AS relatedDataRowsBackedUp
		, @relatedDataRowsUpdated AS relatedDataRowsUpdated
		
		, @interactionRowcount AS interactionRowcount
		, @interactionRowsBackedUp AS interactionRowsBackedUp
		, @interactionRowsUpdated AS interactionRowsUpdated
		
		, @witRowcount AS witRowcount
		, @witRowsBackedUp AS witRowsBackedUp
		, @witRowsUpdated AS witRowsUpdated
		
		, @prwRowcount AS prwRowcount
		, @prwRowsBackedUp AS prwRowsBackedUp
		, @prwRowsUpdated AS prwRowsUpdated
		
		, @wiRowcount AS wiRowcount
		, @wiRowsBackedUp AS wiRowsBackedUp
		, @wiRowsUpdated AS wiRowsUpdated
*/

COMMIT TRAN CLEAN_UP;
	PRINT 'TRANSACTION CLEAN_UP COMMITED'
	GOTO ENDING;
OUTER_ERROR:
	ROLLBACK TRAN CLEAN_UP
	PRINT 'TRANSACTION CLEAN_UP IS ROLLED BACK'
ENDING:
	PRINT 'END OF EXECUTNG SCRIPT'