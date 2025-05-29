SET NOCOUNT ON

declare @LoanNumber nvarchar(20)
declare @LenderCode nvarchar(20)

set @LoanNumber =  '10040715169'

set @LenderCode = '3124'

begin
	--declare @LoanNumber nvarchar(20)
	declare @LoanId bigint
	declare @LenderId bigint
	
	if OBJECT_ID('tempdb..#loanids') is null
	begin
		create table #loanids
		(
			id bigint not null,
			lendercode nvarchar(30) null,
			lenderid bigint not null
		)
		--DROP TABLE #loanids
	end
	
	truncate table #loanids
	--set @LenderCode = '3544'
	
	------- GET THE LOAN ------
	select 
		'LOAN' AS 'TABLE', 
		l.BRANCH_CODE_TX,
		l.DIVISION_CODE_TX,
		LD.CODE_TX AS LENDER_CODE,
		LD.NAME_TX AS LENDER_NAME,
		LD.ID AS LENDER_ID,
		L.ID,
		L.NUMBER_TX,
		L.RECORD_TYPE_CD,
		L.STATUS_CD,
		L.STATUS_DT,
		L.CREATE_DT,
		L.UPDATE_DT,
		L.UPDATE_USER_TX,
		L.PURGE_DT,
		L.*
	from
		LOAN l
		inner join LENDER ld on ld.ID = l.LENDER_ID
	where
		l.NUMBER_TX = @LoanNumber
		and ld.CODE_TX = isnull(@LenderCode, ld.CODE_TX)
		
	insert into #loanids	
	select 
		distinct
		--@LoanId = MIN(l.id), @LenderCode = max(ld.code_tx), @LenderId = max(ld.id)
		l.ID as ID, ld.CODE_TX as CODE_TX, l.LENDER_ID as LENDER_ID --into #loanids
	from 
		LOAN l 
		inner join LENDER ld on ld.ID = l.LENDER_ID 		
	where 
		l.NUMBER_TX = @LoanNumber --and ld.CODE_TX=@LenderCode
		and l.PURGE_DT is null
		--and l.record_type_cd = 'G' --and L.STATUS_CD = 'A'
		and ld.CODE_TX = isnull(@LenderCode, ld.CODE_TX)

	
	
	
	------- GET THE COLLATERAL ------
	select 
		'COLLATERAL' AS 'TABLE',
		C.ID,
		C.PROPERTY_ID,
		C.STATUS_CD,
		cc.CODE_TX,
		C.LOAN_BALANCE_NO,
		C.LOAN_PERCENTAGE_NO,
		C.CREATE_DT,
		C.UPDATE_DT,
		C.UPDATE_USER_TX,
		C.PURGE_DT,
		C.*
	from
		COLLATERAL C
		JOIN COLLATERAL_CODE cc on cc.ID = C.COLLATERAL_CODE_ID 
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id
--	where
--		L.ID = @LoanId


	------- GET THE PROPERTY ------
	select 
		'PROPERTY' AS 'TABLE',
		P.ID,
		P.RECORD_TYPE_CD,
		P.ADDRESS_ID,
		P.DESCRIPTION_TX,
		P.VIN_TX,
		P.YEAR_TX,
		P.MAKE_TX,
		P.MODEL_TX,
		P.BODY_TX,
		A.LINE_1_TX,
		A.LINE_2_TX,
		A.CITY_TX,
		A.STATE_PROV_TX,
		A.POSTAL_CODE_TX,
		P.CREATE_DT,
		P.UPDATE_DT,
		P.UPDATE_USER_TX,
		P.PURGE_DT,
		P.*
	from
		PROPERTY P
		LEFT OUTER JOIN OWNER_ADDRESS A ON A.ID = P.ADDRESS_ID
		INNER JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id
 	where
		A.PURGE_DT is null



