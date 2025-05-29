SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

DECLARE

	  @queueId   bigint, 
	  @userId bigint = null,
	  @lenderId bigint = null,
	  @userRoles nvarchar(100) = null


BEGIN
	SET NOCOUNT ON

	DECLARE @OpenWI int
	DECLARE @OldestOpenWI date
	DECLARE @OldestOpenWILastReassign date
	DECLARE @WorkedToday int
	DECLARE @OldestWorkedToday date
	DECLARE @OldestWorkedTodayLastReassign date
	DECLARE @WorkedByMe int
	DECLARE @OldestWorkedByMe date
	DECLARE @OldestWorkedByMeLastReassign date
	DECLARE @OK int
	DECLARE @OldestOK date
	DECLARE @OldestOKLastReassign date
	DECLARE @Warning int
	DECLARE @OldestWarning date
	DECLARE @OldestWarningLastReassign date
	DECLARE @Critical int
	DECLARE @OldestCritical date
	DECLARE @OldestCriticalLastReassign date
	DECLARE @InDefault int
	DECLARE @OldestInDefault date
	DECLARE @OldestInDefaultLastReassign date
	DECLARE @Reserved int
	DECLARE @CheckedOut int
	declare @sql nvarchar(max)
	declare @startdate date
	declare @enddate date
	declare @cacheKey nvarchar(100)
	declare @cacheWorkedByUserKey nvarchar(100)
	declare @cacheWorkedTodayKey nvarchar(100)
	declare @cacheExpire datetime
	declare @cacheWorkedByUserExpire datetime
	declare @cacheWorkedTodayExpire datetime

	select @startdate = CAST(getdate() AS DATE) ,
			 @endDate = dateadd(dd, 1, CAST(getdate() AS DATE))

	set @cacheExpire = DATEADD(minute, isnull(convert(int, (select meaning_tx from ref_code where code_cd = 'MyDayQueueCountCacheExpiration' and domain_cd = 'System')), -5), getdate())
	set @cacheWorkedByUserExpire = DATEADD(minute, isnull(convert(int, (select meaning_tx from ref_code where code_cd = 'MyDayWorkedByMeCacheExpiration' and domain_cd = 'System')), -15), getdate())
	set @cacheWorkedTodayExpire = DATEADD(minute, isnull(convert(int, (select meaning_tx from ref_code where code_cd = 'MyDayWorkedTodayCacheExpiration' and domain_cd = 'System')), -15), getdate())

	set @cacheKey = 'Queue: ' + convert(nvarchar(100), @queueId) + '-'+ convert(nvarchar(100), isnull(@lenderId,'0')) + '-' + isnull(@userRoles,'')
	set @cacheWorkedByUserKey = 'WorkedByUser: ' + convert(nvarchar(100), isnull(@userId,'0')) + '-'+ convert(nvarchar(100), isnull(@lenderId,'0')) 
	set @cacheWorkedTodayKey = 'WorkedToday: ' + convert(nvarchar(100), isnull(@userId,'0')) + '-'+ convert(nvarchar(100), isnull(@lenderId,'0')) 

	-------------------------------------------------------------------------------------------------------------------------------------------------
	---- POPULATE THE WORKED BY ME VALUES
	-------------------------------------------------------------------------------------------------------------------------------------------------
	select @WorkedByMe = WORKED_BY_ME_NO,
		   @OldestWorkedByMe = OLDEST_WORKED_BY_ME_DT,
		   @OldestWorkedByMeLastReassign = OLDEST_WORKED_BY_ME_LAST_REASSIGN_DT
	from
		WORK_QUEUE_COUNT_CACHE
	where
		KEY_TX = @cacheWorkedByUserKey 
		and UPDATE_DT >= @cacheWorkedByUserExpire 

	if @WorkedByMe is null
	BEGIN
		PRINT 'calculating Worked by user'

	  -------------------------------------------------------------------------------
	  -- Count of completed Worked By Me workitems
	  
	  -- @OldestWorkedByMeReassign = min( select max(wia.create_dt) from work_item_action wia where wia.WORK_ITEM_ID = wi.id and wia.ACTION_CD = 'reassign user level' and wia.PURGE_DT is null) ) '

		  select @sql = N'Select @WorkedByMe = count(wi.ID),
								 @OldestWorkedByMe = min(wi.create_dt),
								 @OldestWorkedByMeLastReassign = min(wi.create_dt)
				 FROM 
					dbo.WORK_ITEM_ACTION wia
					INNER JOIN dbo.WORK_ITEM wi on wia.id = wi.last_work_item_action_id
					INNER JOIN dbo.WORK_QUEUE_WORK_ITEM_RELATE wqwi on wqwi.WORK_ITEM_ID = wi.ID
					INNER JOIN dbo.WORK_QUEUE wq on wq.ID = wqwi.WORK_QUEUE_ID
				 WHERE 
					   wqwi.WORK_QUEUE_ID = @queueId
					   AND wqwi.CROSS_QUEUE_COUNT_IND = ''Y''
					   AND wi.STATUS_CD = ''Complete''
					   ' + case when @userID is not null then 'AND wia.ACTION_USER_ID = @userId' else '' end + '
					   ' + case when @lenderId is not null then 'AND wi.content_xml.value(''Content[1]/Lender[1]/Id[1]'',''bigint'') = @lenderId' else '' end + ' 
					   AND wi.UPDATE_DT >= @startdate and wi.Update_dt < @enddate
					   AND WI.PURGE_DT IS NULL
					   AND WQWI.PURGE_DT IS NULL
			   AND wia.PURGE_DT IS NULL
					   AND wq.ACTIVE_IN=''Y'''
		  exec sp_executesql @sql, 
				N'@queueID bigint, @lenderId bigint, @userID bigint, @startdate datetime, @enddate datetime, @WorkedByMe int output, @OldestWorkedByMe date output, @OldestWorkedByMeLastReassign date output', 
				@queueID, @lenderId, @userID, @startdate, @enddate, @WorkedByMe output, @OldestWorkedByMe output, @OldestWorkedByMeLastReassign output 
				with recompile
	
		  UPDATE WORK_QUEUE_COUNT_CACHE 
		  SET WORKED_BY_ME_NO = @WorkedByMe,
			  OLDEST_WORKED_BY_ME_DT = @OldestWorkedByMe,
			  OLDEST_WORKED_BY_ME_LAST_REASSIGN_DT = @OldestWorkedByMeLastReassign,
			  UPDATE_DT = GETDATE()
		  WHERE 
				KEY_TX = @cacheWorkedByUserKey

		  IF @@ROWCOUNT = 0 
			  INSERT INTO WORK_QUEUE_COUNT_CACHE (KEY_TX, WORKED_BY_ME_NO, OLDEST_WORKED_BY_ME_DT, OLDEST_WORKED_BY_ME_LAST_REASSIGN_DT, CREATE_DT, UPDATE_DT)
			  VALUES (@cacheWorkedByUserKey, @WorkedByMe, @OldestWorkedByMe, @OldestWorkedByMeLastReassign, getdate(), getdate())
	END



	-------------------------------------------------------------------------------------------------------------------------------------------------
	---- POPULATE THE WORKED TODAY VALUES
	-------------------------------------------------------------------------------------------------------------------------------------------------
	select @WorkedToday = WORKED_TODAY_NO,
		   @OldestWorkedToday = OLDEST_WORKED_TODAY_DT,
		   @OldestWorkedTodayLastReassign = OLDEST_WORKED_TODAY_LAST_REASSIGN_DT
	from
		WORK_QUEUE_COUNT_CACHE
	where
		KEY_TX = @cacheWorkedTodayKey 
		and UPDATE_DT >= @cacheWorkedTodayExpire 

	if @WorkedToday is null
	BEGIN
		PRINT 'calculating Worked Today'

		  -------------------------------------------------------------------------------
		  -- Count of completed Worked Today workitems
		  -- @OldestWorkedTodayReassign = min( select max(wia.create_dt) from work_item_action wia where wia.WORK_ITEM_ID = wi.id and wia.ACTION_CD = 'reassign user level' and wia.PURGE_DT is null) ) '
		  set @sql = 'SELECT @WorkedToday = count(wi.ID), 
							 @OldestWorkedToday = min(wi.create_dt),
							 @OldestWorkedTodayLastReassign = min(wi.create_dt)
				FROM 
				dbo.WORK_ITEM wi 
				inner join dbo.WORK_QUEUE_WORK_ITEM_RELATE wqwi on wi.ID = wqwi.WORK_ITEM_ID
				INNER JOIN dbo.WORK_ITEM_ACTION wia ON wi.ID = wia.WORK_ITEM_ID
				INNER JOIN dbo.WORK_QUEUE wq on wq.ID = wqwi.WORK_QUEUE_ID
				WHERE 
				wqwi.WORK_QUEUE_ID = @queueId
				AND wqwi.CROSS_QUEUE_COUNT_IND = ''Y''
				AND wi.LAST_WORK_ITEM_ACTION_ID = wia.id
				AND wi.STATUS_CD = ''Complete''
				AND wia.TO_STATUS_CD = ''Complete''
				   AND wi.UPDATE_DT >= @startdate and wi.Update_dt < @endDate
				' + case when @lenderId is not null then 'AND wi.content_xml.value(''Content[1]/Lender[1]/Id[1]'',''bigint'') = @lenderId' else '' end + ' 
				AND WI.PURGE_DT IS NULL
				AND WQWI.PURGE_DT IS NULL
				AND wia.PURGE_DT is NULL
				AND wq.ACTIVE_IN=''Y'''
		  exec sp_executesql @sql, 
		                     N'@queueID bigint, @lenderId bigint, @startdate datetime, @enddate datetime, @WorkedToday int output, @OldestWorkedToday date output, @OldestWorkedTodayLastReassign date output', 
							 @queueID, @lenderId, @startdate, @enddate, @WorkedToday output, @OldestWorkedToday output, @OldestWorkedTodayLastReassign output 
							 with recompile

		  UPDATE WORK_QUEUE_COUNT_CACHE 
		  SET WORKED_TODAY_NO = @WorkedToday,
			  OLDEST_WORKED_TODAY_DT = @OldestWorkedToday,
			  OLDEST_WORKED_TODAY_LAST_REASSIGN_DT = @OldestWorkedTodayLastReassign,
			  UPDATE_DT = GETDATE()
		  WHERE 
				KEY_TX = @cacheWorkedTodayKey

		  IF @@ROWCOUNT = 0 
			  INSERT INTO WORK_QUEUE_COUNT_CACHE (KEY_TX, WORKED_TODAY_NO, OLDEST_WORKED_TODAY_DT, OLDEST_WORKED_TODAY_LAST_REASSIGN_DT, CREATE_DT, UPDATE_DT)
			  VALUES (@cacheWorkedTodayKey, @WorkedToday, @OldestWorkedToday, @OldestWorkedTodayLastReassign, getdate(), getdate())
	END	  

	-------------------------------------------------------------------------------------------------------------------------------------------------
	---- POPULATE THE QUEUE SPECIFIC VALUES
	-------------------------------------------------------------------------------------------------------------------------------------------------
	select 
		@OpenWI = [OPEN_WI_NO],
		@OldestOpenWI = [OLDEST_OPEN_WI_DT],
		@OldestOpenWILastReassign = [OLDEST_OPEN_WI_LAST_REASSIGN_DT],
		@OK = [OK_NO],
		@OldestOK = [OLDEST_OK_DT],
		@OldestOKLastReassign = [OLDEST_OK_LAST_REASSIGN_DT],
		@Warning = [WARNING_NO],
		@OldestWarning = [OLDEST_WARNING_DT],
		@OldestWarningLastReassign = [OLDEST_WARNING_LAST_REASSIGN_DT],
		@Critical = [CRITICAL_NO],
		@OldestCritical = [OLDEST_CRITICAL_DT],
		@OldestCriticalLastReassign = [OLDEST_CRITICAL_LAST_REASSIGN_DT],
		@InDefault = [IN_DEFAULT_NO],
		@OldestInDefault = [OLDEST_IN_DEFAULT_DT],
		@OldestInDefaultLastReassign = [OLDEST_IN_DEFAULT_LAST_REASSIGN_DT],
		@Reserved = [RESERVED_NO],
		@CheckedOut = [CHECKED_OUT_NO] 
	FROM 
		WORK_QUEUE_COUNT_CACHE wqcc
	WHERE
		KEY_TX = @cacheKey 
		and UPDATE_DT >= @cacheExpire 

	--- if we have nothing either because no cache hit OR expired then execute the queries
	IF @OpenWI is null 
	BEGIN
		PRINT 'calculating non-user counts'

		IF @lenderId = 0 
			SET @lenderId = null

		IF @userRoles = ''
			SET @userRoles = null

		create table #USER_LEVELS
		(
			USER_ROLE_CD NVARCHAR(100)
		)

		IF @userRoles is not null 
		BEGIN
			INSERT INTO #USER_LEVELS (USER_ROLE_CD)
			SELECT STRVALUE FROM dbo.SplitFunction(@userRoles,',')
		END
		ELSE
		BEGIN
			INSERT INTO #USER_LEVELS (USER_ROLE_CD)
			SELECT CODE_CD FROM REF_CODE WHERE DOMAIN_CD = 'WorkQueueUserLevel' and PURGE_DT is null and ACTIVE_IN = 'Y'
		END

		-- get the counts/dates just for queue
		set @sql = 
			'SELECT  
				@OK = isnull(sum (case when rc.meaning_tx = ''Ok''
							then 1 else 0 end ),0),
				@OldestOK = min(case when rc.meaning_tx = ''Ok'' then wi.CREATE_DT else null end),
				@OldestOKLastReassign = isnull(min(case when rc.meaning_tx = ''Ok'' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = ''Ok'' then wi.CREATE_DT else null end)),

				@Warning = isnull(sum(case when rc.meaning_tx = ''Warning'' 
							   then 1 else 0 end),0),
				@OldestWarning = min(case when rc.meaning_tx = ''Warning'' then wi.CREATE_DT else null end), 
				@OldestWarningLastReassign = isnull(min(case when rc.meaning_tx = ''Warning'' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = ''Warning'' then wi.CREATE_DT else null end)),
			
				@Critical = isnull(sum(case when rc.meaning_tx = ''Critical''
								 then 1 else 0 end),0),
				@OldestCritical = min(case when rc.meaning_tx = ''Critical'' then wi.CREATE_DT else null end),
				@OldestCriticalLastReassign = isnull(min(case when rc.meaning_tx = ''Critical'' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = ''Critical'' then wi.CREATE_DT else null end)),
			
				@InDefault = isnull(sum (case when rc.meaning_tx = ''InDefault'' 					
								  then 1 else 0 end),0),
				@OldestInDefault = min(case when rc.meaning_tx = ''InDefault'' then wi.CREATE_DT else null end),
				@OldestInDefaultLastReassign = isnull(min(case when rc.meaning_tx = ''InDefault'' then wiara.max_reassign_dt else null end), min(case when rc.meaning_tx = ''InDefault'' then wi.CREATE_DT else null end)),
			
				@Reserved = isnull(sum (case when wi.RESERVED_DT IS NOT NULL
								 then 1 else 0 end),0),

				@CheckedOut = isnull(sum( case when WI.CHECKED_OUT_OWNER_ID IS NOT NULL
										AND wi.CHECKED_OUT_DT IS NOT NULL 
								   then 1 else 0 end),0),

				@OpenWI = isnull(sum(case when wq.ACTIVE_IN=''Y''
								 then 1 else 0 end),0),
				@OldestOpenWI = min(case when wq.ACTIVE_IN=''Y'' then wi.CREATE_DT else null end),
				@OldestOpenWILastReassign = isnull(min(case when wq.ACTIVE_IN=''Y'' then wiara.max_reassign_dt else null end), min(case when wq.ACTIVE_IN=''Y'' then wi.CREATE_DT else null end))

			FROM 
				WORK_QUEUE_WORK_ITEM_RELATE wqwi 
				inner join WORK_ITEM wi  			on wqwi.WORK_ITEM_ID = wi.ID
				join WORK_QUEUE wq 					on wq.ID = wqwi.WORK_QUEUE_ID
				left join REF_CODE rc  			on wqwi.SLA_LEVEL_NO = rc.CODE_CD and rc.DOMAIN_CD = ''SLALevel'' 
				left outer join (select wia.work_item_id, max(wia.create_dt) as max_reassign_dt from WORK_ITEM_ACTION wia where
								 wia.ACTION_CD = ''reassign user level'' and wia.PURGE_DT is null group by wia.WORK_ITEM_ID) wiaRA on wiaRA.Work_item_id = wi.id 
			'
		    + case when @userRoles is not null then ' inner join #USER_LEVELS ur on ur.USER_ROLE_CD = wi.USER_ROLE_CD' else '' end
			+ '
			WHERE 
				wqwi.WORK_QUEUE_ID = @queueId
				AND wi.STATUS_CD NOT IN ( ''Complete'', ''Withdrawn'', ''Error'' )
				AND wi.PURGE_DT is NULL
				AND wqwi.PURGE_DT is NULL
				AND wq.purge_dt IS NULL
				AND wqwi.CROSS_QUEUE_COUNT_IND = ''Y''
				AND wq.ACTIVE_IN=''Y'' 
			'
			+ case when @lenderid is not null then 'AND wi.content_xml.value(''Content[1]/Lender[1]/Id[1]'',''bigint'') = @lenderId' else '' end
