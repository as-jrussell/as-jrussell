SELECT SUM(max_length)AS IndexSize
--select (object_name(object_id)), *
FROM sys.columns
WHERE name IN (N'ContractType',
'LenderID','EffectiveDate',
'LenderName',
'BatchID',
'AlliedDocID',
'BatchDate',
'ScanOperator',
'DocumentPath',
'MailDate',
'VIN',
'Status',
'ExportTime')
AND object_id = OBJECT_ID(N'dbo.OutputImages');
   
--1700
