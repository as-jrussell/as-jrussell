USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_ProcessBreakdown]    Script Date: 8/16/2019 8:46:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[UT_ProcessBreakdown]


AS

SELECT COUNT(*)[CountOfProcesses], SERVICE_NAME_TX,  MAX(pl.END_DT) MaxEndDate
FROM unitrac..PROCESS_LOG pl
WHERE UPDATE_USER_TX like ('UBSProc%')
and SERVICE_NAME_TX is not NULL and CAST(pl.CREATE_DT AS DATE) = cast(getdate() AS date)
GROUP BY SERVICE_NAME_TX
ORDER BY SERVICE_NAME_TX Asc 
GO

