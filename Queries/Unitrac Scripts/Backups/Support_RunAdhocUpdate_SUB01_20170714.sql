USE [Unitrac_Reports]
GO
/****** Object:  StoredProcedure [dbo].[Support_RunAdhocUpdate]    Script Date: 7/15/2017 12:56:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Support_RunAdhocUpdate] @SQL_Statement NVARCHAR(MAX)
AS

  SET NUMERIC_ROUNDABORT OFF;
  SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
      QUOTED_IDENTIFIER, ANSI_NULLS ON;

DECLARE @errornum INT = NULL ,
		@errormsg NVARCHAR(255) = NULL ,
		@errorseverity INT = NULL ,
		@errorstate INT = NULL ,
		@errorline INT = NULL ,
		@MessageString NVARCHAR(512),
		@procname NVARCHAR(128)

BEGIN TRY
	EXEC sp_executesql @SQL_Statement
END TRY
BEGIN CATCH

	SELECT @errornum = ERROR_NUMBER(),
			@ErrorMsg = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@errorstate = ERROR_STATE(),
			@errorLine = ERROR_LINE(),
			@procname = ERROR_PROCEDURE()

	SELECT @MEssageString = 'ERROR ' + ISNULL(CONVERT(VARCHAR(20), @errornum), '') + ': [' + ISNULL(@ErrorMsg, '') + '] occurred in ' + ISNULL(@procname, 'Support_RunAdhocUpdate')
	                                + ' running dynamic SQL statement at line: ' + ISNULL(CONVERT(VARCHAR(20), @errorLine) , '')
	RAISERROR (	@MEssageString, 10, 1) WITH LOG
	SELECT SQL_Statement = @SQL_Statement

END CATCH

RETURN

