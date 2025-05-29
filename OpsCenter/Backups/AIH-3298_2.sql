use msdb

select CONCAT('EXEC msdb.dbo.sp_update_job @job_id=N''',job_id,''', @new_name=N''','Unitrac-',name,'_Archive''')
--select *
from sysjobs
where name IN ('ArchiveChangeHistory','ArchiveInteractionHistory','ArchivePropertyChange','ArchivePropertyChange Stop')





select so.name, sj.*
from sysjobs sj
join sysoperators so on sj.notify_email_operator_id =SO.ID
WHERE so.name not in (

'dbAdmins',
'DBAlert',
'MoserIT',
'NOCAlert',
'DBA')

select cast(case WHEN id = 1 THEN 'DBA GROUP' WHEN ID IN (7) THEN 'NOC' ELSE 'REMOVE' END AS nvarchar) AS [Status],NAME, email_address
--select *
from sysoperators
WHERE --ID noT IN (3,4,5,8,10,6)
name not in (

'dbAdmins',
'DBAlert',
'MoserIT',
'NOCAlert',
'DBA')



USE [msdb]
GO

/****** Object:  Operator [Ray]    Script Date: 6/22/2021 3:49:39 PM ******/
select CONCAT('EXEC msdb.dbo.sp_delete_operator @name=N''', NAME, '''')
from sysoperators
WHERE ID IN (3,4,5,8,10,6)
