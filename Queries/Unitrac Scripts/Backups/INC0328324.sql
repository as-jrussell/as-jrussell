USE UniTrac 




SELECT DISTINCT L.NAME_TX [Lender Name], L.CODE_TX [Lender Code], LP.NAME_TX [Name], LP.DESCRIPTION_TX [Description],
RC.DESCRIPTION_TX [Basic Type], CR.DESCRIPTION_TX [Basic Sub Type], concat(AA.CITY_TX,', ',AA.STATE_PROV_TX ) [Location]
INTO jcs..INC0328324
FROM    dbo.BUSINESS_OPTION BO
        JOIN dbo.BUSINESS_OPTION_GROUP BG ON BO.BUSINESS_OPTION_GROUP_ID = BG.ID
		 LEFT JOIN dbo.LENDER_PRODUCT LP ON LP.ID = BG.RELATE_ID
                                           AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
        LEFT JOIN dbo.LENDER L ON L.ID = LP.LENDER_ID
        LEFT JOIN dbo.AGENCY A ON A.ID = L.AGENCY_ID
		LEFT JOIN dbo.REF_CODE RC ON RC.CODE_CD = LP.BASIC_TYPE_CD AND RC.DOMAIN_CD = 'LenderProductBasicType'
		LEFT JOIN dbo.REF_CODE CR ON CR.CODE_CD = LP.BASIC_SUB_TYPE_CD AND CR.DOMAIN_CD = 'LenderProductBasicSubType'
		LEFT JOIN dbo.ADDRESS AA ON AA.ID = L.PHYSICAL_ADDRESS_ID
WHERE   L.STATUS_CD = 'ACTIVE' 
        AND L.PURGE_DT IS NULL
        AND L.TEST_IN = 'N'
        AND LP.PURGE_DT IS NULL
        AND bo.PURGE_DT IS NULL
        AND bg.PURGE_DT IS NULL

