USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_LongRunningProcesses]    Script Date: 8/16/2019 8:46:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[UT_LongRunningProcesses]


AS



SELECT CONVERT(TIME,END_DT- START_DT)[hh:mm:ss], PD.NAME_TX,  PL.SERVICE_NAME_TX, pl.START_DT
FROM unitrac.dbo.PROCESS_LOG PL
JOIN unitrac.dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE pl.UPDATE_USER_TX like ('UBSProc%')
and SERVICE_NAME_TX is not NULL and CAST(pl.CREATE_DT AS DATE) = cast(getdate() AS date) and 
CONVERT(TIME,pl.END_DT-pl. START_DT) > '00:30'
ORDER BY CONVERT(TIME,END_DT- START_DT) DESC 

GO

