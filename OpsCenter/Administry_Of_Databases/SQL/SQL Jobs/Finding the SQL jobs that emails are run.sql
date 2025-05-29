USE [msdb]
GO

SET NOCOUNT ON;

--SELECT 'SQL Agent job(s) with notification operator found:' AS [Message]

SELECT j.[name] AS [SQL jobs with notification]
FROM [dbo].[sysjobs] j
LEFT JOIN [dbo].[sysoperators] o ON (j.[notify_email_operator_id] = o.[id])
WHERE j.[enabled] = 1
	--AND j.[notify_level_email] IN (1, 2, 3)
GO



USE [msdb]
GO

SET NOCOUNT ON;

--SELECT 'SQL Agent job(s) with notification operator found:' AS [Message]

SELECT j.[name] AS [SQL jobs without notification]
FROM [dbo].[sysjobs] j
LEFT JOIN [dbo].[sysoperators] o ON (j.[notify_email_operator_id] = o.[id])
WHERE j.[enabled] = 0
	--AND j.[notify_level_email] IN (1, 2, 3)
GO