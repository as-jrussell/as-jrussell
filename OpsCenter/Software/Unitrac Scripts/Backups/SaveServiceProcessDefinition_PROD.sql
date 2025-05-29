USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[SaveServiceProcessDefinition]    Script Date: 5/26/2016 5:03:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SaveServiceProcessDefinition](
      @ID bigint,
      @STATUS_CD nvarchar(10),
      @LAST_SCHEDULED_DT datetime,
      @LAST_RUN_DT datetime,
      @USE_LAST_SCHEDULED_DT_IN	char,
      @OVERRIDE_DT datetime,
	  @SETTINGS_XML_IM xml,
      @UPDATE_USER_TX nvarchar(15)
)
AS
BEGIN
   SET NOCOUNT ON
   declare @now datetime
   declare @lockId numeric
   set @now = getdate()
	
   if @id = 0
		return
		
   UPDATE PROCESS_DEFINITION 
   SET
	   STATUS_CD = @STATUS_CD,
	   LAST_SCHEDULED_DT = ISNULL(@LAST_SCHEDULED_DT,LAST_SCHEDULED_DT),
	   LAST_RUN_DT = @LAST_RUN_DT,
	   USE_LAST_SCHEDULED_DT_IN = @USE_LAST_SCHEDULED_DT_IN,
	   OVERRIDE_DT = @OVERRIDE_DT,
	   SETTINGS_XML_IM = @SETTINGS_XML_IM,
	   UPDATE_DT = @now,
	   UPDATE_USER_TX = @UPDATE_USER_TX
   WHERE ID = @ID
   
   SELECT @lockId = LOCK_ID FROM PROCESS_DEFINITION WHERE ID = @ID
   
   select @id, @lockId, @now, @@ROWCOUNT
   
END

GO

