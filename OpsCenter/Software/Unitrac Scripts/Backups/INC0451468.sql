use unitrac


select L.NUMBER_TX, C.* 
into unitrachdstorage..INC0451468_collateralcodes
from collateral c
join loan l on l.id = c.loan_id
join COLLATERAL_CODE CC on CC.ID = C.c.collateral_code_id
join lender le on le.id = l.lender_id
where 
 l.record_type_cd = 'A' and le.code_tx = '1844'
 and  c.c.collateral_code_id in (SELECT  CC.ID FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.c.collateral_code_id = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE L.CODE_TX = '1844' and ( CC.CODE_TX like '%-OT' or  CC.CODE_TX like '%-A') )




update C
set c.collateral_code_id = 1, c.LENDER_COLLATERAL_CODE_TX = 'DEFAULT', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (67, 68, 87, 88)


update C
set c.collateral_code_id = 10, c.LENDER_COLLATERAL_CODE_TX = 'RV', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (69, 70)


update C
set c.collateral_code_id = 8, c.LENDER_COLLATERAL_CODE_TX = 'BOAT', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (71,72)


update C
set c.collateral_code_id = 15, c.LENDER_COLLATERAL_CODE_TX = 'ATV', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (73,74)

update C
set c.collateral_code_id = 9, c.LENDER_COLLATERAL_CODE_TX = 'MOBILEHOME', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (75,76)


update C
set c.collateral_code_id = 12, c.LENDER_COLLATERAL_CODE_TX = 'SNOWMOBILE', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (77,78)




update C
set c.collateral_code_id = 16, c.LENDER_COLLATERAL_CODE_TX = 'JET SKI', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (79,80)

update C
set c.collateral_code_id = 14, c.LENDER_COLLATERAL_CODE_TX = 'FARM EQUIP', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (81,82)


update C
set c.collateral_code_id = 61, c.LENDER_COLLATERAL_CODE_TX = 'TRVL TRL', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (85, 86, 309,345, 259)

update C
set c.collateral_code_id = 7, c.LENDER_COLLATERAL_CODE_TX = 'MOTORCYCLE', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (89,90, 379)

update C
set c.collateral_code_id = 62, c.LENDER_COLLATERAL_CODE_TX = 'MOTORHOME', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (203, 204)

update C
set c.collateral_code_id = 229, c.LENDER_COLLATERAL_CODE_TX = 'COMMERCIAL', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (243, 244)


update C
set c.collateral_code_id = 229, c.LENDER_COLLATERAL_CODE_TX = 'COMMERCIAL', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', c.LOCK_ID = CASE WHEN c.LOCK_ID >= 255 THEN 1 ELSE c.LOCK_ID + 1 END
--select *
from COLLATERAL c 
join unitrachdstorage..INC0451468_collateralcodes ci on ci.id = c.id
where c.collateral_code_id in (87, 88)


select  l.* 
into unitrachdstorage..INC0451468_branch
from loan l 
join lender le on le.id = l.lender_id
where le.code_tx = '1844' and l.branch_code_tx = 'DIRECT'



update L
set  l.branch_code_tx = '1844', UPDATE_DT = getdate(), UPDATE_user_tx = 'INC0451468', l.LOCK_ID = CASE WHEN l.LOCK_ID >= 255 THEN 1 ELSE l.LOCK_ID + 1 END
from LOAN l 
where id in (select id from unitrachdstorage..INC0451468_branch)




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 c.LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0451468' , 'N' , 
 GETDATE() ,  1 , 
'Change branch from DIRECT to 1844', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0451468_branch)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 c.LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , L.ID , 'INC0451468' , 'N' , 
 GETDATE() ,  1 , 
'Moved Loan Collateral out of Tier Tracking', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0451468_collateralcodes)


