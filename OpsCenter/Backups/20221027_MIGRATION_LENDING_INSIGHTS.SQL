USE ROLE OWNER_EDW_PROD;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_PROD;

USE SCHEMA LNDINS;

DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LENDER;

CREATE OR REPLACE TABLE LNDINS.D_LI_LENDER
(
 D_LI_LENDER_ID                                               NUMBER(38,0)         NOT NULL PRIMARY KEY
,LENDERID                                                     NUMBER(10,0)
,CLIENTCODE                                                   TEXT(10)
,LENDERLONGNAME                                               TEXT(100)
,LENDERSHORTNAME                                              TEXT(50)
,LENDERID_PARENT                                              NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LOAN_AUTO;

CREATE OR REPLACE TABLE LNDINS.D_LI_LOAN_AUTO
(
 D_LI_LOAN_AUTO_ID                                            NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,VEHICLE_TYPE                                                 NUMBER(3,0)
,NEW_USED_CODE                                                NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,DEALER_CODE                                                  TEXT(30)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,VEHICLE_YEAR                                                 NUMBER(10,0)
,VEHICLE_MODEL                                                TEXT(50)
,VEHICLE_MAKE                                                 TEXT(50)
,VEHICLE_VIN                                                  TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,DEALER_PERSONNEL_CODE                                        TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LOAN_BUSINESS;

CREATE OR REPLACE TABLE LNDINS.D_LI_LOAN_BUSINESS
(
 D_LI_LOAN_BUINESS_ID                                         NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,RATE                                                         NUMBER(6,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LOAN_TYPE                                                    NUMBER(3,0)
,BUSINESS_TYPE                                                NUMBER(3,0)
,NATURE_OF_BUSINESS                                           NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,PL_INVESTOR_CODE                                             TEXT(10)
,PL_INVESTOR_NAME                                             TEXT(255)
,PL_MULTI_PARTICIPANT                                         TEXT(1)
,PL_SOLD_IN_POOL                                              TEXT(1)
,PL_ORIGINAL_APPRAISAL                                        NUMBER(19,4)
,PL_UPDATED_VALUE                                             NUMBER(19,4)
,DATE_OF_UPDATEDVALUE                                         TIMESTAMP_NTZ
,PL_IS_PG                                                     TEXT(1)
,PL_LOAN_MOD                                                  TEXT(1)
,PL_MBL_CREDITSCORE                                           NUMBER(10,0)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,CREDIT_SCORE_2_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LOAN_FILE_IMPORT;

CREATE OR REPLACE TABLE LNDINS.D_LI_LOAN_FILE_IMPORT
(
 D_LI_LOAN_FILE_IMPORT_ID                                     NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,USERGUID                                                     TEXT(50)
,CLIENTCODE                                                   TEXT(10)
,MODULEID                                                     NUMBER(3,0)
,BATCHDATE                                                    DATE
,UPLOADDATETIME                                               TIMESTAMP_NTZ
,ORIGINALFILENAME                                             TEXT(255)
,LENDERID                                                     NUMBER(10,0)
,FILESTAGEID                                                  NUMBER(3,0)
,FILESTAGEUPDATEDON                                           TIMESTAMP_NTZ
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LOAN_MORTGAGE;

CREATE OR REPLACE TABLE LNDINS.D_LI_LOAN_MORTGAGE
(
 D_LI_LOAN_MORTGAGE_ID                                        NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LIEN_1ST_POSITION                                            TEXT(1)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,OWNER_OCCUPIED                                               TEXT(1)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LOAN_REVOLVING;

CREATE OR REPLACE TABLE LNDINS.D_LI_LOAN_REVOLVING
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL PRIMARY KEY
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,LINE_ORIGINAL_DATE                                           TIMESTAMP_NTZ
,CURRENT_LIMIT                                                NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,PMT_DUE_DATE                                                 TIMESTAMP_NTZ
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,FICO_SCORE_SNAPSHOT                                          NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,CURRENT_RATE                                                 NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LOAN_STUDENT;

CREATE OR REPLACE TABLE LNDINS.D_LI_LOAN_STUDENT
(
 D_LI_LOAN_STUDENT_ID                                         NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,CREDIT_UNION_CODE                                            TEXT(50)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,SCHOOL_CODE                                                  TEXT(10)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS.D_LI_LOAN_TYPE;

CREATE OR REPLACE TABLE LNDINS.D_LI_LOAN_TYPE
(
 D_LI_LOAN_TYPE_ID                                            NUMBER(38,0)         NOT NULL PRIMARY KEY
,LOANTYPEID                                                   NUMBER(38,0)
,LOANTYPELONGNAME                                             TEXT(50)
,PRODUCTTYPEID                                                NUMBER(3,0)
,ETL_LOANTYPE                                                 NUMBER(38,0)
,LENDERID                                                     NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


USE SCHEMA LNDINS_STG;

DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LENDER_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LENDER_TEMP
(
 D_LI_LENDER_ID                                               NUMBER(38,0)         NOT NULL PRIMARY KEY
,LENDERID                                                     NUMBER(10,0)
,CLIENTCODE                                                   TEXT(10)
,LENDERLONGNAME                                               TEXT(100)
,LENDERSHORTNAME                                              TEXT(50)
,LENDERID_PARENT                                              NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LOAN_AUTO_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LOAN_AUTO_TEMP
(
 D_LI_LOAN_AUTO_ID                                            NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,VEHICLE_TYPE                                                 NUMBER(3,0)
,NEW_USED_CODE                                                NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,DEALER_CODE                                                  TEXT(30)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,VEHICLE_YEAR                                                 NUMBER(10,0)
,VEHICLE_MODEL                                                TEXT(50)
,VEHICLE_MAKE                                                 TEXT(50)
,VEHICLE_VIN                                                  TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,DEALER_PERSONNEL_CODE                                        TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LOAN_BUSINESS_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LOAN_BUSINESS_TEMP
(
 D_LI_LOAN_BUINESS_ID                                         NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,RATE                                                         NUMBER(6,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LOAN_TYPE                                                    NUMBER(3,0)
,BUSINESS_TYPE                                                NUMBER(3,0)
,NATURE_OF_BUSINESS                                           NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,PL_INVESTOR_CODE                                             TEXT(10)
,PL_INVESTOR_NAME                                             TEXT(255)
,PL_MULTI_PARTICIPANT                                         TEXT(1)
,PL_SOLD_IN_POOL                                              TEXT(1)
,PL_ORIGINAL_APPRAISAL                                        NUMBER(19,4)
,PL_UPDATED_VALUE                                             NUMBER(19,4)
,DATE_OF_UPDATEDVALUE                                         TIMESTAMP_NTZ
,PL_IS_PG                                                     TEXT(1)
,PL_LOAN_MOD                                                  TEXT(1)
,PL_MBL_CREDITSCORE                                           NUMBER(10,0)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,CREDIT_SCORE_2_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LOAN_FILE_IMPORT_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LOAN_FILE_IMPORT_TEMP
(
 D_LI_LOAN_FILE_IMPORT_ID                                     NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,USERGUID                                                     TEXT(50)
,CLIENTCODE                                                   TEXT(10)
,MODULEID                                                     NUMBER(3,0)
,BATCHDATE                                                    DATE
,UPLOADDATETIME                                               TIMESTAMP_NTZ
,ORIGINALFILENAME                                             TEXT(255)
,LENDERID                                                     NUMBER(10,0)
,FILESTAGEID                                                  NUMBER(3,0)
,FILESTAGEUPDATEDON                                           TIMESTAMP_NTZ
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LOAN_MORTGAGE_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LOAN_MORTGAGE_TEMP
(
 D_LI_LOAN_MORTGAGE_ID                                        NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LIEN_1ST_POSITION                                            TEXT(1)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,OWNER_OCCUPIED                                               TEXT(1)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LOAN_REVOLVING_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LOAN_REVOLVING_TEMP
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL PRIMARY KEY
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,LINE_ORIGINAL_DATE                                           TIMESTAMP_NTZ
,CURRENT_LIMIT                                                NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,PMT_DUE_DATE                                                 TIMESTAMP_NTZ
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,FICO_SCORE_SNAPSHOT                                          NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,CURRENT_RATE                                                 NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LOAN_STUDENT_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LOAN_STUDENT_TEMP
(
 D_LI_LOAN_STUDENT_ID                                         NUMBER(38,0)         NOT NULL PRIMARY KEY
,FILEIMPORTID                                                 NUMBER(38,0)
,CREDIT_UNION_CODE                                            TEXT(50)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,SCHOOL_CODE                                                  TEXT(10)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.D_LI_LOAN_TYPE_TEMP;

CREATE OR REPLACE TABLE LNDINS_STG.D_LI_LOAN_TYPE_TEMP
(
 D_LI_LOAN_TYPE_ID                                            NUMBER(38,0)         NOT NULL PRIMARY KEY
,LOANTYPEID                                                   NUMBER(38,0)
,LOANTYPELONGNAME                                             TEXT(50)
,PRODUCTTYPEID                                                NUMBER(3,0)
,ETL_LOANTYPE                                                 NUMBER(38,0)
,LENDERID                                                     NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LENDER;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LENDER
(
 LENDERID                                                     NUMBER(10,0)         NOT NULL PRIMARY KEY
,CLIENTCODE                                                   TEXT(10)
,LENDERLONGNAME                                               TEXT(100)
,LENDERSHORTNAME                                              TEXT(50)
,LENDERID_PARENT                                              NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LOAN_AUTO;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LOAN_AUTO
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,VEHICLE_TYPE                                                 NUMBER(3,0)
,NEW_USED_CODE                                                NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,DEALER_CODE                                                  TEXT(30)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,VEHICLE_YEAR                                                 NUMBER(10,0)
,VEHICLE_MODEL                                                TEXT(50)
,VEHICLE_MAKE                                                 TEXT(50)
,VEHICLE_VIN                                                  TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,DEALER_PERSONNEL_CODE                                        TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LOAN_BUSINESS;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LOAN_BUSINESS
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)             NOT NULL
,LOAN_ID                                                      TEXT(50)             NOT NULL
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ        NOT NULL
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,RATE                                                         NUMBER(6,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LOAN_TYPE                                                    NUMBER(3,0)
,BUSINESS_TYPE                                                NUMBER(3,0)
,NATURE_OF_BUSINESS                                           NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,PL_INVESTOR_CODE                                             TEXT(10)
,PL_INVESTOR_NAME                                             TEXT(255)
,PL_MULTI_PARTICIPANT                                         TEXT(1)
,PL_SOLD_IN_POOL                                              TEXT(1)
,PL_ORIGINAL_APPRAISAL                                        NUMBER(19,4)
,PL_UPDATED_VALUE                                             NUMBER(19,4)
,DATE_OF_UPDATEDVALUE                                         TIMESTAMP_NTZ
,PL_IS_PG                                                     TEXT(1)
,PL_LOAN_MOD                                                  TEXT(1)
,PL_MBL_CREDITSCORE                                           NUMBER(10,0)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,CREDIT_SCORE_2_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LOAN_FILE_IMPORT;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LOAN_FILE_IMPORT
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,USERGUID                                                     TEXT(50)
,CLIENTCODE                                                   TEXT(10)
,MODULEID                                                     NUMBER(3,0)
,BATCHDATE                                                    DATE
,UPLOADDATETIME                                               TIMESTAMP_NTZ
,ORIGINALFILENAME                                             TEXT(255)
,LENDERID                                                     NUMBER(10,0)
,FILESTAGEID                                                  NUMBER(3,0)
,FILESTAGEUPDATEDON                                           TIMESTAMP_NTZ
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LOAN_MORTGAGE;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LOAN_MORTGAGE
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LIEN_1ST_POSITION                                            TEXT(1)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,OWNER_OCCUPIED                                               TEXT(1)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LOAN_REVOLVING;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LOAN_REVOLVING
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,LINE_ORIGINAL_DATE                                           TIMESTAMP_NTZ
,CURRENT_LIMIT                                                NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,PMT_DUE_DATE                                                 TIMESTAMP_NTZ
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,FICO_SCORE_SNAPSHOT                                          NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,CURRENT_RATE                                                 NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LOAN_STUDENT;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LOAN_STUDENT
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,CREDIT_UNION_CODE                                            TEXT(50)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,SCHOOL_CODE                                                  TEXT(10)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.LND_LI_LOAN_TYPE;

CREATE OR REPLACE TABLE LNDINS_STG.LND_LI_LOAN_TYPE
(
 LOANTYPEID                                                   NUMBER(38,0)         NOT NULL
,LOANTYPELONGNAME                                             TEXT(50)
,PRODUCTTYPEID                                                NUMBER(3,0)
,ETL_LOANTYPE                                                 NUMBER(38,0)
,LENDERID                                                     NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LENDER;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LENDER
(
 LENDERID                                                     NUMBER(10,0)         NOT NULL
,CLIENTCODE                                                   TEXT(10)
,LENDERLONGNAME                                               TEXT(100)
,LENDERSHORTNAME                                              TEXT(50)
,LENDERID_PARENT                                              NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LENDER_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LENDER_H
(
 LENDERID                                                     NUMBER(10,0)         NOT NULL
,CLIENTCODE                                                   TEXT(10)
,LENDERLONGNAME                                               TEXT(100)
,LENDERSHORTNAME                                              TEXT(50)
,LENDERID_PARENT                                              NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_AUTO;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_AUTO
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,VEHICLE_TYPE                                                 NUMBER(3,0)
,NEW_USED_CODE                                                NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,DEALER_CODE                                                  TEXT(30)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,VEHICLE_YEAR                                                 NUMBER(10,0)
,VEHICLE_MODEL                                                TEXT(50)
,VEHICLE_MAKE                                                 TEXT(50)
,VEHICLE_VIN                                                  TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,DEALER_PERSONNEL_CODE                                        TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_AUTO_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_AUTO_H
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,VEHICLE_TYPE                                                 NUMBER(3,0)
,NEW_USED_CODE                                                NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,DEALER_CODE                                                  TEXT(30)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,VEHICLE_YEAR                                                 NUMBER(10,0)
,VEHICLE_MODEL                                                TEXT(50)
,VEHICLE_MAKE                                                 TEXT(50)
,VEHICLE_VIN                                                  TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,DEALER_PERSONNEL_CODE                                        TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_BUSINESS;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_BUSINESS
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)             NOT NULL
,LOAN_ID                                                      TEXT(50)             NOT NULL
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ        NOT NULL
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,RATE                                                         NUMBER(6,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LOAN_TYPE                                                    NUMBER(3,0)
,BUSINESS_TYPE                                                NUMBER(3,0)
,NATURE_OF_BUSINESS                                           NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,PL_INVESTOR_CODE                                             TEXT(10)
,PL_INVESTOR_NAME                                             TEXT(255)
,PL_MULTI_PARTICIPANT                                         TEXT(1)
,PL_SOLD_IN_POOL                                              TEXT(1)
,PL_ORIGINAL_APPRAISAL                                        NUMBER(19,4)
,PL_UPDATED_VALUE                                             NUMBER(19,4)
,DATE_OF_UPDATEDVALUE                                         TIMESTAMP_NTZ
,PL_IS_PG                                                     TEXT(1)
,PL_LOAN_MOD                                                  TEXT(1)
,PL_MBL_CREDITSCORE                                           NUMBER(10,0)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,CREDIT_SCORE_2_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_BUSINESS_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_BUSINESS_H
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)             NOT NULL
,LOAN_ID                                                      TEXT(50)             NOT NULL
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ        NOT NULL
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,RATE                                                         NUMBER(6,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LOAN_TYPE                                                    NUMBER(3,0)
,BUSINESS_TYPE                                                NUMBER(3,0)
,NATURE_OF_BUSINESS                                           NUMBER(3,0)
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,PL_INVESTOR_CODE                                             TEXT(10)
,PL_INVESTOR_NAME                                             TEXT(255)
,PL_MULTI_PARTICIPANT                                         TEXT(1)
,PL_SOLD_IN_POOL                                              TEXT(1)
,PL_ORIGINAL_APPRAISAL                                        NUMBER(19,4)
,PL_UPDATED_VALUE                                             NUMBER(19,4)
,DATE_OF_UPDATEDVALUE                                         TIMESTAMP_NTZ
,PL_IS_PG                                                     TEXT(1)
,PL_LOAN_MOD                                                  TEXT(1)
,PL_MBL_CREDITSCORE                                           NUMBER(10,0)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,CREDIT_SCORE_2_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_FILE_IMPORT;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_FILE_IMPORT
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,USERGUID                                                     TEXT(50)
,CLIENTCODE                                                   TEXT(10)
,MODULEID                                                     NUMBER(3,0)
,BATCHDATE                                                    DATE
,UPLOADDATETIME                                               TIMESTAMP_NTZ
,ORIGINALFILENAME                                             TEXT(255)
,LENDERID                                                     NUMBER(10,0)
,FILESTAGEID                                                  NUMBER(3,0)
,FILESTAGEUPDATEDON                                           TIMESTAMP_NTZ
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_FILE_IMPORT_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_FILE_IMPORT_H
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,USERGUID                                                     TEXT(50)
,CLIENTCODE                                                   TEXT(10)
,MODULEID                                                     NUMBER(3,0)
,BATCHDATE                                                    DATE
,UPLOADDATETIME                                               TIMESTAMP_NTZ
,ORIGINALFILENAME                                             TEXT(255)
,LENDERID                                                     NUMBER(10,0)
,FILESTAGEID                                                  NUMBER(3,0)
,FILESTAGEUPDATEDON                                           TIMESTAMP_NTZ
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_MORTGAGE;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_MORTGAGE
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LIEN_1ST_POSITION                                            TEXT(1)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,OWNER_OCCUPIED                                               TEXT(1)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_MORTGAGE_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_MORTGAGE_H
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,LIEN_1ST_POSITION                                            TEXT(1)
,ORIGINAL_TERM                                                NUMBER(10,0)
,LOAN_TO_VALUE_RATIO                                          NUMBER(6,4)
,OWNER_OCCUPIED                                               TEXT(1)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,OTHER_LOAN_BALANCE                                           NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_REVOLVING;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_REVOLVING
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,LINE_ORIGINAL_DATE                                           TIMESTAMP_NTZ
,CURRENT_LIMIT                                                NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,PMT_DUE_DATE                                                 TIMESTAMP_NTZ
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,FICO_SCORE_SNAPSHOT                                          NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,CURRENT_RATE                                                 NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_REVOLVING_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_REVOLVING_H
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,LINE_ORIGINAL_DATE                                           TIMESTAMP_NTZ
,CURRENT_LIMIT                                                NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,PMT_DUE_DATE                                                 TIMESTAMP_NTZ
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BROKER_FLAG                                                  TEXT(1)
,BROKER_CODE                                                  TEXT(10)
,BANKRUPTCY_FLAG                                              TEXT(1)
,FICO_SCORE_SNAPSHOT                                          NUMBER(10,0)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,CREDIT_UNION_CODE                                            TEXT(50)
,LOAN_TYPE                                                    NUMBER(38,0)
,CURRENT_RATE                                                 NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_STUDENT;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_STUDENT
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,CREDIT_UNION_CODE                                            TEXT(50)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,SCHOOL_CODE                                                  TEXT(10)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_STUDENT_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_STUDENT_H
(
 FILEIMPORTID                                                 NUMBER(38,0)         NOT NULL
,CREDIT_UNION_CODE                                            TEXT(50)
,ACCOUNT_NUMBER                                               TEXT(50)
,LOAN_ID                                                      TEXT(50)
,DATE_ACCOUNT_OPENED                                          TIMESTAMP_NTZ
,ORIGINAL_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_BALANCE                                             NUMBER(19,4)
,CURRENT_BALANCE                                              NUMBER(19,4)
,LOAN_DUE_DATE                                                TIMESTAMP_NTZ
,ORIGINAL_TERM                                                NUMBER(10,0)
,BRANCH_CODE                                                  TEXT(30)
,CREDIT_SCORE_1                                               NUMBER(10,0)
,CREDIT_SCORE_2                                               NUMBER(10,0)
,CREDIT_SCORE_3                                               NUMBER(10,0)
,DELINQUENT_AMOUNT                                            NUMBER(19,4)
,CHARGE_OFF_DATE                                              TIMESTAMP_NTZ
,CHARGE_OFF_AMOUNT                                            NUMBER(19,4)
,LOAN_OFFICER_CODE                                            TEXT(10)
,DATE_OF_BIRTH                                                TIMESTAMP_NTZ
,INCOME                                                       NUMBER(19,4)
,DI_RATIO_1                                                   NUMBER(8,4)
,DI_RATIO_2                                                   NUMBER(8,4)
,COBORROWER_FLAG                                              TEXT(1)
,STATE                                                        TEXT(2)
,ZIP_CODE                                                     TEXT(10)
,CUSTOM1                                                      TEXT(50)
,CUSTOM2                                                      TEXT(50)
,CUSTOM3                                                      TEXT(50)
,BANKRUPTCY_FLAG                                              TEXT(1)
,CREDIT_SCORE_1_SNAPSHOT                                      NUMBER(10,0)
,SCHOOL_CODE                                                  TEXT(10)
,VALUE_AT_ORIGINATION                                         NUMBER(19,4)
,CURRENT_VALUE                                                NUMBER(19,4)
,LOAN_TYPE                                                    NUMBER(38,0)
,RATE                                                         NUMBER(4,4)
,CUSTOM4                                                      TEXT(50)
,CUSTOM5                                                      TEXT(50)
,CUSTOM6                                                      TEXT(50)
,LOAN_COSTS                                                   NUMBER(19,4)
,BUSINESS_TYPE                                                TEXT(50)
,BUSINESS_LOAN_PURPOSE                                        TEXT(50)
,INDUSTRY_CODE                                                TEXT(50)
,CUSTOM7                                                      TEXT(50)
,CUSTOM8                                                      TEXT(50)
,CUSTOM9                                                      TEXT(50)
,CUSTOM10                                                     TEXT(50)
,CUSTOM11                                                     TEXT(50)
,CUSTOM12                                                     TEXT(50)
,ORIGINAL_ACCOUNT_NUMBER                                      TEXT(50)
,ORIGINAL_LOAN_ID                                             TEXT(50)
,FUNDED_DATE                                                  TIMESTAMP_NTZ
,APPROVED_DATE                                                TIMESTAMP_NTZ
,DATE_CUSTOM1                                                 TIMESTAMP_NTZ
,DATE_CUSTOM2                                                 TIMESTAMP_NTZ
,DATE_CUSTOM3                                                 TIMESTAMP_NTZ
,PERCENT_CUSTOM1                                              NUMBER(8,4)
,PERCENT_CUSTOM2                                              NUMBER(8,4)
,PERCENT_CUSTOM3                                              NUMBER(8,4)
,AMOUNT_CUSTOM1                                               NUMBER(19,4)
,AMOUNT_CUSTOM2                                               NUMBER(19,4)
,AMOUNT_CUSTOM3                                               NUMBER(19,4)
,CREDIT_SCORE_4                                               NUMBER(10,0)
,PROBABILITY_OF_DEFAULT                                       NUMBER(8,4)
,EXPOSURE_AT_DEFAULT                                          NUMBER(11,2)
,LOSS_GIVEN_DEFAULT                                           NUMBER(8,4)
,APPLICATION_NUMBER                                           TEXT(30)
,CREDIT_SCORE_5                                               NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_TYPE;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_TYPE
(
 LOANTYPEID                                                   NUMBER(38,0)         NOT NULL
,LOANTYPELONGNAME                                             TEXT(50)
,PRODUCTTYPEID                                                NUMBER(3,0)
,ETL_LOANTYPE                                                 NUMBER(38,0)
,LENDERID                                                     NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
);


DESCRIBE TABLE EDW_TEST.LNDINS_STG.STG_LI_LOAN_TYPE_H;

CREATE OR REPLACE TABLE LNDINS_STG.STG_LI_LOAN_TYPE_H
(
 LOANTYPEID                                                   NUMBER(38,0)         NOT NULL
,LOANTYPELONGNAME                                             TEXT(50)
,PRODUCTTYPEID                                                NUMBER(3,0)
,ETL_LOANTYPE                                                 NUMBER(38,0)
,LENDERID                                                     NUMBER(10,0)
,BATCH_ID                                                     NUMBER(38,0)
,HASH_ID                                                      TEXT(32)
,CREATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_DT                                                    TIMESTAMP_NTZ
,UPDATE_USER_TX                                               TEXT(15)
,CURRENT_FLG                                                  TEXT(1)
);
