use UniTrac

BEGIN TRAN;
DECLARE @lender AS NVARCHAR(20)
DECLARE @RowsToChange INT;

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

		
use UniTrac



declare @rowcount int = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

--SELECT COUNT(*)
UPDATE TOP (1000) l
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'BKFulCleanUp'
--select * 
FROM #tmploan t 
JOIN loan l ON l.ID = t.LOAN_ID
AND l.PURGE_DT is NULL


	select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END


SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY


--SELECT COUNT(*)
UPDATE  TOP (1000) c
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpcol t 
JOIN COLLATERAL c on c.ID = t.col_id
AND c.PURGE_DT IS null


select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

--SELECT COUNT(*)
UPDATE  TOP (1000) p
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpprop t
JOIN PROPERTY p on p.ID = t.PROPERTY_ID
AND p.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

--SELECT COUNT(*)
UPDATE   TOP (1000) rc
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmprc t
JOIN REQUIRED_COVERAGE rc ON rc.ID = t.rc_id
AND rc.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY


UPDATE  TOP (1000) olr
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpowner t
JOIN OWNER_LOAN_RELATE olr on olr.ID = t.OLR_ID
AND olr.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY


UPDATE  TOP (1000) o
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpowner t
JOIN OWNER o ON o.ID = t.OWNER_ID
AND o.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY


UPDATE  TOP (1000) oa
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpowner t
JOIN OWNER_ADDRESS oa ON oa.ID = t.owner_add_id
AND oa.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

--SELECT COUNT(*)
UPDATE  TOP (1000) re
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpReqescrow t
JOIN REQUIRED_ESCROW re on re.ID = t.RE_ID
AND re.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY


--SELECT COUNT(*)
UPDATE  TOP (1000) e
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpescrow t 
JOIN ESCROW e ON e.ID = t.escrow_id
AND e.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY


--SELECT COUNT(*)
UPDATE  TOP (1000) pr
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpPR t
JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.ID = t.pr_id
AND pr.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

--SELECT COUNT(*)
UPDATE  TOP (1000) op
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpOP t
JOIN OWNER_POLICY op ON op.ID = t.OWNER_POLICY_ID
AND op.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

--SELECT COUNT(*)
UPDATE  TOP (1000) pc
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), update_user_tx = 'UTPRDT541'
FROM #tmpPC t
JOIN POLICY_COVERAGE pc ON pc.ID = t.pc_id
AND pc.PURGE_DT IS null

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END



SET @rowcount  = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

UPDATE  TOP (1000) ih
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM INTERACTION_HISTORY ih
JOIN #tmpprop t ON t.PROPERTY_ID = ih.PROPERTY_ID
AND ih.PURGE_DT is NULL

select @rowcount = @@rowcount

	END TRY
	BEGIN CATCH

		select Error_number(),
			   error_message(),
			   error_severity(),
				error_state(),
				error_line()

		 THROW
		 BREAK

	END CATCH
END




UPDATE n
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM NOTICE n
JOIN #tmploan t on t.LOAN_ID = n.LOAN_ID
WHERE n.PURGE_DT is null


--SELECT COUNT(*)
UPDATE n
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM #tmpRC r
JOIN NOTICE n ON n.CPI_QUOTE_ID = r.CPI_QUOTE_ID
WHERE n.PURGE_DT is null

--SELECT COUNT(*)
UPDATE r
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
JOIN #tmploan t ON t.LOAN_ID = r.UNITRAC_RELATE_CLASS_ID 
WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Loan'
and r.purge_dt is null

UPDATE r
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
JOIN #tmpcol t ON t.col_id = r.UNITRAC_RELATE_CLASS_ID 
WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Collateral'
AND r.PURGE_DT IS null

UPDATE pcp
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM PRIOR_CARRIER_POLICY pcp
JOIN #tmpRC r ON r.rc_id = pcp.REQUIRED_COVERAGE_ID


UPDATE ih
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM INTERACTION_HISTORY ih
JOIN #tmploan t ON t.LOAN_ID = ih.LOAN_ID

UPDATE i
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM IMPAIRMENT i
JOIN #tmpRC r on r.rc_id = i.REQUIRED_COVERAGE_ID

UPDATE wi
SET PURGE_DT = GETDATE(), update_dt = GETDATE(), UPDATE_USER_TX = 'UTPRDT541'
FROM WORK_ITEM wi
JOIN #tmploan t ON t.LOAN_ID = wi.RELATE_ID
WHERE wi.WORKFLOW_DEFINITION_ID = 8
