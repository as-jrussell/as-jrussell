use unitrac

​

/*
	TFS 46595
	Nationwide, lender 4663
	I have a lender that returned their billing; and they want to wave the loan & CPI on 252 loans. 
	I wanted to see if I provided a spreadsheet of the loans; if a script could be ran to process this. 
	If it is possible; please let me know and I will provide the list.

	1. CPI Status - B (binder)
	2. CPI Sub Status - C (CPI)
	3. Exposure Date - FPC Expiration Date
	4. Summary Status - B (binder)
	5. Summary Sub Status - C (CPI)
	6. RC Status = W (waive)
	6. FPC Cancellation 
		Status = C, Cancellation Date = today

	7. CPI Activity
		Insert Cancel Activity - Flat Cancelled, WAIVE Reason. Start Date = FPC Effective, End Date = FPC Expiration, reporting cancel date = FPC Effective
		

	Adjust RC Status & clear good thru date
	Clear Notice Cycle Information
	Create PC & PCU records
	Revert OP & PC to prior status and end/exp dates


*/
	
IF OBJECT_ID(N'tempdb..#tmpWaiveRCs',N'U') IS NOT NULL
	DROP TABLE #tmpWaiveRCs


    CREATE TABLE #tmpWaiveRCs
    (
      LOAN_ID BIGINT ,
      RC_ID BIGINT ,
	  PROP_ID BIGINT,
	  FPC_ID BIGinT,
	  LOAN_NO varchar(100),
	  RC_STATUS varchar(2),
      SUMMARY_STATUS VARCHAR(1),
	  SUMMARY_SUB_STATUS VARCHAR(1),
	  CPI_STATUS VARCHAR(1),
	  CPI_SUB_STATUS VARCHAR(1),
	  EXPOSURE_DT DATETIME,
	  NEW_EXPOSURE_DT Datetime,
	  FPC_EFF_DT Datetime,
	  FPC_EXP_DT datetime,
	  CPI_QUOTE_ID BIGINT
    )

Declare @Task varchar(10) = 'TASK46595'
Declare @CPIStatus varchar(2) = 'C'
Declare @BinderStatus varchar(2) = 'B'
Declare @WaiveStatus varchar(2) = 'W'
--Declare @NewExposure datetime = '06/01/2018'
	
INSERT INTO #tmpWaiveRCs
(
    LOAN_ID, RC_ID, PROP_ID, FPC_ID, LOAN_NO, RC_STATUS, SUMMARY_STATUS, SUMMARY_SUB_STATUS, CPI_STATUS, CPI_SUB_STATUS, EXPOSURE_DT, NEW_EXPOSURE_DT, FPC_EFF_DT, FPC_EXP_DT, CPI_QUOTE_ID
)
select 
 l.ID, RC.ID, RC.PROPERTY_ID, fpc.id, l.NUMBER_TX, rc.STATUS_CD, rc.SUMMARY_STATUS_CD, rc.SUMMARY_SUB_STATUS_CD, rc.CPI_STATUS_CD, rc.CPI_SUB_STATUS_CD, rc.EXPOSURE_DT, fpc.EXPIRATION_DT, fpc.EFFECTIVE_DT, fpc.EXPIRATION_DT, fpc.CPI_QUOTE_ID
from loan l
inner join lender ldr on ldr.id = l.LENDER_ID
inner join COLLATERAL c on c.LOAN_ID = l.ID and c.PURGE_DT is NULL
inner join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = c.PROPERTY_ID and rc.PURGE_DT is NULL
join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on r.REQUIRED_COVERAGE_ID = rc.id
join FORCE_PLACED_CERTIFICATE fpc on fpc.id = r.FPC_ID
where ldr.CODE_TX = '4663' 
 --and rc.INSURANCE_SUB_STATUS_CD = 'R' and (rc.INSURANCE_STATUS_CD = 'F' or rc.INSURANCE_STATUS_CD = 'P')
