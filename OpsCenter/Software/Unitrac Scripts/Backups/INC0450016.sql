use UniTrac

select wi.* into unitrachdstorage..INC0450016_workitems
from utl_match_result umr
inner join work_item wi on wi.relate_id = umr.id and wi.workflow_definition_id = 2
inner join loan l on l.id = umr.loan_id
inner join lender le on le.id = l.lender_id
where le.code_tx = '3400'
and wi.purge_dt is null
and wi.status_cd = 'initial'
and l.branch_code_tx = 'vsi'


select umr.* into unitrachdstorage..INC0450016_umr
from utl_match_result umr
inner join work_item wi on wi.relate_id = umr.id and wi.workflow_definition_id = 2
inner join loan l on l.id = umr.loan_id
inner join lender le on le.id = l.lender_id
where le.code_tx = '3400'
and wi.purge_dt is null
and wi.status_cd = 'initial'
and l.branch_code_tx = 'vsi'



update wi
set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0450016', STATUS_CD = 'Withdrawn'
--select *
from WORK_ITEM wi
join unitrachdstorage..INC0450016_workitems iw on wi.id = iw.ID



update umr 
set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0450016'
--select *
from utl_match_result umr
join unitrachdstorage..INC0450016_umr rmu on umr.id =rmu.id
