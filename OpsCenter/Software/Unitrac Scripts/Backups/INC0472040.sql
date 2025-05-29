use unitrac


---Breakdown of all the work items that Ryan has completely XXXX
 select workflow_definition_id, wd.name_tx, count(*) [Count], min(wi.create_dt) [Oldest Work Item]
from work_item wi 
join USERS u on u.id = CONTENT_XML.value('(/Content/LenderAdmin/Id)[1]', 'varchar (50)')
join workflow_definition wd on wd.id = wi.workflow_definition_id
where family_name_tx = 'Chhin' and 
wi.STATUS_CD   in ('Initial' ) and wi.purge_dt is null 
and user_role_cd = 'LENDER_ADMIN'
GROUP BY workflow_definition_id, wd.name_tx


--What specific Key Images work items Ryan has xxxx spreadsheet
select CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)'), wi.*
from work_item wi 
join USERS u on u.id = CONTENT_XML.value('(/Content/LenderAdmin/Id)[1]', 'varchar (50)')
where family_name_tx = 'Chhin' and 
wi.STATUS_CD   in ('Initial' ) and wi.purge_dt is null and
 wi.workflow_definition_id = 4 and user_role_cd = 'LENDER_ADMIN' 
 order by wi.create_dt asc 
 