and l.PURGE_DT is NULL and rc.STATUS_CD <> 'W'
and l.NUMBER_TX in (
'775934',
'772339',
'781103',
'782942',
'785081',
'785928',
'783521',
'773445',
'777554',
'784817',
'778998',
'780548',
'777534',
'780639',
'771305',
'763006',
'784282',
'757949',
'773853',
'774035',
'785510',
'784471',
'784435',
'770108',
'759213',
'778303',
'777611',
'781024',
'782013',
'780476',
'780993',
'758072',
'779853',
'775993',
'776994',
'778445',
'778543',
'782104',
'770059',
'776946',
'783718',
'782809',
'773618',
'784788',
'775109',
'784111',
'784674',
'770256',
'766005',
'776480',
'782442',
'778137',
'769548',
'774779',
'778865',
'785086',
'778102',
'779475',
'766157',
'763709',
'777241',
'776596',
'779262',
'783280',
'777798',
'783028',
'770429',
'782756',
'779952',
'776116',
'782965',
'777988',
'778897',
'779742',
'782886',
'782958',
'772132',
'755504',
'777589',
'781556',
'776692',
'771257',
'776764',
'780730',
'766380',
'783044',
'767949',
'780133',
'784523',
'775539',
'785406',
'764242',
'779127',
'777880',
'775575',
'762437',
'785900',
'772498',
'775880',
'780861',
'775985',
'781385',
'774914',
'781759',
'778320',
'782408',
'774619',
'785488',
'776007',
'779540',
'782150',
'776371',
'784294',
'781663',
'785715',
'781920',
'763756',
'781013',
'783942',
'778197',
'780127',
'779579',
'780463',
'776865',
'779316',
'778266',
'776960',
'780562',
'781673',
'782545',
'776689',
'784444',
'785897',
'779276',
'776662',
'768590',
'780668',
'777532',
'783529',
'780842',
'777628',
'769804',
'785398',
'777123',
'781997',
'784793',
'771698',
'778049',
'780713',
'758799',
'786378',
'784731',
'783394',
'777867',
'781316',
'784334',
'780061',
'781031',
'784641',
'785131',
'771175',
'770836',
'770118',
'781834',
'771999',
'776024',
'784348',
'765390',
'780099',
'759056',
'780324',
'784840',
'785330',
'766205',
'783597',
'770007',
'786163',
'775467',
'782831',
'777428',
'773536',
'781382',
'781421',
'772959',
'785688',
'763163',
'780245',
'756352',
'773830',
'781884',
'776067',
'774609',
'772140',
'782665',
'779834',
'777960',
'780490',
'778242',
'777809',
'782450',
'777180',
'780817',
'780020',
'772800',
'767351',
'759671',
'776622',
'769582',
'779930',
'778617',
'780856',
'784017',
'772666',
'779208',
'783805',
'780945',
'785077',
'783411',
'772913',
'765041',
'779869',
'771383',
'778073',
'785540',
'769436',
'764933',
'779134',
'785648',
'781969',
'785838',
'773383',
'780067',
'759926',
'786232',
'781466',
'777486',
'753953',
'780319',
'784597',
'781512',
'777717',
'785158',
'775958',
'783206',
'777557',
'778592',
'774819',
'775714',
'776678',
'786151',
'782768',
'767291',
'782033',
'786103',
'783402',
'783271',
'781453',
'785659',
'777206',
'780257',
'763377',
'778428',
'785467',
'785885',
'781548',
'777567',
'781037',
'785854',
'765185',
'784421',
'776517',
'778710')
AND fpc.NUMBER_TX in 
(
'MQE0001358',
'MQE0002106',
'MQE0002475',
'MQE0002107',
'MQE0002108',
'MQE0002105',
'MQE0002104',
'MQM0018904',
'MQM0018901',
'MQE0001467',
'MQE0001245',
'MQE0002098',
'MQM0018970',
'MQM0018946',
'MQE0001465',
'MQM0018895',
'MQE0002090',
'MQE0002025',
'MQM0018896',
'MQE0001355',
'MQE0001313',
'MQM0019477',
'MQE0001458',
'MQE0001218',
'MQE0001463',
'MQM0018966',
'MQE0001359',
'MQE0001322',
'MQE0002091',
'MQM0019461',
'MQE0001399',
'MQM0018944',
'MQE0001390',
'MQE0001408',
'MQE0001404',
'MQM0018973',
'MQM0018885',
'MQE0001443',
'MQE0002072',
'MQE0002054',
'MQE0001924',
'MQE0001157',
'MQE0002062',
'MQE0001177',
'MQE0001378',
'MQE0001291',
'MQE0002059',
'MQE0002058',
'MQE0002081',
'MQM0018882',
'MQE0001434',
'MQM0019468',
'MQE0001975',
'MQE0002053',
'MQE0001464',
'MQE0001968',
'MQE0001987',
'MQE0001967',
'MQM0019464',
'MQE0001200',
'MQE0002009',
'MQM0019455',
'MQE0002041',
'MQE0002050',
'MQM0019498',
'MQM0019463',
'MQM0019494',
'MQE0001215',
'MQE0001388',
'MQM0018954',
'MQM0019505',
'MQE0001266',
'MQE0001260',
'MQE0001908',
'MQE0002005',
'MQE0001459',
'MQE0002076',
'MQE0001274',
'MQE0001213',
'MQM0019413',
'MQE0001234',
'MQE0001384',
'MQE0001447',
'MQE0001928',
'MQM0018898',
'MQE0002086',
'MQM0019503',
'MQE0002087',
'MQE0002006',
'MQE0001888',
'MQE0001320',
'MQE0001953',
'MQE0001363',
'MQE0001268',
'MQE0001242',
'MQE0001450',
'MQE0001462',
'MQM0018962',
'MQE0001468',
'MQE0001426',
'MQE0001341',
'MQE0002019',
'MQE0001308',
'MQE0001344',
'MQE0001197',
'MQE0001891',
'MQE0001294',
'MQE0001454',
'MQM0018956',
'MQE0002077',
'MQE0001445',
'MQE0001880',
'MQE0001326',
'MQE0002028',
'MQM0019418',
'MQE0001438',
'MQE0001444',
'MQE0001297',
'MQE0001472',
'MQM0019487',
'MQE0001971',
'MQE0001977',
'MQE0002002',
'MQE0001421',
'MQE0001230',
'MQE0001246',
'MQE0001403',
'MQE0001999',
'MQE0002079',
'MQE0001170',
'MQE0001420',
'MQE0001475',
'MQM0019466',
'MQE0002017',
'MQE0001327',
'MQE0002088',
'MQE0001225',
'MQM0019452',
'MQE0002074',
'MQM0019485',
'MQE0002057',
'MQM0019478',
'MQE0001379',
'MQE0001913',
'MQE0001285',
'MQE0001473',
'MQE0001907',
'MQE0001193',
'MQE0001194',
'MQE0001912',
'MQE0001427',
'MQE0001916',
'MQE0001305',
'MQE0001237',
'MQM0018917',
'MQE0001267',
'MQE0001253',
'MQM0019448',
'MQE0001877',
'MQE0001437',
'MQE0001414',
'MQE0001316',
'MQE0001366',
'MQE0001897',
'MQE0001235',
'MQE0001965',
'MQE0001275',
'MQE0002045',
'MQE0001347',
'MQM0019469',
'MQE0001457',
'MQE0001243',
'MQE0002049',
'MQE0001387',
'MQE0001909',
'MQE0001960',
'MQE0001158',
'MQE0001163',
'MQM0019473',
'MQE0001203',
'MQM0019422',
'MQE0001455',
'MQM0018902',
'MQE0001991',
'MQE0001184',
'MQE0002031',
'MQE0001271',
'MQM0018935',
'MQE0001166',
'MQE0002095',
'MQE0001994',
'MQE0001413',
'MQM0018921',
'MQE0001217',
'MQE0001882',
'MQE0001950',
'MQE0001250',
'MQE0001933',
'MQM0018950',
'MQE0001252',
'MQE0002082',
'MQE0001190',
'MQE0001214',
'MQM0019482',
'MQE0001367',
'MQE0001295',
'MQE0001883',
'MQE0001296',
'MQE0001978',
'MQE0001328',
'MQE0001992',
'MQE0002007',
'MQE0001402',
'MQM0019425',
'MQM0018909',
'MQM0018905',
'MQE0002023',
'MQE0001996',
'MQE0001871',
'MQM0018903',
'MQM0019467',
'MQE0002066',
'MQM0019493',
'MQE0002030',
'MQE0001270',
'MQE0001393',
'MQE0001868',
'MQE0001895',
'MQE0001409',
'MQE0001401',
'MQM0018884',
'MQE0002085',
'MQM0019459',
'MQE0001365',
'MQM0019453',
'MQM0018881',
'MQM0018910',
'MQE0002034',
'MQE0001283',
'MQE0001872',
'MQM0019427',
'MQE0001222',
'MQM0019446',
'MQM0019450',
'MQM0019454',
'MQE0001406',
'MQE0001376',
'MQE0001417',
'MQM0019420',
'MQE0001350',
'MQM0018934',
'MQM0018922',
'MQE0001863',
'MQE0002093',
'MQM0019430',
'MQE0002064',
'MQE0001422',
'MQE0001461',
'MQE0001474',
'MQM0019462',
'MQE0001273',
'MQE0001240',
'MQE0001372',
'MQE0001867',
'MQM0018930',
'MQM0019460',
'MQE0001345',
'MQM0018920',
'MQE0001346',
'MQM0018899',
'MQM0019421',
'MQE0002094')


