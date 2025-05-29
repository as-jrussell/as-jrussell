---Login onto Staging Environments
--VUTSTAGE
--UTSTAGE

USE [VUT]
GO

TRUNCATE TABLE  lkuRateByCriteria


TRUNCATE TABLE lkuCarrierZipCode


TRUNCATE TABLE lkuCarrierpropertyCode


TRUNCATE TABLE lkuPropertyCode

TRUNCATE TABLE lkuRateGroupID


TRUNCATE TABLE tblCoverageType





USE VUTstage.[dbo].VUT 
SELECT * FROM dbo.lkuRateByCriteria


TRUNCATE TABLE  lkuRateByCriteria
--0

TRUNCATE TABLE lkuCarrierZipCode
--260347

TRUNCATE TABLE lkuCarrierpropertyCode
--408

TRUNCATE TABLE lkuPropertyCode
--3336
TRUNCATE TABLE lkuRateGroupID
--14

TRUNCATE TABLE tblCoverageType
--14






SELECT * FROM vut..lkuRateByCriteria