USE UniTrac

--- Change Table Query


SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID = '14644'
order by c.create_dt desc 


SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.USER_TX = 'jrussell' AND c.CREATE_DT >= '2020-01-09'



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
Allied.UniTrac.ProcessHelper.UniTracProcessDefinition
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

