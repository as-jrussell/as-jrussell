USE [UniTrac]
GO 


SELECT UPDATE_DT, * FROM UnitracHDStorage..INC0280312


--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX, RC.UPDATE_USER_TX [User], 'Track Status' [Status], RC.* 
INTO UnitracHDStorage..INC0280312
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('2258') AND RC.STATUS_CD = 'T' AND 
--AND RC.UPDATE_USER_TX <> 'LDHPCRA' AND 
RC.UPDATE_USER_TX LIKE 'LDH%'

SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'T'

	UPDATE RC 
	SET STATUS_CD = 'A', UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0280312'
	--SELECT COUNT(*)
	FROM dbo.REQUIRED_COVERAGE RC
	WHERE ID IN (SELECT ID FROM UnitracHDStorage..INC0280312)
	--4049
	
	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , L.ID , 'INC0280312' , 'N' , 
 GETDATE() ,  1 , 
'Moved Loan Coverage status to Active from Track', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0280312)
--272