USE [UniTrac]
GO
/****** Object:  StoredProcedure [sys].[sp_addlinkedserver]    Script Date: 6/23/2016 5:12:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [sys].[sp_addlinkedserver]
	@server			sysname,				-- server name
	@srvproduct		nvarchar(128) = NULL,	-- product name (dflt to ss)
	@provider		nvarchar(128) = NULL,	-- oledb provider name
	@datasrc		nvarchar(4000) = NULL,	-- oledb datasource property
	@location		nvarchar(4000) = NULL,	-- oledb location property
	@provstr		nvarchar(4000) = NULL,	-- oledb provider-string property
	@catalog		sysname = NULL			-- oledb catalog property
as
	-- VARIABLES
	declare @retcode	int,
		@srvproduct2	nvarchar(128)

	set @srvproduct2 = @srvproduct

	-- VALIDATE OLEDB PARAMETERS
	if @provider is null
	begin
		-- NO PROVIDER MEANS CANNOT SPECIFY ANY PROPERTIES!
		if	@datasrc is not null or @location is not null or
			@provstr is not null or @catalog is not null
		begin
			raiserror(15426,-1,-1)
			return (1)
		end

		-- THIS MUST BE A WELL-KNOWN "SQL Server" TYPE (DEFAULT IS SS)
		if @srvproduct IS NOT null AND lower(@srvproduct) <> N'sql server'
		begin
			raiserror(15427,-1,-1,@srvproduct)
			return (1)
		end

		-- USE ALL-NULLS FOR SQL-SERVER PROVIDER
		select @srvproduct = NULL
	end
	else if @srvproduct in (N'SQL Server')  -- WELL-KNOWN PRODUCT
	begin
		-- ILLEGAL TO SPECIFY PROVIDER/PROPERTIES FOR SQL Server PRODUCT
		raiserror(15428,-1,-1,@srvproduct)
		return (1)
	end
	else if @srvproduct is null or lower(@srvproduct) like N'%sql server%'
	begin
		raiserror(15429,-1,-1,@srvproduct)
		return (1)
	end

	-- DISALLOW USER TRANSACTION
	set implicit_transactions off
	if @@trancount > 0
	begin
		raiserror(15002,-1,-1,'sys.sp_addlinkedserver')
		return (1)
	end

	BEGIN TRANSACTION

	-- ADD THE LINKED-SERVER
	EXEC @retcode = sys.sp_MSaddserver_internal @server,
				@srvproduct, @provider, @datasrc, @location, @provstr, @catalog,
				1, 0			-- @linkedstyle, @localentry

	if( @retcode = 0 )
	begin
		-- EMDEventType(x_eet_Create_Linked_Server), EMDUniversalClass(x_eunc_Server), src major id, src minor id, src name
		-- -1 means ignore target stuff, target major id, target minor id, target name,
		-- # of parameters, 5 parameters
		-- Note: we do not pass @provstr since it can contain passwords
		EXEC %%System().FireTrigger(ID = 225, ID = 102, ID = 0, ID = 0, Value = @server,
			ID = -1, ID = 0, ID = 0, Value = NULL, 
			ID = 7, Value = @server, Value = @srvproduct2, Value = @provider, Value = @datasrc, Value = @location, Value = NULL, Value = @catalog)


		COMMIT TRANSACTION
		-- SUCCESS
		return (0) -- sp_addlinkedserver
	end
	else if( @retcode = 2 )
	begin
		ROLLBACK
		raiserror(15028,-1,-1,@server);
		return (1)
	end
	else 
	begin
		ROLLBACK
		return (1)
	end

