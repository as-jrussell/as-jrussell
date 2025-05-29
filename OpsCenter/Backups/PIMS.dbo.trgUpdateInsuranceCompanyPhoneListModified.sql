-- =============================================
-- Author:Judy Roberson-- Create date: 1/18/2021
-- Description:Add Modify trigger to InsuranceCompanyPhoneList
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trgUpdateInsuranceCompanyPhoneListModified]'))
	BEGIN
		/* CREATE missing trigger */
		EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [dbo].[trgUpdateInsuranceCompanyPhoneListModified] ON [dbo].[InsuranceCompanyPhoneList]  
												FOR UPDATE AS 
												BEGIN
													Update [InsuranceCompanyPhoneList]  
													set  Modified =  (GetDate())from [InsuranceCompanyPhoneList],insertedwhere [InsuranceCompanyPhoneList].GUID = inserted.GUID
												END;'
	END
ELSE
	BEGIN
		/* ALTER existing trigger */
		EXEC dbo.sp_executesql @statement = N'ALTER TRIGGER [dbo].[trgUpdateInsuranceCompanyPhoneListModified] ON [dbo].[InsuranceCompanyPhoneList]  
												FOR UPDATE AS 
												BEGIN
													Update [InsuranceCompanyPhoneList]  
													set  Modified =  (GetDate())from [InsuranceCompanyPhoneList],insertedwhere [InsuranceCompanyPhoneList].GUID = inserted.GUID
												END;'
	END


ALTER TABLE [dbo].[trgUpdateInsuranceCompanyPhoneListModified] ENABLE TRIGGER [trgUpdateInsuranceCompanyPhoneListModified]


