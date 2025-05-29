--SELECT NUMBER_TX,l.BRANCH_CODE_TX, l.DIVISION_CODE_TX, MIN(l.CREATE_DT), COUNT(*), MAX(l.ID) AS MaxLoanId
--FROM LOAN l
--JOIN lender ldr ON ldr.id = l.LENDER_ID
--WHERE l.PURGE_DT is NULL
--AND ldr.CODE_TX = '3551'
--AND l.RECORD_TYPE_CD in ('g','a','d')
--AND CAST(l.CREATE_DT AS DATE) = CAST('2019-04-25' AS DATE)
--GROUP BY l.NUMBER_TX,l.BRANCH_CODE_TX, l.DIVISION_CODE_TX
--HAVING COUNT(*) >1

DECLARE @updUser AS NVARCHAR(20)

SET @updUser = 'TFS49400'

declare @ToBePurgedLoanIdList table ( LOAN_ID bigint )
declare @ToBePurgedCollIdList table ( col_id bigint )
declare @ToBePurgedPropIdList table ( Property_Id bigint )
declare @ToBePurgedRCIdList table ( rc_id bigint, CPI_QUOTE_ID bigint )
declare @ToBePurgedOwnerIdList table ( OLR_ID bigint, OWNER_ID bigint, ADDRESS_ID bigint )
declare @ToBePurgedREIdList table ( RE_ID bigint )
declare @ToBePurgedEscrowIdList table ( escrow_id bigint )
declare @ToBePurgedPORIdList table ( pr_id bigint )
declare @ToBePurgedOPIdList table ( OWNER_POLICY_ID bigint )
declare @ToBePurgedPCIdList table ( Pc_Id bigint )
	
insert into @ToBePurgedLoanIdList
select 273530115 UNION
select 273530116 UNION
select 273530135 UNION
select 273530158 UNION
select 273530162 UNION
select 273530163 UNION
select 273530166 UNION
select 273530172 UNION
select 273530167 UNION
select 273530169 UNION
select 273530168 UNION
select 273530179 UNION
select 273530165 UNION
select 273530171 UNION
select 273530175 UNION
select 273530198 UNION
select 273530200 UNION
select 273530203 UNION
select 273530205 UNION
select 273530206 UNION
select 273530173 UNION
select 273530177 UNION
select 273530170 UNION
select 273530174 UNION
select 273530180 UNION
select 273530187 UNION
select 273530191 UNION
select 273530192 UNION
select 273530178 UNION
select 273530182 UNION
select 273530188 UNION
select 273530190 UNION
select 273530176 UNION
select 273530183 UNION
select 273530196 UNION
select 273530211 UNION
select 273530212 UNION
select 273530217 UNION
select 273530218 UNION
select 273530214 UNION
select 273530216 UNION
select 273530220 UNION
select 273530228 UNION
select 273530229 UNION
select 273530230 UNION
select 273530231 UNION
select 273530232 UNION
select 273530181 UNION
select 273530184 UNION
select 273530185 UNION
select 273530186 UNION
select 273530189 UNION
select 273530197 UNION
select 273530199 UNION
select 273530202 UNION
select 273530222 UNION
select 273530209 UNION
select 273530210 UNION
select 273530194 UNION
select 273530195

--SELECT *
--FROM LOAN
--WHERE NUMBER_TX IN (
--        SELECT LoanNumber_TX
--        FROM LOAN_EXTRACT_TRANSACTION_DETAIL
--        WHERE TRANSACTION_ID = 282918760
--            AND (
--                LM_MatchLoanId_TX IS NULL
--                OR LM_MatchLoanId_TX = '0'
--                )
--        )
--    AND UPDATE_USER_TX = 'LDHADHOC'

insert into @ToBePurgedCollIdList
SELECT c.ID AS col_id
FROM @ToBePurgedLoanIdList t
JOIN COLLATERAL c ON c.LOAN_ID = t.LOAN_ID
WHERE c.PURGE_DT is NULL

insert into @ToBePurgedPropIdList
SELECT c.PROPERTY_ID
FROM @ToBePurgedCollIdList t
JOIN COLLATERAL c on c.ID = t.col_id
JOIN PROPERTY p on p.ID = c.PROPERTY_ID
WHERE p.PURGE_DT is null


--select count(*) as 'Number of Collaterals Matching these properties' from @ToBePurgedCollIdList

insert INTO @ToBePurgedRCIdList
SELECT rc.ID as rc_id, rc.CPI_QUOTE_ID
FROM @ToBePurgedPropIdList t
JOIN REQUIRED_COVERAGE rc on rc.PROPERTY_ID = t.PROPERTY_ID
WHERE rc.PURGE_DT is NULL

insert INTO @ToBePurgedOwnerIdList
SELECT olr.ID AS OLR_ID,olr.OWNER_ID, o.ADDRESS_ID 
FROM @ToBePurgedLoanIdList t
JOIN OWNER_LOAN_RELATE olr on olr.LOAN_ID = t.LOAN_ID
JOIN OWNER o on o.ID = olr.OWNER_ID
JOIN OWNER_ADDRESS oa ON oa.ID = o.ADDRESS_ID 
WHERE o.PURGE_DT is NULL
AND olr.PURGE_DT is null
AND oa.PURGE_DT is null