/* RC Updates */
update rc 
set CPI_STATUS_CD = @BinderStatus, CPI_SUB_STATUS_CD = @CPIStatus, SUMMARY_STATUS_CD = @BinderStatus, SUMMARY_SUB_STATUS_CD = @CPIStatus, 
	STATUS_CD = @WaiveStatus, EXPOSURE_DT = t.NEW_EXPOSURE_DT
	,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (rc.LOCK_ID % 255 ) + 1
from #tmpWaiveRCs t
join REQUIRED_COVERAGE rc on rc.ID = t.RC_ID


/* FPC Updates */

update fpc 
set STATUS_CD = 'C', CANCELLATION_DT = getdate(), ACTIVE_IN = 'N', BILLING_STATUS_CD = 'CLSD',
UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (fpc.LOCK_ID % 255 ) + 1
from #tmpWaiveRCs t
join FORCE_PLACED_CERTIFICATE fpc on fpc.id = t.FPC_ID
where fpc.CANCELLATION_DT is null


/* CPI Quote Updates */
update cpi 
set CLOSE_DT = getdate(), CLOSE_REASON_CD = 'DOC', 
update_dt = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (cpi.LOCK_ID % 255 ) + 1
from #tmpWaiveRCs t
join FORCE_PLACED_CERTIFICATE fpc on fpc.id = t.FPC_ID
join CPI_QUOTE cpi on cpi.id = fpc.CPI_QUOTE_ID
where fpc.CANCELLATION_DT is null and 
cpi.CLOSE_DT is null


