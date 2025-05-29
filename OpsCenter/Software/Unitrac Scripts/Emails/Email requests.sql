use unitrac

---Getting data from QA2
select  E.* from loan l
join notice n on l.id = n.loan_id 
join  email_requests e on e.relate_id = n.id and e.relate_class_name_tx ='Allied.UniTrac.Notice'
join LENDER ll on ll.id = l.lender_id
where l.number_tx in ('203994-01','220791-01', '7417', '8885', '15151', '22225') and ll.code_tx = '3002'


---on Prod1
insert EMAIL_REQUESTS ( mail_type_id, to_tx, cc_tx, from_tx,subject_tx, html_message_tx, plain_message_tx, attachment_tx, sent_dt, create_dt, update_dt, purge_dt, status_cd, status_message_tx, lnkres1_tx, lnkres2_tx, lnkres3_tx, update_user_tx, lock_id, relate_id, relate_class_name_tx)
select mail_type_id, to_tx, cc_tx, from_tx,subject_tx, html_message_tx, plain_message_tx, attachment_tx, NULL, create_dt, update_dt, purge_dt, status_cd, status_message_tx, lnkres1_tx, lnkres2_tx, lnkres3_tx, update_user_tx, lock_id, relate_id, relate_class_name_tx
from [utqa-sql-14].[Unitrac].[dbo].email_requests
where id in (1958600,1958602)


----On DB01
insert EMAIL_REQUESTS ( mail_type_id, to_tx, cc_tx, from_tx,subject_tx, html_message_tx, plain_message_tx, attachment_tx, sent_dt, create_dt, update_dt, purge_dt, status_cd, status_message_tx, lnkres1_tx, lnkres2_tx, lnkres3_tx, update_user_tx, lock_id, relate_id, relate_class_name_tx)
select mail_type_id, to_tx, cc_tx, from_tx,subject_tx, html_message_tx, plain_message_tx, attachment_tx, NULL, create_dt, update_dt, purge_dt, status_cd, status_message_tx, lnkres1_tx, lnkres2_tx, lnkres3_tx, update_user_tx, lock_id, relate_id, relate_class_name_tx
from [unitrac-prod1].[Unitrac].[dbo].email_requests
where id in (1958600,1958602)
