--List process definition IDs to be rerun in the where clause of this select
--- Where XXXXX enter code provided from email
select pd.id 
into #Temp1
from PROCESS_DEFINITION pd where pd.ID in(
XXXXXX
)


UPDATE pd
SET STATUS_CD = 'Complete'
     , OVERRIDE_DT = GETDATE()
     , [LOCK_ID] = ([LOCK_ID] % 255) + 1
 ,[UPDATE_DT] = GetDate()
 ,[UPDATE_USER_TX] = 'ADMIN'
--select *
from PROCESS_DEFINITION pd
inner join #Temp1 t1 on t1.ID = pd.ID
GO

update pli
set pli.purge_dt = GETDATE(),
pli.UPDATE_DT = GETDATE(),
pli.UPDATE_USER_TX = 'ADMIN',
pli.LOCK_ID = (pli.LOCK_ID % 255) + 1
--select *
from PROCESS_LOG_ITEM pli
where
pli.ID in (
	select pli.ID 
	from PROCESS_DEFINITION pd
	inner join PROCESS_LOG pl on pl.PROCESS_DEFINITION_ID = pd.ID
		and pl.PURGE_DT is null
	inner join PROCESS_LOG_ITEM pli on pli.PROCESS_LOG_ID = pl.ID
		and pli.PURGE_DT is null
		and pli.STATUS_CD = 'ERR'
		and pli.RELATE_TYPE_CD = 'Allied.UniTrac.BillingGroup'
	where
	pd.ID in (select ID from #Temp1)
)
GO