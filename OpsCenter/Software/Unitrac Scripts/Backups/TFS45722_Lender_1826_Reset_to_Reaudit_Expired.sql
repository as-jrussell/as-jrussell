/*
	TFS 45722
	Lender #1826 / Wauna (SMP Conversion) - 
	need script ran to place 446 loans in reaudit status eff 6/1/18, with notice sequences restarted

	Adjust RC Status & clear good thru date
	Clear Notice Cycle Information
	Create PC & PCU records
	Revert OP & PC to prior status and end/exp dates


*/
	
IF OBJECT_ID(N'tempdb..#tmpReAuditRCs',N'U') IS NOT NULL
	DROP TABLE #tmpReAuditRCs
IF OBJECT_ID(N'tempdb..#tmpPolicies',N'U') IS NOT NULL
	DROP TABLE #tmpPolicies 	
IF OBJECT_ID(N'tempdb..#tmpCurrentPC',N'U') IS NOT NULL
	DROP TABLE #tmpCurrentPC
IF OBJECT_ID(N'tempdb..#tmpMaxStart',N'U') IS NOT NULL
	drop table #tmpMaxStart   

    CREATE TABLE #tmpReAuditRCs
    (
      LOAN_ID BIGINT ,
      RC_ID BIGINT ,
	  PROP_ID BIGINT,
	  LOAN_NO varchar(100),
      INS_SUMMARY_STATUS VARCHAR(1),
	  INS_SUMMARY_SUB_STATUS VARCHAR(1),
	  EXPOSURE_DT DATETIME
    )

Declare @Task varchar(8) = 'TASK45722'
Declare @ExpiredStatus varchar(2) = 'E'
Declare @ReAuditStatus varchar(2) = 'R'
Declare @NewExposure datetime = '06/01/2018'
	
INSERT INTO #tmpReAuditRCs
(
    LOAN_ID, RC_ID, PROP_ID, LOAN_NO, INS_SUMMARY_STATUS, INS_SUMMARY_SUB_STATUS, EXPOSURE_DT
)
select  l.ID, RC.ID, RC.PROPERTY_ID, l.NUMBER_TX, rc.SUMMARY_STATUS_CD, rc.SUMMARY_SUB_STATUS_CD, rc.EXPOSURE_DT
from loan l
inner join lender ldr on ldr.id = l.LENDER_ID
inner join COLLATERAL c on c.LOAN_ID = l.ID and c.PURGE_DT is NULL
inner join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = c.PROPERTY_ID and rc.PURGE_DT is NULL
where ldr.CODE_TX = '1826' 
 --and rc.INSURANCE_SUB_STATUS_CD = 'R' and (rc.INSURANCE_STATUS_CD = 'F' or rc.INSURANCE_STATUS_CD = 'P')
 
