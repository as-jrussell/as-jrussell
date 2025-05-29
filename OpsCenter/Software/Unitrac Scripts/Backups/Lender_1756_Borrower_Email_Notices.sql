use unitrac


select 
l.number_tx, n.id as notice_id,
n.*
into unitrachdstorage..Lender_1756_Borrower_Email_Notices
from process_log_item pli
join notice n on n.id = pli.relate_id and pli.RELATE_TYPE_CD = 'Allied.UniTrac.Notice'
left join document_container dc on dc.RELATE_ID = N.ID AND DC.RELATE_CLASS_NAME_TX = 'Allied.UniTrac.Notice'
join loan l on l.id = n.loan_id 
where pli.process_log_Id = 65580726
and n.type_cd = 'ben'
AND DC.ID IS NULL


update N 
set n.purge_dt = GETDATE(), n.update_dt = GETDATE(), n.lock_id = n.lock_id +1
--select n.purge_dt, *
from notice N
join unitrachdstorage..Lender_1756_Borrower_Email_Notices BEN on N.ID = BEN.ID