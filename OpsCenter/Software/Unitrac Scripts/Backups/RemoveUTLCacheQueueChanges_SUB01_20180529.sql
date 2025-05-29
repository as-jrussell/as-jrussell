USE [Unitrac_Reports]
GO

/****** Object:  StoredProcedure [dbo].[RemoveUTLCacheQueueChanges]    Script Date: 5/29/2018 6:14:15 PM ******/
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
		DECLARE @requestDt DATETIME, @lastId BIGINT = 0

		SELECT @requestDt = REQUEST_DT
		FROM UTL_CACHE_CHANGE_REQUEST ccr
		WHERE ccr.GUID = @guid

		IF EXISTS(SELECT 'X' FROM REF_CODE WHERE DOMAIN_CD = 'System' AND CODE_CD = 'UTLSyncLastId')
			SELECT @lastId = MEANING_TX FROM REF_CODE WHERE CODE_CD = 'UTLSyncLastId' AND DOMAIN_CD = 'System'

		IF @requestDt IS NOT NULL
		BEGIN
			DELETE
			FROM UTL_CACHE_CHANGE_QUEUE
			WHERE CREATE_DT <= @requestDt AND ID <= @lastId

			SELECT @@ROWCOUNT AS DELETED; 
		END		
	END
END

GO

