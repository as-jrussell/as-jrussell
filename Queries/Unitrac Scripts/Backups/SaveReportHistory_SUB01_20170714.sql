USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[SaveReportHistory]    Script Date: 7/14/2017 4:15:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SaveReportHistory](
      @ID bigint,
      @REPORT_ID bigint = null,
      @DOCUMENT_CONTAINER_ID bigint = null,
      @REPORT_DATA_XML xml = null,
      @STATUS_CD varchar(30) = null,
      @GENERATION_SOURCE_CD varchar(1) = null,
      @REPORT_PATH_TX varchar(100) = null,
      @RECORD_COUNT_NO bigint = null,
      @ELAPSED_RUNTIME_NO bigint = null,
      @CREATED_BY_TX varchar(30) = null,
      @UPDATE_USER_TX varchar(30) = null,
      @purge char(1) = null,
      @lockId tinyint,
      @AGENCY_ID bigint,
	  @RETRY_COUNT_NO int,
	  @WEB_PUBLISH_STATUS_CD char(2) = null,
	  @PRINT_REPORT_STATUS_CD nvarchar(10) = null,
	  @OUTPUT_TYPE_CD nvarchar(10) = null,
	  @RETAIN_GROUP_IN char(1) = null,
      @MSG_LOG_TX varchar(max) = null,
      @LENDER_ID bigint = null
)
AS
BEGIN
   SET NOCOUNT ON
   declare @now datetime
   set @now = getdate()

   declare @purgeDate datetime
   if @purge = 'Y'
      set @purgeDate = @now

   declare @nextLockId int
   set @nextLockId = 1

   if @id = 0
   begin
      INSERT INTO REPORT_HISTORY
      (
      REPORT_ID,
      DOCUMENT_CONTAINER_ID,
      REPORT_DATA_XML,
      STATUS_CD,
      GENERATION_SOURCE_CD,
      REPORT_PATH_TX,
      RECORD_COUNT_NO,
      ELAPSED_RUNTIME_NO,
      CREATED_BY_TX,
      CREATE_DT,
      UPDATE_DT,
      UPDATE_USER_TX,
      LOCK_ID,
      AGENCY_ID,
	  RETRY_COUNT_NO,
	  WEB_PUBLISH_STATUS_CD,
	  PRINT_REPORT_STATUS_CD,
	  OUTPUT_TYPE_CD,
	  RETAIN_GROUP_IN,
      MSG_LOG_TX,
      LENDER_ID
      )
      values
      (
      @REPORT_ID,
      @DOCUMENT_CONTAINER_ID,
      @REPORT_DATA_XML,
      @STATUS_CD,
      @GENERATION_SOURCE_CD,
      @REPORT_PATH_TX,
      @RECORD_COUNT_NO,
      @ELAPSED_RUNTIME_NO,
      @CREATED_BY_TX,
      @now,
      @now,
      @UPDATE_USER_TX,
      @nextLockId,
      @AGENCY_ID,
	  @RETRY_COUNT_NO,
	  @WEB_PUBLISH_STATUS_CD,
	  @PRINT_REPORT_STATUS_CD,
	  @OUTPUT_TYPE_CD,
	  @RETAIN_GROUP_IN,
      @MSG_LOG_TX,
      @LENDER_ID
      )
      set @id = SCOPE_IDENTITY()
   end
   else
   begin
      if @lockId < 255
         set @nextLockId = @lockId +1

      UPDATE REPORT_HISTORY 
      set
      REPORT_ID = @REPORT_ID,
      DOCUMENT_CONTAINER_ID = @DOCUMENT_CONTAINER_ID,
      REPORT_DATA_XML = @REPORT_DATA_XML,
      STATUS_CD = @STATUS_CD,
      GENERATION_SOURCE_CD = @GENERATION_SOURCE_CD,
      REPORT_PATH_TX = @REPORT_PATH_TX,
      --RECORD_COUNT_NO = @RECORD_COUNT_NO,
      ELAPSED_RUNTIME_NO = @ELAPSED_RUNTIME_NO,
      CREATED_BY_TX = @CREATED_BY_TX,
      UPDATE_DT = @now,
      UPDATE_USER_TX = @UPDATE_USER_TX,
      PURGE_DT = @purgeDate,
      LOCK_ID = @nextLockId,
      AGENCY_ID = @AGENCY_ID,
	  RETRY_COUNT_NO = @RETRY_COUNT_NO,
	  WEB_PUBLISH_STATUS_CD=@WEB_PUBLISH_STATUS_CD,
	  PRINT_REPORT_STATUS_CD=@PRINT_REPORT_STATUS_CD,
	  OUTPUT_TYPE_CD = @OUTPUT_TYPE_CD,
	  RETAIN_GROUP_IN = @RETAIN_GROUP_IN,
      MSG_LOG_TX = @MSG_LOG_TX,
      LENDER_ID = @LENDER_ID
      WHERE ID = @ID AND LOCK_ID = @lockId
   end

   select @id, @nextLockId, @now, @@ROWCOUNT
END
