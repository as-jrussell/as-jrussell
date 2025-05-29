select 'GRANT VIEW DEFINITION ON ' + quotename(specific_schema) 
+ '.' + quotename(specific_name)
+ ' TO ' + 'ITitle'
  from INFORMATION_SCHEMA.routines
where routine_type = 'PROCEDURE'
order by quotename(specific_schema),quotename(specific_name) 

GRANT VIEW DEFINITION ON [dbo].[WebPublish] TO ITitle



GRANT VIEW DEFINITION ON [dbo].[LIBatchCheckIn] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIBatchCheckOut] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIBatchInsert] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIBatchSelCount] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIDocInsert] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIExportPath] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIGetCycleDate] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIGetLenderInfo] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIGetProcessFiles] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIHasAccess] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIManagementConsoleBegin] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIMC_Batch_Received] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIMoveBatchInsert] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIPathActiveSel] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIUpdateBatchFile] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIUpdateProcessFiles] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[LIWriteLog] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[SendLIEmail] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[SendLIEmail_2008] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[SendLIEmailStatus] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[SendLIEmailStatus_2008] TO ITitle
GRANT VIEW DEFINITION ON [dbo].[SendLIRegion] TO ITitle