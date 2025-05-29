--- Example Single Lender
SELECT  RELATED_DATA_DEF.NAME_TX ,
        RELATED_DATA_DEF.DESC_TX ,
        RELATED_DATA.VALUE_TX ,
        *
FROM    RELATED_DATA
        INNER JOIN RELATED_DATA_DEF ON RELATED_DATA.DEF_ID = RELATED_DATA_DEF.ID
WHERE   RELATED_DATA.RELATE_ID = 1810

---- Present DEF_ID values
SELECT DISTINCT DEF_ID
FROM RELATED_DATA
WHERE RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)

----- Lender List
SELECT *
FROM LENDER

------ Lender Row on Related Data table (Tracking Source Example)
SELECT *
FROM RELATED_DATA
WHERE RELATE_ID = 1810 AND ID = 31986011

---- Different Related Data Offerings
SELECT *
FROM RELATED_DATA_DEF
WHERE NAME_TX IN ('LenderReviewsBillingIndicator','BranchRequired','DivisionRequired','EnableCancelNotice','CCUCancelNoticeTemplateId','CCFCancelNoticeTemplateId','LenderAdmin','UsePayeeCode','DirectPay','ZeroPremiumWorkitem','LenderEscrowFileIndicator','MaxExtractUnmatchCount','DropDays','UseBorrowerInsuranceSubCompanies','IsGrouped','PaymentFileIndicator','AllowARDirectUpdate','LenderBillingFileIndicator','AllowVDDirectUpdate','NetPremiumAccounting')
ORDER BY NAME_TX

---- Old DEF_ID Value
SELECT *
FROM RELATED_DATA
WHERE DEF_ID = 76

----- Example Lender Code
SELECT *
FROM LENDER
WHERE CODE_TX = '2771'

---- Example Lender Config Additional Data
SELECT *
FROM RELATED_DATA
WHERE RELATE_ID = 1810 AND ID = 31986011


---- Related Data for all 33 Lenders
SELECT *
FROM RELATED_DATA
WHERE DEF_ID IN (111,113,80,85,84,98,81,104,83,109,86,112,101,78,103,114,110,108,97,99)
AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
