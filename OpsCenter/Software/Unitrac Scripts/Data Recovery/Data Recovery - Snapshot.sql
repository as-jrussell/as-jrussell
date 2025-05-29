
--Run backup on snapshot datbase
SELECT * 
INTO jcs..processdefinition_2016xxxxxx
FROM dbo.PROCESS_DEFINITION
WHERE ACTIVE_IN = 'Y'
AND ONHOLD_IN = 'N'