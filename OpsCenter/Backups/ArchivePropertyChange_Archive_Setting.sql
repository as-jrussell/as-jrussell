USE [Unitrac];

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ArchivePropertyChange_Archive_Setting') AND type in (N'P', N'PC'))
BEGIN
	/* Create Empty Stored Procedure */
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ArchivePropertyChange_Archive_Setting]  AS RETURN 0;';
END;
GO



/* Alter Stored Procedure */
ALTER PROCEDURE [dbo].[ArchivePropertyChange_Archive_Setting] ( @WhatIF BIT = 1) 
AS 
BEGIN
    /* Content of stored procedure */

SET NOCOUNT ON;

Declare @Day nvarchar(100),@NumberOfLoops AS nvarchar(3), @Batchsize nvarchar(4)
SELECT @Day = DATENAME(dw, GETDATE())

SET @NumberOfLoops = CASE WHEN @Day in ('Sunday','Saturday') THEN '10000' ELSE '3000' END
SET @Batchsize = CASE WHEN @Day in ('Sunday','Saturday') THEN  '3000' ELSE '3000' END

-- Declare local variables

DECLARE @SQLcmd AS nvarchar(max);



select @SQLcmd = '
DECLARE @NumberOfLoops AS int;
DECLARE @RC int
DECLARE @Batchsize int
DECLARE @createdateoffset int
DECLARE @DoDELETE int
DECLARE @process_log_id bigint


SET @NumberOfLoops = 1;


WHILE ( @NumberOfLoops <=  '+@NumberOfLoops+')
    BEGIN
        -- Just delete any xxx rows that are below the HighWaterMark
   EXECUTE @RC = [dbo].[ArchivePropertyChange] 
   @Batchsize =  '+@Batchsize+'
  ,@createdateoffset = 450
  ,@DoDELETE = 1
  ,@process_log_id = NULL  
        WAITFOR DELAY ''00:00:01:00'';
          
        SET @NumberOfLoops =@NumberOfLoops + 1;
    END'

    IF( @WhatIF = 1 )
        BEGIN
            /* Do NOT invoke any change - display what would happen */
			Print @SQLcmd
        END
    ELSE
        BEGIN
            /* Invoke changes */
            EXEC (@SQLcmd)
        END
END


