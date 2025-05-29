USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE

--Loan  Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT RC.* FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX IN ('8500') --AND L.NUMBER_TX = '201600943'
AND rc.SUMMARY_SUB_STATUS_CD = 'C' AND rc.SUMMARY_STATUS_CD IN ('E', 'F')
AND rc.TYPE_CD = 'WIND' AND rc.STATUS_CD = 'I'

SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'B'


SELECT L.* FROM dbo.REQUIRED_COVERAGE rc
 JOIN dbo.PROPERTY P ON P.ID = rc.PROPERTY_ID
 JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
 JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
 JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = L.ID
 WHERE P.LENDER_ID = 92 AND rc.TYPE_CD ='WIND'
 AND rc.STATUS_CD = 'I'


 SELECT * FROM dbo.LENDER
 WHERE CODE_TX = '8500'

USE UniTrac
---Property Change Table Query


SELECT * FROM dbo.PROPERTY_CHANGE PC
LEFT JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PC.ID = PCU.CHANGE_ID
WHERE PC.ENTITY_NAME_TX = 'Allied.UniTrac.RequiredCoverage'
AND PC.ENTITY_ID ='128740925'


--CPI_STATUS_CD
--SUMMARY_STATUS_CD

---It will always be on of the items below
/*
ENTITY_NAME_TX
Allied.UniTrac.Collateral
Allied.UniTrac.DocumentInteraction
Allied.UniTrac.Escrow
Allied.UniTrac.Loan
Allied.UniTrac.Owner
Allied.UniTrac.OwnerPolicy
Allied.UniTrac.OwnerPolicyInteraction
Allied.UniTrac.PolicyCoverage
Allied.UniTrac.ProcessHelper.UniTracProcessDefinit
Allied.UniTrac.Property
Allied.UniTrac.RequiredCoverage
Osprey.ProcessMgr.ProcessDefinition
Quote
Refund

*/



SELECT  L.NUMBER_TX , RC.TYPE_CD ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
		CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status]     
INTO    UniTracHDStorage..INC0329442
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        LEFT JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
        LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = RC.SUMMARY_STATUS_CD
                                       AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
        LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = RC.SUMMARY_SUB_STATUS_CD
                                       AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
        LEFT JOIN dbo.REF_CODE RC7 ON RC7.CODE_CD = RC.SUMMARY_SUB_STATUS_CD
                                       AND RC7.DOMAIN_CD = 'RequiredCoverageSubStatus'
		LEFT JOIN dbo.LENDER_ORGANIZATION LO ON LO.LENDER_ID = LL.ID 
									    AND LO.TYPE_CD = 'DIV' AND LO.CODE_TX = L.DIVISION_CODE_TX	
		WHERE LL.CODE_TX IN ('8500') 
AND rc.SUMMARY_SUB_STATUS_CD = 'C' AND rc.SUMMARY_STATUS_CD IN ('E', 'F')
AND rc.TYPE_CD = 'WIND' AND RC.STATUS_CD = 'I'
	




here is one example.. 201600943 
4:38:11 PM: Troy Nothem: here is the other one... 2385474831 