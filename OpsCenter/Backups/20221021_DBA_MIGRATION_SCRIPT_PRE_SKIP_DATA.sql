USE ROLE OWNER_EDW_PROD;
USE WAREHOUSE EDW_PROD_INFA_WH;
USE DATABASE EDW_PROD;


USE SCHEMA CDW;

DESCRIBE TABLE EDW_TEST.CDW.D_PIMS_PRE_SKIP_DATA;

CREATE OR REPLACE TABLE CDW.D_PIMS_PRE_SKIP_DATA
(
 D_PIMS_PRE_SKIP_DATA_ID                                      NUMBER(38,0)         NOT NULL
,UID                                                          NUMBER(10,0)         NOT NULL
,PRE_SKIP_MONTH                                               NUMBER(6,0)          NOT NULL
,PRE_SKIP_YEAR                                                NUMBER(6,0)          NOT NULL
,RELATIONSHIP_ID_NUMBER                                       NUMBER(10,0)         NOT NULL
,CLIENT_ID_NUMBER                                             NUMBER(10,0)         NOT NULL
,COVERAGE_TYPE                                                TEXT(20)
,PROVIDER                                                     TEXT(50)             NOT NULL
,PROVIDER_ID                                                  TEXT(50)
,PAR_PRE_SKIP_ID                                              TEXT(50)
,PRODUCT_TYPE                                                 TEXT(20)
,ACCOUNT_NAME                                                 TEXT(100)
,BORROWER_NAME                                                TEXT(100)
,VUT_LENDER_ID                                                TEXT(10)
,VIN                                                          TEXT(50)
,BALANCE                                                      NUMBER(19,4)
,ASSIGNED_DATE                                                TIMESTAMP_NTZ
,RECOVERY_DATE                                                TIMESTAMP_NTZ
,COMPLETED_DATE                                               TIMESTAMP_NTZ
,STATUS                                                       NUMBER(10,0)
,SOURCE_WORKSHEET                                             TEXT(50)
,SUMMARY_DATE                                                 TIMESTAMP_NTZ
,CREATED                                                      TIMESTAMP_NTZ
,MODIFIED                                                     TIMESTAMP_NTZ
,USER_ID                                                      TEXT(50)
,BATCH_ID                                                     NUMBER(38,0)         NOT NULL
,HASH_ID                                                      TEXT(32)             NOT NULL
,CREATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_USER_TX                                               TEXT(15)             NOT NULL
,CURRENT_FLG                                                  TEXT(1)              NOT NULL
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ        NOT NULL
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ        NOT NULL
);


USE SCHEMA STG;

DESCRIBE TABLE EDW_TEST.STG.D_PIMS_PRE_SKIP_DATA_TEMP;

CREATE OR REPLACE TABLE STG.D_PIMS_PRE_SKIP_DATA_TEMP
(
 D_PIMS_PRE_SKIP_DATA_ID                                      NUMBER(38,0)         NOT NULL
,UID                                                          NUMBER(10,0)         NOT NULL
,PRE_SKIP_MONTH                                               NUMBER(6,0)          NOT NULL
,PRE_SKIP_YEAR                                                NUMBER(6,0)          NOT NULL
,RELATIONSHIP_ID_NUMBER                                       NUMBER(10,0)         NOT NULL
,CLIENT_ID_NUMBER                                             NUMBER(10,0)         NOT NULL
,COVERAGE_TYPE                                                TEXT(20)
,PROVIDER                                                     TEXT(50)             NOT NULL
,PROVIDER_ID                                                  TEXT(50)
,PAR_PRE_SKIP_ID                                              TEXT(50)
,PRODUCT_TYPE                                                 TEXT(20)
,ACCOUNT_NAME                                                 TEXT(100)
,BORROWER_NAME                                                TEXT(100)
,VUT_LENDER_ID                                                TEXT(10)
,VIN                                                          TEXT(50)
,BALANCE                                                      NUMBER(19,4)
,ASSIGNED_DATE                                                TIMESTAMP_NTZ
,RECOVERY_DATE                                                TIMESTAMP_NTZ
,COMPLETED_DATE                                               TIMESTAMP_NTZ
,STATUS                                                       NUMBER(10,0)
,SOURCE_WORKSHEET                                             TEXT(50)
,SUMMARY_DATE                                                 TIMESTAMP_NTZ
,CREATED                                                      TIMESTAMP_NTZ
,MODIFIED                                                     TIMESTAMP_NTZ
,USER_ID                                                      TEXT(50)
,BATCH_ID                                                     NUMBER(38,0)         NOT NULL
,HASH_ID                                                      TEXT(32)             NOT NULL
,CREATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_USER_TX                                               TEXT(15)             NOT NULL
,CURRENT_FLG                                                  TEXT(1)              NOT NULL
,EFFECTIVE_FROM_DT                                            TIMESTAMP_NTZ        NOT NULL
,EFFECTIVE_TO_DT                                              TIMESTAMP_NTZ        NOT NULL
);


DESCRIBE TABLE EDW_TEST.STG.LND_PIMS_PRE_SKIP_DATA;

