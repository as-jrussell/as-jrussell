Use UNITRAC_DW

Select L.CODE_TX,L.NAME_TX,L.TAX_ID_TX,L.TEST_IN,L.ACTIVE_DT,L.CANCEL_DT,L.PURGE_DT,L.STATUS_CD from UniTrac.dbo.LENDER L
left Join LENDER_DIM DW on DW.CODE_TX = L.CODE_TX
WHERE L.PURGE_DT is NULL and DW.CODE_TX is NULL and L.STATUS_CD = 'ACTIVE' 
and L.ACTIVE_DT is not NULL
--WHERE L.AGENCY_ID = 1 and L.PURGE_DT is NULL and DW.CODE_TX is NULL and L.STATUS_CD = 'ACTIVE' 
--AND L.ACTIVE_DT is not NULL-- AND L.CODE_TX='5660'
--and L.CODE_TX in ('0100','2039','2042','2044','2078','2079','2255','2255','2257','2259','2261','3082','3083','3084','3086','3087','3088','3089','3090','3140','4455','5155','5175','6609','1045','3081','7523','7524','7532','7568','7593','7613','7643','7644','7645','7646','7647','7648','7649','7650','7651','7652','7653','7654','7655','7656','7657','7658','7659','7660','7661','7662','7663','7664')
Order by L.PURGE_DT,L.STATUS_CD


--Move Lenders into LENDER_DIM
--after Sharlenes approval, if there are any from the Review step
Insert into LENDER_DIM (CODE_TX,NAME_TX,CREATE_DT,UPDATE_DT,AGENCY_ID)
Select L.CODE_TX,L.NAME_TX,GETDATE(),GETDATE(),L.AGENCY_ID from UniTrac.dbo.LENDER L
left Join LENDER_DIM DW on DW.CODE_TX = L.CODE_TX
where  L.PURGE_DT is NULL and DW.CODE_TX is NULL and L.STATUS_CD = 'ACTIVE' and L.ACTIVE_DT is not NULL --AND L.AGENCY_ID = 1 and L.CODE_TX<>'3767' OR L.CODE_TX='2273' OR L.CODE_TX='2276')


--Insert missing Lender_DIM Attributes
--If no results from the Review step above then this will have 0 rows affected
Insert into LENDER_DIM_ATTRIBUTE (LENDER_ID,CLAIM_SERVICE_IN,TRACK_ONLY_IN,TEST_ACCT_IN,ACTIVE_IN,CENTER_ID,AGENCY_ID,STATE_CD,COUNTRY_CD,START_DT,END_DT)
Select DW.ID,'N','N',L.TEST_IN, Case when L.STATUS_CD = 'ACTIVE' then 'Y' else 'N' END,
MAX(CD.ID),L.AGENCY_ID,Case when A.STATE_PROV_TX is NULL then '??' else A.STATE_PROV_TX END,'US',isnull(L.ACTIVE_DT,L.CREATE_DT),L.CANCEL_DT
from UniTrac.dbo.LENDER L
Join LENDER_DIM DW on DW.CODE_TX = L.CODE_TX
left Join LENDER_DIM_ATTRIBUTE DWA on DWA.LENDER_ID = DW.ID
left Join Unitrac.dbo.[ADDRESS] A on A.ID = L.PHYSICAL_ADDRESS_ID
left Join UniTrac.dbo.SERVICE_CENTER_FUNCTION_LENDER_RELATE R on R.LENDER_ID = L.ID
left Join UniTrac.dbo.SERVICE_CENTER_FUNCTION F on R.SERVICE_CENTER_FUNCTION_ID = R.ID
left Join UniTrac.dbo.SERVICE_CENTER C on C.ID = F.SERVICE_CENTER_ID
left Join CENTER_DIM CD on CD.CODE_TX = C.CODE_TX
where DWA.LENDER_ID is NULL --and L.AGENCY_ID = 1
Group by 
DW.ID,L.TEST_IN, Case when L.STATUS_CD = 'ACTIVE' then 'Y' else 'N' END,
L.AGENCY_ID,Case when A.STATE_PROV_TX is NULL then '??' else A.STATE_PROV_TX END,L.ACTIVE_DT,L.CREATE_DT,L.CANCEL_DT


--Review Lender_DIM attributes duplicates
Select COUNT(A.LENDER_ID),L.ID from LENDER_DIM L 
left Join LENDER_DIM_ATTRIBUTE A on A.LENDER_ID = L.ID
Group by L.ID having COUNT(A.LENDER_ID) > 1


--Delete Lender_DIM attributes
--It is okay to delete the duplicate attributes without Sharlenes review
Delete from LENDER_DIM_ATTRIBUTE where ID in 
(
Select min(A.ID) from LENDER_DIM L 
left Join LENDER_DIM_ATTRIBUTE A on A.LENDER_ID = L.ID
Group by L.ID having COUNT(A.LENDER_ID) > 1
)


--Review Test Indicator
--looking for a mismatch of Test accounts incorrectly identified
Select L.AGENCY_ID,L.CODE_TX,L.NAME_TX,L.TEST_IN,L.ACTIVE_DT,L.STATUS_CD,A.START_DT,A.TEST_ACCT_IN,A.ACTIVE_IN from LENDER_DIM_ATTRIBUTE A
Join LENDER_DIM D on D.ID = A.LENDER_ID
Join UniTrac.dbo.LENDER L on L.CODE_TX = D.CODE_TX and L.AGENCY_ID = D.AGENCY_ID
where A.TEST_ACCT_IN <> L.TEST_IN and L.CODE_TX not in ('ALD ORD-UP') and PURGE_DT is NULL


--Set Status and set or clear CancelDT
--Send a screenshot of the results to Sharlene for review and she will identify what status they should be for this month
--the next (Update) step will set ACTIVE_IN to Y if the STATUS_CD is Active. It will set ACTIVE_IN to N for any other status
Select L.CODE_TX,L.NAME_TX,A.ACTIVE_IN,L.ACTIVE_DT,L.STATUS_CD,A.START_DT,A.END_DT,L.CANCEL_DT from LENDER_DIM_ATTRIBUTE A
Join LENDER_DIM D on D.ID = A.LENDER_ID
Join UniTrac.dbo.LENDER L on L.CODE_TX = D.CODE_TX and L.AGENCY_ID = D.AGENCY_ID
where 
L.PURGE_DT is NULL
and
(
A.ACTIVE_IN = 'N' and L.STATUS_CD = 'ACTIVE'
or 
A.ACTIVE_IN = 'Y' and (L.STATUS_CD <> 'ACTIVE')
)
and L.CODE_TX not in ('ALD ORD-UP')


--This Update step will set ACTIVE_IN to Y if the STATUS_CD is Active. It will set ACTIVE_IN to N for any other status
--Be sure to get Sharlenes input as to what Status the lenders should be in for this month
Update LENDER_DIM_ATTRIBUTE
Set ACTIVE_IN = Case when Status_CD = 'ACTIVE' then 'Y' else 'N' END
from LENDER_DIM_ATTRIBUTE A
Join LENDER_DIM D on D.ID = A.LENDER_ID
Join UniTrac.dbo.LENDER L on L.CODE_TX = D.CODE_TX and L.AGENCY_ID = D.AGENCY_ID
where 
L.PURGE_DT is NULL
and
(
A.ACTIVE_IN = 'N' and L.STATUS_CD = 'ACTIVE'
or 
A.ACTIVE_IN = 'Y' and (L.STATUS_CD <> 'ACTIVE')
)
and L.CODE_TX not in ('ALD ORD-UP')