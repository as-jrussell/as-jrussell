USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_PendingJob]    Script Date: 8/16/2019 8:46:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[UT_PendingJob]

AS

SELECT

        pd.PROCESS_TYPE_CD, pd.PROC_PRIORITY_NO,  pd.ONHOLD_IN, COUNT(*) AS CountOfProcesses

FROM unitrac.dbo.UBSReadyToExecuteQueue AS t1

JOIN sys.conversation_endpoints ce ON t1.conversation_handle = ce.conversation_handle

JOIN unitrac.dbo.PROCESS_DEFINITION pd on pd.ID =  (SELECT

                CAST(MESSAGE_BODY AS XML).value(N'(/MsgRoot/Id/node())[1]', N'bigint')

                FROM dbo.UBSReadyToExecuteQueue t2 WHERE t2.CONVERSATION_HANDLE = t1.CONVERSATION_HANDLE

        )

              GROUP BY pd.PROCESS_TYPE_CD, pd.PROC_PRIORITY_NO, pd.ONHOLD_IN

              ORDER BY PROC_PRIORITY_NO, COUNT(*)

 

GO

