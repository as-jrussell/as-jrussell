USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.NUMBER_TX,IH.* 
into #tmpIH
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
inner join dbo.REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('3769') 
AND L.NUMBER_TX IN ( '116721') 


SELECT L.NUMBER_TX,IH.* 
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
inner join dbo.REQUIRED_COVERAGE RC on RC.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
WHERE LL.CODE_TX IN ('3769') 
AND L.NUMBER_TX IN ( '1005807') 




insert into INTERACTION_HISTORY (type_cd, loan_id, property_id, required_coverage_id, document_id, effective_dt, effective_order_no, issue_dt, note_tx, special_handling_xml, alert_in, pending_in, in_house_only_in, relate_class_tx, relate_id, create_dt, create_user_tx, update_dt, update_user_tx, purge_dt, lock_id, delete_id, archived_in) 
select ih.type_cd, ih.loan_id, '242841759', ih.required_coverage_id, ih.document_id, ih.effective_dt, ih.effective_order_no, ih.issue_dt, ih.note_tx, ih.special_handling_xml, ih.alert_in, ih.pending_in, ih.in_house_only_in, ih.relate_class_tx, ih.relate_id, ih.create_dt, ih.create_user_tx, ih.update_dt, 'INC0392637', ih.purge_dt, ih.lock_id, ih.delete_id, ih.archived_in
from INTERACTION_HISTORY IH
join #tmpIH HI on IH.ID = HI.ID


/*
update ih 
set purge_dt = GETDATE()
--select *
from interaction_history ih
where id in (469718395)

*/