and l.RECORD_TYPE_CD = 'G' and l.PURGE_DT is NULL
and l.NUMBER_TX in (
'140284-3050',
'145724-3175',
'153677-3050',
'131936-3550',
'141207-3550',
'106278-3550',
'104088-3550',
'554445-3050',
'136714-3500',
'454181-3051',
'152347-3050',
'146081-3550',
'105181-3100',
'143157-3275',
'132747-3050',
'126275-3175',
'109054-3550',
'149445-3050',
'148552-3275',
'124755-3000',
'142686-3550',
'152067-3050',
'152549-3550',
'142269-3550',
'140110-3050',
'127033-3051',
'130537-3053',
'453206-3051',
'109066-3124',
'128771-3052',
'455865-3051',
'150241-3550',
'134362-3550',
'134837-3551',
'147154-3124',
'134755-3550',
'144187-3550',
'151728-3550',
'144666-3052',
'145261-3550',
'152099-3550',
'105103-3050',
'552307-3051',
'121872-3625',
'135988-3051',
'136681-3051',
'140489-3051',
'105247-3500',
'135538-3050',
'151898-3050',
'154331-3550',
'151684-3050',
'145386-3052',
'150400-3050',
'133316-3550',
'154491-3550',
'143796-3052',
'144319-3550',
'3717-3276',
'147664-3550',
'135980-3552',
'450284-3050',
'455531-3550',
'125139-3050',
'146961-3550',
'141090-3050',
'154289-3550',
'142266-3550',
'141428-3125',
'127321-3500',
'130763-3500',
'543734-3550',
'127158-3050',
'300333-3100',
'144583-3550',
'152164-3550',
'152955-3050',
'135610-3051',
'104426-3050',
'154488-3550',
'145703-3051',
'135987-3125',
'300883-3125',
'141000-3050',
'152636-3550',
'109278-3550',
'152445-3225',
'147634-3550',
'152727-3550',
'540270-3500',
'149308-3550',
'153897-3550',
'129784-3050',
'150884-3550',
'150906-3050',
'124190-3050',
'146090-3550',
'145783-3500',
'125973-3050',
'150804-3550',
'141420-3050',
'107021-3500',
'133203-3050',
'135915-3276',
'7849-3175',
'128309-3550',
'144517-3550',
'154111-3050',
'136211-3550',
'151235-3550',
'142640-3050',
'151002-3550',
'130044-3050',
'3441-3050',
'136508-3052',
'140232-3051',
'152027-3550',
'150965-3550',
'520266-3052',
'143287-3050',
'453652-3124',
'126385-3550',
'3819-3550',
'152610-3550',
'153969-3550',
'540850-3550',
'130592-3500',
'151472-3550',
'149090-3550',
'101235-3550',
'148656-3050',
'152177-3550',
'132523-3275',
'151813-3550',
'153906-3124',
'153283-3050',
'145327-3550',
'123716-3050',
'106969-3050',
'153694-3550',
'154952-3550',
'149392-3550',
'151172-3050',
'148511-3550',
'109980-3500',
'151379-3050',
'142745-3550',
'570625-3050',
'128272-3050',
'4609-3550',
'151088-3550',
'454771-3124',
'153262-3550',
'149093-3000',
'131140-3051',
'152200-3550',
'153828-3550',
'124490-3050',
'146819-3050',
'142079-3125',
'126455-3125',
'145531-3051',
'142938-3000',
'140638-3050',
'141298-3051',
'153122-3050',
'144459-3550',
'142283-3500',
'149188-3050',
'147446-3124',
'143954-3276',
'542777-3501',
'127807-3050',
'141454-3550',
'152315-3550',
'141901-3051',
'131623-3050',
'151335-3050',
'8183-3550',
'128142-3050',
'151645-3550',
'135347-3050',
'135136-3050',
'142056-3500',
'131140-3100',
'151846-3550',
'133510-3052',
'106439-3050',
'129733-3551',
'153600-3550',
'145198-3550',
'153780-3550',
'146043-3550',
'103199-3051',
'122099-3053',
'144190-3550',
'9235-3500',
'102475-3053',
'540780-3500',
'544181-3051',
'152061-3550',
'154345-3550',
'153557-3550',
'152641-3050',
'145678-3052',
'154571-3050',
'136088-3550',
'106918-3050',
'540999-3053',
'131603-3225',
'148007-3551',
'148583-3551',
'153159-3550',
'154327-3550',
'130519-3100',
'152574-3550',
'142886-3550',
'152746-3550',
'143759-3550',
'131227-3050',
'152925-3550',
'146681-3550',
'152401-3550',
'150936-3550',
'152472-3550',
'151341-3500',
'100678-3052',
'146832-3550',
'153366-3550',
'154363-3050',
'154503-3550',
'152322-3550',
'133620-3050',
'151998-3550',
'151229-3050',
'151702-3550',
'147669-3052',
'152669-3050',
'153886-3550',
'552401-3550',
'136940-3050',
'142268-3050',
'146793-3550',
'153135-3500',
'149108-3550',
'151434-3550',
'5647-3000',
'154013-3550',
'152237-3550',
'145581-3551',
'149705-3050',
'150272-3050',
'136044-3175',
'102874-3500',
'105016-3050',
'126457-3050',
'151965-3550',
'144213-3550',
'153862-3050',
'3212-3500',
'146235-3550',
'122215-3051',
'153700-3550',
'153293-3050',
'151264-3550',
'154757-3550',
'153092-3550',
'542825-3050',
'141482-3050',
'151659-3550',
'151621-3550',
'131395-3550',
'109287-3052',
'154730-3550',
'152705-3550',
'145820-3550',
'149550-3550',
'151209-3550',
'148998-3050',
'530648-3550',
'154042-3550',
'153712-3050',
'147398-3050',
'151029-3550',
'152499-3550',
'154673-3550',
'151662-3550',
'151427-3550',
'142904-3550',
'153380-3550',
'133939-3050',
'136369-3051',
'106043-3051',
'142246-3052',
'149292-3550',
'142640-3550',
'136693-3051',
'101568-3550',
'148708-3550',
'150785-3550',
'909-3051',
'154628-3550',
'152613-3550',
'147969-3050',
'153134-3225',
'152307-3550',
'130087-3500',
'152651-3050',
'148664-3550',
'100583-3050',
'145559-3550',
'143551-3050',
'124967-3050',
'153095-3550',
'152529-3050',
'134283-3050',
'144896-3550',
'154897-3050',
'140858-3550',
'151613-3550',
'151969-3550',
'151605-3550',
'543648-3550',
'451857-3225',
'154707-3050',
'147526-3550',
'121703-3550',
'134814-3500',
'151721-3550',
'153354-3550',
'151170-3551',
'151833-3550',
'152779-3550',
'148441-3050',
'154325-3550',
'140501-3053',
'152586-3550',
'153816-3550',
'148761-3550',
'148190-3050',
'153809-3550',
'143732-3050',
'153589-3550',
'153679-3550',
'143641-3050',
'149264-3550',
'151803-3550',
'152783-3550',
'152722-3550',
'153562-3550',
'145457-3550',
'153909-3550',
'148117-3550',
'147762-3550',
'152407-3500',
'153111-3550',
'142406-3550',
'153012-3550',
'151926-3050',
'135235-3051',
'152807-3550',
'154414-3550',
'146783-3050',
'104128-3050',
'145331-3551',
'143733-3550',
'152664-3550',
'153281-3550',
'136822-3053',
'130483-3550',
'154678-3550',
'7789-3000',
'149920-3500',
'151997-3550',
'151577-3500',
'154817-3550',
'125314-3050',
'142450-3500',
'145352-3125',
'153308-3550',
'147882-3052',
'136223-3500',
'151726-3550',
'154777-3550',
'144970-3550',
'144477-3550',
'154774-3050',
'153124-3500',
'151962-3550',
'154419-3050',
'122996-3550',
'134693-3050',
'150381-3550',
'155389-3050',
'132194-3001',
'144553-3276',
'144553-3276',
'147889-3550',
'153587-3550',
'142271-3550',
'145326-3000',
'135751-3551',
'149702-3550',
'420207-3500',
'146781-3552',
'131518-3500',
'151115-3124',
'152873-3550',
'133950-3500',
'141310-3500',
'154938-3550',
'125857-3052',
'151628-3550',
'302424-3051',
'125703-3551',
'403675-3000',
'145796-3052',
'154561-3550',
'152865-3500',
'133928-3052',
'551416-3052',
'150092-3050',
'104285-3050',
'140764-3500',
'154101-3550',
'145464-3501',
'149996-3550',
'142825-3550',
'153787-3550',
'140028-3625',
'122012-3050',
'108274-3550',
'155095-3550',
'2787-3500',
'550219-3050',
'140907-3501',
'126891-3124',
'152292-3500',
'102403-3052',
'107622-3050',
'122939-3501',
'135927-3550',
'153678-3500',
'152789-3500',
'153613-3550',
'152978-3500'
)



