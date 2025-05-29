USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UpdateEscrowTransmissionStatusCode]    Script Date: 3/16/2017 7:59:48 AM ******/
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

	DECLARE @currentLockId INT
	SET @currentLockId = 1

	DECLARE @rowCnt INT

	IF @lockId < 255
		SET @nextLockId = @lockId + 1

	UPDATE ESCROW
	SET	UPDATE_DT = @now
		,UPDATE_USER_TX = @UPDATE_USER_TX
		,LOCK_ID = @nextLockId
		,TRAN_STATUS_CD = @TRAN_STATUS_CD
	WHERE ID = @id
	AND LOCK_ID = @lockId

	SET @rowCnt = @@rowcount

	if @rowCnt = 0
	BEGIN
		SELECT @currentLockId = LOCK_ID
		FROM ESCROW
		WHERE ID = @id

		SET @nextLockId = (@currentLockId % 255) + 1

		UPDATE ESCROW
		SET	UPDATE_DT = @now
			,UPDATE_USER_TX = @UPDATE_USER_TX
			,LOCK_ID = @nextLockId
			,TRAN_STATUS_CD = @TRAN_STATUS_CD
		WHERE ID = @id
		AND LOCK_ID = @currentLockId

		SET @rowCnt = @@rowcount
	END


	SELECT
		@id
		,@nextLockId
		,@now
		,@rowCnt
END


GO

