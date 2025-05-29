USE UniTrac




select * 
--INTO UniTracHDStorage..ActiveRequiredCoverage20160816
FROM loan l
join collateral c 
on l.id = c.loan_id
join required_coverage rc
on rc.property_id = c.property_id
join lender le
on le.id = l.lender_id
where le.code_tx = '1852'
and rc.type_cd = 'Wind'
and rc.status_cd = 'I'
and rc.record_type_cd ='g'
and l.status_cd = 'a'
and c.status_cd ='a'
and l.record_type_cd ='g'




UPDATE dbo.REQUIRED_COVERAGE
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'TaskUpdate',LOCK_ID=LOCK_ID+1, STATUS_CD = 'A'
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..ActiveRequiredCoverage20160816)
--709

INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'TaskUpdate' , 'N' , 
 GETDATE() ,  1 , 
 'Make Status Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..ActiveRequiredCoverage20160816)
