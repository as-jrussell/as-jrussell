
update ACCOUNTING_PERIOD
 set END_DT = '2017-01-01', UPDATE_DT=getdate(), UPDATE_USER_TX='TFS39944', LOCK_ID=LOCK_ID+1 where id = 367
update ACCOUNTING_PERIOD
 set START_DT = '2017-01-01', YEAR_NO=2017, PERIOD_NO=1, UPDATE_DT=getdate(), UPDATE_USER_TX='TFS39944', LOCK_ID=LOCK_ID+1 where id = 371

