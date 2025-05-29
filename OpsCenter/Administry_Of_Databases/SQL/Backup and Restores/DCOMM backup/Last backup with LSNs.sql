SELECT distinct  CONCAT('restore database ',database_name, ' from disk= ''') +f.physical_device_name+''' with norecovery',
b.backup_finish_date,b.first_lsn,b.last_lsn,

b.backup_size /1024/1024 AS size_MB,b.type,b.recovery_model,
b.server_name ,b.database_name,b.user_name

FROM MSDB.DBO.BACKUPMEDIAFAMILY F
JOIN MSDB.DBO.BACKUPSET B
ON (f.media_set_id=b.media_set_id)
WHERE database_name like'UnitracArchive'
and backup_finish_date >= '2021-10-17 23:00'
ORDER BY b.backup_finish_date desc


