USE UniTrac

-----Error Status
SELECT R.NAME_TX,RH.*
	FROM REPORT_HISTORY rh 
	LEFT JOIN REPORT R ON R.id = RH.REPORT_ID
WHERE   RH.STATUS_CD = 'ERR' 
        AND CAST(RH.UPDATE_DT AS DATE) >= CAST(GETDATE() AS DATE)
		ORDER BY RH.MSG_LOG_TX DESC

	
----Pending
SELECT R.NAME_TX,RH.*
	FROM REPORT_HISTORY rh 
	JOIN REPORT R ON R.id = RH.REPORT_ID
	WHERE CAST(RH.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE) AND rh.STATUS_CD = 'PEND'
	ORDER BY CREATE_DT ASC  
 
 


-----Complete
 SELECT R.NAME_TX,RH.*
FROM    REPORT_HISTORY rh
	JOIN REPORT R ON R.id = RH.REPORT_ID
WHERE   STATUS_CD = 'COMP' 
		AND CAST(rh.UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
ORDER BY rh.UPDATE_DT DESC



---ProcessDefinition
SELECT  STATUS_CD ,* FROM dbo.PROCESS_DEFINITION
WHERE ID = '30'

--Process Log
SELECT TOP 10 * FROM dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '30'
ORDER BY UPDATE_DT DESC 






