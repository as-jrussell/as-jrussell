USE Unitrac
go

DELETE FROM TRADING_PARTNER_LOG WHERE
(MESSAGE_ID = 0 AND PROCESS_CD <> 'BSS')
OR
(LOG_MESSAGE LIKE '%Directory Watcher Deactivated for Trading Partner%')
OR
(LOG_MESSAGE LIKE '%Directory watcher activated and Sweep Files performed%')
OR
(LOG_MESSAGE LIKE '%Messages not available%')
OR
(LOG_MESSAGE LIKE '%Sweep Files performed and no files found for Trading Partner%')
OR
(LOG_MESSAGE LIKE '%Input folder not setup for Trading Partner%')
OR
(LOG_MESSAGE LIKE '%Initiated messages swept for execution%')
OR
(LOG_MESSAGE LIKE '%Initiated messages Execution Complete%')
OR
(LOG_MESSAGE LIKE '%Sweep Files performed and Work Items Queued for Trading Partner%')
OR
(LOG_MESSAGE LIKE '%Work Item Queued for file%')

USE [UniTrac]
GO
if  convert(int, left(convert(nvarchar(128), serverproperty('productversion')),2)) >= 12
begin
	ALTER INDEX [PK_TRADING_PARTNER_LOG] ON [dbo].[TRADING_PARTNER_LOG] REBUILD WITH ( SORT_IN_TEMPDB = ON, online = on, DATA_COMPRESSION = PAGE)
end
else
begin
	ALTER INDEX [PK_TRADING_PARTNER_LOG] ON [dbo].[TRADING_PARTNER_LOG] REBUILD WITH ( SORT_IN_TEMPDB = ON, online = off, DATA_COMPRESSION = PAGE)
end
GO
USE [UniTrac]
GO
ALTER INDEX [IDX_TRADING_PARTNER_LOG_MSG_ID] ON [dbo].[TRADING_PARTNER_LOG] REBUILD WITH ( ONLINE = ON, SORT_IN_TEMPDB = ON, DATA_COMPRESSION = ROW)
GO
USE [UniTrac]
GO
ALTER INDEX [IDX_TP_ID_CREATE_DT] ON [dbo].[TRADING_PARTNER_LOG] REBUILD WITH ( ONLINE = ON, SORT_IN_TEMPDB = ON, DATA_COMPRESSION = ROW)
GO
