use msdb

--select * from sysjobs

SELECT J.name AS Job_Name
, P.name AS Job_Owner
FROM msdb.dbo.sysjobs J
LEFT JOIN
sys.server_principals P
ON J.owner_sid = P.sid
where p.name is null
and enabled = 1