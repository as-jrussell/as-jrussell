USE [UniTrac];
GO




--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT L.NUMBER_TX [Loan Number] ,
       CONCAT(O.FIRST_NAME_TX, ' ', O.LAST_NAME_TX) [Member Name] ,
       RC1.DESCRIPTION_TX [Loan Status] ,
       RC2.DESCRIPTION_TX [Loan Type] ,
       P.VIN_TX [Vehicle VIN] ,
       P.YEAR_TX [Vehicle Year] ,
       P.MAKE_TX [Vehicle Make] ,
       P.MODEL_TX [Model VIN] ,
       OP.POLICY_NUMBER_TX [Policy Number] ,
       OP.BIC_NAME_TX [Insurance Company] ,
       BIC.EMAIL_TX [Insurance Email] ,
       CONCAT(
                 AAA.LINE_1_TX ,
                 ' ' ,
                 AAA.LINE_2_TX,
                 ' ' ,
                 AAA.CITY_TX,
                 ' ' ,
                 AAA.STATE_PROV_TX,
                 ' ' ,
                 AAA.POSTAL_CODE_TX
             ) [Insurance Information] ,
       BIC.NAME_TX ,
       BIC.AGENT_TX
INTO   JCs..INC0336946
FROM   LOAN L
       INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
       INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
       INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
       INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
       INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
       INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
       INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
       INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
       INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
       INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
       INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = L.RECORD_TYPE_CD
                                      AND RC1.DOMAIN_CD = 'LoanStatus'
       INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                      AND RC2.DOMAIN_CD = 'RecordType'
       INNER JOIN dbo.BORROWER_INSURANCE_AGENCY BIC ON BIC.ID = OP.BIA_ID
       LEFT JOIN dbo.ADDRESS AAA ON AAA.ID = BIC.ADDRESS_ID
WHERE  LL.CODE_TX = '1695'
       AND L.DIVISION_CODE_TX = 3;




SELECT DISTINCT L.NUMBER_TX [Loan Number] ,
       CONCAT(O.FIRST_NAME_TX, ' ', O.LAST_NAME_TX) [Member Name] ,
       RC1.DESCRIPTION_TX [Loan Status] ,
       RC2.DESCRIPTION_TX [Loan Type] ,
       P.VIN_TX [Vehicle VIN] ,
       P.YEAR_TX [Vehicle Year] ,
       P.MAKE_TX [Vehicle Make] ,
       P.MODEL_TX [Model VIN] ,
       OP.BIC_NAME_TX [Insurance Company] ,
       OP.POLICY_NUMBER_TX [Policy Number] ,
       BIC.NAME_TX ,
       BIC.AGENT_TX
INTO   JCs..INC0336946_Mirascon
FROM   LOAN L
       INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
       INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
       INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
       INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
       INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
       INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
       INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
       INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = P.ID
       INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
       INNER JOIN dbo.POLICY_COVERAGE PC ON PC.OWNER_POLICY_ID = OP.ID
       INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = L.RECORD_TYPE_CD
                                      AND RC1.DOMAIN_CD = 'LoanStatus'
       INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                      AND RC2.DOMAIN_CD = 'RecordType'
       LEFT JOIN dbo.BORROWER_INSURANCE_AGENCY BIC ON BIC.ID = OP.BIA_ID
       LEFT JOIN dbo.ADDRESS AAA ON AAA.ID = BIC.ADDRESS_ID
WHERE  LL.CODE_TX = '1695'
       AND L.DIVISION_CODE_TX = 3
       AND  BIC.NAME_TX LIKE '%Mirascon%';
