USE [UniTrac]
GO
/****** Object:  StoredProcedure [dbo].[Report_VerifyDataLenderColumns]    Script Date: 5/10/2016 8:15:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Report_VerifyDataLenderColumns]
 @ReportType as varchar(25)
,@ReportConfig as varchar(25)=NULL
,@ReportDomain as varchar(30)='Report_VerifyData'
as
BEGIN

DECLARE @cols NVARCHAR(2000) 
SELECT  @cols = COALESCE(@cols + ',[' + ATTRIBUTE_CD + ']', 
                        '[' + ATTRIBUTE_CD + ']') 
FROM    REF_CODE_ATTRIBUTE 
where DOMAIN_CD = @ReportDomain and REF_CD = 'DEFAULT'
ORDER BY ATTRIBUTE_CD 

--print @cols

Select 
RAD.ATTRIBUTE_CD,
Case 
  when Custom.VALUE_TX is not NULL then Custom.VALUE_TX
  when RA.VALUE_TX is not NULL then RA.VALUE_TX
  else RAD.VALUE_TX
End as VALUE_TX
into #t1
from REF_CODE RC
Join REF_CODE_ATTRIBUTE RAD on RAD.DOMAIN_CD = RC.DOMAIN_CD and RAD.REF_CD = 'DEFAULT'
left Join REF_CODE_ATTRIBUTE RA on RA.DOMAIN_CD = RC.DOMAIN_CD and RC.CODE_CD = RA.REF_CD and RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
left Join 
  (
  Select CODE_TX,REPORT_CD,REPORT_DOMAIN_CD,REPORT_REF_ATTRIBUTE_CD,VALUE_TX from REPORT_CONFIG RC
  Join REPORT_CONFIG_ATTRIBUTE RCA on RCA.REPORT_CONFIG_ID = RC.ID
  ) Custom
   on Custom.CODE_TX = @ReportConfig and RAD.DOMAIN_CD = Custom.REPORT_DOMAIN_CD and RAD.ATTRIBUTE_CD = Custom.REPORT_REF_ATTRIBUTE_CD and @ReportType = Custom.REPORT_CD
where RC.DOMAIN_CD = @ReportDomain and RC.CODE_CD = @ReportType

Declare @QueryString as nvarchar(4000)
Set @QueryString = 
'Select * 
from #t1
pivot ( max(VALUE_TX) for ATTRIBUTE_CD in (' + @cols + ')) as Information'

Execute(@QueryString)

END


