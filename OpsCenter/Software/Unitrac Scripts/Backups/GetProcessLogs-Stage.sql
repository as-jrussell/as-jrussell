USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetProcessLogs]    Script Date: 3/23/2016 2:20:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetProcessLogs]
(
	@id   BIGINT = NULL,
	@processDefinitionId BIGINT = NULL,
	@fromDate DATETIME2 = NULL,
   @mostRecentLogs CHAR(1) = 'N'
)
AS
BEGIN
   SET NOCOUNT ON
   IF @id = 0
      SET @id = NULL
   IF @processDefinitionId = 0
	  SET @processDefinitionId = NULL
   
   IF @id IS NOT NULL   	  
	   SELECT
		  ID,
		  PROCESS_DEFINITION_ID,
		  START_DT,
		  LOCK_ID,
		  END_DT,
		  STATUS_CD,
		  MSG_TX
	   FROM PROCESS_LOG
	   WHERE
		  ID = @id
   ELSE IF @processDefinitionId IS NOT NULL AND @mostRecentLogs = 'Y'
	   SELECT TOP 20
		  ID,
		  PROCESS_DEFINITION_ID,
		  START_DT,
		  LOCK_ID,
		  END_DT,
		  STATUS_CD,
		  MSG_TX
	   FROM PROCESS_LOG
	   WHERE PROCESS_DEFINITION_ID = @processDefinitionId	
	   AND PURGE_DT IS NULL
      ORDER BY id DESC
	ELSE IF @processDefinitionId IS NOT NULL AND @fromDate IS NULL
	   SELECT
		  ID,
		  PROCESS_DEFINITION_ID,
		  START_DT,
		  LOCK_ID,
		  END_DT,
		  STATUS_CD,
		  MSG_TX
	   FROM PROCESS_LOG
	   WHERE PROCESS_DEFINITION_ID = @processDefinitionId	
	   AND PURGE_DT IS NULL
	ELSE IF @processDefinitionId IS NOT NULL AND @fromDate IS NOT NULL
	   SELECT
		  ID,
		  PROCESS_DEFINITION_ID,
		  START_DT,
		  LOCK_ID,
		  END_DT,
		  STATUS_CD,
		  MSG_TX
	   FROM PROCESS_LOG
	   WHERE PROCESS_DEFINITION_ID = @processDefinitionId
	   AND CREATE_DT >= @fromDate
	   AND PURGE_DT IS NULL
	   ORDER BY CREATE_DT ASC
END

GO


