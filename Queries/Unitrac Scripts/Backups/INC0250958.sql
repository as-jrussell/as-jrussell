USE UniTrac

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE DESCRIPTION_TX LIKE '%1868%'


UPDATE dbo.PROCESS_DEFINITION
SET ACTIVE_IN = 'N', ONHOLD_IN = 'Y', UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0250958'
--SELECT * FROM dbo.PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD = 'CYCLEPRC'
AND DESCRIPTION_TX LIKE '%1868%'