USE UniTrac


---- DROP TABLE #TMPPROPERTY
SELECT  
		LOAN.NUMBER_TX as LoanNumber,
        LOAN.ID AS LOAN_ID ,
        COLL.ID AS COLL_ID ,
        COLL.PROPERTY_ID AS PR_ID
INTO    #TMPPROPERTY
FROM    LOAN
        JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
                                AND COLL.PURGE_DT IS NULL
                                AND LOAN.PURGE_DT IS NULL
								and COLL.primary_loan_in = 'Y'
        JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
                            AND PR.PURGE_DT IS NULL
							and PR.RECORD_TYPE_CD = 'G'
        INNER JOIN COLLATERAL_CODE ON Coll.COLLATERAL_CODE_ID = COLLATERAL_CODE.ID
WHERE   
		1=1
		and LOAN.LENDER_ID = 2260
		and loan.Purge_dt is null
		and loan.RECORD_TYPE_CD = 'G'
		and LOAN.EXTRACT_UNMATCH_COUNT_NO = 0
		and loan.Status_cd <> 'U'
		and COLL.EXTRACT_UNMATCH_COUNT_NO = 0
		and COLL.status_cd <> 'U'
		AND ( REPLACEMENT_COST_VALUE_NO IS  NULL
              OR REPLACEMENT_COST_VALUE_NO = 0
            )
        AND COLLATERAL_CODE.SECONDARY_CLASS_CD <> 'COND'
		--AND Loan.NUMBER_TX = '140322133'

---- DROP TABLE #TMPPLCY
SELECT  
required_coverage.PROPERTY_ID as PROPERTY_ID,
(
	select policy_coverage.ID
	from policy_coverage
	inner join ( select top 1 PC.ID, PC.end_dt from policy_coverage as pc where pc.owner_policy_id = OP.ID and PC.sub_Type_cd = 'CADW' and PC.Type_cd = required_coverage.Type_cd order by PC.end_dt desc ) as pcmax on pcmax.id = policy_coverage.id
	where
	policy_coverage.owner_policy_id = OP.ID	
) as PC_ID
INTO #TMPPLCY
FROM    #TMPPROPERTY PR
inner join required_coverage on required_coverage.PROPERTY_ID = PR.PR_ID and required_coverage.purge_dt is null and required_coverage.Type_cd = 'HAZARD'
cross apply GetCurrentCoverage(required_coverage.PROPERTY_ID, required_coverage.ID, required_coverage.Type_cd) OP
where 
OP.EXCESS_IN = 'N'


SELECT #TMPPROPERTY.LoanNumber, PR.REPLACEMENT_COST_VALUE_NO, PC.Amount_no
FROM PROPERTY PR 
JOIN #TMPPROPERTY on #TMPPROPERTY.PR_ID = PR.ID
JOIN #TMPPLCY on #TMPPLCY.PROPERTY_ID = PR.ID
JOIN POLICY_COVERAGE PC on PC.ID = #TMPPLCY.PC_ID







--UPDATE PR SET REPLACEMENT_COST_VALUE_NO = PC.Amount_no , 
--UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0228273' , 
--LOCK_ID = PR.LOCK_ID % 255 + 1
------- SELECT TMP.BALANCE_AMOUNT_NO , PC.BASE_AMOUNT_NO
--FROM PROPERTY PR 
--JOIN #TMPPLCY on #TMPPLCY.PROPERTY_ID = PR.ID
--JOIN POLICY_COVERAGE PC on PC.ID = #TMPPLCY.PC_ID


-- INSERT INTO PROPERTY_CHANGE
-- (
-- ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
-- CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
-- LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN
-- )
-- SELECT DISTINCT  'Allied.UniTrac.Property' , TMP.PROPERTY_ID , 'INC0228273' , 'N' , 
-- GETDATE() ,  1 , 
-- 'Changed RCV from ' + convert(varchar(20), ISNULL(REPLACEMENT_COST_VALUE_NO,0))  + ' to ' + 
-- ISNULL(convert(varchar(20), CAST(BALANCE_AMOUNT_NO AS DECIMAL(18,2))), 'NULL') , 
-- 'N' , 'Y' , 1 ,  'Allied.UniTrac.Property' , TMP.PROPERTY_ID , 'PEND' , 'N'
-- FROM #TMPPLCY TMP 
-- WHERE NUMBER_TX = '140322133'
-- ---- 2475
 
-- --SELECT DISTINCT PROPERTY_ID FROM #TMPPC_01
-- ---- 2475
 
 
--UPDATE RC SET GOOD_THRU_DT = NULL , 
--UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0228273' ,
--LOCK_ID = RC.LOCK_ID % 255 + 1
------ SELECT COUNT(*)
--FROM REQUIRED_COVERAGE RC JOIN #TMPPLCY TMP ON 
--TMP.PROPERTY_ID = RC.PROPERTY_ID 
--WHERE NUMBER_TX = '140322133'
------ 4996



--SELECT RC.INSURANCE_SUB_STATUS_CD,* FROM LOAN L
--INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
--INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
--INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
--INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
--INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
--INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
--INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
--INNER JOIN dbo.LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
--WHERE LL.CODE_TX IN ('7350') AND L.NUMBER_TX IN (SELECT NUMBER_TX FROM #TMPPLCY)
--AND L.NUMBER_TX = '140322133'