-------- Check for Process Definitions With Status Code Equal To Error
SELECT * FROM UniTrac..PROCESS_DEFINITION
WHERE --STATUS_CD = 'Error'
ID IN (20534)