USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT LL.NAME_TX [Lender Name], LL.CODE_TX [Lender Code], L.NUMBER_TX [Loan Number], CC.CODE_TX [Collateral Code], 
CC.PRIMARY_CLASS_CD [Class], RC1.DESCRIPTION_TX [RecordType], RC2.DESCRIPTION_TX [LoanStatus],RC3.DESCRIPTION_TX [LoanType],
RC4.DESCRIPTION_TX [Insurance Status],DIVISION_CODE_TX [Division Code], BRANCH_CODE_TX [Branch Code]
--SELECT COUNT(*)
INTO JCs..INC0245000_Commercial
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN dbo.COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID 
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = C.PROPERTY_ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC1.DOMAIN_CD = 'RecordType'
INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.STATUS_CD
                                       AND RC2.DOMAIN_CD = 'LoanStatus'
INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.TYPE_CD
                                       AND RC3.DOMAIN_CD = 'LoanType'
INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = OP.STATUS_CD
                                       AND RC4.DOMAIN_CD = 'OwnerPolicyStatus'
WHERE DIVISION_CODE_TX = '4' AND (BRANCH_CODE_TX = 'COMMERCIAL' OR 
 PRIMARY_CLASS_CD = 'COM') AND OP.STATUS_CD <> 'F' AND L.RECORD_TYPE_CD = 'G'


SELECT LL.NAME_TX [Lender Name], LL.CODE_TX [Lender Code], L.NUMBER_TX [Loan Number], CC.CODE_TX [Collateral Code], 
CC.PRIMARY_CLASS_CD [Class], RC1.DESCRIPTION_TX [RecordType], RC2.DESCRIPTION_TX [LoanStatus],RC3.DESCRIPTION_TX [LoanType],
RC4.DESCRIPTION_TX [Insurance Status],DIVISION_CODE_TX [Division Code], BRANCH_CODE_TX [Branch Code]
--SELECT COUNT(*)
INTO JCs..INC0245000_Mortgage
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN dbo.COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID 
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.PROPERTY_ID = C.PROPERTY_ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = POP.OWNER_POLICY_ID
INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC1.DOMAIN_CD = 'RecordType'
INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.STATUS_CD
                                       AND RC2.DOMAIN_CD = 'LoanStatus'
INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.TYPE_CD
                                       AND RC3.DOMAIN_CD = 'LoanType'
INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = OP.STATUS_CD
                                       AND RC4.DOMAIN_CD = 'OwnerPolicyStatus'
WHERE DIVISION_CODE_TX = '10' AND --(BRANCH_CODE_TX = 'COMMERCIAL' OR 
 SECONDARY_CLASS_CD = 'RES'--) 
 AND L.RECORD_TYPE_CD = 'G'



 --16117

---Finding Branch
SELECT LO.TYPE_CD, LO.CODE_TX , Lo.NAME_TX,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID --AND RD.DEF_ID = '105'
WHERE L.CODE_TX = '6497' AND Lo.TYPE_CD = 'DIV'



---Finding Collateral Code
SELECT  CC.* 
         FROM dbo.COLLATERAL_CODE CC
INNER JOIN dbo.LCCG_COLLATERAL_CODE_RELATE CCR ON CCR.COLLATERAL_CODE_ID = CC.ID
INNER JOIN dbo.LENDER_COLLATERAL_CODE_GROUP LCCG ON LCCG.ID = CCR.LCCG_ID
INNER JOIN dbo.LENDER L ON L.ID = LCCG.LENDER_ID
WHERE L.CODE_TX = 'XXXX'


SELECT * FROM UniTracHDStorage..INC0245000_Commercial


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'OwnerPolicyStatus'



SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'CADW'



SELECT TOP 5 * FROM dbo.OWNER_POLICY OP
JOIN dbo.PROPERTY_OWNER_POLICY_RELATE POP ON POP.OWNER_POLICY_ID = OP.ID
JOIN dbo.PROPERTY P ON P.ID = POP.PROPERTY_ID
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
ORDER BY UPDATE_DT DESC 