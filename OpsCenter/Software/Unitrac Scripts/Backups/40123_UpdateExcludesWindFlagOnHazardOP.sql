/*
40123
create a tmp table with OPs to be updated. 
*/
USE [UniTrac]

   if OBJECT_ID('tempdb..#tmp_OPs') IS NOT NULL
	   drop table #tmp_OPs


	SELECT op.ID, op.SPECIAL_HANDLING_XML.value('(/SH/PolicyExcludesWind)[1]', 'nvarchar(max)') as ExcludesWind,
	op.SPECIAL_HANDLING_XML as opXML,
	rcH.id as RCHazzID, rcW.ID as RCWindID
	 
	into #tmp_OPs
	from loan l
	inner join LENDER ldr on ldr.ID = l.LENDER_ID
	inner join COLLATERAL c on c.LOAN_ID = l.ID and c.PURGE_DT is null
	inner join COLLATERAL_CODE cc on cc.ID = c.COLLATERAL_CODE_ID and cc.PURGE_DT is NULL
	inner join PROPERTY p on p.id = c.PROPERTY_ID and p.PURGE_DT is NULL
	inner join REQUIRED_COVERAGE rcW on rcW.PROPERTY_ID = p.ID and rcW.TYPE_CD = 'WIND' and rcW.PURGE_DT is NULL
	inner join REQUIRED_COVERAGE rcH on rcH.PROPERTY_ID = p.ID and rcH.TYPE_CD = 'HAZARD' and rcH.PURGE_DT is NULL  

	cross apply GetCurrentCoverage(rcW.property_id, rcW.ID, rcW.TYPE_CD) CurrentCovWind
	cross apply GetCurrentCoverage(rcH.property_id, rcH.ID, rcH.TYPE_CD) CurrentCovHazard

	inner join PROPERTY_OWNER_POLICY_RELATE popr on popr.PROPERTY_ID = CurrentCovHazard.PROPERTY_ID
	inner join OWNER_POLICY op on op.ID = popr.OWNER_POLICY_ID and op.POLICY_NUMBER_TX = CurrentCovHazard.POLICY_NUMBER_TX

	where 
	CurrentCovHazard.POLICY_NUMBER_TX <> CurrentCovWind.POLICY_NUMBER_TX
	and ISNull(CurrentCovWind.BASE_PROPERTY_TYPE_CD,'') = IsNull(CurrentCovHazard.BASE_PROPERTY_TYPE_CD,'')
	and rcw.STATUS_CD = 'I' and rch.STATUS_CD = 'A' 
	and ldr.CODE_TX NOT IN ('2028','1002','1007','1012','1023','1026','1034','2236') 
	and cc.CODE_TX NOT LIKE '%CONDO%'
	and l.PURGE_DT is null AND l.RECORD_TYPE_CD = 'G'
	-- only look at records where SP xml on owner policy has N for PolicyExcludesWind or PolicyExcludesWind tag is missing
	and (op.SPECIAL_HANDLING_XML.value('(/SH/PolicyExcludesWind)[1]', 'nvarchar(max)') = 'N' OR
		  op.SPECIAL_HANDLING_XML.exist('(/SH/PolicyExcludesWind)[1]') = 0 )
	and op.STATUS_CD NOT IN ('C','E')
	
	SET NOCOUNT on
	Declare @opId bigint
	Declare @excludesWind nvarchar(10)	
	Declare @opXML XML
	Declare @RCHazzardID bigint
	Declare @RCWindID bigint
	Declare @oldValue varchar(1) = 'N'
	Declare @newValue varchar(1) = 'Y'
	Declare @shXML as XML
	DECLARE @counter as bigint = 0

	declare itemCursor cursor for
		Select ID, ExcludesWind, opXML, RCHazzID, RCWindID  from #tmp_OPs;

	print '--- Affected List --'
	open itemCursor

	fetch next from itemCursor into @opID, @excludesWind, @opXML, @RCHazzardID, @RCWindID

	While @@FETCH_STATUS = 0
	begin
		
		set @counter = @counter + 1
		print 'Owner Policy ID / Hazzard RC ID / Wind RC ID: ' + cast(@opID as nvarchar) + ' / ' +  cast(@RCHazzardID as nvarchar) + ' / ' + cast(@RCWindID as nvarchar)

		If  @opXML is NULL
		BEGIN
			-- Special Handling is completely null, insert whole node.
			set @shXML = '<SH><PolicyExcludesWind>Y</PolicyExcludesWind></SH>'
			update OWNER_POLICY
			set SPECIAL_HANDLING_XML = @shXML,
			UPDATE_DT = getdate(), UPDATE_USER_TX = 'Task40213',
			LOCK_ID = (LOCK_ID % 255) + 1
			Where  id = @opId
		END

		if @excludesWind is NULL and @opXML IS NOT NULL
		BEGIN
			--Insert PolicyExcludesWind Node with value of Y
			update OWNER_POLICY
			set SPECIAL_HANDLING_XML.modify('insert <PolicyExcludesWind>Y</PolicyExcludesWind> into (/SH[1])'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = 'Task40213',
			LOCK_ID = (LOCK_ID % 255) + 1
			Where  id = @opId
		END

		if @excludesWind = 'N' AND @opXML IS NOT NULL
		BEGIN			
			-- Change value of PolicyExcludesWind
			update OWNER_POLICY
			set SPECIAL_HANDLING_XML.modify('replace value of (/SH/PolicyExcludesWind[. = sql:variable("@oldValue")]/text())[1]
			with sql:variable("@newValue")'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = 'Task40213',
			LOCK_ID = (LOCK_ID % 255) + 1
			Where  id = @opId			
		END		
		
		update REQUIRED_COVERAGE 
		set GOOD_THRU_DT = NULL,
		UPDATE_DT = getdate(), UPDATE_USER_TX = 'Task40213',
		LOCK_ID = (LOCK_ID % 255) + 1
		where id in (@RCHazzardID, @RCWindID)	

		fetch next from itemCursor into @opId, @excludesWind, @opXML, @RCHazzardID, @RCWindID

	end

	print 'Total: ' + cast(@counter as varchar)
	close itemCursor;
	deallocate itemCursor;
	set NOCOUNT OFF


	