use UniTrac 

/*
DROP TABLE #tmploan
DROP TABLE #tmpcol
DROP TABLE #tmpprop
DROP TABLE #tmpRC
DROP TABLE #tmpowner
DROP TABLE #tmpReqescrow
DROP TABLE #tmpescrow
DROP TABLE #tmpPR
DROP TABLE #tmpOP
DROP TABLE #tmpPC

ROLLBACK

*/

BEGIN TRAN;
DECLARE @lender AS NVARCHAR(20)
DECLARE @Ticket NVARCHAR(15) =N'AIH_3338';
DECLARE @RowsToChange INT;
DECLARE @RowsToChange2 INT;
DECLARE @RowsToChange3 INT;
DECLARE @RowsToChange4 INT;
DECLARE @RowsToChange5 INT;
DECLARE @RowsToChange6 INT;
DECLARE @RowsToChange7 INT;
DECLARE @RowsToChange8 INT;
DECLARE @RowsToChange9 INT;
DECLARE @RowsToChange10 INT;
DECLARE @RowsToChange11 INT;
DECLARE @RowsToChange12 INT;
DECLARE @RowsToChange13 INT;
DECLARE @RowsToChange14 INT;
DECLARE @RowsToChange15 INT;
DECLARE @RowsToChange16 INT;
DECLARE @RowsToChange17 INT;
DECLARE @RowsToChange18 INT;
DECLARE @RowsToChange19 INT;
DECLARE @RowsToChange20 INT;
DECLARE @RowsToChange21 INT;

SET @lender = '4219'

--DROP table #tmploan
SELECT l.ID as LOAN_ID
INTO #tmploan
FROM LENDER ldr
JOIN LOAN l ON l.LENDER_ID = ldr.id 
WHERE 
ldr.CODE_TX = @lender
AND l.PURGE_DT is null


SELECT c.ID AS col_id
INTO #tmpcol
FROM #tmploan t
JOIN COLLATERAL c ON c.LOAN_ID = t.LOAN_ID
WHERE c.PURGE_DT is NULL


SELECT c.PROPERTY_ID
INTO #tmpprop
FROM #tmpcol t
JOIN COLLATERAL c on c.ID = t.col_id
JOIN PROPERTY p on p.ID = c.PROPERTY_ID
WHERE p.PURGE_DT is null



SELECT rc.ID as rc_id, rc.CPI_QUOTE_ID
INTO #tmpRC
FROM #tmpprop t
JOIN REQUIRED_COVERAGE rc on rc.PROPERTY_ID = t.PROPERTY_ID
WHERE rc.PURGE_DT is NULL


SELECT olr.ID AS OLR_ID,olr.OWNER_ID, o.ADDRESS_ID , oa.id as owner_add_id
INTO #tmpowner
FROM #tmploan t
JOIN OWNER_LOAN_RELATE olr on olr.LOAN_ID = t.LOAN_ID
JOIN OWNER o on o.ID = olr.OWNER_ID
JOIN OWNER_ADDRESS oa ON oa.ID = o.ADDRESS_ID 
WHERE o.PURGE_DT is NULL
AND olr.PURGE_DT is null
AND oa.PURGE_DT is null


--DROP TABLE #tmpReqescrow
SELECT re.ID AS RE_ID
INTO #tmpReqescrow
FROM #tmpRC t
JOIN REQUIRED_ESCROW re ON re.REQUIRED_COVERAGE_ID = t.rc_id
WHERE re.PURGE_DT is NULL


SELECT e.ID AS escrow_id
INTO #tmpescrow
FROM #tmpprop t 
JOIN ESCROW e ON e.PROPERTY_ID = t.PROPERTY_ID
WHERE e.PURGE_DT is NULL



SELECT pr.ID as pr_id
INTO #tmpPR
FROM #tmpprop t
JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.PROPERTY_ID = t.PROPERTY_ID
WHERE pr.PURGE_DT is null


--DROP table #tmpOP
SELECT pr.OWNER_POLICY_ID 
INTO #tmpOP
FROM #tmpPR t
JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.ID = t.pr_id
JOIN OWNER_POLICY op on op.ID = pr.OWNER_POLICY_ID
WHERE op.PURGE_DT is null


SELECT pc.ID AS pc_id
INTO #tmpPC
FROM #tmpOP o
JOIN POLICY_COVERAGE pc ON pc.OWNER_POLICY_ID = o.OWNER_POLICY_ID
WHERE pc.PURGE_DT IS NULL


SELECT @RowsToChange = count(L.ID)
FROM #tmploan t 
JOIN loan l ON l.ID = t.LOAN_ID
AND l.PURGE_DT is NULL

