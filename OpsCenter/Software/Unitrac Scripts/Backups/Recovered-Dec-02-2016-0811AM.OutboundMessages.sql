USE UniTrac

-----Pulls Lender and their Services that Inbound Message was on
SELECT P.TAB.value('.', 'nvarchar(max)') AS LenderCode, SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]', 'nvarchar(max)') AS ServiceName
INTO #tmpLenders
FROM PROCESS_DEFINITION pd 
CROSS APPLY pd.SETTINGS_XML_IM.nodes('(/ProcessDefinitionSettings/LenderList/LenderID)') AS P (TAB)
WHERE pd.PROCESS_TYPE_CD = 'MSGSRV' 
AND pd.ACTIVE_IN = 'y'


--Takes previous joins in and pulls on the WIs that are being currently worked

SELECT 
    M.ID INTO #tmp

FROM 
     MESSAGE M (NOLOCK) 
     JOIN TRADING_PARTNER TP (NOLOCK) ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
     JOIN DELIVERY_INFO DI (NOLOCK) ON M.DELIVERY_INFO_ID = DI.ID 
     JOIN RELATED_DATA RD (NOLOCK) ON DI.ID = RD.RELATE_ID 
	 JOIN RELATED_DATA_DEF RDD (NOLOCK) ON RDD.ID = RD.DEF_ID 
          AND RDD.NAME_TX = 'UniTracDeliveryType' 
     JOIN WORK_ITEM wi (NOLOCK) ON (wi.RELATE_ID = M.RELATE_ID_TX 
               AND wi.WORKFLOW_DEFINITION_ID = 1) 
     CROSS APPLY wi.CONTENT_XML.nodes('/Content/Information/ProcessLogs/ProcessLog') AS P (TAB) 
     JOIN PROCESS_LOG_ITEM PLI (NOLOCK) ON (P.TAB.value('@Id', 'BIGINT') = PLI.PROCESS_LOG_ID 
               AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan') 
     CROSS APPLY PLI.INFO_XML.nodes('/INFO_LOG/RELATE_INFO') AS PLI_INFO (TAB)
WHERE 
     M.PROCESSED_IN = 'N' 
     AND (M.RECEIVED_STATUS_CD = 'INIT'  OR M.RECEIVED_STATUS_CD = 'OBADHOC' )
     AND M.MESSAGE_DIRECTION_CD = 'O' 
     AND TP.TYPE_CD = 'LFP_TP' 
     AND RD.VALUE_TX = 'IMPORT'  
GROUP BY 
     TP.EXTERNAL_ID_TX, 
     TP.NAME_TX, 
     TP.TYPE_CD, 
     M.ID, 
     M.SENT_STATUS_CD, 
     M.RECEIVED_STATUS_CD, 
     M.UPDATE_USER_TX, 
     M.UPDATE_DT 
ORDER BY M.id ASC


---Shows WI that are in queue and WI not moved over to ADHOC service

SELECT 
     'OUTBOUND' as 'DIRECTION',
	 t.ServiceName,
     TP.EXTERNAL_ID_TX, 
     TP.NAME_TX, 
     TP.TYPE_CD, 
     M.* 
FROM message M (NOLOCK) 
JOIN TRADING_PARTNER TP (NOLOCK) 
     ON M.RECEIVED_FROM_TRADING_PARTNER_ID = TP.ID 
     JOIN DELIVERY_INFO DI
	ON M.DELIVERY_INFO_ID = DI.ID
JOIN RELATED_DATA RD
	ON DI.ID = RD.RELATE_ID
JOIN RELATED_DATA_DEF RDD
	ON RDD.ID = RD.DEF_ID
	AND RDD.NAME_TX = 'UniTracDeliveryType'
left JOIN #tmpLenders t ON t.LenderCode = TP.EXTERNAL_ID_TX
WHERE M.PROCESSED_IN = 'N' AND M.ID NOT IN (SELECT * FROM #tmp)  
AND M.RECEIVED_STATUS_CD IN ('INIT'  )
AND M.MESSAGE_DIRECTION_CD = 'O' 
and TYPE_CD = 'LFP_TP'
and m.purge_dt is null
and m.DELIVER_TO_TRADING_PARTNER_ID = '2046'
and TP.EXTERNAL_ID_TX not in ('2771', '3400', '1771', '1574', '5350', '4824')
AND RD.VALUE_TX = 'IMPORT' AND t.ServiceName <> 'MSGSRVREXTINFO'
AND SENDING_TRADING_PARTNER_ID <> '3109'
--AND TP.EXTERNAL_ID_TX = '6586'
ORDER BY  EXTERNAL_ID_TX DESC 


/*
DROP TABLE #tmp
DROP TABLE #tmpLenders

SELECT * FROM #tmp


BEGIN TRAN


UPDATE  MESSAGE
SET     RECEIVED_STATUS_CD = 'RCVD'
--SELECT PROCESSED_IN,RECEIVED_STATUS_CD,* FROM dbo.MESSAGE
WHERE   ID IN (6444991,
6444927,
6443419,
6443421,
6445797,
6445800,
6445805,
6409030,
6445944)

--ROLLBACK

--COMMIT


SELECT U.USER_NAME_TX,  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.* FROM dbo.WORK_ITEM WI
JOIN dbo.MESSAGE M ON M.RELATE_ID_TX = WI.RELATE_ID AND WI.WORKFLOW_DEFINITION_ID = '1'
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE M.ID IN ()
and wi.STATUS_CD not in ('Complete','ImportCompleted')
ORDER BY WI.STATUS_CD ASC 

SELECT * FROM dbo.MESSAGE
WHERE ID IN ()


SELECT ID INTO #tmpM FROM dbo.DOCUMENT
WHERE MESSAGE_ID IN ()


SELECT DATA.value( '(/Lender/Lender/CurrentLenderSummaryMatchResult/TotalExtractRecords)[1]', 'varchar(500)' ) as TotalExtractRecords,  
DATA.value( '(/Lender/Lender/CurrentLenderSummaryMatchResult/TotalDBLoans)[1]', 'varchar(500)' ) as LoanCount,  
DATA.value( '(/Lender/Lender/CurrentLenderSummaryMatchResult/TotalDBCollaterals)[1]', 'varchar(500)' ) as TotalDBCollaterals,  
DATA.value( '(/Lender/Lender/CurrentLenderSummaryMatchResult/TotalCollaterals)[1]', 'varchar(500)' ) as TotalCollaterals,  
* FROM dbo.[TRANSACTION]
WHERE DOCUMENT_ID IN (SELECT * FROM #tmpM)


SELECT PROCESS_LOG_ID, COUNT(*) FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN ()
GROUP BY PROCESS_LOG_ID 



*/




