USE UniTrac



Update PC
set 
PC.amount_no = SP.[Property RCV],
PC.base_amount_no = SP.[Property RCV]
--SELECT SP.[Property RCV], SP.[Property RCV], PC.amount_no, PC.base_amount_no, *
FROM dbo.POLICY_COVERAGE PC
JOIN UniTracHDStorage..[UnivofIowa2725] SP ON SP.[policy_coverage#ID] = PC.ID

where PC.ID = [policy_coverage.ID]



SELECT * FROM UniTracHDStorage..[UnivofIowa2725] 

SELECT * FROM UniTracHDStorage..INC0247385


SELECT * FROM UniTracHDStorage..[UnivofIowa2725Cleanup] 
WHERE [Action 1] = 'Set Policy Coverage Amount_no and base_amountNo to Collateral Balance (Column J)'


UPDATE PC
SET PC.AMOUNT_NO =IC.[Collateral Balance], PC.BASE_AMOUNT_NO =IC.[Collateral Balance]
--SELECT PC.BASE_AMOUNT_NO, PC.AMOUNT_NO, * 
FROM dbo.POLICY_COVERAGE PC
JOIN UniTracHDStorage..[UnivofIowa2725Cleanup] IC ON IC.[policy_coverage#ID] = PC.ID
WHERE IC.[Action 1] = 'Set Policy Coverage Amount_no and base_amountNo to Collateral Balance (Column J)'


UPDATE PC
SET PC.AMOUNT_NO =IC.[Property RCV], PC.BASE_AMOUNT_NO =IC.[Property RCV]
--SELECT PC.BASE_AMOUNT_NO, PC.AMOUNT_NO, * 
FROM dbo.POLICY_COVERAGE PC
JOIN UniTracHDStorage..[UnivofIowa2725Cleanup] IC ON IC.[policy_coverage#ID] = PC.ID
WHERE IC.[Action 1] = 'Set policy coverage amount_no and base_amountNo to Property RCV (column K)'



UPDATE OP
SET PC.AMOUNT_NO =IC.[Property RCV], PC.BASE_AMOUNT_NO =IC.[Property RCV]
--SELECT * 
FROM dbo.OWNER_POLICY OP
JOIN UniTracHDStorage..[UnivofIowa2725Cleanup] IC ON IC.[owner_Policy#ID] = OP.ID
WHERE IC.[Action #2] = 'Set Owner Policy to Have Walls-In Coverage'


SELECT * FROM dbo.REF_CODE
WHERE MEANING_TX LIKE '%wall%'

SELECT  I.* FROM dbo.REQUIRED_COVERAGE RC
JOIN dbo.IMPAIRMENT I ON I.REQUIRED_COVERAGE_ID = RC.ID
WHERE RC.ID = --'135864640'

'139875449'

SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'WI'
