USE UniTrac	




SELECT L.RECORD_TYPE_CD, C.PURGE_DT, P.RECORD_TYPE_CD, RC.RECORD_TYPE_CD,
OA.PURGE_DT, O.PURGE_DT, OLR.PURGE_DT,
 * FROM dbo.LOAN L 
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
JOIN dbo.OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID
JOIN dbo.OWNER O ON O.ID = OLR.OWNER_ID
JOIN dbo.OWNER_ADDRESS OA ON OA.ID = O.ADDRESS_ID
JOIN dbo.LENDEr LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX = '8100' AND L.NUMBER_TX = '898785-0001'




UPDATE dbo.LOAN
SET RECORD_TYPE_CD = 'D'
WHERE ID = '92807985'




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC027591' , 'N' , 
 GETDATE() ,  1 , 
'Deleted Loan', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (92807985)


SELECT * --INTO jcs..INC027591 
FROM UniTrac..LOAN L 
WHERE L.ID IN (92807985)




