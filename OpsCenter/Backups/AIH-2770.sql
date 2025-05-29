USE [master]
GO
CREATE LOGIN [ELDREDGE_A\''] FROM WINDOWS WITH DEFAULT_DATABASE=[UIPath]
GO

USE [UIPath]

CREATE USER [ELDREDGE_A\''] FOR LOGIN [ELDREDGE_A\''];

/* Create App Role */
CREATE ROLE [UIPath_APP_ACCESS] AUTHORIZATION [dbo];

/* Add object and permissions to role */
GRANT SELECT ON [dbo].[QueueDefinitions]  TO [UIPath_APP_ACCESS];
GRANT SELECT ON [dbo].[QueueItems]  TO [UIPath_APP_ACCESS];

/* Add members to new role */
ALTER ROLE [UIPath_APP_ACCESS] ADD MEMBER [ELDREDGE_A\''];

/*

USE [master]
GO

/****** Object:  Login [ELDREDGE_A\'']    Script Date: 5/11/2021 4:20:09 PM ******/
DROP LOGIN [ELDREDGE_A\'']
GO



USE [UIPath]
GO
ALTER ROLE [UIPath_APP_ACCESS] DROP MEMBER [ELDREDGE_A\'']
GO

DROP ROLE [UIPath_APP_ACCESS]


DROP USER [ELDREDGE_A\'']
*/

