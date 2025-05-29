USE UniTrac 

SELECT  *
FROM    dbo.LENDER
WHERE   CODE_TX IN ( '1010036', '1010040', '1010041', '1010045', '1010053',
                     '1010060', '1010089', '1010090', '1010091', '1010092',
                     '1010093', '9010001', '9010027', '10010003', '10010019',
                     '10010035', '10010200', '10010213', '10010311',
                     '10010313', '10010335', '10010358', '10015599',
                     '10015799', '10016900', '10020000', '10020200',
                     '10021100', '10021300', '10023000', '10024700',
                     '10025400', '16010100', '23040027', '32010013',
                     '39020047', '41010066', '41010100', '41010108',
                     '41020143' )


SELECT  L.NAME_TX [Lender Name] ,
        CODE_TX [Lender Code] ,
        LP.DESCRIPTION_TX [Lender Product] , 
        BO.NAME_TX [ForcedPlcyOptReportNonPayDay] ,
        BO.DESCRIPTION_TX [ForcedPlcyOptReportNonPayDay Desc] , BO.DEFAULT_VALUE_TX,
        GROUP_TYPE_CD ,
        START_DT ,
        END_DT ,
        BASIC_TYPE_CD ,
        BASIC_SUB_TYPE_CD
INTO    UniTracHDStorage.. INC0274458 
FROM    dbo.BUSINESS_OPTION BO
        JOIN dbo.BUSINESS_OPTION_GROUP BG ON BO.BUSINESS_OPTION_GROUP_ID = BG.ID
        LEFT JOIN dbo.BUSINESS_RULE_BASE BR ON BR.ID = BO.BUSINESS_RULE_ID
        LEFT JOIN dbo.LENDER_PRODUCT LP ON LP.ID = BG.RELATE_ID
                                           AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
        LEFT JOIN dbo.LENDER L ON L.ID = LP.LENDER_ID
        LEFT JOIN dbo.AGENCY A ON A.ID = BG.RELATE_ID
                                  AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.Agency'
        LEFT JOIN dbo.WORK_QUEUE WQ ON A.ID = BG.RELATE_ID
                                       AND BG.RELATE_CLASS_NM = 'UnitracWorkQueue'
        LEFT JOIN dbo.COMMISSION_RATE CR ON CR.ID = BG.RELATE_ID
                                            AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.CommissionRate'
WHERE   L.CODE_TX IN ( '1010036', '1010040', '1010041', '1010045', '1010053',
                       '1010060', '1010089', '1010090', '1010091', '1010092',
                       '1010093', '9010001', '9010027', '10010003', '10010019',
                       '10010035', '10010200', '10010213', '10010311',
                       '10010313', '10010335', '10010358', '10015599',
                       '10015799', '10016900', '10020000', '10020200',
                       '10021100', '10021300', '10023000', '10024700',
                       '10025400', '16010100', '23040027', '32010013',
                       '39020047', '41010066', '41010100', '41010108',
                       '41020143' )
        AND BO.NAME_TX = 'ForcedPlcyNonPayDays'


SELECT BO.* --INTO UniTracHDStorage..INC0272899_BO
FROM    dbo.BUSINESS_OPTION BO
        JOIN dbo.BUSINESS_OPTION_GROUP BG ON BO.BUSINESS_OPTION_GROUP_ID = BG.ID
        LEFT JOIN dbo.BUSINESS_RULE_BASE BR ON BR.ID = BO.BUSINESS_RULE_ID
        LEFT JOIN dbo.LENDER_PRODUCT LP ON LP.ID = BG.RELATE_ID
                                           AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.LenderProduct'
        LEFT JOIN dbo.LENDER L ON L.ID = LP.LENDER_ID
        LEFT JOIN dbo.AGENCY A ON A.ID = BG.RELATE_ID
                                  AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.Agency'
        LEFT JOIN dbo.WORK_QUEUE WQ ON A.ID = BG.RELATE_ID
                                       AND BG.RELATE_CLASS_NM = 'UnitracWorkQueue'
        LEFT JOIN dbo.COMMISSION_RATE CR ON CR.ID = BG.RELATE_ID
                                            AND BG.RELATE_CLASS_NM = 'Allied.UniTrac.CommissionRate'
WHERE   L.CODE_TX IN ( '1010036', '1010040', '1010041', '1010045', '1010053',
                       '1010060', '1010089', '1010090', '1010091', '1010092',
                       '1010093', '9010001', '9010027', '10010003', '10010019',
                       '10010035', '10010200', '10010213', '10010311',
                       '10010313', '10010335', '10010358', '10015599',
                       '10015799', '10016900', '10020000', '10020200',
                       '10021100', '10021300', '10023000', '10024700',
                       '10025400', '16010100', '23040027', '32010013',
                       '39020047', '41010066', '41010100', '41010108',
                       '41020143' )
        AND BO.NAME_TX = 'ForcedPlcyNonPayDays'


		UPDATE dbo.BUSINESS_OPTION
		SET DEFAULT_VALUE_TX = '14', UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0272899'
		--SELECT * FROM dbo.BUSINESS_OPTION
		WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0272899_bo)



		SELECT * FROM UniTracHDStorage.. INC0274458 