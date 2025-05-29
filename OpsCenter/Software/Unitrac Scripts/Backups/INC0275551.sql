USE UniTrac	

SELECT L.BRANCH_CODE_TX, RC.* FROM dbo.LOAN L
JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
JOIN dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
JOIN dbo.REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = P.ID
WHERE L.NUMBER_TX = '73234-101'


SELECT TOP 1 LOGO_IM FROM LOGO WHERE LENDER_ID in (select ID from LENDER where CODE_TX ='3266') AND PURGE_DT IS NULL

SELECT * FROM dbo.REPORT_HISTORY
WHERE REPORT_ID = '58' AND STATUS_CD = 'PEND'




SELECT * FROM dbo.REPORT_HISTORY RH 
JOIN dbo.PROCESS_LOG_ITEM PLI ON RH.ID = PLI.RELATE_ID AND PLI.RELATE_TYPE_CD LIKE '%ReportHistory'
JOIN dbo.PROCESS_LOG PL ON PL.ID = PLI.PROCESS_LOG_ID
JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE RH.LENDER_ID = '386' AND RH.UPDATE_DT >= '2016-12-05 '



		            ---------------- Setting Report to Re-Pend/Re-Try -------------------
UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), DOCUMENT_CONTAINER_ID = NULL 
	, REPORT_DATA_XML = '<ReportData>
  <Report>
    <Title value="Payment Increase Notices - Default PI Notice" />
    <ReportID value="" />
    <UniqueReportID value="" />
    <ReportConfigID value="801" />
    <SourceReportConfigID value="41370" />
    <BillingGroupID value="0" />
    <ProcessDefinitionID value="12601" />
    <ProcessLogID value="39827675" />
    <DocumentID value="0" />
    <GroupByTx value="" />
    <SortByTx value="PolicyNumber" />
    <FilterByTx value="PI1LP-IN01-BLNK" />
    <HeaderTx value="" />
    <FooterTx value="" />
    <CertsSubmitted value="N" />
    <NoticesSubmitted value="N" />
    <Regenerated value="N" />
    <Lender value="3266" />
    <CreatedDate value="2016-12-01T23:22:34" />
    <StartDate value="2016-11-29T23:22:33" />
    <EndDate value="2016-12-01T23:22:44" />
    <Center />
    <Division value="3" />
    <Coverage />
    <ReportType value="PI1LP-IN01-BLNK" />
    <ReportConfig value="PI1LP-IN01-BLNK" />
    <WorkItemId value="35615805" />
    <Branches />
    <RelateId value="0" />
    <RelateClassName />
  </Report>
</ReportData>'
--		,REPORT_ID = '27'
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN (10924705)



SELECT * FROM dbo.REPORT_HISTORY
WHERE REPORT_ID = '58' AND UPDATE_DT >='2016-10-07 '
AND LENDER_ID = '386'