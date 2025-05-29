USE [UniTrac_DW]
GO

/****** Object:  StoredProcedure [dbo].[GetESFinancialSummarySubReport]    Script Date: 7/6/2017 9:15:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- GetESFinancialSummarySubReport '2/1/2010'
CREATE procedure [dbo].[GetESFinancialSummarySubReport](@date datetime)
as
declare @monthId bigint

select @monthId = ID from MONTH_DIM where MONTH_NO = MONTH(@date) and YEAR_NO = YEAR(@date)

--select rf.DESC_TX, rf.REPORT_TABLE_CD, rf.ROW_CD, 5 as cmAct, 20 as cmPlan, 40 as ytdAct, 6 as ytdPlan, 1233 as totPlan, rf.SORT_ORDER_NO
select rf.DESC_TX, rf.REPORT_TABLE_CD, rf.ROW_CD, sum(fact.[AMOUNT_NO]) as cmAct,
	abs(sum(fact.[PLAN_AMOUNT_NO])) as cmPlan, sum(fact.YTD_AMOUNT_NO) as ytdAct,
	abs(sum(fact.YTD_PLAN_AMOUNT_NO)) as ytdPlan, abs(sum(fact.TOTAL_YEAR_PLAN_AMOUNT_NO)) as totPlan, rf.SUB_DESC_TX, rf.SORT_ORDER_NO
from REPORT_FUNCTION_DEF rf
left join dbo.LINE_ITEM_FACT fact on rf.ROW_CD = fact.LINE_ITEM_CD and fact.MONTH_ID = @monthId
where rf.REPORT_CD = 'ESR' and rf.REPORT_TABLE_CD = 'FS'
group by rf.DESC_TX, rf.REPORT_TABLE_CD, rf.ROW_CD, rf.SUB_DESC_TX, rf.SORT_ORDER_NO 
order by rf.SORT_ORDER_NO

GO

