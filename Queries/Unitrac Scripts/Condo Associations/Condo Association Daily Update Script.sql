
--1) Collect all failed transactions for past 7 days
SELECT RELATE_ID_TX INTO #tmpTXN
FROM TRADING_PARTNER_LOG
WHERE LOG_SEVERITY_CD = 'ERROR' AND PROCESS_CD = 'INSDOCPA' AND LOG_MESSAGE LIKE '%Property Association Name not found%'
AND CREATE_DT >= DATEADD(dd, -7, GETDATE()) AND RELATE_TYPE_CD = 'Transaction'
--523

--2) Collect all transactions still in error
SELECT D2.NAME_TX, D2.DELIVERY_INFO_GROUP_ID,DATA.value('(/Transaction/InsuranceDocument/Property/Condo/@Association)[1]', 'nvarchar(max)')as CondoAssociation,T.CREATE_dT, T.STATUS_CD,T.ID INTO #tmpTXNERR
FROM [TRANSACTION] T
INNER JOIN DOCUMENT D ON T.DOCUMENT_ID = D.ID
INNER JOIN DOCUMENT D2 ON D.MESSAGE_ID = D2.MESSAGE_ID AND D2.DELIVERY_INFO_GROUP_ID in (3683,4144)
WHERE T.ID IN (SELECT RELATE_ID_TX FROM #tmpTXN) AND T.STATUS_cD = 'ERR'
--6611
--4446 DISTINCT
--104


--3) Insert Condos into Prop Assoc Table
INSERT INTO PROPERTY_ASSOCIATION (NAME_TX, TYPE_CD, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
SELECT DISTINCT DATA.value('(/Transaction/InsuranceDocument/Property/Condo/@Association)[1]', 'nvarchar(max)')as CondoAssociation,'CON',GETDATE(), GETDATE(), 'TFS41347',1
FROM [TRANSACTION] T
INNER JOIN DOCUMENT D ON T.DOCUMENT_ID = D.ID
INNER JOIN DOCUMENT D2 ON D.MESSAGE_ID = D2.MESSAGE_ID AND D2.DELIVERY_INFO_GROUP_ID = 3683
WHERE T.ID IN (SELECT ID FROM #tmpTXNERR) AND DATA.value('(/Transaction/InsuranceDocument/Property/Condo/@Association)[1]', 'nvarchar(max)') NOT IN (SELECT DISTINCT NAME_TX FROM PROPERTY_ASSOCIATION)
--83

--4) Reset Batches
SELECT DISTINCT Replace(Replace(Replace(D2.NAME_TX, 'UT_', ''), '.ASC.PGP', ''), '.CSV.PGP', '') as BatchID into #tmpBatchID
FROM [TRANSACTION] T
INNER JOIN DOCUMENT D ON T.DOCUMENT_ID = D.ID
INNER JOIN DOCUMENT D2 ON D.MESSAGE_ID = D2.MESSAGE_ID AND D2.DELIVERY_INFO_GROUP_ID = 3683
WHERE T.ID IN (SELECT ID FROM #tmpTXNERR)
--5380

update vut.dbo.scanbatch
set received = 0, receiveddate = NULL
--SELECT * FROM  vut.dbo.scanbatch
where batchid in (select BatchID from #tmpBatchID)
--5379
--85


--4) Reset Transactions
UPDATE  [TRANSACTION]
SET     STATUS_CD = 'INIT' , PROCESSED_IN = 'N' ,LOCK_ID = LOCK_ID + 1,UPDATE_USER_TX = 'TFS41347'
--SELECT * FROM [TRANSACTION]
WHERE ID in (SELECT ID FROM #tmpTXNERR)


--5) Reset Messages
SELECT DISTINCT DOCUMENT_ID into #tmpDOCUPD
FROM [TRANSACTION]
WHERE ID in (SELECT ID FROM #tmpTXNERR)
--5381
--85

SELECT DISTINCT OB.ID into #tmpMSGUPD
FROM DOCUMENT DOC
LEFT JOIN MESSAGE IB ON DOC.MESSAGE_ID = IB.ID
LEFT JOIN MESSAGE OB ON OB.RELATE_ID_TX = IB.ID 
WHERE DOC.ID in (SELECT DOCUMENT_ID FROM #tmpDOCUPD)
--85

--OB Reset
update MESSAGE
set RECEIVED_STATUS_CD = 'INIT', PROCESSED_IN = 'N', LOCK_ID = LOCK_ID + 1, UPDATE_DT = GETDATE(), SENT_STATUS_CD = 'PEND',UPDATE_USER_TX = 'TFS41347'
--SELECT * FROM MESSAGE
where ID in (SELECT ID FROM #tmpMSGUPD)



--Monitor Queries

--Batches
select received, receiveddate,*
from vut.dbo.scanbatch
where batchid in (select BatchID from #tmpBatchID)
ORDER BY scanbatch.received DESC

--Transactions
SELECT PROCESSED_IN,*
FROM [TRANSACTION]
WHERE ID in (select ID FROM #tmpTXNERR)
ORDER BY [TRANSACTION].PROCESSED_IN, [TRANSACTION].STATUS_CD

--Messages
SELECT PROCESSED_IN, *
FROM MESSAGE
where ID in (SELECT ID FROM #tmpMSGUPD)
ORDER BY MESSAGE.PROCESSED_IN




--One-Off Name Updates

UPDATE [TRANSACTION]
SET DATA.modify('replace value of (/Transaction/InsuranceDocument/Property/Condo/@Association)[1] with "WEST AIRPORT PALMS BUSINESS PARK CONDO ASSOCIATION"')
, LOCK_ID = LOCK_ID + 1
WHERE ID IN (196341753,196341754,196341755,196341756)


--Additional Research Queries

SELECT IB.ID, OB.ID, D2.NAME_TX
FROM DOCUMENT DOC
LEFT JOIN MESSAGE IB ON DOC.MESSAGE_ID = IB.ID
LEFT JOIN MESSAGE OB ON OB.RELATE_ID_TX = IB.ID 
INNER JOIN DOCUMENT D2 ON DOC.MESSAGE_ID = D2.MESSAGE_ID AND D2.DELIVERY_INFO_GROUP_ID = 3683
WHERE DOC.ID in (20748559)

SELECT *
FROM TRADING_PARTNER_LOG
WHERE MESSAGE_ID IN (9446394)
ORDER BY CREATE_DT DESC

--One-Off Resets

update vut.dbo.scanbatch
set received = 0, receiveddate = null
where batchid in ('LIUNITRACAPP01201708101005350083')

UPDATE  [TRANSACTION]
SET     STATUS_CD = 'INIT' , PROCESSED_IN = 'N' ,LOCK_ID = LOCK_ID + 1,UPDATE_USER_TX = 'TFS41347'
--SELECT * FROM [TRANSACTION]
WHERE ID in (203000528)

update MESSAGE
set RECEIVED_STATUS_CD = 'INIT', PROCESSED_IN = 'N', LOCK_ID = LOCK_ID + 1, UPDATE_DT = GETDATE(), SENT_STATUS_CD = 'PEND',UPDATE_USER_TX = 'TFS41347'
--SELECT * FROM MESSAGE
where ID in (9446817)


