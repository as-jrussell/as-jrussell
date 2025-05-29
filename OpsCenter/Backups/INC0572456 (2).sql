USE [IQQ_LIVE]
GO

  ---- Grant access 
GRANT EXECUTE ON OBJECT::SearchGapWaiverLocation 
    TO [IQQBILLS-QA];  
GO  


---- Drop Access

use [IQQ_LIVE]
GO
REVOKE EXECUTE ON [dbo].[SearchGapWaiverLocation] TO [IQQBILLS-QA] AS [dbo]
GO
