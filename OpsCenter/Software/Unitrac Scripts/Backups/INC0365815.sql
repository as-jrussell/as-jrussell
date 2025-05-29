USE [UniTrac]
GO

update C set C.status_cd = 'Z', C.update_dt = GETDATE(), C.update_user_tx = 'INC0365815', C.LOCK_ID = C.LOCK_ID+1
--select C.status_cd, R.status_cd, *
from collateral C
join UnitracHDStorage..INC0365815_Repossessed R on R.ID = C.ID



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , L.ID , 'INC0365815' , 'N' , 
 GETDATE() ,  1 , 
'Make Collateral Repo', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , L.ID , 'PEND' , 'N'
FROM Collateral L 
WHERE L.ID IN (SELECT ID FROM UnitracHDStorage..INC0365815_Repossessed)




select L.NUMBER_TX, C.status_cd [Current Status], R.status_cd [Backed up status], L.*
--into UnitracHDStorage..INC0365815_time
from collateral C
join loan l on l.id = c.loan_id
join UnitracHDStorage..INC0365815_Repossessed R on R.ID = C.ID