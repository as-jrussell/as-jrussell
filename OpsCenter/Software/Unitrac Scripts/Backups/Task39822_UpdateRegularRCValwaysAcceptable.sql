/*
Task 39822 - Set RegularRCVAlwaysAcceptable to True for Lenders' Hazard, Wind & Earthquake products
*/


--select  ldr.CODE_TX, lp.NAME_TX, bo.NAME_TX, bo.DEFAULT_VALUE_TX, lcgct.TYPE_CD,
--bo.UPDATE_DT, bo.UPDATE_USER_TX, bo.LOCK_ID

update bo set bo.DEFAULT_VALUE_TX = 'True', bo.UPDATE_DT = GETDATE(), bo.UPDATE_USER_TX = 'Task39823',
bo.LOCK_ID = (bo.LOCK_ID % 255) + 1

from lender ldr
join LENDER_PRODUCT lp on lp.LENDER_ID = ldr.ID and lp.PURGE_DT is null
join LENDER_COLLATERAL_GROUP_COVERAGE_TYPE lcgct on lcgct.Lender_Product_id = lp.id and lcgct.PURGE_DT is null
join BUSINESS_OPTION_GROUP bog on bog.Relate_ID = lp.ID and bog.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
join BUSINESS_OPTION bo on bo.BUSINESS_OPTION_GROUP_ID = bog.ID and bo.NAME_TX = 'RegularRCValwaysAcceptable' and bo.DEFAULT_VALUE_TX = 'False'
Where 
lcgct.TYPE_CD in ('HAZARD','EARTHQUAKE','WIND','BLDR-HAZARD','HUR') 


