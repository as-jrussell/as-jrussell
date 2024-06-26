USE Unitrac


SELECT TOP 5* FROM dbo.POLICY_ENDORSEMENT PE 

SELECT TOP 5* FROM dbo.ISSUE_PROCEDURE IP
JOIN dbo.CARRIER_ISSUE_PROCEDURE_RELATE CIP ON CIP.ISSUE_PROCEDURE_ID = IP.ID
JOIN dbo.CARRIER_PRODUCT cp ON cp.ID = CIP.CARRIER_PRODUCT_ID 
JOIN dbo.CARRIER C ON C.ID = cp.CARRIER_ID

SELECT * FROM dbo.CARRIER
WHERE NAME_TX LIKE '%National Gen%'

SELECT DISTINCT PE.NAME_TX,PE.PERCENTAGE_NO, MPE.START_DT, MPE.END_DT  FROM dbo.POLICY_ENDORSEMENT PE
JOIN dbo.MASTER_POLICY_ENDORSEMENT MPE ON MPE.POLICY_ENDORSEMENT_ID = PE.ID 
JOIN dbo.CARRIER_POLICY_ENDORSEMENT_RELATE CPE ON CPE.POLICY_ENDORSEMENT_ID = PE.ID
JOIN dbo.CARRIER_PRODUCT CP ON CP.ID = CPE.CARRIER_PRODUCT_ID
JOIN dbo.CARRIER C ON C.ID = CP.CARRIER_ID
JOIN dbo.MASTER_POLICY MP ON MP.CARRIER_ID = C.ID
JOIN dbo.LENDER L ON mp.LENDER_ID = L. ID
WHERE PE. NAME_TX IN ('Schedule Rating Increase', 'Schedule Rating Decrease', 'Schedule Rating') OR 
PE.NAME_TX LIKE '%borrow%' OR PE.NAME_TX LIKE '%Lender deductible%'
AND MPE.PURGE_DT IS NULL AND PE.PURGE_DT IS NULL

SELECT * FROM dbo.CARRIER C

SELECT DISTINCT L.NAME_TX [Lender Name], L.CODE_TX [Lender Code], PE.NAME_TX [Policy Endorsement],
PE.PERCENTAGE_NO [Policy Endorsement Percentage], MPE.START_DT [Start Date], MPE.END_DT [End Date]
INTO JCS..INC0317527_SchedulingRating
FROM dbo.POLICY_ENDORSEMENT PE
JOIN dbo.MASTER_POLICY_ENDORSEMENT MPE ON MPE.POLICY_ENDORSEMENT_ID = PE.ID 
JOIN dbo.CARRIER_POLICY_ENDORSEMENT_RELATE CPE ON CPE.POLICY_ENDORSEMENT_ID = PE.ID
JOIN dbo.CARRIER_PRODUCT CP ON CP.ID = CPE.CARRIER_PRODUCT_ID
JOIN dbo.CARRIER C ON C.ID = CP.CARRIER_ID
JOIN dbo.MASTER_POLICY MP ON MP.CARRIER_ID = C.ID
JOIN dbo.LENDER L ON mp.LENDER_ID = L. ID
WHERE PE. NAME_TX IN ('Schedule Rating') 
AND C.NAME_TX = 'National General' AND L.PURGE_DT IS NULL 
AND L.STATUS_CD = 'ACTIVE' AND L.TEST_IN = 'N' AND MPE.PURGE_DT IS NULL 
AND CPE.PURGE_DT IS NULL AND CP.PURGE_DT IS NULL AND C.PURGE_DT IS NULL 
AND MP.PURGE_DT IS NULL
ORDER BY L.CODE_TX ASC 


SELECT DISTINCT L.NAME_TX [Lender Name], L.CODE_TX [Lender Code], PE.NAME_TX [Policy Endorsement],
PE.PERCENTAGE_NO [Policy Endorsement Percentage], MPE.START_DT [Start Date], MPE.END_DT [End Date]
INTO JCS..INC0317527_SchedulingIncrease
FROM dbo.POLICY_ENDORSEMENT PE
JOIN dbo.MASTER_POLICY_ENDORSEMENT MPE ON MPE.POLICY_ENDORSEMENT_ID = PE.ID 
JOIN dbo.CARRIER_POLICY_ENDORSEMENT_RELATE CPE ON CPE.POLICY_ENDORSEMENT_ID = PE.ID
JOIN dbo.CARRIER_PRODUCT CP ON CP.ID = CPE.CARRIER_PRODUCT_ID
JOIN dbo.CARRIER C ON C.ID = CP.CARRIER_ID
JOIN dbo.MASTER_POLICY MP ON MP.CARRIER_ID = C.ID
JOIN dbo.LENDER L ON mp.LENDER_ID = L. ID
WHERE PE. NAME_TX IN ('Schedule Rating Increase') 
AND C.NAME_TX = 'National General' AND L.PURGE_DT IS NULL 
AND L.STATUS_CD = 'ACTIVE' AND L.TEST_IN = 'N' AND MPE.PURGE_DT IS NULL 
AND CPE.PURGE_DT IS NULL AND CP.PURGE_DT IS NULL AND C.PURGE_DT IS NULL 
AND MP.PURGE_DT IS NULL
ORDER BY L.CODE_TX ASC 


