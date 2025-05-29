
 SELECT servicename, process_id, startup_type_desc, status_desc,
last_startup_time, service_account
FROM sys.dm_server_services