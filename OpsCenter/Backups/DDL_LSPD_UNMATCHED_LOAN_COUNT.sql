USE ROLE OWNER_EDW_PROD;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_PROD;

USE SCHEMA CDW;
	
DROP TABLE LSPD_UNMATCHED_LOAN_COUNT;
	
DESC TABLE EDW_TEST.CDW.LSPD_UNMATCHED_LOAN_COUNT;

create or replace TABLE LSPD_UNMATCHED_LOAN_COUNT (
	SUMMARY_DATE DATE,
	LENDER_ID NUMBER(38,0),
	LENDER_CODE VARCHAR(1000),
	LENDER_NAME VARCHAR(1000),
	AGENCY_NAME VARCHAR(10000),
	ALLIED_PROTECT_TIER VARCHAR(1000),
	REGION_NAME VARCHAR(1000),
	LOAN_GROUP VARCHAR(16777216),
	PRODUCT_BILLING_TYPE VARCHAR(100),
	PRODUCT_RATE_TYPE VARCHAR(100),
	PRODUCT_BILLING_GROUP VARCHAR(16777216),
	PRODUCT_RATE_GROUP VARCHAR(16777216),
	UNMATCHED_LOAN_COUNT NUMBER(38,0),
	"tot_coverage_type_phys-damage" NUMBER(38,0),
	"tot_coverage_type_hazard" NUMBER(38,0),
	"tot_coverage_type_flood" NUMBER(38,0),
	"tot_coverage_type_auto-liability" NUMBER(38,0),
	"tot_coverage_type_wind" NUMBER(38,0),
	"tot_coverage_type_equipment" NUMBER(38,0),
	"tot_coverage_type_comm-liability" NUMBER(38,0),
	"tot_coverage_type_reo-liability" NUMBER(38,0),
	"tot_coverage_type_earthquake" NUMBER(38,0),
	"tot_coverage_type_hur" NUMBER(38,0),
	"tot_coverage_type_worker-comp" NUMBER(38,0),
	"tot_coverage_type_life" NUMBER(38,0),
	"tot_coverage_type_comm-content" NUMBER(38,0),
	"tot_coverage_type_bldr-hazard" NUMBER(38,0),
	"tot_coverage_type_contractor-liability" NUMBER(38,0),
	"tot_coverage_type_biz-interrupt" NUMBER(38,0),
	"tot_coverage_type_sinkhole" NUMBER(38,0),
	"tot_coverage_type_bldr-flood" NUMBER(38,0),
	"tot_coverage_type_prof-liability" NUMBER(38,0),
	"tot_coverage_type_pollution-liability" NUMBER(38,0),
	"tot_coverage_type_lender-auto-damage" NUMBER(38,0),
	"tot_coverage_type_liquor-liability" NUMBER(38,0),
	ESCROW_IND VARCHAR(100),
	LOAD_DATE DATE
);