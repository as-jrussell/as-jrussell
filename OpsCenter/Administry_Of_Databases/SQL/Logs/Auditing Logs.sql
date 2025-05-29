
/*https://docs.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-get-audit-file-transact-sql?view=sql-server-ver15 */

SELECT count (*), server_principal_name, database_name
  FROM fn_get_audit_file( 'F:\Audit\Successful%5logins_1499B8F1-41E1-4463-8E9D-3BE0AA085CA6_0_132694428038580000.sqlaudit' , DEFAULT , DEFAULT)
  group by server_principal_name, database_name

--Contains information about the database audit specifications in a SQL Server audit on a server instance.
select * from sys.database_audit_specifications


--Contains information about the database audit specifications in a SQL Server audit on a server instance for all databases.

select * from sys.database_audit_specification_details

--Contains information about the database audit specifications in a SQL Server audit on a server instance for all databases.
select * from sys.server_audits

--Contains information about the server audit specifications in a SQL Server audit on a server instance.
select * from sys.server_audit_specifications

--Contains information about the server audit specification details (actions) in a SQL Server audit on a server instance.
--select * from sys.server_audit_specifications_details

--Contains stores extended information about the file audit type in a SQL Server audit on a server instance.
select * from sys.server_file_audits


