USE [UniTrac]
GO

/****** Object:  StoredProcedure [dbo].[Report_InsuranceCarrierChangeColumns]    Script Date: 7/12/2017 2:47:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report_InsuranceCarrierChangeColumns] (@ReportType as varchar(100), @SubReport as varchar(100)=NULL)
AS
BEGIN
--DECLARE @SubReport nvarchar(30)=NULL
DECLARE @Domain as nvarchar(50)=NULL
DECLARE @cols NVARCHAR(2000)=NULL
DECLARE @QueryString as nvarchar(4000)

--Get rid of residual #TA tables
IF OBJECT_ID(N'tempdb..#TA',N'U') IS NOT NULL
  DROP TABLE #TA

IF @SubReport = '0000'
	SET @SubReport = @ReportType

SET @Domain = 'Report_InsuranceCarrierChange'

SELECT  @cols = COALESCE(@cols + ',[' + ATTRIBUTE_CD + ']', 
                        '[' + ATTRIBUTE_CD + ']') 
FROM    REF_CODE_ATTRIBUTE 
WHERE DOMAIN_CD = @Domain and REF_CD = 'DEFAULT'
ORDER BY ATTRIBUTE_CD 

SELECT ATTRIBUTE_CD, VALUE_TX INTO #TA FROM REF_CODE_ATTRIBUTE WHERE DOMAIN_CD = @Domain AND REF_CD = 'DEFAULT' ORDER BY ATTRIBUTE_CD

IF @SubReport IS NOT NULL
BEGIN
	UPDATE TA SET TA.VALUE_TX = RCA.VALUE_TX
	FROM #TA TA JOIN REF_CODE_ATTRIBUTE RCA ON TA.ATTRIBUTE_CD = RCA.ATTRIBUTE_CD
	WHERE RCA.DOMAIN_CD = @Domain AND RCA.REF_CD = @SubReport
END

Set @QueryString = 
'Select * 
from #TA
pivot ( max(VALUE_TX) for ATTRIBUTE_CD in (' + @cols + ')) as Information'
Execute(@QueryString)
END


GO

