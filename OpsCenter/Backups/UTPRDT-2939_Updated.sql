USE UniTrac
GO

BEGIN TRAN;

/* Declare variables */
DECLARE @Ticket NVARCHAR(15) =N'UTPRDT_2939';
DECLARE @SourceDatabase NVARCHAR(100) = 'UniTrac' /* This will be the schema in HDTStorage */;
declare @Backout_Name   varchar(100)    = @Ticket + '_FT'
DECLARE @RowsToChange INT;
Declare @ErrorOccurred bit = 0 
Declare @ErrorMsg NVARCHAR(max)

IF (OBJECT_ID('tempdb..#financial_transactions') IS NOT NULL)
BEGIN
   DROP TABLE #financial_transactions
END

Select * Into #financial_transactions
FROM
(
	VALUES
	(35341347, 0.50), --Cert ASH0063673
	(35129775, 0.27), --Cert ASH0063077
	(35253574, 0.25), --Cert ASH0063675
	(35253572, 0.20) --Cert ASH0063674
) As financial_transactions(ID, Amount)

SELECT @RowsToChange = Count(*)
FROM #financial_transactions

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
	from FINANCIAL_TXN where ID IN (Select ID from #financial_transactions)')

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
	/* Step 3 - Perform table updates */

	Update FINANCIAL_TXN
	SET 
		AMOUNT_NO = AMOUNT_NO + FT.Amount,
		UPDATE_USER_TX = @Ticket,
		UPDATE_DT = GetDate(),
		LOCK_ID = LOCK_ID % 255 + 1
	FROM #financial_transactions As FT
	WHERE FINANCIAL_TXN.ID = FT.ID

	/* Step 4 - Inspect results */
	IF ( @@ROWCOUNT = @RowsToChange )
	BEGIN
		PRINT 'Updated Successfully'
	END
	ELSE
	BEGIN
		SET @ErrorMsg = 'FAILED TO UPDATE - Performing Rollback'
		SET @ErrorOccurred = 1
	END
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
