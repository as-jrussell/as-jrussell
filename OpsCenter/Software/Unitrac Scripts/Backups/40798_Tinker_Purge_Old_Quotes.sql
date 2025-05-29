/*
40798
find loans with two quotes open after tinker cycle ran. WI 38910923
purge first open quote and create memo
*/
USE [UniTrac]

   if OBJECT_ID('tempdb..#tmp_Quotes') IS NOT NULL
	   drop table #tmp_Quotes

	if OBJECT_ID('tempdb..#tmp_OldQuotes') IS NOT NULL
	drop table #tmp_OldQuotes

select  ee.REQUIRED_COVERAGE_ID, l.NUMBER_TX, l.id as LoanID, n.id as NoticeID, cpi.id as QuoteID
into #tmp_Quotes
from 
WORK_ITEM wi
inner join PROCESS_LOG_ITEM pli on pli.PROCESS_LOG_ID = wi.RELATE_ID and wi.RELATE_TYPE_CD = 'Osprey.ProcessMgr.ProcessLog'
inner join NOTICE n on n.ID = pli.RELATE_ID and pli.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
inner join EVALUATION_EVENT ee on ee.id = pli.EVALUATION_EVENT_ID
inner join REQUIRED_COVERAGE rc on rc.id = ee.REQUIRED_COVERAGE_ID
inner join CPI_QUOTE cpi on cpi.id = n.CPI_QUOTE_ID and cpi.PURGE_DT is null and cpi.CLOSE_DT is null
inner join loan l on l.ID = n.LOAN_ID and l.PURGE_DT is null

where n.PURGE_DT is NULL
and l.LENDER_ID = 2283
and wi.id = 38910923

select n.cpi_quote_ID AS OldQuoteID, l.id as LoanID, rc.ID as RCID, rc.PROPERTY_ID as PropID 
into #tmp_OldQuotes
from #tmp_Quotes t
inner join notice n on n.Loan_ID = t.LoanID
inner join CPI_QUOTE cpi on cpi.id = n.CPI_QUOTE_ID and cpi.PURGE_DT is null and cpi.CLOSE_DT is null
inner join loan l on l.ID = n.LOAN_ID and l.PURGE_DT is null
inner join REQUIRED_COVERAGE rc on rc.id = t.REQUIRED_COVERAGE_ID
INNER  join EVENT_SEQUENCE es on es.id = rc.LAST_EVENT_SEQ_ID
left join EVENT_SEQ_CONTAINER esc on esc.id = rc.LAST_SEQ_CONTAINER_ID
inner join EVALUATION_EVENT ee on ee.EVENT_SEQUENCE_ID = es.id and ee.REQUIRED_COVERAGE_ID = rc.id

outer apply
( select type_cd
	from CPI_Activity act
	where act.cpi_quote_id = cpi.id and act.Type_CD = 'C'

) Activity

where n.PURGE_DT is NULL
and l.LENDER_ID = 2283
and n.cpi_Quote_ID <> t.QuoteID
and n.type_CD in ('N','C')
and Activity.Type_CD is null
order by l.number_tx


set NOCOUNT ON
Declare @quoteID as bigint
Declare @loanID as bigint
Declare @rcID as bigint
Declare @propID as bigint
Declare @memoXML as xml
Declare @memo as nvarchar(max)
Declare @updateUser as nvarchar = 'Task40798'


declare itemCursor cursor for
Select OldQuoteID, LoanID, RCID, PropID from #tmp_OldQuotes

print 'Purging Interaction History, CPI Quote & CPI Activity Records tied to the following CPI Quote IDs: '
open itemCursor

FETCH next from itemCursor into @quoteID, @loanID, @rcID, @propID

While @@FETCH_STATUS= 0
Begin

	print cast(@quoteID as nvarchar)

	 --Select *
	 update ih
	 set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @updateUser, LOCK_ID = (LOCK_ID % 255) + 1
	 from INTERACTION_HISTORY ih
	 Where ih.RELATE_ID = @quoteID and ih.RELATE_CLASS_TX = 'Allied.UniTrac.CPIQuote' --and ih.PURGE_DT is NULL

	--Select *
	update cpi
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @updateUser, LOCK_ID = (LOCK_ID % 255) + 1

	from CPI_QUOTE cpi
	where cpi.ID = @quoteID

	--select *
	update cpia
	set PURGE_DT = getdate(), UPDATE_DT = getdate(), UPDATE_USER_TX = @updateUser, LOCK_ID = (LOCK_ID % 255) + 1
	from CPI_ACTIVITY cpia
	where cpia.CPI_QUOTE_ID = @quoteID

	--Create Internal Memo to show quote was deleted. 
	set @memo = 'Purged Duplicate Open Quote. TFS 40798. CPI Quote ID: ' + cast( @quoteID as NVARCHAR)
	set @memoXML = '<SH>
					<RC>' + cast( @rcID as nvarchar) + '</RC>
					</SH>'

	insert into
	  INTERACTION_HISTORY (TYPE_CD,LOAN_ID,PROPERTY_ID,EFFECTIVE_DT,ISSUE_DT,NOTE_TX,SPECIAL_HANDLING_XML,ALERT_IN,PENDING_IN,IN_HOUSE_ONLY_IN,CREATE_DT,
						CREATE_USER_TX,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,ARCHIVED_IN)
						VALUES
						('MEMO', @loanID, @propID, getdate(), GETDATE(), @memo, @memoXML , 'Y' , 'N', 'Y', getdate(), @updateUser,GETDATE(), @updateUser,
						1 ,'N')


	FETCH next from itemCursor into @quoteID, @loanID, @rcID, @propID
End
Close itemCursor;
deallocate itemCursor;
set nocount off