SELECT * from #tmpReAuditRCs


 update rc
 set rc.Summary_Status_CD = @ExpiredStatus, rc.INSURANCE_STATUS_CD = @ExpiredStatus,
	 rc.SUMMARY_SUB_STATUS_CD = @ReAuditStatus, rc.INSURANCE_SUB_STATUS_CD = @ReAuditStatus,
	 rc.EXPOSURE_DT = @NewExposure, rc.Good_THRU_DT = null, 
	 rc.NOTICE_DT = null, rc.LAST_EVENT_SEQ_ID = null, rc.LAST_EVENT_DT = null, rc.LAST_SEQ_CONTAINER_ID = null, rc.NOTICE_TYPE_CD = null, rc.NOTICE_SEQ_NO = null,
	 rc.CPI_QUOTE_ID = null,
	 rc.UPDATE_USER_TX=@Task, rc.UPDATE_DT = getdate(), rc.LOCK_ID = (LOCK_ID % 255) + 1

 from REQUIRED_COVERAGE rc
 join #tmpReAuditRCs t on t.RC_ID = rc.ID
 where rc.PURGE_DT is null 


-- Clear any pending events tied to these RCs that are part of a eval notice sequence
update ee
set ee.STATUS_CD = 'CLR', MSG_LOG_TX = 'Clear notice cycle TFS 45722'
,ee.UPDATE_DT = getdate(), ee.UPDATE_USER_TX = @Task, ee.LOCK_ID = (ee.LOCK_ID % 255) + 1
from #tmpReAuditRCs t
join EVALUATION_EVENT ee on ee.REQUIRED_COVERAGE_ID = t.RC_ID
where ee.STATUS_CD = 'PEND' and ee.EVENT_SEQUENCE_ID is not null


