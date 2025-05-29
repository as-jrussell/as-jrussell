

---- Set loan to Archive when it is deleted


UPDATE L
SET l.RECORD_TYPE_CD = 'A', l.UPDATE_USER_TX = 'EOMCLNUP',l.UPDATE_DT = GETDATE(), L.LOCK_ID = L.LOCK_ID + 1
FROM #fpcnoloan f
JOIN LOAN L ON L.ID = f.LOAN_ID AND L.RECORD_TYPE_CD = 'D'


----Verify if FPC is linked to an RC on an Unpurged loan. If so, ignore.

SELECT LN.PURGE_DT,LN.UPDATE_USER_TX,*
from FORCE_PLACED_CERTIFICATE fpc
  join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on fpc.ID = r.FPC_ID AND r.PURGE_DT IS NULL 
  join REQUIRED_COVERAGE rc on r.REQUIRED_COVERAGE_ID = rc.ID
  join COLLATERAL CL on  rc.PROPERTY_ID = CL.PROPERTY_ID
  join LOAN LN on CL.LOAN_ID = LN.ID
WHERE fpc.NUMBER_TX = 'FL50009143'



--drop table #tmpPropId
--drop table #fpcCrossLink



	select  c.PROPERTY_ID
into #tmpPropId
from #fpcNoLoan f
join loan l on l.id = f.LOAN_ID 
join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on r.FPC_ID = f.FPC_ID
join REQUIRED_COVERAGE rc on rc.id = r.REQUIRED_COVERAGE_ID and rc.PURGE_DT is null
join COLLATERAL c on rc.PROPERTY_ID = c.PROPERTY_ID 
group by  c.PROPERTY_ID
having count(*) > 1

select fpc.id as fpc_id, fpc.LOAN_ID
into #fpcCrossLink
from #tmpPropId t
join REQUIRED_COVERAGE rc on rc.PROPERTY_ID = t.PROPERTY_ID
join FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE r on r.REQUIRED_COVERAGE_ID = rc.id and r.PURGE_DT is null
join FORCE_PLACED_CERTIFICATE fpc ON r.FPC_ID = fpc.ID
and fpc.id in (select fpc_id from #fpcNoLoan)




SET NOCOUNT off

declare @LoanNumber nvarchar(20)
declare @VUTRegion nvarchar(20)
declare @LenderCode nvarchar(20)
declare @division int

declare @fpc_id as int
declare @good_loan_id as int
declare @bad_loan_id as int
	
	declare @LoanId bigint
	declare @LenderId bigint
	


DECLARE db_cursor CURSOR FOR  
SELECT *
FROM #fpcCrossLink
order by fpc_id, LOAN_ID



OPEN db_cursor   
FETCH NEXT FROM db_cursor into @fpc_id, @bad_loan_id 


WHILE @@FETCH_STATUS = 0   
BEGIN   

select  @division = DIVISION_CODE_TX  from loan where id = @bad_loan_id

select top 1  @LoanNumber= l.NUMBER_TX , @LenderCode = ldr.CODE_TX
from loan l
join #fpcNoLoan nl on nl.LOAN_ID = l.id and nl.FPC_ID = @fpc_id
join lender ldr on ldr.id = l.LENDER_ID

	select 
		distinct
				l.ID as ID, ld.CODE_TX as CODE_TX, l.LENDER_ID as LENDER_ID , l.PURGE_DT as purge_dt
				into #loanids
	from 
		LOAN l 
		inner join LENDER ld on ld.ID = l.LENDER_ID 
			where 
		l.NUMBER_TX = @LoanNumber 		
		and ld.CODE_TX = @LenderCode
		and l.DIVISION_CODE_TX = @division

select @good_loan_id = l.ID from #loanids l where l.purge_dt is null

update FPC
set LOAN_ID = @good_loan_id, UPDATE_USER_TX = 'EOMCLNUP9',UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID + 1
from FORCE_PLACED_CERTIFICATE fpc 
where id = @fpc_id



update Ih
set LOAN_ID = @good_loan_id, UPDATE_USER_TX = 'EOMCLNUP9',UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID + 1
from INTERACTION_HISTORY ih 
where  LOAN_ID = @bad_loan_id


drop table #loanids

FETCH NEXT FROM db_cursor into @fpc_id, @bad_loan_id 


END   
CLOSE db_cursor
DEALLOCATE db_cursor




---------------------------------
--- If FPC returns MUST clean up before EOM
---------------------------------------

SELECT * FROM #fpcNoLoan  fnl
JOIN #CurrentFPC cf ON cf.FPCID = FPC_ID


