





SELECT Sum(max_length)AS TotalIndexKeySize
--select *
FROM   sys.columns
WHERE  name IN ('ContractType','LenderID','LenderName','BatchID',
                'AlliedDocID','BatchDate','ScanOperator','DocumentPath',
                'EffectiveDate','MailDate','VIN','Status',
                'ExportTime')
       AND object_id = Object_id(N'dbo.OutputImages'); 