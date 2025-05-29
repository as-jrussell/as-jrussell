USE Unitrac

SELECT * FROM dbo.PROCESS_DEFINITION
WHERE NAME_TX LIKE '%6608%' AND PROCESS_TYPE_CD = 'BILLING'

UPDATE dbo.PROCESS_DEFINITION
SET STATUS_CD = 'Complete'
WHERE ID = 14240


SELECT * FROM dbo.WORK_ITEM
WHERE ID  = 41600732 OR 
RELATE_ID = 49841747 AND WORKFLOW_DEFINITION_ID = 9

SELECT * FROM dbo.PROCESS_LOG
WHERE --id = 50431603
PROCESS_DEFINITION_ID = 12445 AND UPDATE_DT >= '2017-09-01'
AND END_DT IS NOT NULL 


--49841747

--DROP TABLE #tmpEE3

SELECT EVALUATION_EVENT_ID INTO #tmpEE4 FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 49159396


SELECT RELATE_ID INTO #IHn4 FROM dbo.EVALUATION_EVENT
WHERE ID IN (SELECT * FROM #tmpEE4)
AND TYPE_CD = 'AOBC'

SELECT*FROM dbo.EVALUATION_EVENT
WHERE ID IN (SELECT * FROM #tmpEE4)
AND RELATE_TYPE_CD = 'Allied.UniTrac.NoticeInteraction'

SELECT *FROM dbo.EVALUATION_EVENT
WHERE ID IN (SELECT * FROM #tmpEE2)
AND TYPE_CD = 'AOBC'

SELECT * FROM dbo.EVENT_SEQUENCE
WHERE --id IN (440458, 440457, 177241)
--440457 purged,
EVENT_SEQ_CONTAINER_ID IN (52282,
130582)
ORDER BY EVENT_SEQ_CONTAINER_ID, ORDER_NO ASC 


SELECT * FROM dbo.INTERACTION_HISTORY
WHERE ID IN (SELECT * FROM #IHn)

SELECT * FROM dbo.EVENT_SEQ_CONTAINER
WHERE id-- = 130582
IN (52282,
130582)



SELECT * FROM dbo.TEMPLATE
WHERE ID IN (0, 10)

SELECT * FROM dbo.LENDER_PRODUCT

WHERE id = 2674

LENDER_ID = 193


Vehicle, PHYS-DAMAGE- moved to SMP w/Call Outs - eff 8.1.17


SELECT * FROM dbo.PROCESS_DEFINITION
WHERE id = 12445


USE UniTrac

--- Change Table Query



SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID IN ('2674') AND C.ENTITY_NAME_TX IN ('Allied.UniTrac.LenderProduct')
ORDER BY c.CREATE_DT DESC 


---It will always be on of the items below
/*
Allied.UniTrac.AccountingPeriod
Allied.UniTrac.Agency
Allied.UniTrac.AgencyRefDomain
Allied.UniTrac.BorrowerInsuranceAddress
Allied.UniTrac.BorrowerInsuranceAgency
Allied.UniTrac.BorrowerInsuranceCompany
Allied.UniTrac.CancelProcedure
Allied.UniTrac.Carrier
Allied.UniTrac.CarrierProduct
Allied.UniTrac.CollateralCode
Allied.UniTrac.CommissionRate
Allied.UniTrac.ContentBlockFamily
Allied.UniTrac.ContentSetting
Allied.UniTrac.InternalOutputConfig
Allied.UniTrac.IssueProcedure
Allied.UniTrac.Lender
Allied.UniTrac.LenderCollateralCodeGroup
Allied.UniTrac.LenderExtract.LenderExtract
Allied.UniTrac.LenderFinancialTxn
Allied.UniTrac.LenderGroup
Allied.UniTrac.LenderOrganization
Allied.UniTrac.LenderProduct
Allied.UniTrac.LenderReportConfig
Allied.UniTrac.LetterStyle
Allied.UniTrac.Loan
Allied.UniTrac.Logo
Allied.UniTrac.MasterPolicy
Allied.UniTrac.OutputConfiguration
Allied.UniTrac.OutsourceOutputConfig
Allied.UniTrac.PolicyEndorsement
Allied.UniTrac.ProcessHelper.UniTracProcessDefinit
Allied.UniTrac.PropertyAssociation
Allied.UniTrac.RateTable
Allied.UniTrac.RemittanceAddress
Allied.UniTrac.SalesRegion
Allied.UniTrac.ServiceFeeInvoiceConfig
Allied.UniTrac.Template
Allied.UniTrac.UniTracSecurityGroup
Allied.UniTrac.UniTracUser
Allied.UniTrac.Workflow.UnitracWorkQueue
LDHLib.DeliveryInfo
Osprey.ProcessMgr.ProcessDefinition
Osprey.Workflow.UserWorkQueueRelate
*/


