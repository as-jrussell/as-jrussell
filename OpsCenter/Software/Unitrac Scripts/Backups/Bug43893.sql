USE UniTrac

--- Change Table Query


SELECT * FROM dbo.TEMPLATE
WHERE UPDATE_DT  >= '2018-01-12'

SELECT * FROM dbo.CONTENT_BLOCK_ASSIGNMENT
WHERE UPDATE_DT >= '2018-01-12'

SELECT * FROM dbo.TEMPLATE T
WHERE ID = 70


SELECT * FROM dbo.CONTENT_BLOCK_FAMILY
WHERE	id = 978



SELECT * FROM dbo.CONTENT_BLOCK_DEFINITION
WHERE id = 3108



SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID IN ('70') AND C.ENTITY_NAME_TX IN ('Allied.UniTrac.Template')
AND  C.CREATE_DT >= '2018-01-12'



SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID IN ('978') AND C.ENTITY_NAME_TX IN ('Allied.UniTrac.ContentBlockFamily')
AND  C.CREATE_DT >= '2018-01-12'




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


