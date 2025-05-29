USE [UniTracHDStorage]
GO

/****** Object:  StoredProcedure [dbo].[UT_OutboundMessage]    Script Date: 12/2/2019 8:52:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[UT_OutboundMessage]


as

SET NOCOUNT ON





--Outbound (LDHService)

SELECT 
     'OUTBOUND' as 'DIRECTION',
     TP.EXTERNAL_ID_TX, 
     TP.NAME_TX, 
     TP.TYPE_CD, 
     M.* 
FROM Unitrac.dbo.message M (NOLOCK) 
JOIN Unitrac.dbo.TRADING_PARTNER TP (NOLOCK) 
     ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
     JOIN Unitrac.dbo.DELIVERY_INFO DI
	ON M.DELIVERY_INFO_ID = DI.ID
JOIN Unitrac.dbo.RELATED_DATA RD
	ON DI.ID = RD.RELATE_ID
JOIN Unitrac.dbo.RELATED_DATA_DEF RDD
	ON RDD.ID = RD.DEF_ID
	AND RDD.NAME_TX = 'UniTracDeliveryType'
WHERE M.PROCESSED_IN = 'N' 
AND ( M.RECEIVED_STATUS_CD = 'INIT'  or M.RECEIVED_STATUS_CD = 'OBADHOC' )
AND M.MESSAGE_DIRECTION_CD = 'O' 
and TYPE_CD = 'LFP_TP'
and m.purge_dt is null
and m.DELIVER_TO_TRADING_PARTNER_ID = '2046'
--and TP.EXTERNAL_ID_TX not in ('2771', '3400', '1771', '1574', '5350', '1832', '7200')
AND RD.VALUE_TX = 'IMPORT'
--AND TP.EXTERNAL_ID_TX = '6586'
ORDER BY  m.id




--Outbound in process

SELECT 
     TP.EXTERNAL_ID_TX, 
     TP.NAME_TX, 
     TP.TYPE_CD, 
     M.ID, 
     M.SENT_STATUS_CD, 
     M.RECEIVED_STATUS_CD, 
     M.UPDATE_USER_TX, 
     M.UPDATE_DT, 
     --COUNT(letd.ID) AS LETD_COUNT, 
     COUNT(PLI.ID) AS PLI_COUNT ,
	 MAX(PLI.UPDATE_USER_TX) AS LDH_User,
	 MIN(PLI.UPDATE_DT) AS FistPLI,
	 MAX(PLI.UPDATE_DT) AS LatestPLI
	 
FROM 
     Unitrac.dbo.MESSAGE M (NOLOCK) 
     JOIN Unitrac.dbo.TRADING_PARTNER TP (NOLOCK) ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
     JOIN Unitrac.dbo.DELIVERY_INFO DI (NOLOCK) ON M.DELIVERY_INFO_ID = DI.ID 
     JOIN Unitrac.dbo.RELATED_DATA RD (NOLOCK) ON DI.ID = RD.RELATE_ID 
     JOIN Unitrac.dbo.RELATED_DATA_DEF RDD (NOLOCK) ON RDD.ID = RD.DEF_ID 
          AND RDD.NAME_TX = 'UniTracDeliveryType' 
     JOIN Unitrac.dbo.WORK_ITEM wi (NOLOCK) ON (wi.RELATE_ID = M.RELATE_ID_TX 
               AND wi.WORKFLOW_DEFINITION_ID = 1) 
     CROSS APPLY wi.CONTENT_XML.nodes('/Content/Information/ProcessLogs/ProcessLog') AS P (TAB) 
     JOIN Unitrac.dbo.PROCESS_LOG_ITEM PLI (NOLOCK) ON (P.TAB.value('@Id', 'BIGINT') = PLI.PROCESS_LOG_ID 
               AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan') 
     CROSS APPLY PLI.INFO_XML.nodes('/INFO_LOG/RELATE_INFO') AS PLI_INFO (TAB) 
     --JOIN DOCUMENT d (NOLOCK) ON M.RELATE_ID_TX = d.MESSAGE_ID 
     --JOIN [TRANSACTION] t (NOLOCK) ON d.ID = t.DOCUMENT_ID 
     --JOIN LOAN_EXTRACT_TRANSACTION_DETAIL letd (NOLOCK) ON (letd.TRANSACTION_ID = t.ID 
     --          AND letd.PURGE_DT IS NULL) 
WHERE 
     M.PROCESSED_IN = 'N' 
     AND (M.RECEIVED_STATUS_CD = 'INIT'  OR M.RECEIVED_STATUS_CD = 'OBADHOC' )
     AND M.MESSAGE_DIRECTION_CD = 'O' 
     AND TP.TYPE_CD = 'LFP_TP' 
     AND RD.VALUE_TX = 'IMPORT' 
--and TP.EXTERNAL_ID_TX not in ('2771', '3400', '1771', '1574', '5350', '1832', '7200')

GROUP BY 
     TP.EXTERNAL_ID_TX, 
     TP.NAME_TX, 
     TP.TYPE_CD, 
     M.ID, 
     M.SENT_STATUS_CD, 
     M.RECEIVED_STATUS_CD, 
     M.UPDATE_USER_TX, 
     M.UPDATE_DT 
ORDER BY  UPDATE_USER_TX,  M.UPDATE_DT ASC




SELECT WI.ID [Work Item], L.NAME_TX, L.CODE_TX, 
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[2]', 'varchar (50)') ProcessID,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[3]', 'varchar (50)') ProcessID,
PD.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service]
FROM Unitrac.dbo.WORK_ITEM WI
LEFT JOIN Unitrac.dbo.LENDER L ON L.ID = WI.LENDER_ID
LEFT JOIN Unitrac.dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
LEFT JOIN Unitrac.dbo.Process_LOG PL on PL.ID = WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)')
left join Unitrac.dbo.process_definition pd on pd.id = pl.process_definition_id
WHERE WORKFLOW_DEFINITION_ID =1 and WI.STATUS_CD = 'Approve'
ORDER BY WI.LENDER_ID DESC 




GO

