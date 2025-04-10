USE UniTrac

--- Masterpiece

SELECT DISTINCT L.NUMBER_TX [Loan Number] ,
        RC.TYPE_CD [Coverage Type] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        REQUIRED_AMOUNT_NO [Coverage Amount] ,
        O.FIRST_NAME_TX [First Name] ,
        O.LAST_NAME_TX [Last Name] ,
        OA.LINE_1_TX [Line 1] ,
        OA.LINE_2_TX [Line 2] ,
        OA.CITY_TX [City] ,
        OA.STATE_PROV_TX [State] ,
        OA.POSTAL_CODE_TX [Zip Code] ,
        OA.COUNTRY_TX [Country], BIC_NAME_TX, POLICY_NUMBER_TX, OP.EFFECTIVE_DT
INTO    INC0242717
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON P.ADDRESS_ID = OA.ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
WHERE   C.COLLATERAL_CODE_ID = '230'
        AND RC.TYPE_CD IN ( 'HAZARD', 'FLOOD' )
        AND L.LENDER_ID = '2087'


