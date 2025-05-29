USE [UiPathInsights]
GO
/****** Object:  View [dbo].[vwQueueItemsDigest]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                CREATE VIEW [dbo].[vwQueueItemsDigest]
                    WITH SCHEMABINDING
                    AS  
                    SELECT 
                    TenantId, QueueName, OrganizationUnitId, COUNT_BIG(*) AS Cnt,
                    SUM(CAST(CASE WHEN
                        [SpecificData] IS NOT NULL AND [SpecificData] LIKE '{"DynamicProperties":%' AND [SpecificData] != '{"DynamicProperties":{}}' OR
                        [AnalyticsData] IS NOT NULL AND [AnalyticsData] LIKE '{"DynamicProperties":%' AND [AnalyticsData] != '{"DynamicProperties":{}}' OR
                        [Output] IS NOT NULL AND [Output] LIKE '{"DynamicProperties":%' AND [Output] != '{"DynamicProperties":{}}'
                    THEN 1 ELSE 0 END AS BIGINT)) AS CntRowsWithCustomFields
                    FROM [dbo].[QueueItems]
                    GROUP BY TenantId, QueueName, OrganizationUnitId
            
GO
/****** Object:  View [dbo].[vwQueueGroupsUserDefined]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwQueueGroupsUserDefined] AS

-- == Notes on how to define queue groups ==
--
-- You may want to define groups to simplify the datamodel for queues which have similar schemas
-- or for performance reasons. Modifying this view allows you define groups of queues into a grouped table.  
-- We have provided a few examples below which may be helpful.
-- 
-- The expected schema output of this view is below in the empty (top 0) select statement.
-- it may be best to leave the following empty select statement there to enforce the correct schema 
-- by unioning in the following groups definitions.
-- 
-- Note: before placing a group into different cube (via a different template) be sure to create those cubes first with the TenantSetupTool

SELECT TOP 0 * FROM (SELECT 
CAST('' AS nvarchar(256)) AS GroupName, 
CAST('' AS nvarchar(256)) AS QueueName, 
CAST(0 AS int) AS TenantId, 
CAST('' AS nvarchar(256)) AS [Cube]
) AS t1

-- ==== Simple Group Example ==== 
--
-- In this example we define only a single simple group.
-- The two queues 'ContactsQueue' and 'FollowUpsQ' in Tenant 1 into the group named 'CMS'
-- 
UNION

SELECT TOP 0 'CMS' AS GroupName, QueueName, TenantId, '{TENANT}-Cube' AS [Cube]
FROM vwQueueItemsDigest 
WHERE TenantId = 1 AND QueueName IN ('ContactsQueue', 'FollowupsQ')

-- ==== Naming Scheme Example ==== 
--
--  This definitions allows us to define a pattern for creating groups.
--  This naming scheme would match 2 or 3 Letters '_' and 3 numbers. 
--  As an example queues FIN_123_QueueInvoices, FIN_123_QueueWorkflows, HR_567_QueueFTE, HR_567_QueuePT
--  Would be grouped into FIN_123 and HR_567 respectively.

UNION

SELECT TOP 0 LEFT(QueueName, 7) AS GroupName, QueueName, TenantId, '{TENANT}-Cube' AS [Cube]
FROM vwQueueItemsDigest 
WHERE QueueName LIKE '[A-Za-z][A-Za-z0-9][A-Za-z0-9]_[0-9][0-9][0-9]%'

UNION

SELECT TOP 0 LEFT(QueueName, 6) AS GroupName, QueueName, TenantId, '{TENANT}-Cube' AS [Cube]
FROM vwQueueItemsDigest 
WHERE QueueName LIKE '[A-Za-z][A-Za-z0-9]_[0-9][0-9][0-9]%'
GO
/****** Object:  View [dbo].[vwQueueGroupsToolDefined]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwQueueGroupsToolDefined] AS

-- == Notes on how to define queue groups ==
--
-- You may want to define groups to simplify the datamodel for queues which have similar schemas
-- or for performance reasons. Modifying this view allows you define groups of queues into a grouped table.  
-- We have provided a few examples below which may be helpful.
-- 
-- The expected schema output of this view is below in the empty (top 0) select statement.
-- it may be best to leave the following empty select statement there to enforce the correct schema 
-- by unioning in the following groups definitions.
-- 
-- Note: before placing a group into different cube (via a different template) be sure to create those cubes first with the TenantSetupTool

SELECT TOP 0 * FROM (SELECT 
CAST('' AS nvarchar(256)) AS GroupName, 
CAST('' AS nvarchar(256)) AS QueueName, 
CAST(0 AS int) AS TenantId, 
CAST('' AS nvarchar(256)) AS [Cube]
) AS t1
GO
/****** Object:  View [dbo].[vwQueueGroups]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwQueueGroups] AS
SELECT * FROM vwQueueGroupsUserDefined
UNION
SELECT * FROM vwQueueGroupsToolDefined
GO
/****** Object:  View [dbo].[vwRobotLogsDigest]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                CREATE VIEW [dbo].[vwRobotLogsDigest]
                WITH SCHEMABINDING
                AS
                SELECT
                    TenantId, ProcessName, OrganizationUnitId, COUNT_BIG(*) AS Cnt, SUM(CAST(CASE WHEN NumCustomFields > 0 THEN 1 ELSE 0 END AS BIGINT)) AS CntRowsWithCustomFields
                FROM [dbo].[RobotLogs]
                GROUP BY TenantId, ProcessName, OrganizationUnitId
            
GO
/****** Object:  View [dbo].[vwProcessGroupsUserDefined]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwProcessGroupsUserDefined] AS

-- == Notes on how to define queue groups ==
--
-- You may want to define groups to simplify the datamodel for queues which have similar schemas
-- or for performance reasons. Modifying this view allows you define groups of queues into a grouped table.  
-- We have provided a few examples below which may be helpful.
-- 
-- The expected schema output of this view is below in the empty (top 0) select statement.
-- it may be best to leave the following empty select statement there to enforce the correct schema 
-- by unioning in the following groups definitions.
-- 
-- Note: before placing a group into different cube (via a different template) be sure to create those cubes first with the TenantSetupTool

SELECT TOP 0 * FROM (SELECT 
CAST('' AS nvarchar(256)) AS GroupName, 
CAST('' AS nvarchar(256)) AS ProcessName, 
CAST(0 AS int) AS TenantId, 
CAST('' AS nvarchar(256)) AS [Cube]
) AS t1

-- ==== Simple Group Example ==== 
--
-- In this example we define only a single simple group.
-- The two queues 'ContactsQueue' and 'FollowUpsQ' in Tenant 1 into the group named 'CMS'
-- 
UNION

SELECT TOP 0 'CMS' AS GroupName, ProcessName, TenantId, '{TENANT}-Cube' AS [Cube]
FROM vwRobotLogsDigest 
WHERE TenantId = 1 AND ProcessName IN ('ContactsQueue', 'FollowupsQ')

-- ==== Naming Scheme Example ==== 
--
--  This definitions allows us to define a pattern for creating groups.
--  This naming scheme would match 2 or 3 Letters '_' and 3 numbers. 
--  As an example queues FIN_123_QueueInvoices, FIN_123_QueueWorkflows, HR_567_QueueFTE, HR_567_QueuePT
--  Would be grouped into FIN_123 and HR_567 respectively.

UNION

SELECT TOP 0 LEFT(ProcessName, 7) AS GroupName, ProcessName, TenantId, '{TENANT}-Cube' AS [Cube]
FROM vwRobotLogsDigest 
WHERE ProcessName LIKE '[A-Za-z][A-Za-z0-9][A-Za-z0-9]_[0-9][0-9][0-9]%'

UNION

SELECT TOP 0 LEFT(ProcessName, 6) AS GroupName, ProcessName, TenantId, '{TENANT}-Cube' AS [Cube]
FROM vwRobotLogsDigest
WHERE ProcessName LIKE '[A-Za-z][A-Za-z0-9]_[0-9][0-9][0-9]%'
GO
/****** Object:  View [dbo].[vwProcessGroupsToolDefined]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwProcessGroupsToolDefined] AS

-- == Notes on how to define queue groups ==
--
-- You may want to define groups to simplify the datamodel for queues which have similar schemas
-- or for performance reasons. Modifying this view allows you define groups of queues into a grouped table.  
-- We have provided a few examples below which may be helpful.
-- 
-- The expected schema output of this view is below in the empty (top 0) select statement.
-- it may be best to leave the following empty select statement there to enforce the correct schema 
-- by unioning in the following groups definitions.
-- 
-- Note: before placing a group into different cube (via a different template) be sure to create those cubes first with the TenantSetupTool

SELECT TOP 0 * FROM (SELECT 
CAST('' AS nvarchar(256)) AS GroupName, 
CAST('' AS nvarchar(256)) AS ProcessName, 
CAST(0 AS int) AS TenantId, 
CAST('' AS nvarchar(256)) AS [Cube]
) AS t1
GO
/****** Object:  View [dbo].[vwProcessGroups]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwProcessGroups] AS
SELECT * FROM vwProcessGroupsUserDefined
UNION
SELECT * FROM vwProcessGroupsToolDefined
GO
/****** Object:  View [dbo].[vwPerProcessTables]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPerProcessTables] AS
SELECT 
    rDigest.TenantId,
    rDigest.ProcessName,
    rDigest.OrganizationUnitId,
    rDigest.CntRowsWithCustomFields
FROM
    [dbo].[vwRobotLogsDigest] AS rDigest
LEFT JOIN [dbo].[vwProcessGroups] AS groups 
    ON rDigest.ProcessName = groups.ProcessName 
	AND rDigest.TenantId = groups.TenantId
WHERE
    groups.ProcessName IS NULL
GO
/****** Object:  View [dbo].[vwPerQueueTables]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPerQueueTables] AS
SELECT 
	qDigest.TenantId,
	qDigest.QueueName,
	qDigest.OrganizationUnitId,
	qDigest.CntRowsWithCustomFields
FROM
	[dbo].[vwQueueItemsDigest] AS qDigest
LEFT JOIN [dbo].[vwQueueGroups] AS groups 
    ON qDigest.QueueName = groups.QueueName 
	AND qDigest.TenantId = groups.TenantId
WHERE
	groups.QueueName IS NULL
GO
/****** Object:  View [read].[METADATACUSTOMFIELDS]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                CREATE VIEW [read].[METADATACUSTOMFIELDS]
                AS
                SELECT
                    ID,
                    TENANTKEY,
		            METADATATYPE,
		            CUSTOMFIELDID ,
		            CUSTOMFIELDNAME,
		            CUSTOMFIELDVISIBILITY
                FROM dbo.METADATACUSTOMFIELDS;
            
GO
/****** Object:  View [read].[PROCESSMETADATA]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                CREATE VIEW [read].[PROCESSMETADATA]
                AS
                SELECT
                    ID,
                    TENANTKEY,
		            PROCESSNAME,
		            PROCESSTIMEINMINUTES,
		            COSTPERHOUR,
		            FIELD1VALUE,
		            FIELD2VALUE,
		            FIELD3VALUE,
		            FIELD4VALUE,
		            FIELD5VALUE,
		            FIELD6VALUE,
		            FIELD7VALUE,
		            FIELD8VALUE,
		            FIELD9VALUE,
		            FIELD10VALUE
                FROM dbo.PROCESSMETADATA;
            
GO
/****** Object:  View [read].[QUEUEMETADATA]    Script Date: 5/21/2024 9:25:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                CREATE VIEW [read].[QUEUEMETADATA]
                AS
                SELECT
                    ID,
                    TENANTKEY,
		            QUEUENAME,
		            QUEUETIMEINMINUTES,
		            COSTPERHOUR,
		            FIELD1VALUE,
		            FIELD2VALUE,
		            FIELD3VALUE,
		            FIELD4VALUE,
		            FIELD5VALUE,
		            FIELD6VALUE,
		            FIELD7VALUE,
		            FIELD8VALUE,
		            FIELD9VALUE,
		            FIELD10VALUE
                FROM dbo.QUEUEMETADATA;
            
GO
