---- DROP TABLE #TMPPCP
SELECT * 
INTO #TMPPCP
FROM PRIOR_CARRIER_POLICY WHERE INSURANCE_COMPANY_NAME_TX = 'MINITER - PC'
AND PURGE_DT IS NULL
----731

---- DROP TABLE #TMPPCP_01
SELECT LOAN.NUMBER_TX , RC.PROPERTY_ID  , LOAN.ID AS LOAN_ID ,
 PCP.* 
INTO #TMPPCP_01
FROM #TMPPCP PCP
JOIN REQUIRED_COVERAGE RC ON RC.ID = PCP.REQUIRED_COVERAGE_ID
AND RC.PURGE_DT IS NULL
JOIN PROPERTY PR ON PR.ID = RC.PROPERTY_ID
AND PR.PURGE_DT IS NULL
JOIN COLLATERAL COLL ON COLL.PROPERTY_ID = PR.ID
AND COLL.PURGE_DT IS NULL
JOIN LOAN ON LOAN.ID = COLL.LOAN_ID
AND LOAN.PURGE_DT IS NULL
WHERE LOAN.LENDER_ID = 2260
AND RC.ID IN 
(
108857530,	108858525,	108858778,	108858820,	108859271,	108859329,	108859742,	108860121,	108860215,	108860215,	108860467,	108861115,	108861143,	108861736,	108861753,	108862355,	108862433,	108863261,	108863594,	108864058,	108864770,	108865451,	108865732,	108865822,	108866100,	108866399,	108867620,	108867783,	108868135,	108868138,	108868324,	108870111,	108870582,	108873108,	108873919,	108874263,	108874491,	108874515,	108875320,	108875555,	108876224,	108876323,	108876784,	108877867,	108878017,	108878171,	108878188,	108878369,	108878511,	108880211,	108880546,	108880651,	108880747,	108881056,	108881073,	108881353,	108881355,	108881423,	108881708,	108881878,	108882096,	108882391,	108882403,	108882669,	108882825,	108883048,	108883088,	108883164,	108883637,	108883666,	108883826,	108884299,	108884436,	108884806,	108884941,	108885023,	108885479,	108885882,	108886970,	108887198,	108887241,	108888343,	108888345,	108888496,	108888527,	108888565,	108888929,	108889015,	108889140,	108889777,	108890145,	108890213,	108890277,	108890849,	108890885,	108890897,	108891041,	108891189,	108891395,	108891463,	108891658,	108892665,	108892735,	108893045,	108893302,	108893463,	108893569,	108893619,	108893649,	108894587,	108894699,	108894871,	108895861,	108895889,	108896095,	108896270,	108896854,	108897030,	108897873,	108899273,	108899331,	108899898,	108900488,	108900708,	108900852,	108900940,	108900962,	108901069,	108901131,	108901468,	108901883,	108901912,	108902035,	108902689,	108903098,	108903261,	108903706,	108903748,	108904348,	108904839,	108905627,	108906719,	108906822,	108907173,	108907299,	108907464,	108907549,	108908515,	108909226,	108909559,	108910398,	108910632,	108911607,	108911855,	108913435,	108914363,	108914460,	108914485,	108914906,	109959236,	109959614,	109960281,	109960337,	109960361,	109960333,	108921204,	109960561,	108921705,	109960805,	108922250,	109960850,	109960939,	109961473,	109961527
)
AND COLL.PRIMARY_LOAN_IN = 'Y'
AND PCP.INSURANCE_COMPANY_NAME_TX = 'MINITER - PC'
----170


---- DROP TABLE #TMPIH
SELECT PCP.* , IH.ID AS IH_ID , IH.SPECIAL_HANDLING_XML , 
IH.SPECIAL_HANDLING_XML AS NEW_SH ,
IH.UPDATE_USER_TX AS IH_UPDATE_USER_TX
INTO #TMPIH
FROM #TMPPCP_01 PCP
JOIN INTERACTION_HISTORY IH ON IH.PROPERTY_ID = PCP.PROPERTY_ID
AND IH.PURGE_DT IS NULL
WHERE IH.TYPE_CD = 'PCP'
AND IH.RELATE_ID = PCP.ID
AND IH.RELATE_CLASS_TX = 'ALLIED.UNITRAC.PRIORCARRIERPOLICY'
-----170

SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36364_PCP
FROM #TMPPCP_01
----170

SELECT * 
INTO UnitracHDStorage.dbo.tmpTask36364_IH
FROM #TMPIH
---- 170


UPDATE IH SET 
SPECIAL_HANDLING_XML.modify('replace value of (/SH/InsuranceCompanyName/text())[1] with "PROCTOR - PC" '),
UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'TASK36364', 
LOCK_ID = IH.LOCK_ID % 255 + 1
---- SELECT *
FROM INTERACTION_HISTORY IH JOIN #TMPIH T1 ON T1.IH_ID = IH.ID
----170


UPDATE PCP
SET INSURANCE_COMPANY_NAME_TX = 'PROCTOR - PC',
UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'TASK36364', 
LOCK_ID = PCP.LOCK_ID % 255 + 1
----- SELECT *
FROM PRIOR_CARRIER_POLICY PCP JOIN #TMPPCP_01 T1 ON 
T1.ID = PCP.ID
----170
