USE UniTrac
GO

BEGIN TRAN;

/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'UTPRDT_2883';
DECLARE @SourceDatabase NVARCHAR(100) = 'UniTrac' /* This will be the schema in HDTStorage */;
declare @Backout_Name   varchar(100)    = @Ticket + '_FPC'
DECLARE @RowsToChange INT;
Declare @ErrorOccurred bit = 0 
Declare @ErrorMsg NVARCHAR(max)
DECLARE @Cert_ID varchar(20)
DECLARE @Cert_Effective_Date varchar(40)

IF (OBJECT_ID('tempdb..#certs') IS NOT NULL)
BEGIN
   DROP TABLE #certs
END

Select * Into #certs
FROM
(
	VALUES
	('9011838', '2021-11-03 00:00:00'),
	('9777410', '2021-11-04 00:00:00'),
	('9864308', '2021-11-08 00:00:00'),
	('9777279', '2021-11-12 00:00:00'),
	('9864039', '2021-11-19 00:00:00'),
	('9819566', '2021-11-21 00:00:00'),
	('9819771', '2021-11-21 00:00:00'),
	('9011971', '2021-11-23 00:00:00'),
	('9819728', '2021-11-29 00:00:00'),
	('9966909', '2021-12-02 00:00:00'),
	('9864136', '2021-12-07 00:00:00'),
	('9106053', '2021-12-08 00:00:00'),
	('9095245', '2021-12-10 00:00:00'),
	('9891485', '2021-12-13 00:00:00'),
	('9095271', '2021-12-18 00:00:00'),
	('9966703', '2021-12-21 00:00:00'),
	('9934754', '2021-12-22 00:00:00'),
	('9891165', '2021-12-26 00:00:00'),
	('9934877', '2022-01-01 00:00:00'),
	('9891212', '2022-01-08 00:00:00'),
	('9934807', '2022-01-10 00:00:00'),
	('9934667', '2022-01-14 00:00:00'),
	('9905936', '2022-01-15 00:00:00'),
	('9966716', '2022-01-18 00:00:00'),
	('9159137', '2022-01-21 00:00:00'),
	('9183297', '2022-02-01 00:00:00'),
	('9183287', '2022-02-05 00:00:00'),
	('8314437', '2022-02-07 00:00:00'),
	('8504088', '2022-02-09 00:00:00'),
	('8504573', '2022-02-09 00:00:00'),
	('9208940', '2022-02-09 00:00:00'),
	('8314464', '2022-02-13 00:00:00'),
	('8313313', '2022-02-16 00:00:00'),
	('10017850', '2022-02-16 00:00:00'),
	('8315408', '2022-02-21 00:00:00'),
	('10033620', '2022-02-21 00:00:00'),
	('10000336', '2022-02-23 00:00:00'),
	('8315321', '2022-02-24 00:00:00'),
	('8313515', '2022-02-24 00:00:00'),
	('8314465', '2022-02-25 00:00:00'),
	('8315495', '2022-02-26 00:00:00'),
	('8315530', '2022-02-26 00:00:00'),
	('9234763', '2022-02-27 00:00:00'),
	('8314058', '2022-02-28 00:00:00'),
	('10017870', '2022-03-01 00:00:00'),
	('8505100', '2022-03-02 00:00:00'),
	('10033636', '2022-03-02 00:00:00'),
	('10017765', '2022-03-04 00:00:00'),
	('10066684', '2022-03-09 00:00:00'),
	('8504593', '2022-03-16 00:00:00'),
	('8504608', '2022-03-19 00:00:00'),
	('10117067', '2022-03-24 00:00:00'),
	('10207179', '2022-04-01 00:00:00'),
	('9332697', '2022-04-04 00:00:00'),
	('10135214', '2022-04-22 00:00:00'),
	('10135280', '2022-04-22 00:00:00'),
	('10207015', '2022-04-27 00:00:00'),
	('10153532', '2022-04-28 00:00:00'),
	('10153469', '2022-04-29 00:00:00'),
	('10170734', '2022-05-02 00:00:00'),
	('8593851', '2022-05-09 00:00:00'),
	('10188666', '2022-05-10 00:00:00'),
	('10207305', '2022-05-10 00:00:00'),
	('10206929', '2022-05-14 00:00:00'),
	('9387630', '2022-05-16 00:00:00'),
	('10207173', '2022-05-18 00:00:00'),
	('10207140', '2022-05-27 00:00:00'),
	('9429120', '2022-06-01 00:00:00'),
	('8923350', '2022-06-03 00:00:00'),
	('10135435', '2022-06-09 00:00:00'),
	('9471633', '2022-06-17 00:00:00'),
	('9443545', '2022-06-19 00:00:00'),
	('9471599', '2022-06-29 00:00:00'),
	('8676049', '2022-07-01 00:00:00'),
	('8756164', '2022-07-06 00:00:00'),
	('9485300', '2022-07-09 00:00:00'),
	('9528770', '2022-07-16 00:00:00'),
	('9500111', '2022-07-16 00:00:00'),
	('9513958', '2022-07-18 00:00:00'),
	('9514015', '2022-07-20 00:00:00'),
	('9528763', '2022-07-26 00:00:00'),
	('8954003', '2022-07-30 00:00:00'),
	('9543955', '2022-07-30 00:00:00'),
	('9528743', '2022-07-31 00:00:00'),
	('9544063', '2022-08-01 00:00:00'),
	('9574031', '2022-08-14 00:00:00'),
	('9604911', '2022-08-21 00:00:00'),
	('9653650', '2022-08-26 00:00:00'),
	('9604952', '2022-08-29 00:00:00'),
	('8872759', '2022-09-03 00:00:00'),
	('9668612', '2022-09-25 00:00:00'),
	('9668548', '2022-09-28 00:00:00'),
	('9683815', '2022-10-01 00:00:00'),
	('8954060', '2022-10-09 00:00:00'),
	('9011898', '2022-10-15 00:00:00'),
	('9777265', '2022-10-29 00:00:00'),
	('9777469', '2022-11-02 00:00:00')
) As certs(ID, Effective_Date)

