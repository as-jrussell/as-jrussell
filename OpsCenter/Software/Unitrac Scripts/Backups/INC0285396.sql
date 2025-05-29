USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT
        L.NUMBER_TX [Loan Number] ,
		RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        CC.DESCRIPTION_TX [Previous Collateral] ,
        CC1.DESCRIPTION_TX [Current Collateral] ,
        P.YEAR_TX [Year] ,
        P.MAKE_TX [Make] ,
        P.MODEL_TX [Model] ,
        P.VIN_TX [VIN]
FROM    LOAN L
        JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
        JOIN dbo.PROPERTY_CHANGE PC ON PC.ENTITY_ID = C.ID
                                       AND PC.ENTITY_NAME_TX = 'Allied.UniTrac.Collateral'
        JOIN dbo.PROPERTY_CHANGE_UPDATE PCU ON PCU.CHANGE_ID = PC.ID
                                               AND PCU.COLUMN_NM = 'COLLATERAL_CODE_ID'
        LEFT JOIN dbo.COLLATERAL_CODE CC ON CC.ID = PCU.FROM_VALUE_TX --AND CC.AGENCY_ID = '1'
        LEFT JOIN dbo.COLLATERAL_CODE CC1 ON CC1.ID = PCU.To_VALUE_TX --AND CC1.AGENCY_ID = '1'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        LEFT JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                      AND RC4.DOMAIN_CD = 'LoanType'
WHERE   L.LENDER_ID = '914'

