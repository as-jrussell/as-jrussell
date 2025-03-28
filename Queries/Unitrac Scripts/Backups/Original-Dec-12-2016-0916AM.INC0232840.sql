USE UniTrac


SELECT DISTINCT
TP.EXTERNAL_ID_TX [Lender Code] ,
tp.NAME_TX[Lender Name] , LO.NAME_TX [Division], DI.DELIVERY_TYPE_CD [PreProcessing Details],
RDD.VALUE_TX [Import Configurations],MAX(C.CREATE_DT) [Enable First Line Of Insurance Added],  
CU.TO_VALUE_TX [Enable First Line Of Insurance]
FROM dbo.CHANGE C
JOIN dbo.CHANGE_UPDATE CU ON CU.CHANGE_ID = C.ID AND Cu.QUALIFIER_TX like '%Enable 1st Line of Insurance Processing%'
JOIN dbo.TRADING_PARTNER TP ON TP.ID = PARENT_ID 
JOIN dbo.DELIVERY_INFO DI ON DI.ID = C.ENTITY_ID
JOIN dbo.DELIVERY_INFO_GROUP DIG ON DIG.DELIVERY_INFO_ID = DI.ID
JOIN dbo.DELIVERY_DETAIL DD ON DD.DELIVERY_INFO_GROUP_ID = DIG.ID
JOIN dbo.DELIVERY_INFO_EXTRACT_CONFIG_RELATE DIC ON DIC.DELIVERY_INFO_ID = DI.ID
JOIN dbo.PPDATTRIBUTE PD ON PD.ID = Cu.TABLE_ID
JOIN dbo.RELATED_DATA RDD ON RDD.RELATE_ID = DI.ID AND RDD.DEF_ID = '96'

WHERE C.DESCRIPTION_TX LIKE '%1st line%' AND CU.TO_VALUE_TX = 'Y' AND CU.FROM_VALUE_TX = '' 
--AND RD2.VALUE_TX IS NULL
GROUP BY TP.EXTERNAL_ID_TX ,tp.NAME_TX,  DI.DELIVERY_TYPE_CD,  LO.NAME_TX,RDD.VALUE_TX, C.CREATE_DT,CU.TO_VALUE_TX 

--SELECT  *
--FROM    dbo.DELIVERY_INFO DI
--        LEFT JOIN dbo.RELATED_DATA RD2 ON RD2.RELATE_ID = DI.ID
--                                          AND RD2.DEF_ID = '95'
--WHERE   DI.ID IN ( 2313, 2175, 1836, 2029, 1228, 1489, 3784, 1691, 3884, 3131,
--                   3252, 3124, 1050, 3689, 2604, 1518 )



--SELECT ID INTO #tmpLO FROM dbo.LENDER
--WHERE CODE_TX IN ('1015', '1572','1597','1625','1738','1994','2086','2118','3067','3200','3200','4005','4216','4357','4500','6071')


--SELECT * FROM dbo.LENDER_ORGANIZATION
--WHERE ID IN (SELECT * FROM #tmpLO)


SELECT * FROM dbo.BUSINESS_OPTION
WHERE NAME_TX LIKE '%LenderExtract%'

SELECT IsNull(LO.CODE_TX, 'All')as CODE_TX,LOB.NAME_TX,LOC.NAME_TX,*
FROM DELIVERY_INFO_EXTRACT_CONFIG_RELATE DIE
LEFT JOIN VUT.dbo.tbllenderextract LE on DIE.RELATE_ID = LE.LenderExtractKey AND DIE.RELATE_CLASS_NAME_TX = 'LenderExtract'
LEFT JOIN LENDER_ORGANIZATION LOC ON LE.ContractTypeKey = LOC.ID
JOIN dbo.LENDER L ON L.ID = LOC.LENDER_ID
--JOIN dbo.TRADING_PARTNER TP ON TP.ID = PARENT_ID 
--JOIN dbo.DELIVERY_INFO DI ON DI.ID = C.ENTITY_ID
--JOIN dbo.DELIVERY_INFO_GROUP DIG ON DIG.DELIVERY_INFO_ID = DI.ID
--JOIN dbo.DELIVERY_DETAIL DD ON DD.DELIVERY_INFO_GROUP_ID = DIG.ID
--JOIN dbo.DELIVERY_INFO_EXTRACT_CONFIG_RELATE DIC ON DIC.DELIVERY_INFO_ID = DI.ID
--JOIN dbo.PPDATTRIBUTE PD ON PD.ID = Cu.TABLE_ID
--JOIN dbo.RELATED_DATA RDD ON RDD.RELATE_ID = DI.ID AND RDD.DEF_ID = '96'
WHERE DELIVERY_INFO_ID = 2079 AND DIE.PURGE_DT IS NULL
order by LOB.CODE_TX,LOC.NAME_TX