SELECT @RowsToChange2 = count(C.ID)
FROM #tmpcol t 
JOIN COLLATERAL c on c.ID = t.col_id
AND c.PURGE_DT IS null

SELECT @RowsToChange3 = count(P.ID)
FROM #tmpprop t
JOIN PROPERTY p on p.ID = t.PROPERTY_ID
AND p.PURGE_DT IS null

SELECT @RowsToChange4 = count(RC.ID)
FROM #tmprc t
JOIN REQUIRED_COVERAGE rc ON rc.ID = t.rc_id
AND rc.PURGE_DT IS null

SELECT @RowsToChange5 = count(OLR.ID)
FROM #tmpowner t
JOIN OWNER_LOAN_RELATE olr on olr.ID = t.OLR_ID
AND olr.PURGE_DT IS null

SELECT @RowsToChange6 = count(RE.ID)
FROM #tmpReqescrow t
JOIN REQUIRED_ESCROW re on re.ID = t.RE_ID
AND re.PURGE_DT IS null

SELECT @RowsToChange7 = count(E.ID)
FROM #tmpescrow t 
JOIN ESCROW e ON e.ID = t.escrow_id
AND e.PURGE_DT IS null

SELECT @RowsToChange8 = count(PR.ID)
FROM #tmpPR t
JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.ID = t.pr_id
AND pr.PURGE_DT IS null


SELECT @RowsToChange9 = count(op.ID)
FROM #tmpOP t
JOIN OWNER_POLICY op ON op.ID = t.OWNER_POLICY_ID
AND op.PURGE_DT IS null


SELECT @RowsToChange10 = count(o.ID)
FROM #tmpowner t
JOIN OWNER o ON o.ID = t.OWNER_ID
AND o.PURGE_DT IS null


SELECT @RowsToChange11 = count(oa.ID)
FROM #tmpowner t
JOIN OWNER_ADDRESS oa ON oa.ID = t.owner_add_id
AND oa.PURGE_DT IS null

SELECT @RowsToChange12 = count(pc.ID)
FROM #tmpPC t
JOIN POLICY_COVERAGE pc ON pc.ID = t.pc_id
AND pc.PURGE_DT IS null

SELECT @RowsToChange13 = count(ih.ID)
FROM INTERACTION_HISTORY ih
JOIN #tmpprop t ON t.PROPERTY_ID = ih.PROPERTY_ID
AND ih.PURGE_DT is NULL

SELECT @RowsToChange14 = count(n.ID)
FROM NOTICE n
JOIN #tmploan t on t.LOAN_ID = n.LOAN_ID
WHERE n.PURGE_DT is null

SELECT @RowsToChange15 = count(n.ID)
FROM #tmpRC r
JOIN NOTICE n ON n.CPI_QUOTE_ID = r.CPI_QUOTE_ID
WHERE n.PURGE_DT is null

SELECT @RowsToChange16 = count(r.ID)
FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
JOIN #tmploan t ON t.LOAN_ID = r.UNITRAC_RELATE_CLASS_ID 
WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Loan'
and r.purge_dt is null

SELECT @RowsToChange17 = count(r.ID)
FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
JOIN #tmpcol t ON t.col_id = r.UNITRAC_RELATE_CLASS_ID 
WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Collateral'
AND r.PURGE_DT IS null

SELECT @RowsToChange18 = count(pcp.ID)
FROM PRIOR_CARRIER_POLICY pcp
JOIN #tmpRC r ON r.rc_id = pcp.REQUIRED_COVERAGE_ID


SELECT @RowsToChange19 = count(ih.ID)
FROM INTERACTION_HISTORY ih
JOIN #tmploan t ON t.LOAN_ID = ih.LOAN_ID

SELECT @RowsToChange20= count(i.ID)
FROM IMPAIRMENT i
JOIN #tmpRC r on r.rc_id = i.REQUIRED_COVERAGE_ID

SELECT @RowsToChange21 = count(wi.ID)
FROM WORK_ITEM wi
JOIN #tmploan t ON t.LOAN_ID = wi.RELATE_ID
WHERE wi.WORKFLOW_DEFINITION_ID = 8


