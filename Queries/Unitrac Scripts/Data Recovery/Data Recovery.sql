USE UniTrac

/*
PRIOR TO SERVER/DB COMING BACK UP TURN OFF ALL THE SERVICES

Check the select with approrpiate times frames below once that is complete
the temp table can be ran (no need to uncomment just start highlight the 
"SELECT ID INTO #tmpPD" on down until you reach the end of the query.
*/
SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
        CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
        *
--SELECT ID INTO #tmpPD
FROM    PROCESS_DEFINITION 
WHERE   CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATE) <> '0001-01-01'
        AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                       'varchar(50)') AS DATETIME) >= 'XXXX-XX-XX XX:00:00'
        AND CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                       'varchar(50)') AS DATETIME) <= 'XXXX-XX-XX XX:00:00'
        AND ONHOLD_IN = 'N'
        AND ACTIVE_IN = 'Y'
		AND PROCESS_TYPE_CD IN ('CYCLEPRC', 'BILLING')


/*
This will place all of the process defnitions on hold to allow the business decide what is
important to run while leaving dates outside of that time frame from being altered
*/



UPDATE PD
SET ONHOLD_IN= 'Y'
FROM dbo.PROCESS_DEFINITION PD
WHERE ID IN (SELECT * FROM #tmpPD)



/*
Backup those that are going to updated
*/

SELECT * 
INTO UniTracHDStorage..[ProcessDefinitionBackupxxxxxxxx]
FROM #tmpPD



/*
Taking on off hold and change the anticipated run date
*/


UPDATE PD
set ONHOLD_IN= 'Y',
SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/AnticipatedNextScheduledDate/text())[1] with "2016-12-16 01:45:00.000"'),  
LOCK_ID=LOCK_ID+1
--SELECT *
FROM dbo.PROCESS_DEFINITION PD
WHERE pd.id in (SELECT * FROM #tmpPD)




/*
Verification
*/

SELECT  SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                              'nvarchar(max)') [Target Service] ,
        CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                   'varchar(50)') AS DATETIME) [Anticipated Scheduled Date] ,
        *
--SELECT ID INTO #tmpPD
FROM    PROCESS_DEFINITION 
WHERE   ID IN (SELECT * FROM #tmpPD)