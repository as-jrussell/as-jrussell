USE UniTrac 

SELECT DISTINCT  L.CODE_TX [Lender Code],
        L.NAME_TX [Lender Name] ,
        LP.DESCRIPTION_TX ,
        LP.NAME_TX [Lender Product] ,
        LP.BASIC_TYPE_CD ,
        LP.BASIC_SUB_TYPE_CD INTO jcs..INC0283141
FROM    dbo.BUSINESS_OPTION BO
        JOIN dbo.BUSINESS_OPTION_GROUP BG ON BO.BUSINESS_OPTION_GROUP_ID = BG.ID
        LEFT JOIN dbo.BUSINESS_RULE_BASE BR ON BR.ID = BO.BUSINESS_RULE_ID
        LEFT JOIN dbo.LENDER_PRODUCT LP ON LP.ID = BG.RELATE_ID
                                           AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
        LEFT JOIN dbo.LENDER L ON L.ID = LP.LENDER_ID
WHERE   BG.NAME_TX LIKE '%REO%'
        AND Bo.NAME_TX LIKE '%Liability%'
