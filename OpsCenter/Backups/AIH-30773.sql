USE [IQQ_LIVE]
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CDLARemoveOldTransactionPersonalData') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE dbo.CDLARemoveOldTransactionPersonalData AS RETURN 0;';
END;
GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[CDLARemoveOldTransactionPersonalData] ( @WhatIF BIT = 1, @ageOutInDays INT = 90, @DatabaseName SYSNAME = 'IQQ_LIVE'  )
AS 

    /* Content of stored procedure */
DECLARE @sqlcmd NVARCHAR(1000)
DECLARE @now DATETIME2= GETUTCDATE()

DECLARE @BLOB_TX NVARCHAR(200) = '{"purgeReason":"aged past '+CAST(@ageOutInDays AS NVARCHAR(100))+ ' days"}'


		SELECT @sqlcmd='USE [' + @DatabaseName + '] 
	
	UPDATE DLA_TRANSACTION SET UPDATE_USER_TX = ''job CDLARemoveOldTransactionPersonalData'', 
	BLOB_TX = '+ @BLOB_TX + ',
	UPDATE_DT ='''+ CAST(@now AS NVARCHAR(100)) +''',
	PURGE_DT = '''+ CAST(@now AS NVARCHAR(100)) +''',
	LOCK_ID = (LOCK_ID % 255) + 1 
	WHERE PURGE_DT IS NULL AND DATEDIFF(DAY, CREATE_DT,'''+ CAST(@now AS NVARCHAR(100)) +''')  >='+ CAST(@ageOutInDays AS NVARCHAR(100)) +''


		
    IF( @WhatIF = 1 )
        BEGIN
            /* Do NOT invoke any change - display what would happen */
			PRINT (@SQLcmd)
        END
    ELSE
        BEGIN
            /* Invoke changes */
           EXEC (@SQLcmd) 
        END
;





