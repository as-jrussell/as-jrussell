Update the following EOM functions to remove all references to TIMMAY DB (Point to VUTQA01 instead):
 
VUTAgencyGetlkuLenderMHNumber
VUTAgencyGetPropertyCode
VUTAgencyGetPropertyTypeCode
VUTAgencyGetRatePropertyCode
VUTAgencyGetRateCriteriaPropertyCode



Note - In VUTAgencyGetCompanyCode, there is a reference to PIP. Thuis can be commented out altogether:
--if @AgencyCode = 'PAS'
--   BEGIN 
--   SELECT 
--   @CompanyCode = CASE 
--   WHEN @UT_COVERAGE_TYPE_CD = 'HAZARD' THEN MFICode
--   WHEN @UT_COVERAGE_TYPE_CD = 'FLOOD' THEN FloodCode
--   WHEN @UT_COVERAGE_TYPE_CD = 'WIND' THEN WindCode
--   WHEN @UT_COVERAGE_TYPE_CD = 'PHYS-DAMAGE' THEN CPICode
--   ELSE '' END
--   FROM [VUT-DB01].OSC.dbo.lkuAMMODCompanyCode
--   WHERE State = @State
  
--   END