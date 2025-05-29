/*https://www.sqlshack.com/overview-of-sql-server-ports/  */


SELECT local_tcp_port
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;
GO



DECLARE @portNumber NVARCHAR(10);
EXEC xp_instance_regread
@rootkey = 'HKEY_LOCAL_MACHINE',
@key = 'Software\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp\IpAll',
@value_name = 'TcpDynamicPorts',
@value = @portNumber OUTPUT;
SELECT [Port Number] = @portNumber;
GO

