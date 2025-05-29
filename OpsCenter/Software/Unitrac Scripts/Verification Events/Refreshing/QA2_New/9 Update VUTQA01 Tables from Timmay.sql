6 VUT DB Tables need to be updated from TIMMAY to VUTQA01. Just truncate the tables in VUTQA01 and SSIS the rows over:


truncate table  lkuRateByCriteria
truncate table  lkuCarrierZipCode
truncate table  lkuCarrierpropertyCode
truncate table  lkuPropertyCode
truncate table  lkuRateGroupID
truncate table  tblCoverageType



***Make sure to check the Enable identity insert box in the target column mappings for each table (See Attachment)***