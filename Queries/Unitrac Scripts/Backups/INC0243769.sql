USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT L.DIVISION_CODE_TX , L.NUMBER_TX,  RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type]		
FROM    LOAN L
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   L.LENDER_ID = '281' AND L.DIVISION_CODE_TX NOT IN ('99')


SELECT * FROM dbo.LENDER
WHERE ID = '281'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LoanType'



SELECT * 
INTO UniTracHDStorage..INC0243769
FROM dbo.LOAN L
WHERE   L.LENDER_ID = '281' AND L.DIVISION_CODE_TX NOT IN ('99')




UPDATE L 
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0243769', L.DIVISION_CODE_TX = '99'
--SELECT B.DIVISION_CODE_TX, *
FROM dbo.LOAN L
JOIN UniTracHDStorage..INC0243769 B ON L.ID = B.ID
--SELECT COUNT (*) FROM LOAN
WHERE B.DIVISION_CODE_TX NOT IN ('3', '4')
--159840


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , ' INC0243769' , 'N' , 
 GETDATE() ,  1 , 
'Moved to  Division 99', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
JOIN UniTracHDStorage..INC0243769 B ON L.ID = B.ID
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0243769)-- AND B.DIVISION_CODE_TX NOT IN ('3', '4')
--159840


SELECT DISTINCT DIVISION_CODE_TX FROM UniTracHDStorage..INC0242955


---Finding Branch
SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '2864' AND Lo.TYPE_CD = 'DIV'