BEGIN /* --  Insert Pc & PCU records for RC */
  		
	  declare @rowcount int = 0
	  declare @rcID bigint = 0,
	          @propID bigint = 0,
			  @currentSummaryStatus nvarchar(2)= null,
			  @currentSummarySubStatus nvarchar(2) = null,
			  @currentExposure datetime = null,
			  @chunksize int = 1000
	  declare itemCursor cursor for
	  select RC_ID, PROP_ID,INS_SUMMARY_STATUS, INS_SUMMARY_SUB_STATUS, EXPOSURE_DT from #tmpReAuditRCs;

	  open itemCursor

	  fetch next from itemCursor into @rcID, @propID, @currentSummaryStatus, @currentSummarySubStatus, @currentExposure

	  WHILE @@FETCH_STATUS = 0
	  BEGIN	  
		-- check to see if a transaction has been started yet
		-- if not (@rowcount is 0), begin a transaction
		if @rowcount = 0
		begin
			begin transaction
		end
		declare @propChangeID bigint = 0
		-- Insert into Property Change Table
		Insert into PROPERTY_CHANGE (ENTITY_NAME_TX,ENTITY_ID,USER_TX,ATTACHMENT_IN,CREATE_DT,DETAILS_IN,FORMATTED_IN,LOCK_ID,PARENT_NAME_TX,PARENT_ID,TRANS_STATUS_CD,UTL_IN)
			values ('Allied.UniTrac.RequiredCoverage',@rcID,@Task,'N',getdate(),'Y','N',1,'Allied.UniTrac.Property',@propID,'PEND','N')
		set @propChangeID = SCOPE_IDENTITY()
		if (@propChangeID <> 0)
		begin
		-- Insert into Property Change Update Table

		--SUMMARY_STATUS_CD
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'SUMMARY_STATUS_CD',@currentSummaryStatus,@ExpiredStatus,2,getdate(),'Y','U')


		--INSURANCE_STATUS_CD
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'INSURANCE_STATUS_CD',@currentSummaryStatus,@ExpiredStatus,2,getdate(),'Y','U')

		--SUMMARY_SUB_STATUS_CD
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'SUMMARY_SUB_STATUS_CD',@currentSummarySubStatus,@ReAuditStatus,2,getdate(),'Y','U')


		--INSURANCE_SUB_STATUS_CD
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'INS_SUMMARY_SUB_STATUS',@currentSummarySubStatus,@ReAuditStatus,2,getdate(),'Y','U')

		--EXPOSURE_DT
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'EXPOSURE_DT',@currentExposure,@NewExposure,2,getdate(),'Y','U')

		--Notice Sequence
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'Notice Sequence',null,'Notice Cycle Cleared',null,getdate(),'Y','U')

		END
		 -- increment the rowcount
		 set @rowcount = @rowcount + 1

		 -- if the rowcount equals the @chunksize, commit the transaction
		 --  reset @rowcount to begin a new transaction
		 if @rowcount = @chunksize
		 begin
		 	  commit transaction
		 	  set @rowcount = 0
		 end

		fetch next from itemCursor into @rcID,@propID, @currentSummaryStatus, @currentExposure
	  END

	  -- if there were any rows updated since the last commit, commit them now
	  if @rowcount > 0
	  	commit transaction

	  close itemCursor;
	  deallocate itemCursor; 
