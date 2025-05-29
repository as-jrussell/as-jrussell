USE UniTrac

--- Change Table Query


SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.ENTITY_ID = '3694' AND c.ENTITY_NAME_TX = 'LDHLib.DeliveryInfo'
order by c.create_dt desc 


SELECT * FROM CHANGE C
LEFT JOIN CHANGE_UPDATE CU ON C.ID = CU.CHANGE_ID
WHERE C.USER_TX = '' AND c.CREATE_DT >= ''



INSERT INTO CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , NOTE_TX , TICKET_TX , 
 USER_TX , ATTACHMENT_IN , CREATE_DT ,  AGENCY_ID , DESCRIPTION_TX ,
 DETAILS_IN , formatted_in , LOCK_ID , PARENT_NAME_TX , PARENT_ID, TRANS_STATUS_CD, TRANS_STATUS_DT )
 SELECT DISTINCT 'LDHLib.DeliveryInfo' , '3694' , 'set the back to blank status' , 'INC0381156', 'INC0381156', 'N',  
 GETDATE() ,  NULL , 'set the back to blank status','Y' , 'Y' , 1 ,  'LDHLib.TradingPartner' , '1012' , 'NEN' , GETDATE()
FROM CHANGE 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_L)


insert into CHANGE_UPDATE
(CHANGE_ID, TABLE_NAME_TX, TABLE_ID, QUALIFIER_TX, COLUMN_NM, FROM_VALUE_TX, TO_VALUE_TX, DATATYPE_NO, CREATE_DT, AREA_TX, FORMAT_FROM_VALUE_TX, FORMAT_TO_VALUE_TX, display_in, operation_cd)
select '2664957', TABLE_NAME_TX, TABLE_ID, QUALIFIER_TX, COLUMN_NM, 'N', '', DATATYPE_NO, GETDATE(), AREA_TX, FORMAT_FROM_VALUE_TX, FORMAT_TO_VALUE_TX, display_in, operation_cd
from change_update
where CHANGE_ID IN (2664288) --(132349,132350,132354) and table_name_tx = 'DELIVERY_DETAIL'



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


select * from work_item wi 
join lender l on wi.lender_id = l.id 
where l.code_tx = '2175' and wi.create_dt >= '2018-10-31'
and workflow_definition_id in (13)

select * from PROCESS_DEFINITION
where name_tx like '%2175%' and update_user_tx = 'BSULLIVAN'



select * from process_log
where process_definition_id in (331053)
and update_dt >= '2018-10-01'
order by update_dt desc 


select * from PROCESS_LOG_ITEM
where process_log_id in (65725701)


select * from trading_partner_log
where message_id in (15905587)


Output File : (\\vut-app\Escrow\InsFile\2175\Output\INS_2175-All Branches-Mortgage-Hazard-Flood-Active Loans_20181031080346.dat) archived to Directory : \\vut-app\Escrow\InsFile\2175\ArchiveOutput  as File: (\\vut-app\Escrow\InsFile\2175\ArchiveOutput\2018_10_31_08_07_50_407-INS_2175-All Branches-Mortgage-Hazard-Flood-Active Loans_20181031080346.dat) created for Document Id : 27929193