exec Sp_configure 'show advanced options' , '1' 
GO
RECONFIGURE WITH OVERRIDE
GO

 EXEC sys.sp_configure N'cost threshold for parallelism', N'75'
GO
RECONFIGURE WITH OVERRIDE
GO

exec Sp_configure 'max degree of parallelism' , '2' --(This will increase as CPU’s are added) to a maximum of 8 with >= 24 cores 
GO
RECONFIGURE WITH OVERRIDE
GO

exec Sp_configure 'max server memory (MB)' , '12288' 
GO
RECONFIGURE WITH OVERRIDE
GO 

exec Sp_configure 'Ad Hoc Distributed Queries' , '1' 
GO
RECONFIGURE WITH OVERRIDE
GO 

exec Sp_configure 'backup compression default' , '1' 
GO
RECONFIGURE WITH OVERRIDE
GO 

exec Sp_configure 'remote admin connections' , '1'
GO
RECONFIGURE WITH OVERRIDE
GO

 exec Sp_configure 'xp_cmdshell', '1' 
 GO
RECONFIGURE WITH OVERRIDE
GO

