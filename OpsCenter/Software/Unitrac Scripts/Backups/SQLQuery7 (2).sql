USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_Active_Processes]    Script Date: 9/18/2017 7:50:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




alter PROCEDURE [dbo].[UT_HomeStreet_Processes] 

as

SET NOCOUNT ON



Declare @NAME_TX varchar(100)
Declare @NEXT_RUN_DATE varchar(max)
Declare @body as varchar(6000)

Set @body = ''

Create Table #tmpActiveProcesses
(
NAME_TX varchar(100),
NEXT_RUN_DATE varchar(max))

Insert into #tmpActiveProcesses (NAME_TX,NEXT_RUN_DATE)
SELECT name_tx, SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') [AnticipatedNextScheduledDate]
  from process_definition
where EXECUTION_FREQ_CD = 'DAY' and process_type_cd = 'CYCLEPRC' and name_tx like '%3551 %'

DECLARE CursorVar CURSOR
READ_ONLY 
FOR
Select NAME_TX ,NEXT_RUN_DATE from #tmpActiveProcesses

OPEN CursorVar
Fetch CursorVar into @NAME_TX,@NEXT_RUN_DATE

While @@Fetch_Status = 0
Begin
set @body = @body + @NAME_TX+', '+@NEXT_RUN_DATE+', '+ char(13)+ char(10)

Fetch Next from CursorVar into @NAME_TX,@NEXT_RUN_DATE
End
Close CursorVar
DEALLOCATE CursorVar

if @body <> ''
Begin
	set @body = 'HomeStreet Process and next schedule date: ' + char(13)+ char(10) + 
	@body 
           Exec UT_HomeStreet_Processes_Email @Body
--Print @body
end

drop table #tmpActiveProcesses
GO

