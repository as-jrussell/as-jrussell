/*
hold down ALT and then press Q and then press S 
*/

IF OBJECT_ID(N'tempdb..#loan1temp',N'U') IS NOT NULL
  DROP TABLE #loan1temp
IF OBJECT_ID(N'tempdb..#loan2temp',N'U') IS NOT NULL
  DROP TABLE #loan2temp

DECLARE @ldr_code1 AS NVarChar(10)
DECLARE @ldr_code2 AS NVarChar(10)
DECLARE @ldr_id1 AS BigInt
DECLARE @ldr_id2 AS BigInt
	SELECT @ldr_code1 = <ldr_code1,,''>
	SELECT @ldr_code2 = <ldr_code2,,''>

SELECT TOP 1 @ldr_id1 = ldr.ID
FROM LENDER AS ldr WITH(NOLOCK)
WHERE ldr.PURGE_DT IS NULL
AND ldr.CODE_TX = @ldr_code1
ORDER BY CASE WHEN ldr.STATUS_CD = 'ACTIVE' THEN 1 ELSE 2 END

SELECT TOP 1 @ldr_id2 = ldr.ID
FROM LENDER AS ldr WITH(NOLOCK)
WHERE ldr.PURGE_DT IS NULL
AND ldr.CODE_TX = @ldr_code2
ORDER BY CASE WHEN ldr.STATUS_CD = 'ACTIVE' THEN 1 ELSE 2 END

SELECT 'LENDER' = 'LENDER',ldr.*
FROM LENDER AS ldr WITH(NOLOCK)
WHERE PURGE_DT IS NULL
  AND ldr.ID IN (@ldr_id1,@ldr_id2)

DECLARE @loan_num1 AS NVarChar(18)
DECLARE @loan_num2 AS NVarChar(18)
	SELECT @loan_num1 = <loan_num1,,''>
	SELECT @loan_num2 = <loan_num2,,''>

DECLARE @loan_id1 AS BigInt
DECLARE @loan_id2 AS BigInt
	SELECT TOP 1 loan.ID, loan.NUMBER_TX, loan.LENDER_ID, loan.PURGE_DT, loan.STATUS_CD 
	into #loan1temp
	FROM LOAN AS loan WITH(NOLOCK) 
		left join lender ldr WITH(NOLOCK) on ldr.id = loan.LENDER_ID 
	SELECT @loan_id1 = ID
	FROM #loan1temp
	ORDER BY 
		CASE WHEN NUMBER_TX IN (@loan_num1) AND LENDER_ID IN (@ldr_id1) THEN 1 
		WHEN PURGE_DT IS NULL AND STATUS_CD = 'A' THEN 2 
		ELSE 3 
		END

	SELECT TOP 1 loan.ID, loan.NUMBER_TX, loan.LENDER_ID, loan.PURGE_DT, loan.STATUS_CD
	into #loan2temp
	FROM LOAN AS loan WITH(NOLOCK) 
		left join lender ldr WITH(NOLOCK) on ldr.id = loan.LENDER_ID

	SELECT @loan_id2 = ID 
	FROM #loan2temp
	ORDER BY 
		CASE WHEN NUMBER_TX IN (@loan_num2) AND LENDER_ID IN (@ldr_id2) THEN 1 
		WHEN PURGE_DT IS NULL AND STATUS_CD = 'A' THEN 2 
		ELSE 3 
		END
/*
SELECT
 '@loan_num1' = @loan_num1
,'@loan_id1' = @loan_id1
,'@loan_num2' = @loan_num2
,'@loan_id2' = @loan_id2
*/
SELECT 'LOAN' = 'LOAN1',LDR_CODE=ldr.CODE_TX,loan.* FROM LOAN AS loan WITH(NOLOCK) left join lender ldr WITH(NOLOCK) on ldr.id = loan.LENDER_ID WHERE loan.NUMBER_TX IN (@loan_num1) AND loan.LENDER_ID IN (@ldr_id1)
SELECT 'LOAN' = 'LOAN2',LDR_CODE=ldr.CODE_TX,loan.* FROM LOAN AS loan WITH(NOLOCK) left join lender ldr WITH(NOLOCK) on ldr.id = loan.LENDER_ID WHERE loan.NUMBER_TX IN (@loan_num2) AND loan.LENDER_ID IN (@ldr_id2)

DECLARE @last_name1 NVarChar(30)
DECLARE @first_name1 NVarChar(30)