SELECT DISTINCT L.NAME_TX [Lender Name], L.CODE_TX [Lender Code], PE.NAME_TX [Policy Endorsement],
PE.PERCENTAGE_NO [Policy Endorsement Percentage], MPE.START_DT [Start Date], MPE.END_DT [End Date]
INTO JCS..INC0317527_SchedulingDecrease
FROM dbo.POLICY_ENDORSEMENT PE
JOIN dbo.MASTER_POLICY_ENDORSEMENT MPE ON MPE.POLICY_ENDORSEMENT_ID = PE.ID 
JOIN dbo.CARRIER_POLICY_ENDORSEMENT_RELATE CPE ON CPE.POLICY_ENDORSEMENT_ID = PE.ID
JOIN dbo.CARRIER_PRODUCT CP ON CP.ID = CPE.CARRIER_PRODUCT_ID
JOIN dbo.CARRIER C ON C.ID = CP.CARRIER_ID
JOIN dbo.MASTER_POLICY MP ON MP.CARRIER_ID = C.ID
JOIN dbo.LENDER L ON mp.LENDER_ID = L. ID
WHERE PE. NAME_TX IN ('Schedule Rating Decrease') 
AND C.NAME_TX = 'National General' AND L.PURGE_DT IS NULL 
AND L.STATUS_CD = 'ACTIVE' AND L.TEST_IN = 'N' AND MPE.PURGE_DT IS NULL 
AND CPE.PURGE_DT IS NULL AND CP.PURGE_DT IS NULL AND C.PURGE_DT IS NULL 
AND MP.PURGE_DT IS NULL
ORDER BY L.CODE_TX ASC 



SELECT DISTINCT L.NAME_TX [Lender Name], L.CODE_TX [Lender Code], PE.NAME_TX [Policy Endorsement],
PE.PERCENTAGE_NO [Policy Endorsement Percentage], MPE.START_DT [Start Date], MPE.END_DT [End Date]
INTO JCS..INC0317527_BorrowersDed
FROM dbo.POLICY_ENDORSEMENT PE
JOIN dbo.MASTER_POLICY_ENDORSEMENT MPE ON MPE.POLICY_ENDORSEMENT_ID = PE.ID 
JOIN dbo.CARRIER_POLICY_ENDORSEMENT_RELATE CPE ON CPE.POLICY_ENDORSEMENT_ID = PE.ID
JOIN dbo.CARRIER_PRODUCT CP ON CP.ID = CPE.CARRIER_PRODUCT_ID
JOIN dbo.CARRIER C ON C.ID = CP.CARRIER_ID
JOIN dbo.MASTER_POLICY MP ON MP.CARRIER_ID = C.ID
JOIN dbo.LENDER L ON mp.LENDER_ID = L. ID
WHERE PE.NAME_TX LIKE '%borrow%'
AND C.NAME_TX = 'National General' AND L.PURGE_DT IS NULL 
AND L.STATUS_CD = 'ACTIVE' AND L.TEST_IN = 'N' AND MPE.PURGE_DT IS NULL 
AND CPE.PURGE_DT IS NULL AND CP.PURGE_DT IS NULL AND C.PURGE_DT IS NULL 
AND MP.PURGE_DT IS NULL
ORDER BY L.CODE_TX ASC 


SELECT DISTINCT L.NAME_TX [Lender Name], L.CODE_TX [Lender Code], PE.NAME_TX [Policy Endorsement],
PE.PERCENTAGE_NO [Policy Endorsement Percentage], MPE.START_DT [Start Date], MPE.END_DT [End Date]
INTO JCS..INC0317527_LenderDed
FROM dbo.POLICY_ENDORSEMENT PE
JOIN dbo.MASTER_POLICY_ENDORSEMENT MPE ON MPE.POLICY_ENDORSEMENT_ID = PE.ID 
JOIN dbo.CARRIER_POLICY_ENDORSEMENT_RELATE CPE ON CPE.POLICY_ENDORSEMENT_ID = PE.ID
JOIN dbo.CARRIER_PRODUCT CP ON CP.ID = CPE.CARRIER_PRODUCT_ID
JOIN dbo.CARRIER C ON C.ID = CP.CARRIER_ID
JOIN dbo.MASTER_POLICY MP ON MP.CARRIER_ID = C.ID
JOIN dbo.LENDER L ON mp.LENDER_ID = L. ID
WHERE PE.NAME_TX LIKE '%Lender deductible%' 
AND C.NAME_TX = 'National General' AND L.PURGE_DT IS NULL 
AND L.STATUS_CD = 'ACTIVE' AND L.TEST_IN = 'N' AND MPE.PURGE_DT IS NULL 
AND CPE.PURGE_DT IS NULL AND CP.PURGE_DT IS NULL AND C.PURGE_DT IS NULL 
AND MP.PURGE_DT IS NULL
ORDER BY L.CODE_TX ASC 

 OR PE.NAME_TX LIKE '%Lender deductible%' 