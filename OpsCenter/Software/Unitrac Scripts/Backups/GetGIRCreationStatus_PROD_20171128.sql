USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[GetGIRCreationStatus]    Script Date: 11/28/2017 8:12:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetGIRCreationStatus]
(
	@requiredCoverageId   bigint
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @isctPendCount INT = 0
	DECLARE @ntcCompCount INT = 0
	DECLARE @girPendCount INT = 0
	DECLARE @groupId BIGINT
	DECLARE @createGIR CHAR(1) = 'N'
	DECLARE @isGIREnabled CHAR(1) = 'N'


	--Check if ESC is GIR enabled
	SELECT @isGIREnabled = esc.GIR_IN	
	FROM EVENT_SEQ_CONTAINER esc
		JOIN REQUIRED_COVERAGE rc ON rc.LAST_SEQ_CONTAINER_ID = esc.ID AND esc.PURGE_DT IS NULL
	WHERE rc.ID = @requiredCoverageId

	--Check if ISCT is pending
	IF @isGIREnabled = 'Y'
	BEGIN
		SELECT @groupId = GROUP_ID
		FROM EVALUATION_EVENT
		WHERE REQUIRED_COVERAGE_ID = @requiredCoverageId
		AND STATUS_CD = 'PEND'
		AND TYPE_CD = 'ISCT'
		AND PURGE_DT IS NULL
	
		--check if notice has been sent
		IF @groupId IS NOT NULL AND @groupId > 0
		BEGIN
			SELECT @ntcCompCount = COUNT(*)
			FROM EVALUATION_EVENT
			WHERE GROUP_ID = @groupId
			AND STATUS_CD = 'COMP'
			AND TYPE_CD = 'NTC'
			AND PURGE_DT IS NULL

			IF @ntcCompCount IS NOT NULL AND @ntcCompCount > 0
			BEGIN
				--Check if a GIR event exists. If exists, then do not create another one.
				SELECT @girPendCount = COUNT(*)
				FROM EVALUATION_EVENT
				WHERE GROUP_ID = @groupId
				AND STATUS_CD = 'PEND'
				AND TYPE_CD = 'GIR'
				AND PURGE_DT IS NULL

				IF @girPendCount IS NULL OR @girPendCount = 0
					SET @createGIR = 'Y'
			END
		END	
	END
	
	SELECT @createGIR GIR_IN, @groupId GROUP_ID

END


GO

