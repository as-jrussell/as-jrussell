-------------- Check Work Items Before Update (To Verify Work Item Definition and Status)
-------------- Work Item ID Number(s) should be provided on HDT
----REPLACE XXXXXXX WITH THE THE WI ID
USE UniTrac

SELECT U.USER_NAME_TX,  WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender,
WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]', 'varchar (50)') ProcessID,
WI.* FROM dbo.WORK_ITEM WI
LEFT JOIN dbo.USERS U ON U.ID = WI.CHECKED_OUT_OWNER_ID
WHERE WI.STATUS_CD = 'Approve'  
ORDER BY CHECKED_OUT_DT DESC 

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'LOANPRCPA'


SELECT PD.NAME_TX, PL.* FROM dbo.PROCESS_LOG PL
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PL.ID IN ()

SELECT TOP 50 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID IN (58339, 336)
ORDER BY UPDATE_DT DESC 


SELECT  WI.CONTENT_XML.value('(/Content/Information/ProcessLogs/ProcessLog/@Id)[1]',
                             'varchar (50)') ProcessID ,
        *
FROM    dbo.WORK_ITEM WI
        JOIN dbo.MESSAGE M ON M.RELATE_ID_TX = WI.RELATE_ID
                              AND WI.WORKFLOW_DEFINITION_ID = '1'
WHERE   M.ID IN (  )
ORDER BY WI.STATUS_CD ASC 


SELECT * FROM dbo.OUTPUT_BATCH
WHERE   CAST(UPDATE_DT AS DATE) >= CAST(GETDATE()-1 AS DATE)
AND STATUS_CD = 'ERR'

ID IN (1137159, 1137162)



UPDATE OB
SET status_CD = 'PEND'

WHERE ID = '1137162'