select 
		'REQUIRED_COVERAGE' AS 'TABLE',
		rc.*
	from
		REQUIRED_COVERAGE rc
		INNER JOIN COLLATERAL C ON C.PROPERTY_ID =  rc.PROPERTY_ID 
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id
		
				select 
		'REQUIRED_ESCROW' AS 'TABLE',
		rc.TYPE_CD,
		re.*
	FROM
	REQUIRED_ESCROW re
		JOIN REQUIRED_COVERAGE rc on rc.ID = re.REQUIRED_COVERAGE_ID
		INNER JOIN COLLATERAL C ON C.PROPERTY_ID =  rc.PROPERTY_ID 
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id

		SELECT 'ESCROW' AS 'TABLE', ercr.REQUIRED_COVERAGE_ID, rc.TYPE_CD, e.*
		FROM ESCROW e
		JOIN PROPERTY p ON p.ID =  e.PROPERTY_ID
		INNER JOIN COLLATERAL C ON C.PROPERTY_ID =  p.id
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id
		join ESCROW_REQUIRED_COVERAGE_RELATE ercr ON ercr.ESCROW_ID = e.ID
		JOIN REQUIRED_COVERAGE rc on rc.ID = ercr.REQUIRED_COVERAGE_ID
		
select 'OwnerPolicy' AS 'TABLE', op.*
	from PROPERTY_OWNER_POLICY_RELATE popr
	join PROPERTY P on p.id = popr.PROPERTY_ID
		LEFT OUTER JOIN OWNER_ADDRESS A ON A.ID = P.ADDRESS_ID
		INNER JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id
		join OWNER_POLICY op on op.id = popr.OWNER_POLICY_ID
				
		
		select 'PolicyCoverage' AS 'TABLE', pc.*
	from PROPERTY_OWNER_POLICY_RELATE popr
	join PROPERTY P on p.id = popr.PROPERTY_ID
		LEFT OUTER JOIN OWNER_ADDRESS A ON A.ID = P.ADDRESS_ID
		INNER JOIN COLLATERAL C ON C.PROPERTY_ID = P.ID
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id
		join OWNER_POLICY op on op.id = popr.OWNER_POLICY_ID
		join POLICY_COVERAGE pc on pc.OWNER_POLICY_ID = op.ID

				
select 'PriorCarrierPolicy' AS 'TABLE', pcp.*
	FROM PRIOR_CARRIER_POLICY pcp 
		JOIN REQUIRED_COVERAGE rc ON rc.ID = pcp.REQUIRED_COVERAGE_ID
		INNER JOIN COLLATERAL C ON C.PROPERTY_ID =  rc.PROPERTY_ID 
		INNER JOIN LOAN L ON L.ID = C.LOAN_ID
		join #loanids lid on lid.ID = l.id

		SELECT 'FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE' AS 'TABLE',
		 FPCRCR.* 
		FROM 		#loanids lid 
		JOIN LOAN L ON L.ID = lid.ID
		INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
		JOIN REQUIRED_COVERAGE rc on C.PROPERTY_ID =  rc.PROPERTY_ID 
		JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.REQUIRED_COVERAGE_ID = rc.id

		SELECT 'FORCE_PLACED_CERTIFICATE' AS 'TABLE',
		 FPC.* 
		FROM 		#loanids lid 
		JOIN LOAN L ON L.ID = lid.ID
		INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
		JOIN REQUIRED_COVERAGE rc on C.PROPERTY_ID =  rc.PROPERTY_ID 
		JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.REQUIRED_COVERAGE_ID = rc.id
		JOIN FORCE_PLACED_CERTIFICATE FPC ON FPC.id = FPCRCR.FPC_ID

		select 'OLR' as 'Table', olr.* from #loanids lid
		join OWNER_LOAN_RELATE olr on olr.LOAN_ID = lid.id
		join OWNER o on o.id = olr.OWNER_ID
		
		select 'OWNER' as 'table', o.* from #loanids lid
		join OWNER_LOAN_RELATE olr on olr.LOAN_ID = lid.id
		join OWNER o on o.id = olr.OWNER_ID






END

