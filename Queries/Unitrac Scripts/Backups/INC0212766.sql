select  BRANCH_CODE_TX, * from LOAN L
WHERE LENDER_ID = '244'and
 L.BRANCH_CODE_TX = '2120' AND L.LENDER_COLLATERAL_CODE_TX = 'X'
		
		
SELECT  L.CODE_TX, LO.CODE_TX, L.TYPE_CD, *
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE LO.TYPE_CD = 'BRCH' AND LO.CODE_TX = '2120'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LenderExtractSearchType'


SELECT * FROM dbo.LENDER
WHERE CODE_TX = '2120'


SELECT * FROM dbo.LENDER
WHERE ID = '244'


SELECT L.* --INTO UniTracHDStorage..INC0212766
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE L.BRANCH_CODE_TX = 'FICS' AND LENDER_COLLATERAL_CODE_TX = 'X' AND L.LENDER_ID = '244'

SELECT * FROM UniTracHDStorage..INC0212766

--1) Update BRANCH_CODE_TX field in LOAN table
UPDATE dbo.LOAN 
SET BRANCH_CODE_TX = 'FICS',UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'INC0212766' ,
LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
WHERE ID IN (SELECT DISTINCT ID FROM UniTracHDStorage..INC0212766)
--1348



--2) Update GOOD_THRU_DT field to NULL in REQUIRED_COVERAGE table
UPDATE RC SET RC.GOOD_THRU_DT = NULL ,RC.UPDATE_DT = GETDATE() , RC.UPDATE_USER_TX = 'INC0212766' ,
RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END
--SELECT DISTINCT RC.ID
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0212766)
--2935


--3) Insert History into PROPERTY_CHANGE table
 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'UNITRAC' , 'N' , 
 GETDATE() ,  1 , 
 'Moved Loan to FICS Branch', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0212766)
--1348