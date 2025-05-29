IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProcessLogItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProcessLogItems]
GO

CREATE PROCEDURE [dbo].[GetProcessLogItems]
(
	@id   bigint = null,
	@processLogId	bigint = null,
	@evaluationEventId	bigint = null,
	@relateTypeCd	nvarchar(50) = null,
	@relateId bigint = null,
	@relateTypeCd2	nvarchar(50) = null, 
	@searchText nvarchar(4000) = null
)
WITH RECOMPILE
AS
BEGIN
   SET NOCOUNT ON
   if @id = 0
      set @id = null
   if @processLogId = 0
      set @processLogId = null
   if @evaluationEventId = 0
      set @evaluationEventId = null
   if @relateTypeCd = ''
      set @relateTypeCd = null            
   
	IF @id is not null
	BEGIN
	   SELECT
		  ID,
		  PROCESS_LOG_ID,
		  STATUS_CD,
		  LOCK_ID,
		  INFO_XML,
		  EVALUATION_EVENT_ID,
		  RELATE_ID,
		  RELATE_TYPE_CD,
		  '' AS SEARCH_TX
	   FROM PROCESS_LOG_ITEM
	   WHERE
		  ID = @id
	END
	ELSE IF @evaluationEventId IS NOT NULL AND @relateTypeCd IS NOT NULL
	BEGIN
	   SELECT
		  ID,
		  PROCESS_LOG_ID,
		  STATUS_CD,
		  LOCK_ID,
		  INFO_XML,
		  EVALUATION_EVENT_ID,
		  RELATE_ID,
		  RELATE_TYPE_CD,
		  '' AS SEARCH_TX
	   FROM PROCESS_LOG_ITEM
	   WHERE
		  EVALUATION_EVENT_ID = @evaluationEventId
		  AND RELATE_TYPE_CD = @relateTypeCd
		  AND PURGE_DT IS NULL
	END
	ELSE IF @processLogId IS NOT NULL AND @relateTypeCd IS NOT NULL
	BEGIN
	   SELECT
		  ID,
		  PROCESS_LOG_ID,
		  STATUS_CD,
		  LOCK_ID,
		  INFO_XML,
		  EVALUATION_EVENT_ID,
		  RELATE_ID,
		  RELATE_TYPE_CD,
		  '' AS SEARCH_TX
	   FROM PROCESS_LOG_ITEM
	   WHERE
		  PROCESS_LOG_ID = @processLogId
		  AND RELATE_TYPE_CD = @relateTypeCd
		  AND PURGE_DT IS NULL
	END					
   ELSE IF @relateId IS NOT NULL AND @relateTypeCd IS NOT NULL and @relateTypeCd2 IS NULL 
	BEGIN
	   SELECT
		  ID,
		  PROCESS_LOG_ID,
		  STATUS_CD,
		  LOCK_ID,
		  INFO_XML,
		  EVALUATION_EVENT_ID,
		  RELATE_ID,
		  RELATE_TYPE_CD,
		  '' AS SEARCH_TX
	   FROM PROCESS_LOG_ITEM
	   WHERE
		  RELATE_ID = @relateId
		  AND RELATE_TYPE_CD = @relateTypeCd
		  AND PURGE_DT IS NULL
	END
	ELSE IF @relateId IS NOT NULL AND @relateTypeCd IS NOT NULL and @relateTypeCd2 IS NOT NULL
	BEGIN
	   SELECT
		  ID,
		  PROCESS_LOG_ID,
		  STATUS_CD,
		  LOCK_ID,
		  INFO_XML,
		  EVALUATION_EVENT_ID,
		  RELATE_ID,
		  RELATE_TYPE_CD,
		  '' AS SEARCH_TX
	   FROM PROCESS_LOG_ITEM
	   WHERE ID in(
			SELECT DISTINCT pli2.ID
			FROM 
			PROCESS_LOG_ITEM pli1
			INNER JOIN PROCESS_LOG_ITEM pli2 on pli2.PROCESS_LOG_ID = pli1.PROCESS_LOG_ID 
				AND pli2.RELATE_TYPE_CD = @relateTypeCd2
			WHERE
			pli1.RELATE_ID = @relateId
			AND pli1.RELATE_TYPE_CD = @relateTypeCd)
			AND PURGE_DT IS NULL
	END
	ELSE IF @processLogId IS NOT NULL
	BEGIN
	   SELECT
		  ID,
		  PROCESS_LOG_ID,
		  STATUS_CD,
		  LOCK_ID,
		  INFO_XML,
		  EVALUATION_EVENT_ID,
		  RELATE_ID,
		  RELATE_TYPE_CD,
		  '' AS SEARCH_TX
	   FROM PROCESS_LOG_ITEM
	   WHERE
		  PROCESS_LOG_ID = @processLogId
		  AND PURGE_DT IS NULL
	END
	ELSE IF @evaluationEventId IS NOT NULL
	BEGIN
	   SELECT
		  ID,
		  PROCESS_LOG_ID,
		  STATUS_CD,
		  LOCK_ID,
		  INFO_XML,
		  EVALUATION_EVENT_ID,
		  RELATE_ID,
		  RELATE_TYPE_CD,
		  '' AS SEARCH_TX
	   FROM PROCESS_LOG_ITEM
	   WHERE
		  EVALUATION_EVENT_ID = @evaluationEventId
		  AND PURGE_DT IS NULL
	END						
END
GO