--DROP TABLE @ToBePurgedREIdList
insert INTO @ToBePurgedREIdList
SELECT re.ID AS RE_ID
FROM @ToBePurgedRCIdList t
JOIN REQUIRED_ESCROW re ON re.REQUIRED_COVERAGE_ID = t.rc_id
WHERE re.PURGE_DT is NULL

insert INTO @ToBePurgedEscrowIdList
SELECT e.ID AS escrow_id
FROM @ToBePurgedPropIdList t 
JOIN ESCROW e ON e.PROPERTY_ID = t.PROPERTY_ID
WHERE e.PURGE_DT is NULL


insert INTO @ToBePurgedPORIdList
SELECT pr.ID as pr_id
FROM @ToBePurgedPropIdList t
JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.PROPERTY_ID = t.PROPERTY_ID
WHERE pr.PURGE_DT is null


--DROP table @ToBePurgedOPIdList
insert INTO @ToBePurgedOPIdList
SELECT pr.OWNER_POLICY_ID 
FROM @ToBePurgedPORIdList t
JOIN PROPERTY_OWNER_POLICY_RELATE pr ON pr.ID = t.pr_id
JOIN OWNER_POLICY op on op.ID = pr.OWNER_POLICY_ID
WHERE op.PURGE_DT is null

Insert INTO @ToBePurgedPCIdList
SELECT pc.ID AS pc_id
FROM @ToBePurgedOPIdList o
JOIN POLICY_COVERAGE pc ON pc.OWNER_POLICY_ID = o.OWNER_POLICY_ID
WHERE pc.PURGE_DT IS NULL

		
--select *
--FROM @ToBePurgedRCIdList t
--JOIN PRIOR_CARRIER_POLICY pcp on pcp.REQUIRED_COVERAGE_ID = t.RC_id


--SELECT 		 FPCRCR.* 
--FROM 	@ToBePurgedRCIdList rc
--JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.REQUIRED_COVERAGE_ID = rc.rc_id


declare @rowcount int = 1000

while @rowcount >= 1000
BEGIN

	BEGIN TRY

--SELECT COUNT(*)
UPDATE l
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedLoanIdList t 
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
UPDATE c
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser,lock_id = lock_id + 1
FROM @ToBePurgedCollIdList t 
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
UPDATE p
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser,lock_id = lock_id + 1
FROM @ToBePurgedPropIdList t
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
UPDATE rc
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedRCIdList t
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

--SELECT COUNT(*) 
UPDATE olr
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedOwnerIdList t
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

--SELECT COUNT(*) 
UPDATE o
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedOwnerIdList t
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

--SELECT COUNT(*) 
UPDATE oa
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedOwnerIdList t
JOIN OWNER_ADDRESS oa ON oa.ID = t.OWNER_ID
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
UPDATE re
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedREIdList t
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
UPDATE e
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedEscrowIdList t 
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
UPDATE pr
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedPORIdList t
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
UPDATE op
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedOPIdList t
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
UPDATE pc
SET PURGE_DT = getdate(), update_dt = getdate(), update_user_tx = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedPCIdList t
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

--SELECT COUNT(*)
UPDATE ercr
SET PURGE_DT = getdate(), update_dt = getdate(), UPDATE_USER_TX = @updUser, lock_id = lock_id + 1
FROM ESCROW_REQUIRED_COVERAGE_RELATE ercr
JOIN @ToBePurgedEscrowIdList t on t.escrow_id = ercr.ESCROW_ID
WHERE ercr.PURGE_DT is null

UPDATE LOAN_NUMBER
set PURGE_DT = getdate(), lock_id = lock_id + 1, UPDATE_DT = getdate(), UPDATE_USER_TX = @updUser
where loan_id in (select id from @ToBePurgedLoanIdList)

--SELECT COUNT(*)
UPDATE n
SET PURGE_DT = getdate(), update_dt = getdate(), UPDATE_USER_TX = @updUser, lock_id = lock_id + 1
FROM NOTICE n
JOIN @ToBePurgedLoanIdList t on t.LOAN_ID = n.LOAN_ID
WHERE n.PURGE_DT is null


--SELECT COUNT(*)
UPDATE n
SET PURGE_DT = getdate(), update_dt = getdate(), UPDATE_USER_TX = @updUser, lock_id = lock_id + 1
FROM @ToBePurgedRCIdList r
JOIN NOTICE n ON n.CPI_QUOTE_ID = r.CPI_QUOTE_ID
WHERE n.PURGE_DT is null

--SELECT COUNT(*)
UPDATE r
SET PURGE_DT = getdate(), update_dt = getdate(), UPDATE_USER_TX = @updUser, lock_id = lock_id + 1
FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
JOIN @ToBePurgedLoanIdList t ON t.LOAN_ID = r.UNITRAC_RELATE_CLASS_ID 
WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Loan'
and r.purge_dt is null

--SELECT COUNT(*)
UPDATE r
SET PURGE_DT = getdate(), update_dt = getdate(), UPDATE_USER_TX = @updUser, lock_id = lock_id + 1
FROM UNITRAC_TO_LATEST_LENDER_DATA_RELATE r
JOIN @ToBePurgedCollIdList t ON t.col_id = r.UNITRAC_RELATE_CLASS_ID 
WHERE r.UNITRAC_RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Collateral'
AND r.PURGE_DT IS null

