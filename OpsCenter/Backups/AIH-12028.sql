

/*
USE [LIMC] 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ExelaReturnStaging') AND name = N'IX_ExelaReturnStaging_ARQ_newBatchId_active')
BEGIN


CREATE NONCLUSTERED INDEX [IX_ExelaReturnStaging_ARQ_newBatchId_active] ON [LIMC].[dbo].[ExelaReturnStaging] ([ARQ], [newBatchId], [active]) 
INCLUDE ([payloadContractType], [lenderKey], [queueType], [originalBatchId])])

WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]



END

GO
 
 00:00:00.031 to install UT-SQLDEV-01 
*/


