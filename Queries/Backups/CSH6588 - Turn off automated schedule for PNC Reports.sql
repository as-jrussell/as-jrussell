USE PRL_PNC_6525_PROD

DECLARE	@currentUTCDate datetime = GETUTCDATE()
		, @changedRecords int = 0;
		
BEGIN TRANSACTION
SELECT	ID
		, SCHEDULED_IN
		, UPDATE_DT
		, UPDATE_USER_TX
		, LOCK_ID
INTO RFPLHDSTORAGE.dbo.RFPLHDSTORAGE_CSH6588 -- REPLACE WITH JIRA Service Ticket Number
FROM REPORT
WHERE ID IN (1,3);

SET	@changedRecords = @@ROWCOUNT

IF ( @changedRecords = 2 )
	BEGIN
		--reset changed records flag
		SET	@changedRecords = 0

		UPDATE	REPORT
		SET		SCHEDULED_IN = 'N'
				, UPDATE_DT = @currentUTCDate
				, UPDATE_USER_TX = 'szabinsky'
				, LOCK_ID = (LOCK_ID % 255) + 1
		WHERE	ID IN (1,3)
			AND	SCHEDULED_IN = 'Y'

		SET	@changedRecords = @@ROWCOUNT

		IF ( @changedRecords = 2)
			BEGIN
				PRINT 'UPDATE SUCCESSFUL'
				COMMIT TRANSACTION
				PRINT 'TRANSACTION COMMITTED'
			END
		ELSE
			BEGIN
				PRINT 'UPDATE FAILED'
				ROLLBACK TRANSACTION
				PRINT 'TRANSACTION ROLLED BACK'
			END
	END
ELSE
	BEGIN
		PRINT 'BACKUP FAILED'
		ROLLBACK TRANSACTION
		PRINT 'TRANSACTION ROLLED BACK'
	END
