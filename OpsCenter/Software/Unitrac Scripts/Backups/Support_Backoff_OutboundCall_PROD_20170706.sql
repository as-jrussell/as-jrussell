USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Support_Backoff_OutboundCall]    Script Date: 7/6/2017 9:32:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec [Support_Backoff_OutboundCall] @workItemId=1660
CREATE PROCEDURE [dbo].[Support_Backoff_OutboundCall]
(
	@workItemId   bigint,
	@eeId bigint
)
AS
BEGIN
	 --Set the options to support indexed views.
  SET NUMERIC_ROUNDABORT OFF;
  SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
      QUOTED_IDENTIFIER, ANSI_NULLS ON;
  SET XACT_ABORT ON

	Declare @ihId bigint
	
	SELECT @ihId = RELATE_ID
	FROM WORK_ITEM
	WHERE ID = @workItemId
	
	UPDATE WORK_ITEM
	SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' ,
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	WHERE ID = @workItemId
	
	UPDATE INTERACTION_HISTORY
	SET PURGE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' ,
	UPDATE_DT = GETDATE() , LOCK_ID = (LOCK_ID % 255) + 1
	WHERE ID = @ihId
	   
	UPDATE EVALUATION_EVENT SET STATUS_CD = 'PEND' , 
	UPDATE_DT = GETDATE() , UPDATE_USER_TX = 'CYCBACKOFF' ,
	LOCK_ID = (LOCK_ID % 255) + 1
	WHERE ID = @eeId
	AND TYPE_CD = 'OBCL'
   
	
END

GO