DECLARE @last_name2 NVarChar(30)
DECLARE @first_name2 NVarChar(30)
	SELECT
	 @last_name1 = <last_name1,,'%'>
	,@first_name1 = <first_name1,,'%'>

	SELECT
	 @last_name2 = <last_name2,,'%'>
	,@first_name2 = <first_name2,,'%'>

DECLARE @own_id1 BigInt
DECLARE @own_id2 BigInt

DECLARE @addr1_line1 NVarChar(100)
DECLARE @addr2_line1 NVarChar(100)
	SELECT @addr1_line1 = <@addr1_line1,,'%'>
	SELECT @addr2_line1 = <@addr2_line1,,'%'>

SELECT 'ADDRESS' = 'ADDR1',addr.* FROM OWNER_ADDRESS AS addr WITH(NOLOCK) WHERE addr.PURGE_DT IS NULL AND addr.LINE_1_TX LIKE @addr1_line1 AND @addr1_line1 <> '' AND @addr1_line1 <> '%'
ORDER BY addr.STATE_PROV_TX, addr.CITY_TX, addr.LINE_1_TX

SELECT 'ADDRESS' = 'ADDR2',addr.* FROM OWNER_ADDRESS AS addr WITH(NOLOCK) WHERE addr.PURGE_DT IS NULL AND addr.LINE_1_TX LIKE @addr2_line1 AND @addr2_line1 <> '' AND @addr2_line1 <> '%'
ORDER BY addr.STATE_PROV_TX, addr.CITY_TX, addr.LINE_1_TX

DECLARE @prop_id1 BigInt
DECLARE @prop_id2 BigInt
	SELECT TOP 1 @prop_id1 = prop.ID
	FROM PROPERTY AS prop WITH(NOLOCK)
	JOIN OWNER_ADDRESS AS addr WITH(NOLOCK) ON addr.ID = prop.ADDRESS_ID
	WHERE prop.PURGE_DT IS NULL AND addr.PURGE_DT IS NULL AND addr.LINE_1_TX LIKE @addr1_line1 AND @addr1_line1 <> '' AND @addr1_line1 <> '%'
	AND prop.LENDER_ID = IsNull(@ldr_id1, prop.LENDER_ID)
	
	SELECT TOP 1 @prop_id2 = prop.ID
	FROM PROPERTY AS prop WITH(NOLOCK)
	JOIN OWNER_ADDRESS AS addr WITH(NOLOCK) ON addr.ID = prop.ADDRESS_ID
	WHERE prop.PURGE_DT IS NULL AND addr.PURGE_DT IS NULL AND addr.LINE_1_TX LIKE @addr2_line1 AND @addr2_line1 <> '' AND @addr2_line1 <> '%'
	AND prop.LENDER_ID = IsNull(@ldr_id2, prop.LENDER_ID)

SELECT 'PROPERTY' = 'PROP1',prop.* FROM PROPERTY AS prop WITH(NOLOCK) WHERE prop.ID = @prop_id1

SELECT 'PROPERTY' = 'PROP2',prop.* FROM PROPERTY AS prop WITH(NOLOCK) WHERE prop.ID = @prop_id2

SELECT
 'LOAN-COL-PROP-OWN' = 'LOAN-COL-PROP-OWN'
 ,LOAN_ID = loan.ID,'colID'=col.ID,PROP_ID = prop.ID
