USE [OspreyDashboard]
GO

/****** Object:  StoredProcedure [dbo].[SaveDatasourceCache]    Script Date: 12/21/2016 2:46:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveDatasourceCache](
      @ID bigint,
      @DATASOURCE_ID bigint,
      @UPDATE_USER_TX nvarchar(50),
      @lockId tinyint,
      @purge char(1) = null,
      @RECORD_DATE datetime = null,
      @RECORD_YEAR int = null,
      @RECORD_MONTH int = null,
      @RECORD_DAY int = null,
      @ASSOCIATION_CD nvarchar(100) = null,
      @ASSOCATION_NAME_TX nvarchar(100) = null,
      @COUNT_NO bigint = null,
      @AMOUNT_NO decimal = null,
      @TYPE_CD nvarchar(100) = null,
      @SOURCE_CD nvarchar(100) = null,
      @RESULT_CD nvarchar(100) = null,
      @STATUS_CD nvarchar(100) = null
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

   if(@RECORD_DAY = 0)
    SET @RECORD_DAY = NULL

   if(@RECORD_YEAR = 0)
    SET @RECORD_YEAR = NULL

   if(@RECORD_MONTH = 0)
    SET @RECORD_MONTH = NULL

   if @ID = 0
   begin
      INSERT INTO DATASOURCE_CACHE
      (
      DATASOURCE_ID,
      CREATE_DT,
      UPDATE_DT,
      UPDATE_USER_TX,
      LOCK_ID,
      RECORD_DATE,
      RECORD_YEAR,
      RECORD_MONTH,
      RECORD_DAY,
      ASSOCIATION_CD,
      ASSOCATION_NAME_TX,
      COUNT_NO,
      AMOUNT_NO,
      TYPE_CD,
      SOURCE_CD,
      RESULT_CD,
      STATUS_CD
      )
      values
      (
      @DATASOURCE_ID,
      @now,
      @now,
      @UPDATE_USER_TX,
      @nextLockId,
      @RECORD_DATE,
      @RECORD_YEAR,
      @RECORD_MONTH,
      @RECORD_DAY,
      @ASSOCIATION_CD,
      @ASSOCATION_NAME_TX,
      @COUNT_NO,
      @AMOUNT_NO,
      @TYPE_CD,
      @SOURCE_CD,
      @RESULT_CD,
      @STATUS_CD
      )
      set @id = SCOPE_IDENTITY()
   end
   else
   begin
      if @lockId < 255
         set @nextLockId = @lockId +1

      UPDATE DATASOURCE_CACHE 
      set
      DATASOURCE_ID = @DATASOURCE_ID,
      UPDATE_DT = @now,
      UPDATE_USER_TX = @UPDATE_USER_TX,
      LOCK_ID = @nextLockId,
      PURGE_DT = @purgeDate,
      RECORD_DATE = @RECORD_DATE,
      RECORD_YEAR = @RECORD_YEAR,
      RECORD_MONTH = @RECORD_MONTH,
      RECORD_DAY = @RECORD_DAY,
      ASSOCIATION_CD = @ASSOCIATION_CD,
      ASSOCATION_NAME_TX = @ASSOCATION_NAME_TX,
      COUNT_NO = @COUNT_NO,
      AMOUNT_NO = @AMOUNT_NO,
      TYPE_CD = @TYPE_CD,
      SOURCE_CD = @SOURCE_CD,
      RESULT_CD = @RESULT_CD,
      STATUS_CD = @STATUS_CD
      WHERE ID = @ID AND LOCK_ID = @lockId
   end

   select @id, @nextLockId, @now, @@ROWCOUNT
END
GO

