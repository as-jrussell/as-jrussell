use CenterPointSecurity

BEGIN TRAN


IF NOT EXISTS(SELECT * FROM sys.columns 
          WHERE Name = N'IdleTimeoutDuration'
          AND Object_ID = Object_ID(N'dbo.cp_sessions'))
BEGIN
		ALTER TABLE cp_sessions ADD IdleTimeoutDuration int;
		PRINT 'SUCCESS - Columns updated Successfully';
  COMMIT
  END
ELSE 
BEGIN
		PRINT 'Performing ROLLBACKUP - Column already added - What are you doing, bro?';
					ROLLBACK;
				END

		 
   /*

Script to back out for whatever reason: ALTER TABLE cp_sessions DROP COLUMN IdleTimeoutDuration;

   */
