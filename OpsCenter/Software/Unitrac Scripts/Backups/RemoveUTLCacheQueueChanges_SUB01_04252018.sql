USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[RemoveUTLCacheQueueChanges]    Script Date: 4/25/2018 3:53:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RemoveUTLCacheQueueChanges]
	@guid UNIQUEIDENTIFIER = null
AS
BEGIN
	IF @guid IS NOT NULL
	BEGIN
		DECLARE @requestDt DATETIME

		SELECT @requestDt = REQUEST_DT
		FROM UTL_CACHE_CHANGE_REQUEST ccr
		WHERE ccr.GUID = @guid

		IF @requestDt IS NOT NULL
		BEGIN
			DELETE
			FROM UTL_CACHE_CHANGE_QUEUE
			WHERE CREATE_DT <= @requestDt

			SELECT @@ROWCOUNT AS DELETED; 
		END		
	END
END

GO

