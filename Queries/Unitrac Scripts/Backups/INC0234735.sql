USE UniTrac


 SELECT UPDATE_DT[Date], CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *

 --SELECT LAST_WORK_ITEM_ACTION_ID INTO #tmpWIA
FROM    UniTrac..WORK_ITEM
WHERE    CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '3124' 
--AND STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WORKFLOW_DEFINITION_ID = '10'
ORDER BY UPDATE_DT DESC 

--187 need to be current queue

SELECT * FROM dbo.WORK_QUEUE
WHERE ID in ( '179' , '187', '90')


SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE ID IN (SELECT * FROM #tmpWIA)
ORDER BY WORK_ITEM_ID DESC 

 
 SELECT UPDATE_DT[Date], CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM
WHERE STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted') AND UPDATE_DT >= '2016-06-10 '
AND WORKFLOW_DEFINITION_ID = '10' AND CURRENT_QUEUE_ID  = '179'
ORDER BY UPDATE_DT DESC 



 SELECT UPDATE_DT[Date], CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM
WHERE STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted') AND UPDATE_DT >= '2016-06-10 '
AND WORKFLOW_DEFINITION_ID = '10' AND CURRENT_QUEUE_ID  = '187'
ORDER BY UPDATE_DT DESC 

SELECT RELATE_ID
INTO #tmpBG
FROM    UniTrac..WORK_ITEM
WHERE    CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '3124' 
--AND STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WORKFLOW_DEFINITION_ID = '10'
ORDER BY UPDATE_DT DESC 




SELECT NUMBER_TX
INTO #tmpL
 FROM dbo.BILLING_GROUP
WHERE ID IN (SELECT * FROM #tmpBG)




SELECT DIVISION_CODE_TX, * FROM dbo.LOAN
WHERE NUMBER_TX IN (SELECT * FROM #tmpL)

 --1) Main Service Center Query (SERVICE_CENTER_FUNCTION_LENDER_RELATE)
SELECT C.CODE_TX, C.NAME_TX, SCFLR.ID as SCFLR_ID,*
FROM LENDER L
INNER JOIN SERVICE_CENTER_FUNCTION_LENDER_RELATE SCFLR ON L.ID = SCFLR.LENDER_ID AND SCFLR.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER_FUNCTION SCF ON SCFLR.SERVICE_CENTER_FUNCTION_ID = SCF.ID AND SCF.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER C ON SCF.SERVICE_CENTER_ID = C.ID  AND C.PURGE_DT IS NULL
WHERE L.CODE_TX IN ('3124', '3000') 
--('7519','7502','7534','7537','7539')
AND CANCEL_DT IS NULL AND L.PURGE_DT IS NULL
ORDER BY L.CODE_TX DESC
 
--2) Service Center Setup by Division
SELECT RD.VALUE_TX,LO.NAME_TX,RD.ID as RD_ID,*
FROM LENDER L
INNER JOIN LENDER_ORGANIZATION LO ON L.ID = LO.LENDER_ID
INNER JOIN RELATED_DATA RD ON LO.ID = RD.RELATE_ID AND RD.DEF_ID = '105'
WHERE L.CODE_TX IN ('3124', '3000')  
--('7519','7502','7534','7537','7539')
AND CANCEL_DT IS NULL AND Lo.PURGE_DT IS NULL AND L.PURGE_DT IS NULL
ORDER BY L.CODE_TX DESC 


/*


Take note with Commercial Mortgage (Division 99) loans they 

*/
















--Update Query
UPDATE SCFLR
SET SERVICE_CENTER_FUNCTION_ID = '108', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0234735'
--SELECT  C.CODE_TX, C.NAME_TX,SCFLR.* 
FROM LENDER L
INNER JOIN SERVICE_CENTER_FUNCTION_LENDER_RELATE SCFLR ON L.ID = SCFLR.LENDER_ID AND SCFLR.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER_FUNCTION SCF ON SCFLR.SERVICE_CENTER_FUNCTION_ID = SCF.ID AND SCF.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER C ON SCF.SERVICE_CENTER_ID = C.ID  AND C.PURGE_DT IS NULL
WHERE SCFLR.ID IN (2829)



--Update Query
UPDATE RELATED_DATA
SET VALUE_TX = 'Calif Mortgage', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0234735'
--SELECT LO.NAME_TX, LO.TYPE_CD, RD.* FROM dbo.RELATED_DATA RD 
INNER JOIN dbo.LENDER_ORGANIZATION LO ON RD.RELATE_ID = LO.ID 
INNER JOIN dbo.LENDER L ON L.ID = LO.LENDER_ID
WHERE RD.ID IN (119120881,
121318561)


(117982500, 117982501, 117982502, 117982503)


SELECT * FROM dbo.LENDER_ORGANIZATION
WHERE ID IN (11377,
11375,
11376,
11378)


SELECT * FROM dbo.LENDER
WHERE ID = '2292'

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE UPDATE_USER_TX = 'WFSrvr4'


SELECT * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '9944'
AND UPDATE_DT >= '2016-06-10 10:45:00 '



SELECT * FROM dbo.CHANGE C
LEFT JOIN dbo.CHANGE_UPDATE CU ON C.ID=Cu.CHANGE_ID
WHERE USER_TX = 'jrussell' AND C.CREATE_DT >= '2016-06-13 10:45:00 '


SELECT * FROM dbo.RELATED_DATA_DEF
WHERE ID = '92'


---From Value_TX 66 to 108

UPDATE RELATED_DATA
SET VALUE_TX = '66', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0234735'
WHERE ID IN  (119120881,
121318561)