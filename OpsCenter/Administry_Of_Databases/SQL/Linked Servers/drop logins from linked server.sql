USE [master]
GO

/*Single drop login*/
EXEC master.dbo.sp_dropserver @server=N'UTPROD_RO', @droplogins='droplogins'
GO

/*Verfications*/
sp_linkedservers  


/*Rename a linked server*/
EXEC master.dbo.sp_serveroption @server=N'DS-SQLDEV-14', @optname=N'name', @optvalue=N'ALLIED-PIMSDB'





/*Multiple linked logins*/

select CONCAT('EXEC master.dbo.sp_dropserver @server=N''',name,'', '' , '''', ',@droplogins=''droplogins''')
FROM sys.servers
where name in ('ALLIED-UT-DEV','IVOS-DB01-TEST', 'UTPROD_RO','UTSTAGE02','VUT-DB01')