,loan.LENDER_ID
,LOAN_ID = loan.ID
,LOAN_NUMBER = loan.NUMBER_TX
,'COL.NUM' = col.COLLATERAL_NUMBER_NO
,'COL.PURGE' = col.PURGE_DT
,'COL.STAT' = col.STATUS_CD
,'COL.UNMATCH' = col.EXTRACT_UNMATCH_COUNT_NO
,'PROP.REC_TYPE_CD'= prop.RECORD_TYPE_CD
,'COL.PRIM.LOAN' = col.PRIMARY_LOAN_IN
,'OWN.ADDR.PRIMARY' = olr.PRIMARY_IN
,'COL.RETAIN' = col.RETAIN_IN
,'COL.LOAN%' = col.LOAN_PERCENTAGE_NO
,'PROP.CALC_COL_BAL' = prop.CALCULATED_COLL_BALANCE_NO
,'COL.LENDER_COL_CD' = col.LENDER_COLLATERAL_CODE_TX
,'COL.PURPOSE' = col.PURPOSE_CODE_TX
,col.COLLATERAL_CODE_ID
,'CC.DESCRIPTION' = cc.DESCRIPTION_TX
,COL_ID = col.ID
,'COL.PURGE' = col.PURGE_DT
,'COL.UPDATE' = col.UPDATE_DT
,PROP_ID = prop.ID
,'PROP.PURGE' = prop.PURGE_DT
,'PROP.UPDATE' = prop.UPDATE_DT
,PROP_ADDR_ID = prop.ADDRESS_ID
,Prop_Desc=coalesce(nullif(addr.LINE_1_TX,''),nullif(prop.description_tx,''),isnull(prop.year_tx+' ','')+isnull(prop.make_tx+' ','')+prop.model_tx)
,'COL.PRIM.LOAN' = col.PRIMARY_LOAN_IN
,'COL.STAT' = col.STATUS_CD
,'PROP.REC_TYPE_CD'= prop.RECORD_TYPE_CD
,ColPurge=col.PURGE_DT
,'COL.UPDATE' = cast(col.UPDATE_DT as date)
,'COL.UPDATE_USER' = col.UPDATE_USER_TX
,'ColNum' = col.COLLATERAL_NUMBER_NO
,'colID'=col.ID
,PROP_ID = prop.ID
,LOAN_NUMBER = loan.NUMBER_TX
,LOAN_ID = loan.ID
,loan.DIVISION_CODE_TX
,loan.BRANCH_CODE_TX
,OWN_ADDR_ID = own.ADDRESS_ID
,OWN_ID = own.ID
,OLR_ID = olr.ID
,'OLR.PRIMARY' = olr.PRIMARY_IN
,OLR_OWN_TYPE = olr.OWNER_TYPE_CD
,'OLR.OWN_TYPE.MEAN' = ot.MEANING_TX
,own.NAME_TX
,own.LAST_NAME_TX
,own.FIRST_NAME_TX
,addr.LINE_1_TX
,addr.LINE_2_TX
,addr.CITY_TX
,addr.STATE_PROV_TX
,addr.POSTAL_CODE_TX
,col.LENDER_COLLATERAL_CODE_TX
,PROP_DESC = prop.DESCRIPTION_TX
,'PROP.REC_TYPE_CD'= prop.RECORD_TYPE_CD
,'PROP.REC_TYPE'= rtc.MEANING_TX
,'PROP.ACV' = prop.ACV_NO
,'PROP.YEAR' = prop.YEAR_TX
,'PROP.MAKE' = prop.MAKE_TX
,'PROP.MODEL' = prop.MODEL_TX
,'PROP.BODY' = prop.BODY_TX
,'PROP.VIN' = prop.VIN_TX
--,'OWN_POL:'='OWN_POL:'
--,op.*
FROM COLLATERAL AS col WITH(NOLOCK)
--left join collateral c2 (nolock) on c2.PROPERTY_ID=col.PROPERTY_ID and c2.id<>col.id
FULL JOIN LOAN AS loan WITH(NOLOCK) ON col.LOAN_ID = loan.ID
LEFT JOIN COLLATERAL_CODE cc WITH(NOLOCK) ON cc.ID = col.COLLATERAL_CODE_ID
LEFT JOIN PROPERTY AS prop WITH(NOLOCK) ON prop.ID = col.PROPERTY_ID
LEFT JOIN REF_CODE AS rtc WITH(NOLOCK) ON rtc.DOMAIN_CD = 'RecordType' AND rtc.CODE_CD = prop.RECORD_TYPE_CD
--LEFT JOIN PROPERTY_OWNER_POLICY_RELATE As popr WITH(NOLOCK) ON popr.PROPERTY_ID = col.PROPERTY_ID
--LEFT JOIN OWNER_POLICY As op WITH(NOLOCK) ON op.ID = popr.OWNER_POLICY_ID
LEFT JOIN OWNER_ADDRESS AS addr WITH(NOLOCK) ON addr.ID = prop.ADDRESS_ID
LEFT JOIN OWNER_LOAN_RELATE AS olr WITH(NOLOCK) ON olr.LOAN_ID = col.LOAN_ID and olr.owner_type_cd='B'
LEFT JOIN REF_CODE AS ot WITH(NOLOCK) ON ot.DOMAIN_CD = 'OwnerType' AND ot.CODE_CD = olr.OWNER_TYPE_CD
LEFT JOIN OWNER AS own WITH(NOLOCK) ON own.ID = olr.OWNER_ID
WHERE (col.LOAN_ID IN (@loan_id1, @loan_id2) OR loan.NUMBER_TX IN (@loan_num1, @loan_num2) OR col.PROPERTY_ID IN (@prop_id1, @prop_id2))
AND loan.LENDER_ID IN (@ldr_id1, @ldr_id2)
--AND olr.PRIMARY_IN = 'Y' -- (CASE WHEN col.COLLATERAL_NUMBER_NO = 1 THEN 'Y' ELSE olr.PRIMARY_IN END)
AND loan.PURGE_DT IS NULL
--AND col.PURGE_DT IS NULL
AND addr.PURGE_DT IS NULL
AND olr.PURGE_DT IS NULL
AND own.PURGE_DT IS NULL
ORDER BY
  case when exists(select top 1 c2.id from collateral c2 (nolock) where c2.PROPERTY_ID=col.PROPERTY_ID and c2.purge_dt is null and c2.id<>col.id) and col.purge_dt is null then 1 else 999999999 end
