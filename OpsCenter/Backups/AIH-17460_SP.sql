USE [IVOS];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT *
               FROM   sys.objects
               WHERE  object_id = Object_id(N'[dbo].[ISO_Reprocess]')
                      AND type IN ( N'P', N'PC' ))
  BEGIN
      /* Create Empty Stored Procedure */
      EXEC dbo.Sp_executesql
        @statement = N'CREATE PROCEDURE [dbo].[ISO_Reprocess] AS RETURN 0;';
  END;

GO

/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[ISO_Reprocess] (@WhatIF BIT = 1,
                                          @Count  varchar(3))

  --EXEC IVOS.dbo.ISO_Reprocess @Count = 100
  

AS
DECLARE @SQLCMD VARCHAR(max)

  BEGIN
      SELECT @sqlcmd = '	
UPDATE TOP ('+(@Count) +') I 
			SET iso_cs_status_code = 2 
			FROM dbo.iso_CS I
			WHERE iso_CS_status_Code = 3
            and response_date > ''10-08-2022'''

      IF( @WhatIF = 1 )
        BEGIN
            PRINT ( @SQLcmd )
        END
  END

BEGIN
    /* Invoke changes */
    EXEC ( @SQLcmd)
END



