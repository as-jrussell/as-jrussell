USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UpdateEscrowTransmissionStatusCode]    Script Date: 3/16/2017 4:54:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateEscrowTransmissionStatusCode] (@id BIGINT,
@UPDATE_USER_TX NVARCHAR(15),
@lockId TINYINT,
@TRAN_STATUS_CD NVARCHAR(10) = 'DNS')
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @now DATETIME
	SET @now = GETDATE()

	DECLARE @nextLockId INT
	SET @nextLockId = 1

	IF @lockId < 255
		SET @nextLockId = @lockId + 1

	UPDATE ESCROW
	SET	UPDATE_DT = @now
		,UPDATE_USER_TX = @UPDATE_USER_TX
		,LOCK_ID = @nextLockId
		,TRAN_STATUS_CD = @TRAN_STATUS_CD
	WHERE ID = @id
	AND LOCK_ID = @lockId

	SELECT
		@id
		,@nextLockId
		,@now
		,@@rowcount
END


GO


