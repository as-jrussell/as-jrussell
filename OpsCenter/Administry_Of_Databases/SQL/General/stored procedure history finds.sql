
SELECT * FROM sys.objects --WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetBillingFinancialTxns]')
where create_date >= '2019-02-13'

use unitrac 
--Checks the last time it was touched 
SELECT * 
FROM sys.objects
where type not in ('IT','U')
ORDER BY create_date DESC 


select * 
from process_log
where server_tx = 'UNITRAC-WH012'
order by create_dt desc 



SELECT *FROM SYS.OBJECTS WHERE NAME = 'GetQCMortgageInadequateCoverage'
use unitrac

---Shows history on stored procedure changes
DECLARE @filename VARCHAR(255) 
SELECT @FileName = SUBSTRING(path, 0, LEN(path)-CHARINDEX('\', REVERSE(path))+1) + '\Log.trc'  
FROM sys.traces   
WHERE is_default = 1;  

SELECT gt.HostName, 
       gt.ApplicationName, 
       gt.NTUserName, 
       gt.NTDomainName, 
       gt.LoginName, 
       gt.SPID, 
       gt.EventClass, 
       te.Name AS EventName,
       gt.EventSubClass,      
       gt.TEXTData, 
       gt.StartTime, 
       gt.EndTime, 
       gt.ObjectName, 
       gt.DatabaseName, 
       gt.FileName, 
       gt.IsSystem
FROM [fn_trace_gettable](@filename, DEFAULT) gt 
JOIN sys.trace_events te ON gt.EventClass = te.trace_event_id 
WHERE gt. = 'Report_WvNonPay'
ORDER BY StartTime DESC; 