/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS (SELECT *
               FROM UniTracHDStorage.sys.tables  -- Someday this will be the standard 
               WHERE name like  @Ticket+'_%' AND type IN (N'U') )
	BEGIN	   
				select L.* 
				INTO UnitracHDStorage..AIH_3338_LOAN
				FROM #tmploan t 
				JOIN loan l ON l.ID = t.LOAN_ID
				AND l.PURGE_DT is NULL

				select C.* 
				INTO UnitracHDStorage..AIH_3338_COLLATERAL
				FROM #tmpcol t 
				JOIN COLLATERAL c on c.ID = t.col_id
				AND c.PURGE_DT IS null

				select P.* 
				INTO UnitracHDStorage..AIH_3338_PROPERTY
				FROM #tmpprop t
				JOIN PROPERTY p on p.ID = t.PROPERTY_ID
				AND p.PURGE_DT IS null

				select RC.* 
				INTO UnitracHDStorage..AIH_3338_REQUIRED_COVERAGE
				FROM #tmprc t
				JOIN REQUIRED_COVERAGE rc ON rc.ID = t.rc_id
				AND rc.PURGE_DT IS null

				select OLR.* 
				INTO UnitracHDStorage..AIH_3338_OWNER_LOAN_RELATE
				FROM #tmpowner t
				JOIN OWNER_LOAN_RELATE olr on olr.ID = t.OLR_ID
				AND olr.PURGE_DT IS null

				select O.* 
				INTO UnitracHDStorage..AIH_3338_OWNER
				FROM #tmpowner t
				JOIN OWNER o ON o.ID = t.OWNER_ID
				AND o.PURGE_DT IS null

				select OA.* 
				INTO UnitracHDStorage..AIH_3338_OWNER_ADDRESS
				FROM #tmpowner t
				JOIN OWNER_ADDRESS oa ON oa.ID = t.owner_add_id
				AND oa.PURGE_DT IS null

				select RE.* 
				INTO UnitracHDStorage..AIH_3338_REQUIRED_ESCROW
				FROM #tmpReqescrow t
				JOIN REQUIRED_ESCROW re on re.ID = t.RE_ID
				AND re.PURGE_DT IS null

				select E.* 
				INTO UnitracHDStorage..AIH_3338_ESCROW
				FROM #tmpescrow t 
				JOIN ESCROW e ON e.ID = t.escrow_id
				AND e.PURGE_DT IS null

				select PR.* 
				INTO UnitracHDStorage..AIH_3338_PROPERTY_OWNER_POLICY_RELATE
				FROM #tmpPR t
				JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.ID = t.pr_id
				AND pr.PURGE_DT IS null

				select OP.* 
				INTO UnitracHDStorage..AIH_3338_OWNER_POLICY
				FROM #tmpOP t
				JOIN OWNER_POLICY op ON op.ID = t.OWNER_POLICY_ID
				AND op.PURGE_DT IS null

				select PC.* 
				INTO UnitracHDStorage..AIH_3338_POLICY_COVERAGE
				FROM #tmpPC t
				JOIN POLICY_COVERAGE pc ON pc.ID = t.pc_id
				AND pc.PURGE_DT IS null

				---Interaction History joined at Property

				select IH.* 
				INTO UnitracHDStorage..AIH_3338_INTERACTION_HISTORY
				FROM INTERACTION_HISTORY ih
				JOIN #tmpprop t ON t.PROPERTY_ID = ih.PROPERTY_ID
				AND ih.PURGE_DT is NULL

				select N.* 
				INTO UnitracHDStorage..AIH_3338_NOTICE
				FROM NOTICE n
				JOIN #tmploan t on t.LOAN_ID = n.LOAN_ID
				WHERE n.PURGE_DT is null

				select N.* 
				INTO UnitracHDStorage..AIH_3338_NOTICE_CPI_QUOTE_ID
				FROM #tmpRC r
				JOIN NOTICE n ON n.CPI_QUOTE_ID = r.CPI_QUOTE_ID
				WHERE n.PURGE_DT is null

				---UNITRAC_TO_LATEST_LENDER_DATA_RELATE joined at Loan
				select R.* 
				INTO UnitracHDStorage..AIH_3338_UNITRAC_TO_LATEST_LENDER_DATA_RELATE_LOAN
				FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
				JOIN #tmploan t ON t.LOAN_ID = r.UNITRAC_RELATE_CLASS_ID 
				WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Loan'
				and r.purge_dt is null

				---UNITRAC_TO_LATEST_LENDER_DATA_RELATE joined at Collateral
				select R.* 
				INTO UnitracHDStorage..AIH_3338_UNITRAC_TO_LATEST_LENDER_DATA_RELATE_COLLATERAL
				FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
				JOIN #tmpcol t ON t.col_id = r.UNITRAC_RELATE_CLASS_ID 
				WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Collateral'
				AND r.PURGE_DT IS null

				select PCP.* 
				INTO UnitracHDStorage..AIH_3338_PRIOR_CARRIER_POLICY
				FROM PRIOR_CARRIER_POLICY pcp
				JOIN #tmpRC r ON r.rc_id = pcp.REQUIRED_COVERAGE_ID

				---Interaction History joined at Loan
				select IH.* 
				INTO UnitracHDStorage..AIH_3338_INTERACTION_HISTORY_LOAN
				FROM INTERACTION_HISTORY ih
				JOIN #tmploan t ON t.LOAN_ID = ih.LOAN_ID

				select I.* 
				INTO UnitracHDStorage..AIH_3338_IMPAIRMENT
				FROM IMPAIRMENT i
				JOIN #tmpRC r on r.rc_id = i.REQUIRED_COVERAGE_ID

				select WI.* 
				INTO UnitracHDStorage..AIH_3338_WORK_ITEM
				FROM WORK_ITEM wi
				JOIN #tmploan t ON t.LOAN_ID = wi.RELATE_ID
				WHERE wi.WORKFLOW_DEFINITION_ID = 8

	
		IF( @@RowCount = @RowsToChange )
		BEGIN
			PRINT 'Storage table meets expections to Loans - continue'

			/* Step 3 - Perform table update */
			UPDATE L
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'BKFulCleanUp'
			--select * 
			FROM #tmploan t 
			JOIN loan l ON l.ID = t.LOAN_ID
			AND l.PURGE_DT is NULL

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
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
			;
		END
		IF( @@RowCount = @RowsToChange2 )
		BEGIN
			PRINT 'Storage table meets expections to Collateral - continue'

			/* Step 3 - Perform table update */
			UPDATE   c
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpcol t 
			JOIN COLLATERAL c on c.ID = t.col_id
			AND c.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange2 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
		END
	    IF( @@RowCount = @RowsToChange3 )
		BEGIN
			PRINT 'Storage table meets expections to Property - continue'

			/* Step 3 - Perform table update */
			UPDATE   p
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpprop t
			JOIN PROPERTY p on p.ID = t.PROPERTY_ID
			AND p.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange3 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			;
		END
		IF( @@RowCount = @RowsToChange4 )
		BEGIN
			PRINT 'Storage table meets expections to REQUIRED_COVERAGE - continue'

			/* Step 3 - Perform table update */
			UPDATE    rc
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmprc t
			JOIN REQUIRED_COVERAGE rc ON rc.ID = t.rc_id
			AND rc.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange4 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange5 )
		BEGIN
			PRINT 'Storage table meets expections to OWNER_LOAN_RELATE - continue'

			/* Step 3 - Perform table update */
			UPDATE  olr
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpowner t
			JOIN OWNER_LOAN_RELATE olr on olr.ID = t.OLR_ID
			AND olr.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange5 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange6 )
		BEGIN
			PRINT 'Storage table meets expections to REQUIRED_ESCROW - continue'

			/* Step 3 - Perform table update */
			UPDATE  TOP (1000) re
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpReqescrow t
			JOIN REQUIRED_ESCROW re on re.ID = t.RE_ID
			AND re.PURGE_DT IS null


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange6 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
;
		END
	    IF( @@RowCount = @RowsToChange7 )
		BEGIN
			PRINT 'Storage table meets expections to ESCROW - continue'

			/* Step 3 - Perform table update */
			UPDATE  e
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			--select *
			FROM #tmpescrow t 
			JOIN ESCROW e ON e.ID = t.escrow_id
			AND e.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange7 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange8 )
		BEGIN
			PRINT 'Storage table meets expections to PROPERTY_OWNER_POLICY_RELATE - continue'

			/* Step 3 - Perform table update */
			UPDATE   pr
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpPR t
			JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.ID = t.pr_id
			AND pr.PURGE_DT IS null


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange8 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange9 )
		BEGIN
			PRINT 'Storage table meets expections to OWNER_POLICY - continue'

			/* Step 3 - Perform table update */
			UPDATE  op
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			--select * 
			FROM #tmpOP t
			JOIN OWNER_POLICY op ON op.ID = t.OWNER_POLICY_ID
			AND op.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange9 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
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
			;
		END
		IF( @@RowCount = @RowsToChange10 )
		BEGIN
			PRINT 'Storage table meets expections to OWNER - continue'

			/* Step 3 - Perform table update */
			UPDATE  o
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpowner t
			JOIN OWNER o ON o.ID = t.OWNER_ID
			AND o.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange10 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
		END
	    IF( @@RowCount = @RowsToChange11)
		BEGIN
			PRINT 'Storage table meets expections to OWNER_ADDRESS - continue'

			/* Step 3 - Perform table update */
			UPDATE  oa
		SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpowner t
			JOIN OWNER_ADDRESS oa ON oa.ID = t.owner_add_id
			AND oa.PURGE_DT IS null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange11 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
		END
		IF( @@RowCount = @RowsToChange12 )
		BEGIN
			PRINT 'Storage table meets expections to POLICY_COVERAGE - continue'

			/* Step 3 - Perform table update */
			UPDATE    PC
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
			FROM #tmpPC t
			JOIN POLICY_COVERAGE pc ON pc.ID = t.pc_id
			AND pc.PURGE_DT IS null


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange12 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange13 )
		BEGIN
			PRINT 'Storage table meets expections to INTERACTION_HISTORY - continue'

			/* Step 3 - Perform table update */
			UPDATE  TOP (1000) ih
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM INTERACTION_HISTORY ih
			JOIN #tmpprop t ON t.PROPERTY_ID = ih.PROPERTY_ID
			AND ih.PURGE_DT is NULL

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange13 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange14 )
		BEGIN
			PRINT 'Storage table meets expections to NOTICE joined by Loans - continue'

			/* Step 3 - Perform table update */
			UPDATE n
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM NOTICE n
			JOIN #tmploan t on t.LOAN_ID = n.LOAN_ID
			WHERE n.PURGE_DT is null


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange14 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
		END
	    IF( @@RowCount = @RowsToChange15 )
		BEGIN
			PRINT 'Storage table meets expections to NOTICE joined by CPI_QUOTE - continue'

			/* Step 3 - Perform table update */
			UPDATE n
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM #tmpRC r
			JOIN NOTICE n ON n.CPI_QUOTE_ID = r.CPI_QUOTE_ID
			WHERE n.PURGE_DT is null

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange15 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange16 )
		BEGIN
			PRINT 'Storage table meets expections to UNITRAC_TO_LATEST_LENDER_DATA_RELATE joined by LOAN - continue'

			/* Step 3 - Perform table update */
			UPDATE r
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
			JOIN #tmploan t ON t.LOAN_ID = r.UNITRAC_RELATE_CLASS_ID 
			WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Loan'
			and r.purge_dt is null


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange16 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange17 )
		BEGIN
			PRINT 'Storage table meets expections to UNITRAC_TO_LATEST_LENDER_DATA_RELATE joined by COLLATERAL - continue'

			/* Step 3 - Perform table update */
			UPDATE r
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
			JOIN #tmpcol t ON t.col_id = r.UNITRAC_RELATE_CLASS_ID 
			WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Collateral'
			AND r.PURGE_DT IS null


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange17 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange18 )
		BEGIN
			PRINT 'Storage table meets expections to NOTICE joined by Loans - continue'

			/* Step 3 - Perform table update */
			UPDATE pcp
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM PRIOR_CARRIER_POLICY pcp
			JOIN #tmpRC r ON r.rc_id = pcp.REQUIRED_COVERAGE_ID

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange18 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
	ELSE
      		BEGIN
        		PRINT 'Storage does not meet expectations - rollback'
			ROLLBACK;
		END
	    IF( @@RowCount = @RowsToChange19 )
		BEGIN
			PRINT 'Storage table meets expections to INTERACTION_HISTORY joined by LOAN - continue'

			/* Step 3 - Perform table update */
			UPDATE ih
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM INTERACTION_HISTORY ih
			JOIN #tmploan t ON t.LOAN_ID = ih.LOAN_ID

        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange19 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange20 )
		BEGIN
			PRINT 'Storage table meets expections to IMPAIRMENT - continue'

			/* Step 3 - Perform table update */
			UPDATE i
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM IMPAIRMENT i
			JOIN #tmpRC r on r.rc_id = i.REQUIRED_COVERAGE_ID



        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange20 )
		  		BEGIN
		    			PRINT 'SUCCESS - Performing Commit'
		    			;
		  		END
			ELSE
		  		BEGIN
		    			PRINT 'FAILED TO UPDATE - Performing Rollback'
		    			;
		  		END
		END
		IF( @@RowCount = @RowsToChange21 )
		BEGIN
			PRINT 'Storage table meets expections to WORK_ITEM - continue'

			/* Step 3 - Perform table update */
			UPDATE wi
			SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
			FROM WORK_ITEM wi
			JOIN #tmploan t ON t.LOAN_ID = wi.RELATE_ID
			WHERE wi.WORKFLOW_DEFINITION_ID = 8


        		/* Step 4 - Inspect results - Commit/Rollback */
			IF ( @@ROWCOUNT = @RowsToChange21 )
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
