---- DROP TABLE #TMPRC
SELECT LOAN.NUMBER_TX , LOAN.DIVISION_CODE_TX , LOAN.BRANCH_CODE_TX ,
RC.REQUIRED_AMOUNT_NO , RC.TYPE_CD ,  PR.REPLACEMENT_COST_VALUE_NO , LOAN.BALANCE_AMOUNT_NO , 
LOAN.ID AS LOAN_ID , COLL.ID AS COLL_ID , COLL.PROPERTY_ID AS PR_ID , RC.ID AS RC_ID
INTO #TMPRC
FROM LOAN
JOIN COLLATERAL COLL ON COLL.LOAN_ID = LOAN.ID
AND COLL.PURGE_DT IS NULL AND LOAN.PURGE_DT IS NULL
JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = COLL.PROPERTY_ID
AND RC.PURGE_DT IS NULL
JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
AND PR.PURGE_DT IS NULL
WHERE LOAN.LENDER_ID = 2231
AND LOAN.RECORD_TYPE_CD = 'G'
AND PR.RECORD_TYPE_CD = 'G'
AND RC.RECORD_TYPE_CD = 'G'
AND COLL.PRIMARY_LOAN_IN = 'Y'
AND LOAN.STATUS_CD = 'A'
AND DIVISION_CODE_TX = '4'


Joey Comment:

Most loans are in Division 99 - this Division_Code_tx restriction needs to go away.

You can limit the output to real-estate by checking the collateral_code.address_lookup_ind = 'Y'
after joining the collateral_code table.
inner join COLLATERAL_CODE on COLLATERAL.COLLATERAL_CODE_ID = COLLATERAL_CODE.ID

In addition, we do not want Condos as part of this task.
Please exclude COndos by using a statement like this

and COLLATERAL_CODE.SECONDARY_CLASS_CD <> 'COND'

Also - we really are looking at only updating a subset, the GetCurrentCurrentCoverage function is fairly expensive on resources.
There is no need to call this on all coverages, but just Hazard, and only where the property.REPLACEMENT_COST_VALUE_NO is null or zero

I would add the following to the where clause of your opening query

and ( Property.Replacement_cost_value_no < 0.1 or Property.Replacement_cost_value_no is null )
and RC.Type_cd = 'HAZARD'


Down below - why in the heck are we setting the policy coverage record to the loan balance?  Who asked for this?  This is very very bad.

The code to select the policy coverage is incomplete and will cause problems if ran as is over time.It is not even lookign for Building Coverage Type "A"  - 'CADW'

I code it something like this when I get the current policy in a single query

,CurrentPolicy as
(
	select 
	#TMPRC.RC_ID as RC_ID,
	OP.ID as OP_ID,
	#TMPRC.Type_cd as COVERAGE,
	(
		select policy_coverage.ID
		from policy_coverage
		inner join ( select top 1 PC.ID, PC.end_dt from policy_coverage as pc where pc.owner_policy_id = OP.ID and PC.sub_Type_cd = 'CADW' and PC.Type_cd = #TMPRC.TYPE_CD order by PC.end_dt desc ) as pcmax on pcmax.id = policy_coverage.id
		where
		policy_coverage.owner_policy_id = OP.ID
	) as PC_ID

	from
	#TMPRC
	cross apply GetCurrentCoverage(#TMPRC.PROPERTY_ID, #TMPRC.RC_ID, #TMPRC.TYPE_CD) OP
)






----14110

--SELECT * FROM #TMPRC

---- DROP TABLE #TMPPLCY
SELECT * 
INTO #TMPPLCY
FROM #TMPRC RC
CROSS APPLY ( SELECT * FROM dbo.GetCurrentCoverage(rc.PR_ID , rc.rc_id , rc.type_cd)
) as Plcy
----7437

--- DROP TABLE #TMPPC
SELECT PLCY.* , PC.ID AS PC_ID , PC.SUB_TYPE_CD ,
PC.START_DT , PC.END_DT , 
PC.AMOUNT_NO , PC.BASE_AMOUNT_NO , 
PC.CANCELLED_IN , 0 AS EXCLUDE
INTO #TMPPC
FROM #TMPPLCY PLCY
JOIN POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = PLCY.ID
AND PC.PURGE_DT IS NULL
WHERE PC.TYPE_CD = PLCY.TYPE_CD
--ORDER BY PLCY.NUMBER_TX , PC.START_DT
---- 10753

----- DROP TABLE #TMPPC_01
SELECT * 
INTO #TMPPC_01
FROM #TMPPC
WHERE AMOUNT_NO = 100000000
AND (REPLACEMENT_COST_VALUE_NO = 100000000 OR
ISNULL(REPLACEMENT_COST_VALUE_NO,0) = 0)
ORDER BY NUMBER_TX
---- 2498

SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36660RC
FROM #TMPRC
---- 14110


SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36660PC
FROM #TMPPC
---- 2498


SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36660PC_01
FROM #TMPPC_01
---- 2498


UPDATE PC SET AMOUNT_NO = T1.BALANCE_AMOUNT_NO , 
BASE_AMOUNT_NO = T1.BALANCE_AMOUNT_NO ,
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'TASK36660', 
LOCK_ID = PC.LOCK_ID % 255 + 1
---- SELECT NUMBER_TX , T1.BALANCE_AMOUNT_NO , PC.AMOUNT_NO , PC.BASE_AMOUNT_NO , T1.BALANCE_AMOUNT_NO
FROM POLICY_COVERAGE PC JOIN #TMPPC_01 T1 ON  T1.PC_ID = PC.ID
---- 2498


UPDATE PR SET REPLACEMENT_COST_VALUE_NO = TMP.BALANCE_AMOUNT_NO , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'TASK36660' , 
LOCK_ID = PR.LOCK_ID % 255 + 1
----- SELECT TMP.BALANCE_AMOUNT_NO , PR.REPLACEMENT_COST_VALUE_NO
FROM PROPERTY PR JOIN #TMPPC_01 TMP ON 
TMP.PROPERTY_ID = PR.ID 
---- 2498


 INSERT INTO PROPERTY_CHANGE
 (
 ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN
 )
 SELECT DISTINCT  'Allied.UniTrac.Property' , TMP.PROPERTY_ID , 'TASK36660' , 'N' , 
 GETDATE() ,  1 , 
 'Changed RCV from ' + convert(varchar(20), ISNULL(REPLACEMENT_COST_VALUE_NO,0))  + ' to ' + 
 ISNULL(convert(varchar(20), CAST(BALANCE_AMOUNT_NO AS DECIMAL(18,2))), 'NULL') , 
 'N' , 'Y' , 1 ,  'Allied.UniTrac.Property' , TMP.PROPERTY_ID , 'PEND' , 'N'
 FROM #TMPPC_01 TMP 
 ---- 2475
 
 --SELECT DISTINCT PROPERTY_ID FROM #TMPPC_01
 ---- 2475
 
 
UPDATE RC SET GOOD_THRU_DT = NULL , 
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'TASK36660' ,
LOCK_ID = RC.LOCK_ID % 255 + 1
---- SELECT COUNT(*)
FROM REQUIRED_COVERAGE RC JOIN #TMPPC_01 TMP ON 
TMP.PROPERTY_ID = RC.PROPERTY_ID 
---- 4996