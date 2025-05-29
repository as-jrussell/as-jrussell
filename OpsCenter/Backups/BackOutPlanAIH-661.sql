

/* Backout plan */
ALTER TABLE [dbo].[trgUpdateInsuranceCompanyPhoneListModified] DISABLE TRIGGER [trgUpdateInsuranceCompanyPhoneListModified]



/* Backout plan - turn off constraints */
Alter table InsuranceCompanyPhoneList nocheck constraint DF_InsuranceCompanyPhoneList_Created
Alter table InsuranceCompanyPhoneList nocheck constraint DF_InsuranceCompanyPhoneList_Modified

