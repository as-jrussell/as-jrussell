USE [UniTrac]
GO

--GRANT EXECUTE ON [dbo].[CheckSumDigit] TO [ELDREDGE_A\BHouk] AS [dbo]
--GO
--GRANT REFERENCES ON [dbo].[CheckSumDigit] TO [ELDREDGE_A\BHouk] AS [dbo]
--GO

GRANT EXECUTE ON [dbo].[CheckSumDigit] TO [PIMSAppService] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[CPGetNotificationEvent] TO [PIMSAppService] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[CheckSumDigit] TO [CenterPointdbDBCred3_CPServices]
GO

use master

GRANT VIEW SERVER STATE TO  [UTdbWorkItemService-API-Prod]


GRANT VIEW SERVER STATE TO [UTdbAuditHistory-API-Prod]
GRANT VIEW SERVER STATE TO [UTdbInteractionHistory-API-Prod]
GRANT VIEW SERVER STATE TO [UTdbInteractionHistory-API-Prod]
GRANT VIEW SERVER STATE TO  [UTdbLenderService-API-Prod] 
GRANT VIEW SERVER STATE TO [UTdbNotificationService-API-Prod]
GRANT VIEW SERVER STATE TO [UTdbPropertyService-API-Prod] 
GRANT VIEW SERVER STATE TO [UTdbQCService-API-Prod]
GRANT VIEW SERVER STATE TO [UTdbUTLService-API-Prod]