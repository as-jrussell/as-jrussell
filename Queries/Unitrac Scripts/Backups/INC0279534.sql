USE [UniTrac]
GO 



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT 
L.NUMBER_TX, RC2.DESCRIPTION_TX [Loan Record Type], RC3.DESCRIPTION_TX [Loan Status] ,
RC4.DESCRIPTION_TX [Loan Type],FPC.NUMBER_TX [Policy Number],fpc.ISSUE_DT,  fpc.EFFECTIVE_DT,
IH.SPECIAL_HANDLING_XML.value('(/SH/Status)[1]', 'varchar (50)') [Current CPI Status]
      --  ,IH.SPECIAL_HANDLING_XML 
INTO jcs..INC0279534
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN dbo.FORCE_PLACED_CERTIFICATE FPC ON FPC.LOAN_ID = L.ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID AND IH.TYPE_CD = 'CPI'
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE LL.CODE_TX IN ('6047') AND RC.TYPE_CD = 'FLOOD'
AND  fpc.effective_dt >= '2014-05-05'
ORDER BY fpc.effective_dt ASC 

---Finding Branch
SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '' AND Lo.TYPE_CD = 'DIV'