--			+ ' 			OPTION (optimize for (@queueId = 999)) '

		exec sp_executesql @sql, 
				N'@queueID bigint, @lenderId bigint, @userRoles nvarchar(100), @OK int output , @OldestOK date output , @OldestOKLastReassign date output , @Warning int output , @OldestWarning date output, 
				 @OldestWarningLastReassign date output , @Critical int output , @OldestCritical date output , @OldestCriticalLastReassign date output , @InDefault int output , @OldestInDefault date output , 
				 @OldestInDefaultLastReassign date output , @Reserved int output , @CheckedOut int output, @OpenWI int output, @OldestOpenWI date output, @OldestOpenWILastReassign date output ',
				@queueID, @lenderId, @userRoles, @OK output , @OldestOK output , @OldestOKLastReassign output , @Warning output , @OldestWarning output , @OldestWarningLastReassign output , @Critical output , 
				@OldestCritical output , @OldestCriticalLastReassign output , @InDefault output , @OldestInDefault output , @OldestInDefaultLastReassign output , @Reserved output , @CheckedOut output,
				@openWI output, @OldestOpenWI output, @OldestOpenWILastReassign output
			with recompile
	-- update the cache entry
		update WORK_QUEUE_COUNT_CACHE 
			  SET
				[OPEN_WI_NO] = @OpenWI,
				[OLDEST_OPEN_WI_DT] = @OldestOpenWI,
				[OLDEST_OPEN_WI_LAST_REASSIGN_DT] = @OldestOpenWILastReassign,
				[OK_NO] = @OK,
				[OLDEST_OK_DT] = @OldestOK,
				[OLDEST_OK_LAST_REASSIGN_DT] = @OldestOKLastReassign,
				[WARNING_NO] = @Warning,
				[OLDEST_WARNING_DT] = @OldestWarning,
				[OLDEST_WARNING_LAST_REASSIGN_DT] = @OldestWarningLastReassign,
				[CRITICAL_NO] = @Critical,
				[OLDEST_CRITICAL_DT] = @OldestCritical,
				[OLDEST_CRITICAL_LAST_REASSIGN_DT] = @OldestCriticalLastReassign, 
				[IN_DEFAULT_NO] = @InDefault,
				[OLDEST_IN_DEFAULT_DT] = @OldestInDefault,
				[OLDEST_IN_DEFAULT_LAST_REASSIGN_DT] = @OldestInDefaultLastReassign,
				[RESERVED_NO] = @Reserved,
				[CHECKED_OUT_NO] = @CheckedOut,
				[UPDATE_DT] = getdate()			
			  WHERE
				KEY_TX = @cacheKey

		-- if no cache entry then insert it
		if @@ROWCOUNT = 0
			  BEGIN
				print @cacheKey

				INSERT INTO WORK_QUEUE_COUNT_CACHE (
					[KEY_TX],
					[OPEN_WI_NO],
					[OLDEST_OPEN_WI_DT],
					[OLDEST_OPEN_WI_LAST_REASSIGN_DT],
					[OK_NO],
					[OLDEST_OK_DT],
					[OLDEST_OK_LAST_REASSIGN_DT],
					[WARNING_NO],
					[OLDEST_WARNING_DT],
					[OLDEST_WARNING_LAST_REASSIGN_DT],
					[CRITICAL_NO],
					[OLDEST_CRITICAL_DT],
					[OLDEST_CRITICAL_LAST_REASSIGN_DT],
					[IN_DEFAULT_NO],
					[OLDEST_IN_DEFAULT_DT],
					[OLDEST_IN_DEFAULT_LAST_REASSIGN_DT],
					[RESERVED_NO],
					[CHECKED_OUT_NO],
					[CREATE_DT],
					[UPDATE_DT] )
				  VALUES (
					@cacheKey,
					@OpenWI,
					@OldestOpenWI,
					@OldestOpenWILastReassign,
					@OK,
					@OldestOK,
					@OldestOKLastReassign,
					@Warning,
					@OldestWarning,
					@OldestWarningLastReassign,
					@Critical,
					@OldestCritical,
					@OldestCriticalLastReassign,
					@InDefault,
					@OldestInDefault,
					@OldestInDefaultLastReassign,
					@Reserved,
					@CheckedOut,
					GETDATE(),
					GETDATE() )
			  END
	END

	SELECT
		@OpenWI,
		@WorkedToday,
		@WorkedByMe,
		@OK,
		@Warning,
		@Critical,
		@InDefault,
		@Reserved,
		@CheckedOut,
		@OldestOpenWI,
		@OldestOpenWILastReassign,
		@OldestWorkedToday,
		@OldestWorkedTodayLastReassign,
		@OldestWorkedByMe,
		@OldestWorkedByMeLastReassign,
		@OldestOK,
		@OldestOKLastReassign,
		@OldestWarning,
		@OldestWarningLastReassign,
		@OldestCritical,
		@OldestCriticalLastReassign,
		@OldestInDefault,
		@OldestInDefaultLastReassign
END
GO
