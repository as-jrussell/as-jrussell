USE UniTrac	

SELECT L.* 
INTO  UniTracHDStorage..INC0274561_L
FROM dbo.LOAN L
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.NUMBER_TX = '208750L2' AND LL.CODE_TX = '4296'



UPDATE LOAN 
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0274561', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'D'
--SELECT * FROM LOAN
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0274561_L)


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0274561' , 'N' , 
 GETDATE() ,  1 , 
'Deleted Loan', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0274561_L)