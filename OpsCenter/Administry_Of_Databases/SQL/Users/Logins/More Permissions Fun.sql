--Returns a list of server-level roles.
sp_helpsrvrole;

--Returns information about the members of a server-level role.
sp_helpsrvrolemember 'bulkadmin';


--	Displays the permissions of a server-level role.
sp_srvrolepermission;


sp_addsrvrolemember @loginame ='ELDREDGE_A\IT Sys Admins' ,  @rolename= 'bulkadmin'--Adds a login as a member of a server-level role. Deprecated. Use ALTER SERVER ROLE instead.
sp_dropsrvrolemember @loginame ='ELDREDGE_A\IT Sys Admins' ,  @rolename= 'bulkadmin' --Removes a SQL Server login or a Windows user or group from a serve

exec xp_logininfo --Shows all the AD accounts 


exec xp_logininfo 'ELDREDGE_A\jrussell' --How user is added to the database



