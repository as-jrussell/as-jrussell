use unitrac


select * from unitrachdstorage..INC0377107

select * from ref_code
where domain_cd = 'RequiredCoverageStatus'



-- Update RequiredCoverage Status from Wavie to Active
UPDATE RC SET STATUS_CD = 'A',
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0377107' , 
LOCK_ID = RC.LOCK_ID % 255 + 1
---- SELECT RC.STATUS_CD, tmp.STATUS_CD ,   *
FROM REQUIRED_COVERAGE RC 
JOIN unitrachdstorage..INC0377107 TMP 
ON TMP.ID = RC.ID 
---- 10701


UPDATE RC SET STATUS_CD = 'A',
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0377107' , 
LOCK_ID = RC.LOCK_ID % 255 + 1
---- SELECT RC.STATUS_CD, tmp.STATUS_CD ,   *
FROM REQUIRED_COVERAGE RC 
JOIN unitrachdstorage..INC0377107 TMP 
ON TMP.ID = RC.ID 
where rc.id = '51843561'
---- 10701

--SELECT DISTINCT LOAN_ID FROM #TMPLOAN

-- Add Property change log
 INSERT INTO PROPERTY_CHANGE
 (
 ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN
 )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , TMP.ID , 'INC0377107' , 'N' ,
 GETDATE(),  1 ,
 'Changed Status from Waive to Active' ,
 'N' , 'Y' , 1 ,  'Allied.UniTrac.RequiredCoverage' , TMP.ID , 'PEND' , 'N'
 FROM  unitrachdstorage..INC0377107 TMP 
 ---- 10682

