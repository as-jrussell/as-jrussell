use unitrac



 SELECT   INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') AS USER_ACTION, l.*
FROM PROCESS_LOG_ITEM PLI
JOIN dbo.WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON WIPLIR.PROCESS_LOG_ITEM_ID = PLI.ID
join escrow e on e.id = pli.relate_id and pli.relate_type_cd = 'Allied.UniTrac.Escrow'
join loan l on l.id = e.loan_id 
WHERE WORK_ITEM_ID = 52849209 and 
INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') is null 




update pli set INFO_XML = '<INFO_LOG>
  <DatabaseCalls />
  <USER_ACTION>Reject</USER_ACTION>
</INFO_LOG>'
--SELECT   INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') AS USER_ACTION, pli.*
FROM PROCESS_LOG_ITEM PLI
JOIN dbo.WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON WIPLIR.PROCESS_LOG_ITEM_ID = PLI.ID
join escrow e on e.id = pli.relate_id and pli.relate_type_cd = 'Allied.UniTrac.Escrow'
join loan l on l.id = e.loan_id 
WHERE WORK_ITEM_ID = 52849209 and 
PLI.ID IN (2882878954,2882878491)



update PLI set purge_dt = NULL
 --SELECT   INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') AS USER_ACTION, *
FROM PROCESS_LOG_ITEM PLI
JOIN dbo.WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON WIPLIR.PROCESS_LOG_ITEM_ID = PLI.ID

WHERE WORK_ITEM_ID = 52849209  --and pli.purge_dt is not null
--and INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') = 'Approve'
and pli.update_user_tx = 'INC0406370' and relate_id in (2218319,
2218428)


SELECT  relate_id, count(relate_id)
FROM PROCESS_LOG_ITEM PLI
JOIN dbo.WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON WIPLIR.PROCESS_LOG_ITEM_ID = PLI.ID

WHERE WORK_ITEM_ID = 52849209  and pli.purge_dt is  null
group by relate_id
having COUNT(relate_id) > 1


drop table #tmp
SELECT INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') AS USER_ACTION, WORK_ITEM_ID, PLI.* into #tmp
FROM PROCESS_LOG_ITEM PLI
JOIN dbo.WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON WIPLIR.PROCESS_LOG_ITEM_ID = PLI.ID

WHERE WORK_ITEM_ID = 52849209  and pli.purge_dt is  null



select  relate_id, count(relate_id),user_action
 from #tmp
group by relate_id, user_action
having COUNT(relate_id) > 1


select L.NUMBER_TX,* from escrow e
join loan l on l.id = e.loan_id
where e.id in (2218319,
2218428)