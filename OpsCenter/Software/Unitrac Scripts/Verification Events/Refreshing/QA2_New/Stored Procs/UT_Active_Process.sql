USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_Active_Processes]    Script Date: 9/18/2017 7:50:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UT_Active_Processes] 

as

SET NOCOUNT ON


Declare @ID varchar(10)
Declare @NAME_TX varchar(100)
Declare @DESCRIPTION_TX varchar(100)
Declare @EXECUTION_FREQ_CD varchar(20)
Declare @PROCESS_TYPE_CD varchar(20)
Declare @ACTIVE_IN varchar(2)
Declare @ONHOLD_IN  varchar(2)
Declare @NEXT_RUN_DATE varchar(30)
Declare @UPDATE_USER_TX varchar(30)
Declare @body as varchar(6000)

Set @body = ''

Create Table #tmpActiveProcesses
(ID varchar(10),
NAME_TX varchar(100),
DESCRIPTION_TX varchar(100),
EXECUTION_FREQ_CD varchar(20),
PROCESS_TYPE_CD varchar(20),
ACTIVE_IN varchar(2),
ONHOLD_IN varchar(2),
NEXT_RUN_DATE varchar(30),
UPDATE_USER_TX varchar(15))

Insert into #tmpActiveProcesses (ID, NAME_TX, DESCRIPTION_TX, EXECUTION_FREQ_CD, PROCESS_TYPE_CD, ACTIVE_IN, ONHOLD_IN, NEXT_RUN_DATE,UPDATE_USER_TX)
SELECT ID, NAME_TX, DESCRIPTION_TX, EXECUTION_FREQ_CD, PROCESS_TYPE_CD, ACTIVE_IN, ONHOLD_IN,SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]', 'nvarchar(30)') as NEXT_RUN_DATE,UPDATE_USER_TX
FROM PROCESS_DEFINITION
WHERE PROCESS_TYPE_CD IN ('CYCLEPRC','BILLING','ESCROW','EOMRPTG') 
AND ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N' AND EXECUTION_FREQ_CD <> 'RUNONCE'

DECLARE CursorVar CURSOR
READ_ONLY 
FOR
Select ID, NAME_TX, DESCRIPTION_TX, EXECUTION_FREQ_CD, PROCESS_TYPE_CD, ACTIVE_IN, ONHOLD_IN, NEXT_RUN_DATE,UPDATE_USER_TX from #tmpActiveProcesses

OPEN CursorVar
Fetch CursorVar into @ID,@NAME_TX,@DESCRIPTION_TX,@EXECUTION_FREQ_CD,@PROCESS_TYPE_CD,@ACTIVE_IN,@ONHOLD_IN,@NEXT_RUN_DATE,@UPDATE_USER_TX

While @@Fetch_Status = 0
Begin
set @body = @body + @ID+', '+@NAME_TX+', '+@DESCRIPTION_TX+', '+@EXECUTION_FREQ_CD+', '+@PROCESS_TYPE_CD+', '+@ACTIVE_IN+', '+@ONHOLD_IN+', '+@NEXT_RUN_DATE+', '+@UPDATE_USER_TX+ char(13)+ char(10)

Fetch Next from CursorVar into @ID,@NAME_TX,@DESCRIPTION_TX,@EXECUTION_FREQ_CD,@PROCESS_TYPE_CD,@ACTIVE_IN,@ONHOLD_IN,@NEXT_RUN_DATE,@UPDATE_USER_TX
End
Close CursorVar
DEALLOCATE CursorVar

if @body <> ''
Begin
	set @body = 'Current Active Cycle/Escrow/Billing/EOM Processes in QA2: ' + char(13)+ char(10) + 
	@body 
           Exec UT_Active_Processes_Email @Body
--Print @body
end

drop table #tmpActiveProcesses
GO

