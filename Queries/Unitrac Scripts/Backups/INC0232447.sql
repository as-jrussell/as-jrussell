USE UniTrac





SELECT * FROM dbo.CHANGE C
INNER JOIN dbo.CHANGE_UPDATE CU ON CU.CHANGE_ID = C.ID 
WHERE USER_TX = 'jrussell' AND C.CREATE_DT >= '2016-06-02 '
ORDER BY C.CREATE_DT DESC 

--Allied.UniTrac.CommissionRate



SELECT  L.CODE_TX [Lender Code],
        L.NAME_TX [Lender Name] ,
        BRB.DESCRIPTION_TX [Rule Description] ,
        RULE_TYPE_CD ,
       CONDITION_TYPE_CD ,
        CR.TYPE_CD ,
        PERCENT_NO ,
        AMOUNT_NO ,
        EFFECTIVE_DT ,
        REFUNDABLE_IN ,
        SUSPENDED_IN ,
        EXPIRATION_DT
--INTO UniTracHDStorage..zINC0232447
FROM    dbo.BUSINESS_RULE_BASE BRB
        INNER JOIN dbo.RULE_CONDITION_BASE RCB ON RCB.BUSINESS_RULE_BASE_ID = BRB.ID AND  RCB.NAME_TX = 'DivisionCode'
        INNER JOIN dbo.BUSINESS_OPTION_GROUP BOG ON BOG.ID = BRB.BUSINESS_OPTION_GROUP_ID
        INNER JOIN dbo.COMMISSION_RATE CR ON CR.id = BOG.RELATE_ID
                                             AND BOG.RELATE_CLASS_NM = 'Allied.UniTrac.CommissionRate'
        INNER JOIN dbo.LENDER L ON L.ID = CR.LENDER_ID
WHERE   BRB.DESCRIPTION_TX LIKE '%Division - Vehicle Loan%'
        AND CR.PURGE_DT IS NULL






SELECT * FROM dbo.REF_CODE WHERE DOMAIN_CD =  
'VRC'
