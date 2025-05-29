USE UniTrac


--Lender File Setup

SELECT
*
FROM DELIVERY_INFO_EXTRACT_CONFIG_RELATE DIE
LEFT JOIN VUT.dbo.tbllenderextract LE on DIE.RELATE_ID = LE.LenderExtractKey AND DIE.RELATE_CLASS_NAME_TX = 'LenderExtract'
LEFT JOIN LENDER_ORGANIZATION LOC ON LE.ContractTypeKey = LOC.ID
LEFT JOIN dbo.LENDER L ON L.ID = LOC.LENDER_ID
LEFT JOIN dbo.TRADING_PARTNER TP ON TP.EXTERNAL_ID_TX = L.CODE_TX
LEFT JOIN dbo.DELIVERY_INFO DI ON DI.TRADING_PARTNER_ID = TP.ID
LEFT JOIN dbo.DELIVERY_INFO_GROUP DIG ON DIG.DELIVERY_INFO_ID = DI.ID
LEFT JOIN dbo.DELIVERY_DETAIL DD ON DD.DELIVERY_INFO_GROUP_ID = DIG.ID
LEFT JOIN dbo.DELIVERY_INFO_EXTRACT_CONFIG_RELATE DIC ON DIC.DELIVERY_INFO_ID = DI.ID
LEFT JOIN dbo.RELATED_DATA RDD ON RDD.RELATE_ID = DI.ID AND RDD.DEF_ID = '96'


---Lender File Import Config 
SELECT L.LenderID, L.LenderName, LE.* FROM vut..tbllenderextract LE
JOIN vut..tblLender L ON L.LenderKey = LE.LenderKey
ORDER BY UPDATEdate DESC 




--Code Setup

SELECT  L.LenderID, L.LenderName, EF.* FROM vut..tblLenderExtractCategoryFieldOrder ECFO
JOIN vut..tblLenderExtractFieldMasterList EF ON EF.LenderExtractFieldMasterListKEY = ECFO.LenderExtractFieldMasterKEY
JOIN vut..tblLenderExtractCategory LEC ON LEC.LenderExtractCategoryKey = ECFO.LenderExtractCategoryKey
JOIN vut..tbllenderExtract LE ON LE.LenderExtractKey = LEC.LenderExtractKey
JOIN vut..tblLender L ON L.LenderKey = LE.LenderKey
