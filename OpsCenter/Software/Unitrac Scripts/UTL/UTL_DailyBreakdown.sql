use utl
go 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create  PROCEDURE [dbo].[UT_DailyUTL_Breakdown]


as

SET NOCOUNT ON
select pd_id, pd_name_tx, MAX(days_pend_rematch_now) DaysPendingRematch from #specificlenders
 GROUP BY pd_id, pd_name_tx
  union all 
 select pd_id, pd_name_tx, MAX(days_pend_rematch_now) DaysPendingRematch from #defaultlenders
 GROUP BY pd_id, pd_name_tx
 ORDER BY pd_id