SELECT @RowsToChange = Count(*)
FROM #certs

/* Existence check for Storage tables - Exit if they exist */
IF NOT EXISTS 
(
	SELECT * FROM HDTStorage.INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_TYPE = 'BASE TABLE'
	AND TABLE_NAME = @Backout_Name
	AND TABLE_SCHEMA = @SourceDatabase
)
BEGIN
	/* Create storage table if it has not yet been created */
	/* populate new Storage table from Sources */
	Print 'populate new Storage table from Sources'

	/* populate new Storage table from Sources */
	Exec('SELECT * into HDTStorage.' + @SourceDatabase + '.' + @Backout_Name + '
	from FORCE_PLACED_CERTIFICATE where ID IN (Select ID from #certs)')

	/* Does Storage Table meet expectations */
	IF( @@RowCount = @RowsToChange )
	BEGIN
		PRINT 'Storage table meets expections - continue'
	END
	ELSE
	BEGIN
		SET @ErrorMsg ='Storage does not meet expectations - rollback'
		SET @ErrorOccurred = 1
	END
End
ELSE
BEGIN
	SET @ErrorMsg ='HD TABLES EXISTS - Stop work'
	SET @ErrorOccurred = 1
END

IF @ErrorOccurred = 0
Begin
	/* Setup Cursor to iterate through certs to update */
	DECLARE Certs_To_Update_Cursor CURSOR FOR 
	SELECT [ID], [Effective_Date]
	FROM #certs 

	/* Step 3 - Perform table updates */
	OPEN Certs_To_Update_Cursor  
	FETCH NEXT FROM Certs_To_Update_Cursor INTO @Cert_ID, @Cert_Effective_Date

	-- Set the status for the cursor
	WHILE @@FETCH_STATUS = 0 AND @ErrorOccurred = 0  
	BEGIN  
		--PRINT('ID: ' + @Cert_ID + ', Effective_Date: ' + @Cert_Effective_Date)
		Update FORCE_PLACED_CERTIFICATE
		SET last_term_reminder_notice_dt = @Cert_Effective_Date
		WHERE ID = @Cert_ID

		/* Step 4 - Inspect results */
		IF ( @@ROWCOUNT = 1 )
		BEGIN
			PRINT 'Updated Successfully'
		END
		ELSE
		BEGIN
			SET @ErrorMsg = 'FAILED TO UPDATE - Performing Rollback'
			SET @ErrorOccurred = 1
		END

 		FETCH NEXT FROM Certs_To_Update_Cursor INTO @Cert_ID, @Cert_Effective_Date 
	END 

	/* Cleanup Cursor */
	CLOSE Certs_To_Update_Cursor
	DEALLOCATE Certs_To_Update_Cursor
END

/* Commit or Rollback */
IF @ErrorOccurred = 1
Begin
	Print @ErrorMsg
	Rollback;
End
Else
Begin
	Commit;
End
