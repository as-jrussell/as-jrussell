USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[ArchivePropertyChange]    Script Date: 9/7/2021 3:30:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[ArchivePropertyChange] (@Batchsize AS INTEGER = NULL,
@createdateoffset INT = NULL,
@DoDELETE AS INTEGER = 0,
@process_log_id BIGINT = NULL OUTPUT)
AS
BEGIN
	SET NOCOUNT ON

	SET NUMERIC_ROUNDABORT OFF;
	SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
	QUOTED_IDENTIFIER, ANSI_NULLS ON;
	SET XACT_ABORT ON

	--Set deadlock priority low so this process is always the deadlock victim
	SET DEADLOCK_PRIORITY LOW

	DECLARE @Process_Definition_ID BIGINT
	DECLARE @now DATETIME = GETDATE()

	IF @Batchsize = 0
		SET @Batchsize = NULL

	IF @createdateoffset = 0
		SET @createdateoffset = NULL

	--- Get setting for parameters from PROCESS_DEFINITON if explicit values not provided
	---   to parameters
	SELECT
		@Process_Definition_ID = ID
	,	@Batchsize =
					CASE
						WHEN @Batchsize IS NULL THEN SETTINGS_XML_IM.value('(/Settings/@BatchSize)[1]', 'int')
						ELSE @Batchsize
					END
	,	@createdateoffset =
							CASE
								WHEN @createdateoffset IS NULL THEN SETTINGS_XML_IM.value('(/Settings/@CreateDateOffset)[1]', 'int')
								ELSE @createdateoffset
							END
	FROM PROCESS_DEFINITION
	WHERE PROCESS_TYPE_CD = 'PC_ARCHIVE'

	--PRINT 'Process Def ID: ' + CAST(@Process_Definition_ID AS VARCHAR(50)) 
	--PRINT 'Batch Size: ' + CAST(@Batchsize AS VARCHAR(50)) 
	--PRINT 'Created Date Offset: ' + CAST(@createdateoffset AS VARCHAR(50)) 


	INSERT PROCESS_LOG (PROCESS_DEFINITION_ID
					,	START_DT
					,	STATUS_CD
					,	MSG_TX
					,	CREATE_DT
					,	UPDATE_DT
					,	UPDATE_USER_TX
					,	LOCK_ID)
		VALUES
		(	@Process_Definition_ID
		,	@now
		,	N'InProcess'
		,	N'Property Change Archive. Batch Size: ' + CONVERT(NVARCHAR(20), @Batchsize)
		,	@now
		,	@now
		,	CONVERT(NVARCHAR(15), SUSER_SNAME())
		,	1)

	SELECT
		@process_log_id = SCOPE_IDENTITY()

	-- if ArchiveIH is already populated with unprocessed interactions, do not add rows to it
	-- resume processing the last, likely failed archive process
	IF NOT EXISTS (SELECT
				*
			FROM UniTracArchive.dbo.ArchivePC
			WHERE archiveflag = 0)
	BEGIN
		TRUNCATE TABLE UniTracArchive.dbo.ArchivePC

		INSERT INTO UniTracArchive.dbo.ArchivePC (ID, CreateDate, UpdateDate)
			SELECT
				pc.ID
				, GETDATE()
				, GETDATE()
			FROM PROPERTY_CHANGE pc
			WHERE pc.CREATE_DT < (GETDATE() - @createdateoffset)
			ORDER BY pc.ID
	END


	-----------------------------------------------------------------------------
	-----------------------------------------------------------------------------

	DECLARE	@rowcount BIGINT
		,	@Info_xml XML

	SELECT
		@rowcount = COUNT(*)
	FROM UniTracArchive.dbo.ArchivePC
	WHERE archiveflag = 0
	SELECT
		@Info_xml = '<INFO>' + CONVERT(VARCHAR(20), @rowcount) + ' PropertyChange rows to be archived</INFO>'

	-- perform the archive
	DECLARE	@rval INT = 0
		,	@RowsConverted INT = 0

	DECLARE @output TABLE (
		ID BIGINT
	)

	DECLARE	@errornum INT
		,	@errormsg NVARCHAR(255)
		,	@errorseverity INT
		,	@errorstate INT
		,	@errorline INT
		,	@Status_CD NVARCHAR(10)
		,	@MSG_TX NVARCHAR(4000)

	IF @DoDELETE > 0
	BEGIN




		INSERT INTO PROCESS_LOG_ITEM (	PROCESS_LOG_ID
									,	STATUS_CD
									,	INFO_XML
									,	CREATE_DT
									,	UPDATE_DT
									,	UPDATE_USER_TX
									,	LOCK_ID)
			VALUES
			(	@process_log_id
			,	'Info'
			,	@Info_xml
			,	GETDATE()
			,	GETDATE()
			,	CONVERT(NVARCHAR(15), SUSER_SNAME())
			,	1)

		--Get the ID of the interaction that was last archived
		SELECT
			@RowsConverted = @Batchsize

		--PRINT 'First Rows Converted : ' + CAST(@RowsConverted AS VARCHAR(50)) 
		--PRINT 'First LastId : ' + CAST(@LastID AS VARCHAR(50)) 

		WHILE @RowsConverted > 0
		BEGIN
		BEGIN TRY

			BEGIN TRANSACTION

			--PRINT 'LastId : ' + CAST(@LastID AS VARCHAR(50)) 

			--Insert the IDs of the interactions to be archived into a temp table variable in batches of 2000 by default			
			INSERT INTO @output (ID)
				SELECT TOP (@Batchsize)
					ID
				FROM UniTracArchive.dbo.ArchivePC ac
				WHERE archiveflag = 0
				ORDER BY ID

			--Change
			--PRINT 'Insert Into Property Change' 
			INSERT INTO UniTracArchive.dbo.PROPERTY_CHANGE (ID
														,	ENTITY_NAME_TX
														,	ENTITY_ID
														,	NOTE_TX
														,	TICKET_TX
														,	USER_TX
														,	ATTACHMENT_IN
														,	CREATE_DT
														,	AGENCY_ID
														,	DESCRIPTION_TX
														,	DETAILS_IN
														,	FORMATTED_IN
														,	LOCK_ID
														,	PARENT_NAME_TX
														,	PARENT_ID
														,	TRANS_STATUS_CD
														,	TRANS_STATUS_DT
														,	UTL_IN
														,	SUPPORT_TRIGGER_IN)
				SELECT
					pc.ID
				,	pc.ENTITY_NAME_TX
				,	pc.ENTITY_ID
				,	pc.NOTE_TX
				,	pc.TICKET_TX
				,	pc.USER_TX
				,	pc.ATTACHMENT_IN
				,	pc.CREATE_DT
				,	pc.AGENCY_ID
				,	pc.DESCRIPTION_TX
				,	pc.DETAILS_IN
				,	pc.FORMATTED_IN
				,	pc.LOCK_ID
				,	pc.PARENT_NAME_TX
				,	pc.PARENT_ID
				,	pc.TRANS_STATUS_CD
				,	pc.TRANS_STATUS_DT
				,	pc.UTL_IN
				,	pc.SUPPORT_TRIGGER_IN
				FROM PROPERTY_CHANGE pc
				WHERE ID IN (SELECT
							ID
						FROM @output)


			--PRINT 'Insert Into Property Change Update'
			--Change Update
			INSERT INTO UniTracArchive.dbo.PROPERTY_CHANGE_UPDATE (	CHANGE_ID
																,	TABLE_NAME_TX
																,	TABLE_ID
																,	QUALIFIER_TX
																,	COLUMN_NM
																,	FROM_VALUE_TX
																,	TO_VALUE_TX
																,	DATATYPE_NO
																,	CREATE_DT
																,	AREA_TX
																,	FORMAT_FROM_VALUE_TX
																,	FORMAT_TO_VALUE_TX
																,	DISPLAY_IN
																,	OPERATION_CD)
				SELECT
					pcu.CHANGE_ID
				,	pcu.TABLE_NAME_TX
				,	pcu.TABLE_ID
				,	pcu.QUALIFIER_TX
				,	pcu.COLUMN_NM
				,	pcu.FROM_VALUE_TX
				,	pcu.TO_VALUE_TX
				,	pcu.DATATYPE_NO
				,	pcu.CREATE_DT
				,	pcu.AREA_TX
				,	pcu.FORMAT_FROM_VALUE_TX
				,	pcu.FORMAT_TO_VALUE_TX
				,	pcu.DISPLAY_IN
				,	pcu.OPERATION_CD
				FROM PROPERTY_CHANGE_UPDATE pcu
				WHERE CHANGE_ID IN (SELECT
							ID
						FROM @output)

			--Delete Change Update
			DELETE FROM PROPERTY_CHANGE_UPDATE
			WHERE CHANGE_ID IN (SELECT
						ID
					FROM @output)

			--Delete Change
			DELETE FROM PROPERTY_CHANGE
			WHERE ID IN (SELECT
						ID
					FROM @output)

			--Update the archive tracking table to reflect the completed status.
			UPDATE UniTracArchive.[dbo].ArchivePC
			SET archiveflag = 1
			, UpdateDate = GETDATE()
			WHERE ID IN (SELECT
					ID
				FROM @output)

			SET	@RowsConverted = @@rowcount

			DELETE FROM @output

			SET @rval = 0

			COMMIT TRANSACTION

		END TRY
		BEGIN CATCH

			ROLLBACK TRANSACTION
			SET @rval = 1

			SELECT
				@errornum = ERROR_NUMBER()
			,	@errormsg = ERROR_MESSAGE()
			,	@errorseverity = ERROR_SEVERITY()
			,	@errorstate = ERROR_STATE()
			,	@errorline = ERROR_LINE()

			RAISERROR (@errormsg, @errorseverity, @errorstate) WITH LOG
		END CATCH

		END
	END

	IF @rval = (1)
	BEGIN
		SELECT
			@Status_CD = 'Error'
		,	@MSG_TX = 'ERROR ' + CONVERT(NVARCHAR(20), @errornum)
			+ ' OCCURED Archiving For Property Change'
			+ ' at line: ' + CONVERT(VARCHAR(20), @errorline) + ':'
			+ CHAR(10) + @errormsg
	END
	ELSE
	BEGIN
		SELECT
			@Status_CD = 'Complete'
	END

	SET @now = GETDATE()

	UPDATE PROCESS_LOG
	SET	END_DT = @now
	,	STATUS_CD = @Status_CD
	,	UPDATE_DT = @now
	,	MSG_TX = @MSG_TX
	WHERE ID = @process_log_id

	RETURN @rval

END
GO


