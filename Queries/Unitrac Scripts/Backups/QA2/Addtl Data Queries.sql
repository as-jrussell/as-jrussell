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

---- Example to Change DEF_ID
UPDATE RELATED_DATA
SET DEF_ID = 200000204
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

----- Example DEF_ID Update
UPDATE RELATED_DATA SET DEF_ID = 200000204
WHERE DEF_ID = 76

---- Related Data for all 33 Lenders
SELECT *
FROM RELATED_DATA
WHERE DEF_ID IN (111,113,80,85,84,98,81,104,83,109,86,112,101,78,103,114,110,108,97,99)
AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)

--------- Update For 21 Types for all 33 Lenders
UPDATE RELATED_DATA SET DEF_ID = 200000238 WHERE DEF_ID = 111 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000240 WHERE DEF_ID = 113 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000207 WHERE DEF_ID = 80 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000212 WHERE DEF_ID = 85 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000211 WHERE DEF_ID = 84 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000225 WHERE DEF_ID = 98 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000208 WHERE DEF_ID = 81 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000231 WHERE DEF_ID = 104 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000210 WHERE DEF_ID = 83 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000236 WHERE DEF_ID = 109 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000213 WHERE DEF_ID = 86 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000239 WHERE DEF_ID = 112 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000228 WHERE DEF_ID = 101 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000206 WHERE DEF_ID = 78 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000230 WHERE DEF_ID = 103 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000241 WHERE DEF_ID = 114 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000237 WHERE DEF_ID = 110 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000235 WHERE DEF_ID = 108 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000224 WHERE DEF_ID = 97 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)
UPDATE RELATED_DATA SET DEF_ID = 200000226 WHERE DEF_ID = 99 AND RELATE_ID IN (1,90,98,168,180,193,199,227,270,307,349,359,363,817,818,836,843,962,1090,1189,1206,1810,1833,1863,1887,1901,1923,1927,1950,1960,2150,2169,2179)