USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[UT_CompletedJob]    Script Date: 8/16/2019 8:45:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[UT_CompletedJob]


AS

			  SELECT pd.PROCESS_TYPE_CD, MIN(pl.CREATE_DT) MinCreateDate, MAX(pl.END_DT) MaxEndDate, COUNT(*) [Count]

from unitrac..PROCESS_DEFINITION pd

join process_log pl ON pl.PROCESS_DEFINITION_ID = pd.ID 

WHERE  CAST(pl.CREATE_DT AS DATE) = cast(getdate() AS date)

AND pl.STATUS_CD = 'Complete'

AND pl.SERVICE_NAME_TX is not null

AND pl.END_DT is NOT NULL

AND pl.MSG_TX like 'Total WorkItems processed:%'

AND pd.LOAD_BALANCE_IN = 'Y'

GROUP BY PROCESS_TYPE_CD

GO

