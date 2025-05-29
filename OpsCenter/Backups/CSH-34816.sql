/*
Missing Index Details from SQLQuery111.sql - SQLSTSTAWRD01.tempdb (ELDREDGE_A\jrussell (80))
The Query Processor estimates that implementing the following index could improve the query cost by 73.824%.
*/

/*
USE [IVOS]
GO
CREATE NONCLUSTERED INDEX [IX_claimant_claimant_type_code_claimant_status_code] ON [dbo].[claimant] 
([claimant_type_code],[claimant_status_code])
INCLUDE ([claim_id],[claimant_id],[insurance_type],[client_code],[claimant_name],[death_date],[delayed_decision_date],[alternate_claimant_number])
GO


USE [IVOS]
GO
CREATE NONCLUSTERED INDEX [claim_file_transfer_date]
ON [dbo].[claim] ([file_transfer_date])
INCLUDE ([claim_id],[claim_number],[incident_date],[incident_reported_date],[org1_code],[org2_code],[org3_code],[org4_code],[org5_code],[org6_code],[org_group_code])
GO
*/

--DROP INDEX [claim_file_transfer_date] ON [dbo].[claim]
--DROP INDEX [IX_claimant_claimant_type_code_claimant_status_code] ON [dbo].[claimant] 
