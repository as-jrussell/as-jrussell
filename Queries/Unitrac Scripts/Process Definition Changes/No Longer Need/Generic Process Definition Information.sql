SELECT * FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('UTLIBREPRC','
UTLMTCHIB')
ORDER BY EXECUTION_FREQ_CD DESC, NAME_TX ASC 








SELECT * FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('MSGSRV')