end /* --  Insert Pc & PCU records for RC */

	 
begin /* -- OP & PC Records */


select 
t.LOAN_ID, t.RC_ID,t.PROP_ID, op.id as OP_ID,  t.LOAN_NO, op.STATUS_CD, op.SUB_STATUS_CD, op.POLICY_NUMBER_TX ,cast( @NewExposure as datetime) as NEW_EXP_DATE
into #tmpPolicies
from  #tmpReAuditRCs t
inner join PROPERTY_OWNER_POLICY_RELATE popr on popr.PROPERTY_ID = t.PROP_ID and popr.PURGE_DT is NULL
inner join OWNER_POLICY op on op.id = popr.OWNER_POLICY_ID and op.PURGE_DT is null


where --(op.STATUS_CD = 'F' or op.STATUS_CD = 'P') --and op.SUB_STATUS_CD = 'R'
 op.EXPIRATION_DT > '01/01/2016'
 and
 CASE
 when op.STATUS_CD = 'C' then 0
 when op.STATUS_CD = 'E' AND op.SUB_STATUS_CD = 'R' then 0
 else 1
 
 end = 1 
order by t.LOAN_NO

select 'Owner Policies to Update', *, @ExpiredStatus as NewStatus_CD, @ReAuditStatus as NewSubStatus_CD from #tmpPolicies order by Loan_no



select op.ID as OP_ID, max(t.NEW_EXP_DATE) as EXPIRATION_DT, pc.TYPE_CD, pc.SUB_TYPE_CD, max(pc.START_DT) as MAX_START_DT
into #tmpMaxStart
from OWNER_POLICY op
  join #tmpPolicies t on op.ID = t.OP_ID
  join POLICY_COVERAGE pc on op.ID = pc.OWNER_POLICY_ID and pc.PURGE_DT is null
group by op.ID, pc.TYPE_CD, pc.SUB_TYPE_CD

 
select op.ID as OP_ID, pc.ID as PC_ID, t.EXPIRATION_DT, pc.TYPE_CD, pc.SUB_TYPE_CD, max(pc.END_DT) MAX_END_DT
into #tmpCurrentPC
from OWNER_POLICY op
  join #tmpMaxStart t on op.ID = t.OP_ID
  join POLICY_COVERAGE pc on op.ID = pc.OWNER_POLICY_ID and pc.PURGE_DT is null
                         and t.TYPE_CD = pc.TYPE_CD and t.SUB_TYPE_CD = pc.SUB_TYPE_CD
                                        and pc.START_DT >= t.MAX_START_DT
                                        --and op.EXPIRATION_DT != pc.END_DT
group by op.ID, pc.ID, t.EXPIRATION_DT, pc.TYPE_CD, pc.SUB_TYPE_CD

SELECT 'PCs To Be Updated', Pc.ID, PC.OWNER_POLICY_ID, pc.END_DT, t.EXPIRATION_DT
from POLICY_COVERAGE pc
   join #tmpCurrentPC t on pc.ID = t.PC_ID
where pc.END_DT = t.MAX_END_DT

END

--BEGIN /* UPDATES */
--	update op
--	set op.STATUS_CD = @ExpiredStatus, op.EXPIRATION_DT = t.New_Exp_Date, 
--	op.UPDATE_DT = getdate(), op.UPDATE_USER_TX = @task, op.LOCK_ID = (op.LOCK_ID % 255) + 1
--	from OWNER_POLICY op
--	join #tmpPolicies t on t.OP_ID = op.ID

--	 update pc
--	 set pc.END_DT = t.EXPIRATION_DT, UPDATE_DT = getdate(), pc.UPDATE_USER_TX = @task, pc.LOCK_ID = (pc.LOCK_ID % 255 ) + 1
--	 from POLICY_COVERAGE pc
--	   join #tmpCurrentPC t on pc.ID = t.PC_ID
--	where pc.END_DT = t.MAX_END_DT

--END /* UPDATES */

--END /* -- OP & PC Records */


	