CREATE OR REPLACE TABLE STG.LND_PIMS_PRE_SKIP_DATA
(
 UID                                                          NUMBER(10,0)         NOT NULL
,PRE_SKIP_MONTH                                               NUMBER(6,0)          NOT NULL
,PRE_SKIP_YEAR                                                NUMBER(6,0)          NOT NULL
,RELATIONSHIP_ID_NUMBER                                       NUMBER(10,0)         NOT NULL
,CLIENT_ID_NUMBER                                             NUMBER(10,0)         NOT NULL
,COVERAGE_TYPE                                                TEXT(20)
,PROVIDER                                                     TEXT(50)             NOT NULL
,PROVIDER_ID                                                  TEXT(50)
,PAR_PRE_SKIP_ID                                              TEXT(50)
,PRODUCT_TYPE                                                 TEXT(20)
,ACCOUNT_NAME                                                 TEXT(100)
,BORROWER_NAME                                                TEXT(100)
,VUT_LENDER_ID                                                TEXT(10)
,VIN                                                          TEXT(50)
,BALANCE                                                      NUMBER(19,4)
,ASSIGNED_DATE                                                TIMESTAMP_NTZ
,RECOVERY_DATE                                                TIMESTAMP_NTZ
,COMPLETED_DATE                                               TIMESTAMP_NTZ
,STATUS                                                       NUMBER(10,0)
,SOURCE_WORKSHEET                                             TEXT(50)
,SUMMARY_DATE                                                 TIMESTAMP_NTZ
,CREATED                                                      TIMESTAMP_NTZ
,MODIFIED                                                     TIMESTAMP_NTZ
,USER_ID                                                      TEXT(50)
,BATCH_ID                                                     NUMBER(38,0)         NOT NULL
,HASH_ID                                                      TEXT(32)             NOT NULL
,CREATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_USER_TX                                               TEXT(15)             NOT NULL
);


DESCRIBE TABLE EDW_TEST.STG.STG_PIMS_PRE_SKIP_DATA;

CREATE OR REPLACE TABLE STG.STG_PIMS_PRE_SKIP_DATA
(
 UID                                                          NUMBER(10,0)         NOT NULL
,PRE_SKIP_MONTH                                               NUMBER(6,0)          NOT NULL
,PRE_SKIP_YEAR                                                NUMBER(6,0)          NOT NULL
,RELATIONSHIP_ID_NUMBER                                       NUMBER(10,0)         NOT NULL
,CLIENT_ID_NUMBER                                             NUMBER(10,0)         NOT NULL
,COVERAGE_TYPE                                                TEXT(20)
,PROVIDER                                                     TEXT(50)             NOT NULL
,PROVIDER_ID                                                  TEXT(50)
,PAR_PRE_SKIP_ID                                              TEXT(50)
,PRODUCT_TYPE                                                 TEXT(20)
,ACCOUNT_NAME                                                 TEXT(100)
,BORROWER_NAME                                                TEXT(100)
,VUT_LENDER_ID                                                TEXT(10)
,VIN                                                          TEXT(50)
,BALANCE                                                      NUMBER(19,4)
,ASSIGNED_DATE                                                TIMESTAMP_NTZ
,RECOVERY_DATE                                                TIMESTAMP_NTZ
,COMPLETED_DATE                                               TIMESTAMP_NTZ
,STATUS                                                       NUMBER(10,0)
,SOURCE_WORKSHEET                                             TEXT(50)
,SUMMARY_DATE                                                 TIMESTAMP_NTZ
,CREATED                                                      TIMESTAMP_NTZ
,MODIFIED                                                     TIMESTAMP_NTZ
,USER_ID                                                      TEXT(50)
,BATCH_ID                                                     NUMBER(38,0)         NOT NULL
,HASH_ID                                                      TEXT(32)             NOT NULL
,CREATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_USER_TX                                               TEXT(15)             NOT NULL
);


DESCRIBE TABLE EDW_TEST.STG.STG_PIMS_PRE_SKIP_DATA_H;

CREATE OR REPLACE TABLE STG.STG_PIMS_PRE_SKIP_DATA_H
(
 UID                                                          NUMBER(10,0)         NOT NULL
,PRE_SKIP_MONTH                                               NUMBER(6,0)          NOT NULL
,PRE_SKIP_YEAR                                                NUMBER(6,0)          NOT NULL
,RELATIONSHIP_ID_NUMBER                                       NUMBER(10,0)         NOT NULL
,CLIENT_ID_NUMBER                                             NUMBER(10,0)         NOT NULL
,COVERAGE_TYPE                                                TEXT(20)
,PROVIDER                                                     TEXT(50)             NOT NULL
,PROVIDER_ID                                                  TEXT(50)
,PAR_PRE_SKIP_ID                                              TEXT(50)
,PRODUCT_TYPE                                                 TEXT(20)
,ACCOUNT_NAME                                                 TEXT(100)
,BORROWER_NAME                                                TEXT(100)
,VUT_LENDER_ID                                                TEXT(10)
,VIN                                                          TEXT(50)
,BALANCE                                                      NUMBER(19,4)
,ASSIGNED_DATE                                                TIMESTAMP_NTZ
,RECOVERY_DATE                                                TIMESTAMP_NTZ
,COMPLETED_DATE                                               TIMESTAMP_NTZ
,STATUS                                                       NUMBER(10,0)
,SOURCE_WORKSHEET                                             TEXT(50)
,SUMMARY_DATE                                                 TIMESTAMP_NTZ
,CREATED                                                      TIMESTAMP_NTZ
,MODIFIED                                                     TIMESTAMP_NTZ
,USER_ID                                                      TEXT(50)
,BATCH_ID                                                     NUMBER(38,0)         NOT NULL
,HASH_ID                                                      TEXT(32)             NOT NULL
,CREATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_DT                                                    TIMESTAMP_NTZ        NOT NULL
,UPDATE_USER_TX                                               TEXT(15)             NOT NULL
,CURRENT_FLG                                                  TEXT(1)              NOT NULL
);

