--DROP TABLE #tmptable

USE UniTrac
--ID NAME_TX
--48 EOM


--ID NAME_TX
--35 BillingStatements
--38 WaiveNonPay
--47 BillingStatements1832
--54 PaymentChanges
--71 PRMACCRCT


--ID NAME_TX
--32 NoticeRegister
--37 PolicyRegister
--50 EscrowException
--51 EscrowNewCarrier
--52 EscrowInsurance
--53 PreEscrow
--58 PaymentIncreaseNotices
--68 NoticeRegisterAOC
--69 EscrowGPGL
--80 BillingStatementsExcel


--ID NAME_TX
--44 ExtractUpdateSummary
--45 Extracts
--46 Escrow
--75 CFPBNotificationSequence

--85 ExtractPostingErrors

--- By Report ID
SELECT DISTINCT
	REPORT_ID,
	REPORT_DOMAIN_CD INTO #tmptable
FROM REPORT_CONFIG


SELECT
	rh.REPORT_ID,
	tt.REPORT_DOMAIN_CD,
	MIN(CREATE_DT) EarliestCreateDate, COUNT(*) PendingCount
FROM REPORT_HISTORY rh
JOIN #tmptable tt
	ON rh.REPORT_ID = tt.REPORT_ID
WHERE STATUS_CD = 'pend' 
--AND rh.REPORT_ID NOT IN (48, 54, 35,38,47,71,32,37,46,50,51,52,53,69,58,68,80)
GROUP BY	rh.REPORT_ID,
			tt.REPORT_DOMAIN_CD
			ORDER BY rh.REPORT_ID

			SELECT top 50 ID, 
rh.REPORT_ID 
FROM REPORT_HISTORY rh
WHERE rh.STATUS_CD = 'pend'                           
Order by  (CASE WHEN REPORT_DATA_XML.value('(//ReportData/Report/SourceReportConfigID/@value)[1]', 'bigint') IS NULL then 0     ELSE 1 END) desc,                                           
(CASE when report_id in (48) then 1 WHEN report_id in (35,54, 38, 47,71) THEN 2                                                
when report_id in (32,37,58,50,51,52,53,69,68,80) then 3                                                
when report_id in (45,44,46,85,75) then 4 else 5 END), ID   


