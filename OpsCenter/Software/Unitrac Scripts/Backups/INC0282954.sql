USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT 
        L.NUMBER_TX [Loan Number] ,
        LO.NAME_TX [Division] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        O.LAST_NAME_TX [Last Name] ,
        O.FIRST_NAME_TX [First Name] ,
        O.MIDDLE_INITIAL_TX [Middle Name] ,
        CONCAT(OA.LINE_1_TX, ' ', OA.LINE_2_TX, ' ', OA.CITY_TX, ', ',
               OA.STATE_PROV_TX) [Mailing Address] ,
        CONCAT(OO.LINE_1_TX, ' ', OO.LINE_2_TX, ' ', OO.CITY_TX, ', ',
               OO.STATE_PROV_TX) [Property Address]
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        LEFT JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        LEFT JOIN dbo.OWNER_ADDRESS OO ON OO.ID = P.ADDRESS_ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        LEFT JOIN dbo.LENDER_ORGANIZATION LO ON LO.LENDER_ID = LL.ID
                                                AND LO.TYPE_CD = 'DIV'
                                                AND LO.CODE_TX = L.DIVISION_CODE_TX
        LEFT JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                      AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        LEFT JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                      AND RC4.DOMAIN_CD = 'LoanType'
WHERE   LL.CODE_TX IN ( '844410' )
        AND L.DIVISION_CODE_TX = '4'
        AND CONCAT(OA.LINE_1_TX, ' ', OA.LINE_2_TX, ' ', OA.CITY_TX, ', ',
                   OA.STATE_PROV_TX) <> CONCAT(OO.LINE_1_TX, ' ', OO.LINE_2_TX,
                                               ' ', OO.CITY_TX, ', ',
                                               OO.STATE_PROV_TX)
