USE [OspreyDashboard]
GO

/****** Object:  StoredProcedure [dbo].[PurgeDataSourceCache]    Script Date: 3/14/2016 3:57:21 PM ******/
DROP PROCEDURE [dbo].[PurgeDataSourceCache]
GO

/****** Object:  StoredProcedure [dbo].[PurgeDataSourceCache]    Script Date: 3/14/2016 3:57:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PurgeDataSourceCache]
	@datasourceId bigint
AS
BEGIN

UPDATE DATASOURCE_CACHE
SET PURGE_DT = GETDATE()
, UPDATE_DT = GETDATE()
, LOCK_ID = CASE  
              	WHEN LOCK_ID = 255 THEN 1
              	ELSE LOCK_ID + 1
              END
WHERE DATASOURCE_ID = @datasourceId
AND PURGE_DT IS NULL

END

GO