select 'updated', * from #tmpWaiveRCs

--select SPECIAL_HANDLING_XML.value('(/SH/Event)[1]', 'nvarchar(max)'), *
--from #tmpWaiveRCs t

--join INTERACTION_HISTORY ih on ih.PROPERTY_ID = t.PROP_ID and ih.TYPE_CD = 'CPI' and ih.RELATE_ID = t.FPC_ID
--join FORCE_PLACED_CERTIFICATE fpc on fpc.id = t.FPC_ID

--where fpc.CANCELLATION_DT is   null
----and fpc.NUMBER_TX in (
----'MQE0001166',
----'MQM0018970',
----'MQE0001190',
----'MQE0002050',
----'MQE0002108')
----order by a.CPI_QUOTE_ID

BEGIN /* --  Insert Pc & PCU records for RC */
  		

	  declare @rcID bigint = 0,
	          @propID bigint = 0,
			  @currentSummaryStatus varchar(1) = null,
			  @currentSummarySubStatus varchar(1) = null,
			  @currentCPIStatus varchar(1) = null,
			  @currentCPISubStatus varchar(1) = null,
			  @currentRCStatus varchar(1) = null,
			  @currentExposure datetime = null,
			  @newExposure_ExpDt datetime = null,
			  @fpcID bigint = 0,
			  @cpiQuoteID bigint = 0,
			  @fpcEffDate datetime

	  declare itemCursor cursor for
	  select RC_ID, PROP_ID, t.SUMMARY_STATUS, t.SUMMARY_SUB_STATUS, t.CPI_STATUS, t.CPI_SUB_STATUS, t.RC_STATUS, 
	  t.EXPOSURE_DT, t.NEW_EXPOSURE_DT, FPC_ID, t.CPI_QUOTE_ID, t.FPC_EFF_DT
	  from #tmpWaiveRCs t
	  join REQUIRED_COVERAGE rc on rc.id = t.RC_ID;

	  open itemCursor

	  fetch next from itemCursor into @rcID, @propID, @currentSummaryStatus, @currentSummarySubStatus, @currentCPIStatus, @currentCPISubStatus,
			@currentRCStatus, @currentExposure, @newExposure_ExpDt, @fpcID, @cpiQuoteID, @fpcEffDate

	  WHILE @@FETCH_STATUS = 0
	  BEGIN	  

		begin transaction

		declare @propChangeID bigint = 0
		declare @totalPremAmt as DECIMAL = 0
		declare @cpiActivityID bigint = 0
		declare @ftxID bigint = 0
		declare @ihIDFPC bigint = 0

		-- Insert into Property Change Table
		Insert into PROPERTY_CHANGE (ENTITY_NAME_TX,ENTITY_ID,USER_TX,ATTACHMENT_IN,CREATE_DT,DETAILS_IN,FORMATTED_IN,LOCK_ID,PARENT_NAME_TX,PARENT_ID,TRANS_STATUS_CD,UTL_IN)
			values ('Allied.UniTrac.RequiredCoverage',@rcID,@Task,'N',getdate(),'Y','N',1,'Allied.UniTrac.Property',@propID,'PEND','N')
		set @propChangeID = SCOPE_IDENTITY()

		if (@propChangeID <> 0)
		begin
		-- Insert into Property Change Update Table
		
		--STATUS_CD
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'STATUS_CD',@currentRCStatus,@WaiveStatus,2,getdate(),'Y','U')

		--SUMMARY_STATUS_CD
		if (@currentSummaryStatus <> @BinderStatus)
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'SUMMARY_STATUS_CD',@currentSummaryStatus,@BinderStatus,2,getdate(),'Y','U')

		--SUMMARY_SUB_STATUS_CD
		if (@currentSummarySubStatus <> @CPIStatus)
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'SUMMARY_SUB_STATUS_CD',@currentSummarySubStatus,@CPIStatus,2,getdate(),'Y','U')

		--EXPOSURE_DT
		if (@currentExposure <> @newExposure_ExpDt)
		BEGIN
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'EXPOSURE_DT',@currentExposure,@newExposure_ExpDt,2,getdate(),'Y','U')
		END

		--CPI_STATUS_CD
		if (@currentCPIStatus <> @BinderStatus)
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'CPI_STATUS_CD',@currentCPIStatus,@BinderStatus,2,getdate(),'Y','U')

		--CPI_SUB_STATUS_CD
		if (@currentCPISubStatus <> @CPIStatus)
		insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
			values(@propChangeID,'REQUIRED_COVERAGE',@rcID,'CPI_SUB_STATUS_CD',@currentCPISubStatus,@CPIStatus,2,getdate(),'Y','U')


		END

		select @totalPremAmt = (TOTAL_PREMIUM_NO * -1) from CPI_ACTIVITY where CPI_QUOTE_ID = @cpiQuoteID and TYPE_CD = 'I'
		/* CPI Activty Insert */
		if Not Exists (select Id from CPI_ACTIVITY where CPI_QUOTE_ID = @cpiQuoteID AND TYPE_CD = 'C' and PURGE_DT is null)
		BEGIN

			/*  CPI Inserts */
			
			insert into CPI_ACTIVITY (CPI_QUOTE_ID, TYPE_CD, PROCESS_DT, TOTAL_PREMIUM_NO, START_DT, END_DT, REASON_CD, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID, PAYMENT_CHANGE_AMOUNT_NO, PRIOR_PAYMENT_AMOUNT_NO, NEW_PAYMENT_AMOUNT_NO, EARNED_PAYMENT_AMOUNT_NO)
				values (@cpiQuoteID, 'C', getdate(), @totalPremAmt, @fpcEffDate, @newExposure_ExpDt, 'WAIVE', getdate(), getdate(), @Task, 1, 0.0, 0.0, 0.0, 0.0)
			set @cpiActivityID = SCOPE_IDENTITY()
		
			if (@cpiActivityID <>0)
			BEGIN
				insert into CERTIFICATE_DETAIL (CPI_ACTIVITY_ID, TYPE_CD, AMOUNT_NO, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
					values (@cpiActivityID, 'PRM', @totalPremAmt, getdate(), getdate(), @Task, 1)
			END

		

			/* FTX Activty Insert */
			if Not Exists (select Id from FINANCIAL_TXN where FPC_ID = @fpcID AND TXN_TYPE_CD = 'C' and PURGE_DT is null)
			BEGIN

				/*  FTX Inserts */
				insert into FINANCIAL_TXN (FPC_ID, LFT_ID, AP_ID, TXN_TYPE_CD, AMOUNT_NO, TXN_DT, REASON_TX, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
					values (@fpcID, 0,0,'C',@totalPremAmt,getdate(),'Waive',getdate(), getdate(), @Task, 1)
				set @ftxID = SCOPE_IDENTITY()
		
				if (@ftxID <> 0 )
				BEGIN
					insert into CERTIFICATE_DETAIL (CPI_ACTIVITY_ID, TYPE_CD, AMOUNT_NO, CREATE_DT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
						values (@ftxID, 'PRM', @totalPremAmt, getdate(), getdate(), @Task, 1)
				END

			END
		END


		/* Interaction History Updates */
		declare @ihStatus varchar(30) = 'CPI Cancelled'
		declare @ihAmount varchar(10) = '0.0'
		declare @ihReason varchar(10) = 'Waive'
		declare @ihStatusDate varchar(30) = '8/9/2018 12:00:00 AM'
		declare @ihEvent varchar(10)  = 'Cancel'

		select top 1 @ihIDFPC = ih.id
		from INTERACTION_HISTORY ih
		where ih.PROPERTY_ID = @propID and ih.RELATE_CLASS_TX = 'Allied.UniTrac.ForcePlacedCertificate'
		and ih.RELATE_ID = @fpcID and ih.TYPE_CD = 'CPI'
		order by ih.UPDATE_DT desc

		/* ih status */
		update INTERACTION_HISTORY 
		set SPECIAL_HANDLING_XML.modify('replace value of (/SH/Status/text())[1] with sql:variable("@ihStatus")'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255) + 1
		where ID = @ihIDFPC

		/* ih status date */
		update INTERACTION_HISTORY 
		set SPECIAL_HANDLING_XML.modify('replace value of (/SH/StatusDate/text())[1] with sql:variable("@ihStatusDate")'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255) + 1
		where ID = @ihIDFPC

		/* ih reason */
		update INTERACTION_HISTORY 
		set SPECIAL_HANDLING_XML.modify('replace value of (/SH/Reason/text())[1] with sql:variable("@ihReason")'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255) + 1
		where ID = @ihIDFPC

		/* ih exp date */
		update INTERACTION_HISTORY 
		set SPECIAL_HANDLING_XML.modify('replace value of (/SH/ExDate/text())[1] with sql:variable("@fpcEffDate")'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255) + 1
		where ID = @ihIDFPC

		/* ih premium amount */
		update INTERACTION_HISTORY 
		set SPECIAL_HANDLING_XML.modify('replace value of (/SH/Premium/text())[1] with sql:variable("@ihAmount")'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255) + 1
		where ID = @ihIDFPC

		/* ih add/upate event */
		declare @ihtemp varchar(30) = NULL
		SELECT @ihtemp =  SPECIAL_HANDLING_XML.value('(/SH/Event)[1]', 'nvarchar(max)')
			from INTERACTION_HISTORY where ID = @ihIDFPC

		if (@ihtemp = null)
		BEGIN
			update INTERACTION_HISTORY
			set UPDATE_DT = GETDATE(), UPDATE_USER_TX = @task,
				LOCK_ID = (LOCK_ID % 255) + 1, SPECIAL_HANDLING_XML.modify('insert <Event>Cancel</Event> into (/SH[1])')
			where ID = @ihIDFPC
		END
		ELSE
		BEGIN
			update INTERACTION_HISTORY 
			set SPECIAL_HANDLING_XML.modify('replace value of (/SH/Event/text())[1] with sql:variable("@ihEvent")'),
				UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255) + 1
			where ID = @ihIDFPC
		end 

		

		commit transaction

		fetch next from itemCursor into @rcID, @propID, @currentSummaryStatus, @currentSummarySubStatus, @currentCPIStatus, @currentCPISubStatus,
			@currentRCStatus, @currentExposure, @newExposure_ExpDt, @fpcID, @cpiQuoteID, @fpcEffDate
	  END



	  close itemCursor;
	  deallocate itemCursor; 
end /* --  Insert Pc & PCU records for RC */



