USE [msdb]
GO

/****** Object:  Job [Revert from Impairment Pending]    Script Date: 10/8/2019 9:28:33 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 10/8/2019 9:28:33 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Revert from Impairment Pending', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Revert from Impairment Pending]    Script Date: 10/8/2019 9:28:34 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Revert from Impairment Pending', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/*

	TFS 50654/50612/50616 - Revert Incorrect Impairment PEnding back to Borrower Ins Pending
		End Date Impairments to be Impairment Start Date
		Mark IH as in house
		RC Expsoure date = OP Expiration
		If good thru is before OP Effective Date = Change to Effective Date
		add property change records for Coverage Statuses

		

*/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
           WHERE TABLE_NAME = N''CREATE Table Temp_TFS50654'' and TABLE_SCHEMA = ''dbo'')
BEGIN
	CREATE Table [dbo].[Temp_TFS50654]
	(
		[ID] BIGINT IDENTITY(1,1) NOT NULL,
		[REQUIRED_COVERAGE_ID] BIGINT  NULL,
		[IMPAIRMENT_ID] BIGINT  NULL ,
		[CREATE_DT] datetime null
	) on [PRIMARY]


END

IF OBJECT_ID(N''tempdb..#tmp'',N''U'') IS NOT NULL
	DROP TABLE #tmp
IF OBJECT_ID(N''tempdb..#tmpDistCov'',N''U'') IS NOT NULL
	DROP TABLE #tmpDistCov
IF OBJECT_ID(N''tempdb..#tmpImp'',N''U'') IS NOT NULL
	DROP TABLE #tmpImp


BEGIN /* Temp Table Setups */

	select top 10000 cc.EFFECTIVE_DT, rc.id as RC_ID, c.LOAN_ID, rc.PROPERTY_ID as PROP_ID, rc.EXPOSURE_DT as CurrentExposureDt, rc.GOOD_THRU_DT,
	cc.id as OP_ID, rc.INSURANCE_STATUS_CD as CurrentInsStatus, rc.INSURANCE_SUB_STATUS_CD as CurrentInsSubStatus,
	 rc.SUMMARY_STATUS_CD as CurrentSummaryStatus, rc.SUMMARY_SUB_STATUS_CD as CurrentSummarySubStatus,
	op.STATUS_CD as OP_STATUS, op.SUB_STATUS_CD as OP_SUB_STATUS,
	imp.id as IMP_ID, imp.CODE_CD as IMP_CODE, imp.START_DT as IMP_END_DT,
	pcuBeforeChanges.*, InsStatusChange.*
	into #tmp
	from REQUIRED_COVERAGE rc
	join COLLATERAL c on c.PROPERTY_ID = rc.PROPERTY_ID and c.PRIMARY_LOAN_IN =''Y'' and c.PURGE_DT is null and c.STATUS_CD = ''A''
	join LOAN ln on ln.ID = c.LOAN_ID and ln.PURGE_DT is null and ln.STATUS_CD =''A''
	cross apply dbo.GetCurrentCoverage(rc.PROPERTY_ID, rc.ID, rc.TYPE_CD) cc 
	join OWNER_POLICY op on op.id = cc.ID
	cross APPLY
	(
		select top 1 pivTo.CHANGE_ID
		FROM
		(
		select pcu.CHANGE_ID,pcu.TO_VALUE_TX, pcu.COLUMN_NM, pcu.CREATE_DT
		from PROPERTY_CHANGE_UPDATE pcu
		where pcu.TABLE_ID = rc.id and pcu.TABLE_NAME_TX = ''REQUIRED_COVERAGE''
		) as src
		pivot ( 
		max(src.TO_VALUE_TX) for src.COLUMN_NM in (INSURANCE_STATUS_CD,INSURANCE_SUB_STATUS_CD,EXPOSURE_DT,SUMMARY_STATUS_CD,SUMMARY_SUB_STATUS_CD)
		) as pivTo
		where pivTo.INSURANCE_SUB_STATUS_CD = rc.INSURANCE_SUB_STATUS_CD
		and CREATE_DT > ''9/24/2019''
		order by pivTo.CREATE_DT desc
	) pcuChanges
	cross apply
	(
	select top 1 *
		FROM
		(
		select pcu.CHANGE_ID,pcu.FROM_VALUE_TX, pcu.COLUMN_NM, pcu.CREATE_DT
		from PROPERTY_CHANGE_UPDATE pcu
		where pcu.TABLE_ID = rc.id and pcu.TABLE_NAME_TX = ''REQUIRED_COVERAGE''
		) as src
		pivot ( 
		max(src.FROM_VALUE_TX) for src.COLUMN_NM in (INSURANCE_STATUS_CD,INSURANCE_SUB_STATUS_CD,EXPOSURE_DT,SUMMARY_STATUS_CD,SUMMARY_SUB_STATUS_CD)
		) as pivFrom
		where pivFrom.CHANGE_ID = pcuChanges.CHANGE_ID
		order by pivFrom.CREATE_DT desc
	) as pcuBeforeChanges
	outer apply 
	(
		select top 1 Change_ID as InsStatusChangeID, to_value_tx as InsStatusFrom
		from property_change_update
		where table_id= rc.id and TABLE_NAME_TX = ''REQUIRED_COVERAGE''
		and column_nm = ''INSURANCE_STATUS_CD'' and to_VALUE_TX = rc.insurance_status_cd
		order by create_dt desc

	) InsStatusChange
	join IMPAIRMENT imp on imp.REQUIRED_COVERAGE_ID = rc.ID and imp.CURRENT_IMPAIRED_IN =''Y''  and imp.PURGE_DT is null 
								and convert(varchar(10),imp.START_DT,101) = convert(varchar(10),pcuBeforeChanges.CREATE_DT,101)
								and imp.CODE_CD in (''IC'',''NS'',''NC'')
	where rc.STATUS_CD = ''A'' 
	and rc.PURGE_DT is NULL
	and rc.INSURANCE_STATUS_CD = ''P''
	and rc.INSURANCE_SUB_STATUS_CD =''I''
	and rc.UPDATE_DT > ''09/25/2019''
	and op.EFFECTIVE_DT > ''10/1/2019''


	select distinct ldr.CODE_TX as Lender, l.NUMBER_TX as loanNumber, t.Effective_dt, t.good_thru_dt, t.rc_id, rc.TYPE_CD as CoverageType, 
		t.CurrentInsStatus, t.CurrentInsSubStatus, t.CurrentExposureDt,
		 t.OP_ID, t.OP_STATUS, t.OP_SUB_STATUS,
		 change_id, t.Create_dt as ChangeCreateDt, 
		 t.Insurance_status_cd as PreviousInsStatus, t.INSURANCE_SUB_STATUS_CD as PreviousInsSubStatus,
		 t.InsStatusFrom, t.InsStatusChangeID, t.Exposure_dt as PreviousExposureDt,
		 t.Summary_status_cd as PreviousSummaryStatus, t.Summary_sub_status_cd as PreviousSummarySubStatus,
		 t.LOAN_ID, t.PROP_ID, ih.id as IH_ID, t.IMP_END_DT
	into #tmpDistCov
	from #tmp t
	join loan l on l.id = t.loan_id
	join lender ldr on ldr.id = l.LENDER_ID
	join REQUIRED_COVERAGE rc on rc.id = t.RC_ID
	join interaction_history ih on ih.relate_id = t.RC_ID and ih.property_id= t.PROP_ID and ih.TYPE_CD=''IMPAIRMENT'' 
			and convert(varchar(10),ih.effective_Dt,101) = convert(varchar(10),t.IMP_END_DT,101)
	order by t.effective_dt, t.good_thru_dt


	Select distinct t.RC_ID, t.PROP_ID, t.CurrentInsSubStatus, t.OP_SUB_STATUS, t.IMP_ID, t.IMP_END_DT
	into #tmpImp
	from #tmp t

END /* temp table setups */

BEGIN /* Backup Temp Table Inserts */

	insert into dbo.Temp_TFS50654
	select RC_ID, IMP_ID, GETDATE()
	from #tmpIMP
END /* Backup Temp Table Inserts */

DECLARE @task varchar=''TFS50654''

BEGIN /* Update Required Coverage Status */

	update rc 
	set INSURANCE_SUB_STATUS_CD = t.OP_SUB_STATUS, SUMMARY_SUB_STATUS_CD = t.OP_SUB_STATUS,
	Good_THRU_DT =
	CASE WHEN rc.Good_THRU_DT < t.effective_dt then t.effective_dt
		 ELSE rc.GOOD_THRU_DT
	END,
	UPDATE_DT = GETDATE(), UPDATE_USER_TX = @task, LOCK_ID = (rc.LOCK_ID % 255 ) + 1
	from #tmpDistCov t
	join REQUIRED_COVERAGE rc on rc.id = t.RC_ID

End /* Update Required Coverage Status */

BEGIN /* Update Impairments */

	update imp 
	set END_DT = imp.START_DT, CURRENT_IMPAIRED_IN = ''N'',
	UPDATE_DT = GETDATE(), UPDATE_USER_TX = @task, LOCK_ID = (imp.LOCK_ID % 255 ) + 1	
	from #tmpImp t
	join IMPAIRMENT imp on imp.id = t.IMP_ID

END /* Update Impairments */

BEGIN /* Mark IH Internal */

	update ih 
	set IN_HOUSE_ONLY_IN = ''Y'',
	UPDATE_DT = GETDATE(), UPDATE_USER_TX = @task, LOCK_ID = (ih.LOCK_ID % 255 ) + 1
	from #tmpDistCov t
	join interaction_history ih on ih.id = t.IH_ID

END /* Mark IH Internal */

BEGIN /* --  Insert Pc & PCU records for RC */
  		
	  declare @rcID bigint = 0,
	          @propID bigint = 0,
			  @impID bigint = 0,
			  @currentInsSubStatus nvarchar(2) = null,
			  @PrevInsSubStatus varchar(2) = null,
			  @impEndDt datetime2(7)
	  declare itemCursor cursor for
	  select distinct RC_ID, PROP_ID, IMP_ID, CurrentInsSubStatus, OP_SUB_STATUS, IMP_END_DT from #tmpImp ;

	  open itemCursor

	  fetch next from itemCursor into @rcID, @propID, @impID, @currentInsSubStatus, @PrevInsSubStatus, @impEndDt

	  WHILE @@FETCH_STATUS = 0
	  BEGIN	 

		declare @propChangeID bigint = 0
		
		-- Insert into Property Change Table
		Insert into PROPERTY_CHANGE (ENTITY_NAME_TX,ENTITY_ID,USER_TX,ATTACHMENT_IN,CREATE_DT,DETAILS_IN,FORMATTED_IN,LOCK_ID,PARENT_NAME_TX,PARENT_ID,TRANS_STATUS_CD,UTL_IN)
			values (''Allied.UniTrac.RequiredCoverage'',@rcID,@Task,''N'',getdate(),''Y'',''N'',1,''Allied.UniTrac.Property'',@propID,''PEND'',''N'')
		set @propChangeID = SCOPE_IDENTITY()

		if (@propChangeID <> 0)
		begin
			-- Insert into Property Change Update Table

			--SUMMARY_SUB_STATUS_CD
			insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
				values(@propChangeID,''REQUIRED_COVERAGE'',@rcID,''SUMMARY_SUB_STATUS_CD'',@currentInsSubStatus,@PrevInsSubStatus,2,getdate(),''Y'',''U'')


			--INSURANCE_SUB_STATUS_CD
			insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
				values(@propChangeID,''REQUIRED_COVERAGE'',@rcID,''INS_SUMMARY_SUB_STATUS'',@currentInsSubStatus,@PrevInsSubStatus,2,getdate(),''Y'',''U'')
		
			--IMPAIRMENT END DATE
			insert into PROPERTY_CHANGE_UPDATE (CHANGE_ID,TABLE_NAME_TX,TABLE_ID,COLUMN_NM,FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
				values(@propChangeID,''IMPAIRMENT'',@impID,''END_DT'',NULL,@impEndDt,10,getdate(),''Y'',''U'')		

		END

		fetch next from itemCursor into @rcID, @propID, @impID, @currentInsSubStatus, @PrevInsSubStatus, @impEndDt
	  END

	  close itemCursor;
	  deallocate itemCursor; 
end /* --  Insert Pc & PCU records for RC */


', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Revert from Impairment Pending', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20191007, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'b1596db6-4f26-459c-83c8-55de87e0085a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

