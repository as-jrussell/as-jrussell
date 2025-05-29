USE [UNITRAC_MORTGAGE];
CREATE USER [PIMSAppService] FOR LOGIN [PIMSAppService];

/* Create App Role */
CREATE ROLE [PIMS_APP_ACCESS] AUTHORIZATION [dbo];

/* Add object and permissions to role */
GRANT SELECT ON [dbo].[OneMainCPIIssueRefund] TO [PIMS_APP_ACCESS];
GRANT SELECT ON [dbo].[Integration_File] TO [PIMS_APP_ACCESS];

/* Add members to new role */
ALTER ROLE [PIMS_APP_ACCESS] ADD MEMBER [PIMSAppService];
