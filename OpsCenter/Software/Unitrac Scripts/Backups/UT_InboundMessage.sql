use UniTracHDStorage

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[UT_InboundMessage]


as

SET NOCOUNT ON




SELECT P.TAB.value('.', 'nvarchar(max)') AS LenderCode, SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName
INTO #tmpLenders
FROM unitrac..PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('(/ProcessDefinitionSettings/LenderList/LenderID)') AS P (TAB)
WHERE pd.PROCESS_TYPE_CD = 'MSGSRV' 
AND pd.ACTIVE_IN = 'y'

SELECT     'INBOUND' as 'DIRECTION',  t.ServiceName,   TP.EXTERNAL_ID_TX,      TP.NAME_TX,      M.CREATE_DT AS [Message Created],   WI.ID AS WI_ID ,  M.* 
FROM unitrac..message M (NOLOCK) 
JOIN unitrac..TRADING_PARTNER TP (NOLOCK)      ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
JOIN      unitrac..DELIVERY_INFO DI           ON M.DELIVERY_INFO_ID = DI.id 
JOIN      unitrac..RELATED_DATA RD           ON DI.id = RD.RELATE_ID 
 JOIN      unitrac..RELATED_DATA_DEF RDD           ON RDD.id = RD.DEF_ID 
 LEFT JOIN unitrac..WORK_ITEM WI ON WI.RELATE_ID = M.ID AND WI.WORKFLOW_DEFINITION_ID = 1
 left JOIN #tmpLenders t ON t.LenderCode = TP.EXTERNAL_ID_TX
WHERE M.PROCESSED_IN = 'N' 
--AND M.RECEIVED_STATUS_CD = 'ADHOC' 
AND M.RECEIVED_STATUS_CD = 'RCVD' 
AND M.MESSAGE_DIRECTION_CD = 'I' 
AND TYPE_CD = 'LFP_TP'
AND RDD.NAME_TX = 'UniTracDeliveryType' 
and m.DELIVER_TO_TRADING_PARTNER_ID = '2046'
--AND rd.VALUE_TX = 'IMPORT'
AND M.PURGE_DT IS NULL 
UNION
SELECT     'INBOUND' as 'DIRECTION',  'ADHOC',   TP.EXTERNAL_ID_TX,      TP.NAME_TX,    M.CREATE_DT AS [Message Created],     WI.ID AS WI_ID ,  M.* 
FROM unitrac..message M (NOLOCK) 
JOIN unitrac..TRADING_PARTNER TP (NOLOCK)      ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
JOIN      unitrac..DELIVERY_INFO DI           ON M.DELIVERY_INFO_ID = DI.id 
JOIN      unitrac..RELATED_DATA RD           ON DI.id = RD.RELATE_ID 
 JOIN      unitrac..RELATED_DATA_DEF RDD           ON RDD.id = RD.DEF_ID 
 LEFT JOIN unitrac..WORK_ITEM WI ON WI.RELATE_ID = M.ID AND WI.WORKFLOW_DEFINITION_ID = 1
 left JOIN #tmpLenders t ON t.LenderCode = TP.EXTERNAL_ID_TX
WHERE M.PROCESSED_IN = 'N' 
AND M.RECEIVED_STATUS_CD = 'ADHOC' 
AND M.MESSAGE_DIRECTION_CD = 'I' 
and TYPE_CD = 'LFP_TP'
 AND RDD.NAME_TX = 'UniTracDeliveryType' 
and m.DELIVER_TO_TRADING_PARTNER_ID = '2046'
--AND rd.VALUE_TX = 'IMPORT'
AND M.PURGE_DT IS null  
ORDER BY    M.CREATE_DT ASC 

--SELECT * FROM #tmpLenders

drop table #tmpLenders


