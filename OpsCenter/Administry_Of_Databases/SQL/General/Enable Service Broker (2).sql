USE master;
GO
ALTER DATABASE [Unitrac] SET ENABLE_BROKER with rollback immediate;
GO




SELECT is_broker_enabled FROM sys.databases WHERE name = 'Unitrac';