USE [UniTrac]
GO


--1) Obtain IDs for all EDI Trading Partners
SELECT ID into #tmpTP
FROM TRADING_PARTNER
WHERE TYPE_CD IN ('EDI_TP')


--2) Obtain all EDI Messages from Trading Partner Log (based on Date)
SELECT DISTINCT MESSAGE_ID into #tmpMSGALL
from TRADING_PARTNER_LOG
where TRADING_PARTNER_ID in (SELECT ID from #tmpTP) AND CREATE_dT >= DATEADD(DD, -3,GETDATE())


--3) Obtain all Failed Transactions for above messages
SELECT RELATE_ID_TX INTO #tmpTXNERR
from TRADING_PARTNER_LOG
WHERE MESSAGE_ID IN (SELECT DISTINCT MESSAGE_ID FROM #tmpMSGALL)


--4) Obtain Ins Cos for above Failed Transactions
SELECT ID, DATA.value('(/Transaction/InsuranceDocument/InsuranceCompany/CompanyName)[1]' , 'varchar(40)') as InsCo, 
Case WHEN DATA.value('(/Transaction/InsuranceDocument/@InterchangeControlNumber)[1]' , 'varchar(40)') IS NULL then 'IDR'
else DATA.value('(/Transaction/InsuranceDocument/@InterchangeControlNumber)[1]' , 'varchar(40)') 
End as InterchangeControlNo, 
DATA.value('(/Transaction/InsuranceDocument/@Id)[1]' , 'varchar(200)') as GroupControlNo, STATUS_CD INTO #tmpTXNInsCo
FROM [TRANSACTION]
WHERE ID IN (SELECT RELATE_ID_TX FROM #tmpTXNERR)


--5) Create temp table with all error messages for failed transactions
SELECT RELATE_ID_TX,
Case
when Left(LOG_MESSAGE,200) like '%The API Server for saving UTLs is unavailable%' then Left(LOG_MESSAGE,200)
WHEN Left(LOG_MESSAGE,200) LIKE '%Exception Message :%' THEN SUBSTRING(SUBSTRING(LOG_MESSAGE,CHARINDEX('Exception Message : ',LOG_MESSAGE)+20,LEN(LOG_MESSAGE)), 1, CHARINDEX('Exception Stack Trace', SUBSTRING(LOG_MESSAGE,CHARINDEX('Exception Message : ',LOG_MESSAGE)+21,LEN(LOG_MESSAGE)))) 
ELSE Left(LOG_MESSAGE,200)
End as ErrorMessage
INTO #tmpERRORS
from TRADING_PARTNER_LOG
WHERE MESSAGE_ID IN (SELECT DISTINCT MESSAGE_ID FROM #tmpMSGALL)
AND RELATE_ID_TX IN (SELECT RELATE_ID_TX FROM #tmpTXNERR)


--6) Grouped results by error and ins co
SELECT DISTINCT Replace(ErrorMessage,char(13) + char(10),'') AS ErrorMessage,InsCo,InterchangeControlNo,GroupControlNo,STATUS_CD,Count(ErrorMessage) as ErrorCount
FROM #tmpERRORS te
LEFT JOIN #tmpTXNInsCo tt on te.RELATE_ID_TX = tt.ID
WHERE tt.STATUS_CD IN ('ERR', 'IGN')
GROUP BY ErrorMessage, InsCo,InterchangeControlNo,GroupControlNo,STATUS_CD
ORDER BY Count (ErrorMessage) DESC, ErrorMessage, InsCo,InterchangeControlNo,GroupControlNo,STATUS_CD

--6) Grouped results by error and ins co
SELECT DISTINCT Replace(ErrorMessage,char(13) + char(10),'') AS ErrorMessage,InsCo,InterchangeControlNo,GroupControlNo,STATUS_CD,Count(ErrorMessage) as ErrorCount
FROM #tmpERRORS te
LEFT JOIN #tmpTXNInsCo tt on te.RELATE_ID_TX = tt.ID
WHERE tt.STATUS_CD IN ('ERR', 'IGN')
GROUP BY ErrorMessage, InsCo,InterchangeControlNo,GroupControlNo,STATUS_CD
ORDER BY Count (ErrorMessage) DESC, ErrorMessage, InsCo,InterchangeControlNo,GroupControlNo,STATUS_CD




DROP TABLE #tmpTP
DROP TABLE #tmpERRORS
DROP TABLE #tmpTXNInsCo
drop TABLE #tmpMSGALL
DROP TABLE  #tmpTXNERR
