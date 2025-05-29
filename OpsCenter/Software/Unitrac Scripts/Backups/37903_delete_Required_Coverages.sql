--begin transaction

declare @now datetime = GetDate();

update REQUIRED_COVERAGE
set PURGE_DT = @now, UPDATE_DT = @NOW, UPDATE_USER_TX = 'tfs-37903', LOCK_ID = LOCK_ID + 1
where ID in
(
   select rc.ID from LOAN ln
      inner JOIN COLLATERAL col on col.LOAN_ID = ln.ID AND col.PURGE_DT IS NULL
      inner JOIN REQUIRED_COVERAGE rc on rc.PROPERTY_ID = col.PROPERTY_ID AND rc.PURGE_DT IS NULL
   where ln.LENDER_ID = 2260
         AND ln.PURGE_DT IS NULL
         AND rc.TYPE_CD = 'REO-LIABILITY'
         AND ln.BRANCH_CODE_TX != 'REO'
)

--rollback transaction
