use unitrac

declare @PDID bigint = '13907'
DECLARE @NextFullCycleDate nvarchar(25) = '6/21/2019 1:30:00 AM'  --remember to ensure that it is in the central time zone 
DECLARE @Task nvarchar(15) = 'INC0427286'


update PROCESS_DEFINITION
set SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/NextFullCycleDate/text())[1] with sql:variable("@NextFullCycleDate")')
,UPDATE_DT = getdate(), UPDATE_USER_TX = @Task, LOCK_ID = (LOCK_ID % 255 ) + 1
where ID = @PDID



select SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/NextFullCycleDate)[1]',
                                    'varchar(50)'),
									* from PROCESS_DEFINITION
where id in (13907)


select * from PROCESS_LOG
where PROCESS_DEFINITION_ID IN (13907)
and UPDATE_DT >= '2019-06-01'
order by update_dt desc


select O.*
from owner o
inner join owner_loan_relate olr on olr.owner_id = o.id
inner join loan l on l.id = olr.loan_id 
inner join lender le on le.id = l.lender_id
where o.update_user_tx = 'INC0425461'
and o.purge_dt is not null
group by le.code_tx, le.name_tx
order by count(o.id) desc 



select * from owner
where id in (68090412 )