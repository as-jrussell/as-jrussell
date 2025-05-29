DECLARE @TheLenderCode varchar(max) = '1007';											
											
with											
coverstat as											
(											
select 											
ref_code.MEANING_TX as MEANING_TX,											
ref_code.Code_cd as CODE_CD											
from 											
ref_code 											
where 											
ref_code.DOMAIN_CD = 'RequiredCoverageStatus'											
and ref_code.purge_dt is null											
and ref_code.Active_in = 'Y'											
),											
											
summarystat as 											
(											
select 											
ref_code.MEANING_TX as MEANING_TX,											
ref_code.Code_cd as CODE_CD											
from 											
ref_code 											
where											
ref_code.DOMAIN_CD = 'RequiredCoverageInsStatus'											
and ref_code.purge_dt is null											
and ref_code.Active_in = 'Y'											
),											
											
summarysubstat as 											
(											
select 											
ref_code.MEANING_TX as MEANING_TX,											
ref_code.Code_cd as CODE_CD											
from 											
ref_code 											
where 											
ref_code.DOMAIN_CD = 'RequiredCoverageInsSubStatus'											
and ref_code.purge_dt is null											
and ref_code.Active_in = 'Y'											
											
),											
											
LoanType as 											
(											
select 											
ref_code.MEANING_TX as MEANING_TX,											
ref_code.Code_cd as CODE_CD											
from 											
ref_code 											
where ref_code.DOMAIN_CD = 'LoanType'											
and ref_code.purge_dt is null											
and ref_code.Active_in = 'Y'											
),											
											
Loanstat as 											
(											
select 											
ref_code.MEANING_TX as MEANING_TX,											
ref_code.Code_cd as CODE_CD											
from 											
ref_code 											
where ref_code.DOMAIN_CD = 'LoanStatus'											
and ref_code.purge_dt is null											
and ref_code.Active_in = 'Y'											
),											
											
collateralstat as 											
(											
select 											
ref_code.MEANING_TX as MEANING_TX,											
ref_code.Code_cd as CODE_CD											
from 											
ref_code 											
where ref_code.DOMAIN_CD = 'CollateralStatus'											
and ref_code.purge_dt is null											
and ref_code.Active_in = 'Y'											
),											
											
NoticeType as 											
(											
select 											
ref_code.MEANING_TX as MEANING_TX,											
ref_code.Code_cd as CODE_CD											
from 											
ref_code 											
where ref_code.DOMAIN_CD = 'NoticeType'											
and ref_code.purge_dt is null											
and ref_code.Active_in = 'Y'											
)											
											
select											
--Required_coverage.ID,											
lender.CODE_TX as 'Lender Code', 											
LENDER.NAME_TX as 'Lender Name',											
loan.number_tx as 'Loan Number',											
convert( char(10), loan.EFFECTIVE_DT, 101)  as 'Loan Effective Date',											
--convert( char(10), loan.Create_dt, 101) as 'Loan Create Date',											
loan.Branch_code_tx as 'Branch',											
--coalesce(loan.ServiceCenter_code_tx, '') as 'Service Center',											
isnull( LoanType.Meaning_tx, '' ) as 'Loan Type', 											
coalesce( loan.Original_balance_amount_NO, 0 ) as 'Original Loan Amount',											
coalesce( loan.CREDIT_LINE_AMOUNT_NO, 0 ) as 'Credit Line Amount',											
loan.BALANCE_AMOUNT_NO as 'Balance',											
isnull( Loanstat.MEANING_TX, '') as 'Loan Status',											
isnull( owner.LAST_NAME_TX, '') as 'Last Name', 											
isnull( owner.FIRST_NAME_TX, '') as 'First Name',											
isnull( collateralstat.Meaning_tx, '') as 'Collateral Status',											
collateral.Loan_balance_no as 'Collateral Balance',											
coalesce( collateral.Lien_position_no, '') as 'Lien Position',											
coalesce(cast(Property.Replacement_cost_value_no as varchar(max)), '') as 'Property RCV',											
property.calculated_coll_balance_no as 'Total Collateral Balance',											
ISNULL(padd.line_1_tx, '') as 'Property Address Line 1', 											
ISNULL(padd.city_tx, '') as 'Property Address City', 											
ISNULL(padd.STATE_PROV_TX, '') as 'Property Address State',											
ISNULL(padd.Postal_code_tx, '') as 'Property Zip',											
ISNULL(property.Flood_zone_tx, '') as 'Flood Zone',											
collateral_code.code_tx as 'Collateral Code',											
COLLATERAL_CODE.PRIMARY_CLASS_CD as 'Primary Class',											
COLLATERAL_CODE.SECONDARY_CLASS_CD as 'Secondary Class',											
collateral.purpose_code_tx as 'Purpose Code',											
collateral.Lender_collateral_code_tx as 'Lender Collateral Code',											
REQUIRED_COVERAGE.TYPE_CD as 'Coverage Type', 											
Required_coverage.REQUIRED_AMOUNT_NO as 'Required Coverage Amount',											
coalesce( coverstat.MEANING_TX, '') as 'Coverage Status',											
coalesce( summarystat.MEANING_TX, '')  as 'Coverage Summary Status',											
isnull( summarysubstat.MEANING_TX, '') as 'Coverage Summary Sub Status',											
isnull( convert( char(10), required_coverage.Exposure_dt, 101), '') as 'Exposure Date'											
											
from LENDER											
inner join LOAN on LOAN.LENDER_ID = LENDER.ID and loan.purge_dt is null and loan.RECORD_TYPE_CD = 'G'											
inner join OWNER_LOAN_RELATE on OWNER_LOAN_RELATE.loan_id = loan.ID and OWNER_LOAN_RELATE.PRIMARY_IN = 'Y'											
inner join OWNER on OWNER.ID = OWNER_LOAN_RELATE.OWNER_ID											
inner join COLLATERAL on LOAN.ID = COLLATERAL.LOAN_ID and collateral.purge_dt is null and collateral.primary_loan_in = 'Y'											
inner join PROPERTY on COLLATERAL.PROPERTY_ID = PROPERTY.ID and property.purge_dt is null and PROPERTY.RECORD_TYPE_CD = 'G'											
inner join REQUIRED_COVERAGE on required_coverage.PROPERTY_ID = PROPERTY.id and required_coverage.purge_dt is null											
inner join COLLATERAL_CODE on COLLATERAL.COLLATERAL_CODE_ID = COLLATERAL_CODE.ID											
inner join owner_address as padd on padd.id = property.address_id											
left outer join coverstat on coverstat.CODE_CD = required_coverage.Status_cd											
left outer join summarystat on summarystat.CODE_CD = required_coverage.SUMMARY_STATUS_CD											
left outer join summarysubstat on summarysubstat.CODE_CD = required_coverage.SUMMARY_SUB_STATUS_CD											
left outer join Loanstat on Loanstat.CODE_CD = loan.Status_cd											
left outer join collateralstat on collateralstat.CODE_CD = collateral.Status_cd											
left outer join LoanType on LoanType.CODE_CD = loan.Type_cd											
											
											
											
where 											
1=1											
and lender.purge_dt is null											
and LOAN.EXTRACT_UNMATCH_COUNT_NO = 0											
and loan.Status_cd <> 'U'											
and collateral.EXTRACT_UNMATCH_COUNT_NO = 0											
and collateral.Status_cd <> 'U'											
and required_coverage.Status_cd <> 'I'											
and lender.code_tx = @TheLenderCode											
											
order by											
loan.number_tx,											
padd.line_1_tx,											
REQUIRED_COVERAGE.TYPE_CD											
