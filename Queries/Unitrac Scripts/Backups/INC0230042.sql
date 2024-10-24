USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT  L.ID , RC.TYPE_CD, 
        L.NUMBER_TX ,
       FFC.DESCRIPTION_TX [Loan Type],
     FCF.DESCRIPTION_TX [Loan Status],
		FC.DESCRIPTION_TX [Record Type], L.EFFECTIVE_DT,
    RC.ID [RC_ID]
--	INTO UniTracHDStorage..INC0230042
        FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.REF_CODE FC ON FC.CODE_CD = L.RECORD_TYPE_CD AND FC.DOMAIN_CD = 'RecordType'
INNER JOIN dbo.REF_CODE FCF ON FCF.CODE_CD = L.STATUS_CD AND FCF.DOMAIN_CD = 'LoanStatus'
INNER JOIN dbo.REF_CODE FFC ON FFC.CODE_CD = L.TYPE_CD AND FFC.DOMAIN_CD = 'LoanType'
WHERE LL.CODE_TX IN ('7150') AND RC.TYPE_CD = 'BLDR-HAZARD'
ORDER BY L.NUMBER_TX DESC



/*


--2) Update GOOD_THRU_DT field to NULL in REQUIRED_COVERAGE table
UPDATE RC SET RC.PURGE_DT = GETDATE () ,RC.UPDATE_DT = GETDATE() , RC.UPDATE_USER_TX = 'INC0230042' ,
RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END
---- SELECT DISTINCT RC.ID
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT RC_ID FROM UniTracHDStorage..INC0230042)

--3) Insert History into PROPERTY_CHANGE table
--Update description field based on new and old branch name. If it varies on loan by loan basis, need to link in our temp table form the beginning

 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0230042' , 'N' , 
 GETDATE() ,  1 , 
 'Purged BLDR-HAZARD from loan ', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE  RC.ID IN (SELECT RC_ID FROM UniTracHDStorage..INC0230042)


*/