, case when col.purge_dt is null then 1 else 2 end
, case when loan.STATUS_CD in ('U') then 1 else 2 end
, case when col.STATUS_CD in ('I','U') then 1 else 2 end
, case when loan.number_tx = @loan_num1 and addr.LINE_1_TX like @addr1_line1 then 1 else 0 end
, case when loan.number_tx = @loan_num2 and addr.LINE_1_TX like @addr2_line1 then 0 else 1 end
, loan.NUMBER_TX, loan.LENDER_ID, col.LOAN_ID
, col.COLLATERAL_NUMBER_NO, col.UPDATE_DT DESC

select
 'OWNER_LOAN_RELATE' = 'OLR'
,olr.LOAN_ID
,LOAN_NUMBER = loan.NUMBER_TX
,'OLR.PRIMARY' = olr.PRIMARY_IN
,OLR_ID = olr.ID
,OLR_OWN_TYPE = olr.OWNER_TYPE_CD
,OWN_ID = own.ID
,OWN_ADDR_ID = own.ADDRESS_ID
,own.LAST_NAME_TX
,own.FIRST_NAME_TX
from OWNER_LOAN_RELATE AS olr WITH(NOLOCK)
JOIN OWNER own WITH(NOLOCK) on own.ID = olr.OWNER_ID
JOIN LOAN loan on loan.id = olr.LOAN_ID
WHERE (loan.number_tx in (@loan_num1, @loan_num2) and loan.LENDER_ID in (@ldr_id1, @ldr_id2))
ORDER BY loan.NUMBER_TX

select
 'ENTITY' = pc.ENTITY_NAME_TX
,pc.ENTITY_ID
,'CREATE' = coalesce(pcu.CREATE_DT,pc.CREATE_DT)
,'BY' = pc.USER_TX
,'TICKET' = pc.TICKET_TX
,pc.DESCRIPTION_TX
,pc.NOTE_TX
,pcu.*
from PROPERTY_CHANGE pc WITH(NOLOCK)
left join PROPERTY_CHANGE_UPDATE pcu WITH(NOLOCK) on pcu.CHANGE_ID = pc.id
where pc.ENTITY_NAME_TX = 'Allied.UniTrac.Loan'
and pc.ENTITY_ID in (@loan_id1, @loan_id2)
order by pc.CREATE_DT DESC
/*
select
 'ENTITY' = pc.ENTITY_NAME_TX
,pc.ENTITY_ID
,'CREATE' = coalesce(pcu.CREATE_DT,pc.CREATE_DT)
,'BY' = pc.USER_TX
,'TICKET' = pc.TICKET_TX
,pc.DESCRIPTION_TX
,pc.NOTE_TX
,pcu.*
from PROPERTY_CHANGE pc WITH(NOLOCK)
left join PROPERTY_CHANGE_UPDATE pcu WITH(NOLOCK) on pcu.CHANGE_ID = pc.id
where pc.ENTITY_NAME_TX = 'Allied.UniTrac.Collateral'
and pc.ENTITY_ID in ()
order by pc.CREATE_DT DESC

select
 'ENTITY' = pc.ENTITY_NAME_TX
,pc.ENTITY_ID
,'CREATE' = coalesce(pcu.CREATE_DT,pc.CREATE_DT)
,'BY' = pc.USER_TX
,'TICKET' = pc.TICKET_TX
,pc.DESCRIPTION_TX
,pc.NOTE_TX
,pcu.*
from PROPERTY_CHANGE pc WITH(NOLOCK)
left join PROPERTY_CHANGE_UPDATE pcu WITH(NOLOCK) on pcu.CHANGE_ID = pc.id
where pc.ENTITY_NAME_TX = 'Allied.UniTrac.Property'
and pc.ENTITY_ID in ()
order by pc.CREATE_DT DESC
*/