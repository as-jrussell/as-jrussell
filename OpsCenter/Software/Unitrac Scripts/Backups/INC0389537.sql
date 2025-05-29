use unitrac

select * from process_definition
where name_tx like '%2814%' and process_type_cd = 'CYCLEPRC'


select * from process_log
where process_definition_id in (284079,
284081,
304638,
284074) and update_dt >= '2019-01-01' and end_dt is not null

select * from work_item
where relate_id = 68443982


select * from PROCESS_LOG_ITEM
where process_log_id =68443982


select l.* from required_coverage rc
join property p on p.id = rc.property_id
join collateral c on p.id = c.property_id
join loan l on l.id = c.loan_id
where rc.id in (145320952,
181193477)

select * from lender_organization
where lender_id = 2294 