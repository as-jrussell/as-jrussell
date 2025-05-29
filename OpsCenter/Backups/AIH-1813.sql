USE [master]
GO
CREATE LOGIN [ELDREDGE_A\EccdbAppIntegration] FROM WINDOWS WITH DEFAULT_DATABASE=[BOND_MAIN]
GO

USE BOND_MAIN

CREATE USER [ELDREDGE_A\EccdbAppIntegration] FOR LOGIN [ELDREDGE_A\EccdbAppIntegration];

/* Create App Role */
CREATE ROLE [ETL_SERVICE_ACCESS] AUTHORIZATION [dbo];

/* Add object and permissions to role */
GRANT SELECT ON [dbo].[''] TO [ETL_SERVICE_ACCESS];

/* Add members to new role */
ALTER ROLE [ETL_SERVICE_ACCESS] ADD MEMBER [ELDREDGE_A\EccdbAppIntegration];

/*

USE [master]
GO

/****** Object:  Login [ELDREDGE_A\EccdbAppIntegration]    Script Date: 5/11/2021 4:20:09 PM ******/
DROP LOGIN [ELDREDGE_A\EccdbAppIntegration]
GO



USE [BOND_MAIN]
GO
ALTER ROLE [ETL_SERVICE_ACCESS] DROP MEMBER [ELDREDGE_A\EccdbAppIntegration]
GO

DROP ROLE [ETL_SERVICE_ACCESS]


DROP USER [ELDREDGE_A\EccdbAppIntegration]
*/

