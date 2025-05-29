USE DBA

/*
USE DBA


select * 
from sys.objects
where type_desc NOT IN ('INTERNAL_TABLE', 'SYSTEM_TABLE')
and name not in ('spt_fallback_db','spt_fallback_dev',
'spt_fallback_usg','QueryNotificationErrorsQueue',
'EventNotificationErrorsQueue','ServiceBrokerQueue',
'spt_values','spt_monitor','MSreplication_options',
'sp_MSrepl_startup','sp_MScleanupmergepublisher')

*/




select  
CASE type
WHEN  'TF'  THEN  CONCAT('DROP FUNCTION ',name,  '')
WHEN 'P' THEN CONCAT('DROP PROC ',name,  '')
WHEN 'U' THEN CONCAT('DROP TABLE ',name,  '')
ELSE 'DO NOT DROP'
END
--select *
from sys.objects
where type_desc NOT IN ('INTERNAL_TABLE', 'SYSTEM_TABLE')
and name not in ('spt_fallback_db','spt_fallback_dev',
'spt_fallback_usg','QueryNotificationErrorsQueue',
'EventNotificationErrorsQueue','ServiceBrokerQueue',
'spt_values','spt_monitor','MSreplication_options',
'sp_MSrepl_startup','sp_MScleanupmergepublisher',
'sp_AS_ExposeColsInIndexLevels',
'sp_AS_helpindex','sproc_GetDDL','sp_helpindex2')
and type  in ('TF', 'P')



