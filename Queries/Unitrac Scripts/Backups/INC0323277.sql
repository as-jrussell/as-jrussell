USE [UniTrac];
GO
/****** Object:  StoredProcedure [dbo].[Report_LenderITD]    Script Date: 10/24/2017 8:30:08 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

DECLARE @LenderCode AS NVARCHAR(10) = NULL ,
        @Division AS NVARCHAR(10) = NULL ,
        @Coverage AS NVARCHAR(100) = NULL ,
        @Branch AS NVARCHAR(MAX) = NULL ,
        @ReportType AS NVARCHAR(50) = NULL ,
        @FromDate AS DATETIME = NULL ,
        @ToDate AS DATETIME = NULL ,
        @GroupByCode AS NVARCHAR(50) = NULL ,
        @SortByCode AS NVARCHAR(50) = NULL ,
        @FilterByCode AS NVARCHAR(50) = NULL ,
        @ReportConfig AS VARCHAR(50) = NULL ,
        @Report_History_ID AS BIGINT = NULL;

SET @LenderCode = '1224';

BEGIN
    SET NOCOUNT ON;
    --Get rid of residual #temp tables
    IF OBJECT_ID(N'tempdb..#tmpfilter', N'U') IS NOT NULL
        DROP TABLE #tmpfilter;
    IF OBJECT_ID(N'tempdb..#tmptable', N'U') IS NOT NULL
        DROP TABLE #tmptable;
    IF OBJECT_ID(N'tempdb..#t1', N'U') IS NOT NULL
        DROP TABLE #t1;

    BEGIN

        DECLARE @LenderID AS BIGINT;
        SELECT @LenderID = ID
        FROM   LENDER
        WHERE  CODE_TX = @LenderCode
               AND PURGE_DT IS NULL;

        DECLARE @BranchTable AS TABLE
            (
                ID INT ,
                STRVALUE NVARCHAR(30)
            );
        INSERT INTO @BranchTable
                    SELECT *
                    FROM   SplitFunction(@Branch, ',');

        DECLARE @GroupBySQL AS VARCHAR(1000) = NULL;
        DECLARE @SortBySQL AS VARCHAR(1000) = NULL;
        DECLARE @FilterBySQL AS VARCHAR(1000) = NULL;
        DECLARE @HeaderTx AS VARCHAR(1000) = NULL;
        DECLARE @FooterTx AS VARCHAR(1000) = NULL;
        DECLARE @FillerZero AS VARCHAR(18);
        DECLARE @RecordCount BIGINT = 0;
        DECLARE @sqlstring AS NVARCHAR(4000);

        SET @FillerZero = '000000000000000000';
        IF @ReportType IS NULL
            SET @ReportType = 'DEFAULT';

        IF @ReportConfig IS NULL
            SET @ReportConfig = 'DEFAULT';

        IF @ToDate IS NULL
            SET @ToDate = GETDATE();

    END;

    CREATE TABLE [dbo].[#tmptable]
        (
            [LOAN_TYPE_TX] [NVARCHAR](1000) NULL ,
            [REQUIREDCOVERAGE_TYPE_TX] [NVARCHAR](1000) NULL ,
            [REQUIREDCOVERAGE_CODE_TX] [NVARCHAR](30) NULL ,
            [LOAN_NUMBER_TX] [NVARCHAR](18) NOT NULL ,
            [LOAN_NUMBERSORT_TX] [NVARCHAR](36) NULL ,
            [OWNER_LASTNAME_TX] [NVARCHAR](30) NOT NULL ,
            [OWNER_FIRSTNAME_TX] [NVARCHAR](30) NOT NULL ,
            [OWNER_MIDDLE_INITIAL_TX] [CHAR](1) NOT NULL ,
            [OWNER_NAME] [NVARCHAR](64) NULL ,
            [OWNER_LINE1_TX] [NVARCHAR](100) NOT NULL ,
            [OWNER_LINE2_TX] [NVARCHAR](100) NOT NULL ,
            [OWNER_STATE_TX] [NVARCHAR](30) NOT NULL ,
            [OWNER_CITY_TX] [NVARCHAR](40) NOT NULL ,
            [OWNER_ZIP_TX] [NVARCHAR](30) NOT NULL ,
            [LOAN_EFFECTIVE_DT] [DATETIME] NULL ,
            [LOAN_BALANCE_NO] [DECIMAL](19, 2) NULL ,
            [COLLATERAL_CODE_TX] [NVARCHAR](30) NULL ,
            [COLLATERAL_NUMBER_NO] [INT] NULL ,
            [LENDER_COLLATERAL_CODE_TX] [NVARCHAR](10) NULL ,
            [LOAN_BRANCHCODE_TX] [NVARCHAR](20) NULL ,
            [LOAN_DIVISIONCODE_TX] [NVARCHAR](20) NULL ,
            [LOAN_OFFICERCODE_TX] [NVARCHAR](20) NULL ,
            [LOAN_LENDERCODE_TX] [NVARCHAR](10) NULL ,
            [LOAN_LENDERNAME_TX] [NVARCHAR](40) NOT NULL ,
            [INSCOMPANY_NAME_TX] [NVARCHAR](100) NOT NULL ,
            [INSCOMPANY_POLICY_NO] [NVARCHAR](30) NOT NULL ,
            [LOAN_CONTRACTTYPECODE] [NVARCHAR](30) NULL ,
            [LOAN_STATUSCODE] [VARCHAR](1) NOT NULL ,
            [COLLATERAL_STATUSCODE] [VARCHAR](2) NOT NULL ,
            [REQUIREDCOVERAGE_STATUSCODE] [VARCHAR](2) NULL ,
            [REQUIREDCOVERAGE_SUBSTATUSCODE] [VARCHAR](2) NULL ,
            [REQUIREDCOVERAGE_INSSTATUSCODE] [VARCHAR](2) NULL ,
            [REQUIREDCOVERAGE_INSSUBSTATUSCODE] [VARCHAR](2) NULL ,
            [EFF_DT] [DATETIME2](7) NULL ,
            [EXP_DT] [DATETIME2](7) NULL ,
            [ISS_DT] [DATETIME2](7) NULL ,
            [INS_TOTAL_NO] [DECIMAL](22, 2) NOT NULL ,
            [INS_PAID_NO] [DECIMAL](18, 2) NOT NULL ,
            [CPI_ISSUEPAID_DT] [DATETIME2](7) NULL ,
            [ISS_REASON_TX] [NVARCHAR](10) NOT NULL ,
            [OP_CANCEL_REASON_CD] [NVARCHAR](10) NULL ,
            [ISS_EVENT_DT] [DATETIME2](7) NULL ,
            [CANCEL_EVENT_DT] [DATETIME2](7) NULL ,
            [CPI_HOLD_IN] [NVARCHAR](1) NULL ,
            [INS_CAN_DT] [DATETIME2](7) NULL ,
            [INS_CAN_TOTAL_NO] [DECIMAL](22, 2) NOT NULL ,
            [INS_CAN_PAID_NO] [DECIMAL](18, 2) NOT NULL ,
            [CPI_CANPAID_DT] [DATETIME2](7) NULL ,
            [INS_TERM] [INT] NOT NULL ,
            [INS_EXPCXL_DT] [DATETIME2](7) NULL ,
            [I_PRM] [DECIMAL](18, 2) NOT NULL ,
            [I_FEE] [DECIMAL](18, 2) NOT NULL ,
            [I_TAX1] [DECIMAL](18, 2) NOT NULL ,
            [I_TAX2] [DECIMAL](18, 2) NOT NULL ,
            [I_TAX3] [DECIMAL](18, 2) NOT NULL ,
            [I_TAX4] [DECIMAL](18, 2) NOT NULL ,
            [I_OTH] [DECIMAL](18, 2) NOT NULL ,
            [C_PRM] [DECIMAL](18, 2) NOT NULL ,
            [C_FEE] [DECIMAL](18, 2) NOT NULL ,
            [C_TAX1] [DECIMAL](18, 2) NOT NULL ,
            [C_TAX2] [DECIMAL](18, 2) NOT NULL ,
            [C_TAX3] [DECIMAL](18, 2) NOT NULL ,
            [C_TAX4] [DECIMAL](18, 2) NOT NULL ,
            [C_OTH] [DECIMAL](18, 2) NOT NULL ,
            [I_TOT_PRM] [DECIMAL](18, 2) NOT NULL ,
            [C_TOT_PRM] [DECIMAL](18, 2) NOT NULL ,
            [I_CNT] [INT] NOT NULL ,
            [C_CNT] [INT] NOT NULL ,
            [P_PRM] [DECIMAL](18, 2) NOT NULL ,
            [P_FEE] [DECIMAL](18, 2) NOT NULL ,
            [P_TAX1] [DECIMAL](18, 2) NOT NULL ,
            [P_TAX2] [DECIMAL](18, 2) NOT NULL ,
            [P_TAX3] [DECIMAL](18, 2) NOT NULL ,
            [P_TAX4] [DECIMAL](18, 2) NOT NULL ,
            [P_OTH] [DECIMAL](18, 2) NOT NULL ,
            [CP_PRM] [DECIMAL](18, 2) NOT NULL ,
            [CP_FEE] [DECIMAL](18, 2) NOT NULL ,
            [CP_TAX1] [DECIMAL](18, 2) NOT NULL ,
            [CP_TAX2] [DECIMAL](18, 2) NOT NULL ,
            [CP_TAX3] [DECIMAL](18, 2) NOT NULL ,
            [CP_TAX4] [DECIMAL](18, 2) NOT NULL ,
            [CP_OTH] [DECIMAL](18, 2) NOT NULL ,
            [LOAN_UNMATCHED_NO] [INT] NULL ,
            [COLL_UNMATCHED_NO] [INT] NULL ,
            [I_PAID_CNT] [INT] NOT NULL ,
            [C_PAID_CNT] [INT] NOT NULL ,
            [PROPERTY_DESCRIPTION] [NVARCHAR](100) NULL ,
            [TOTAL_POLICIES_NO] [INT] NULL ,
            [LOAN_CERT_COUNT_NO] [INT] NULL ,
            [REPORT_SORTBY_TX] [NVARCHAR](2114) NULL ,
            [REPORT_GROUPBY_TX] [NVARCHAR](2012) NULL ,
            [REPORT_FOOTER_TX] [VARCHAR](2012) NULL
        ) ON [PRIMARY];

    CREATE TABLE [dbo].[#tmpfilter]
        (
            [ATTRIBUTE_CD] [NVARCHAR](50) NULL ,
            [VALUE_TX] [NVARCHAR](50) NULL
        ) ON [PRIMARY];

    INSERT INTO #tmpfilter (   [ATTRIBUTE_CD] ,
                               [VALUE_TX]
                           )
                SELECT RAD.ATTRIBUTE_CD ,
                       CASE WHEN CUSTOM.VALUE_TX IS NOT NULL THEN
                                CUSTOM.VALUE_TX
                            WHEN RA.VALUE_TX IS NOT NULL THEN RA.VALUE_TX
                            ELSE RAD.VALUE_TX
                       END AS VALUE_TX
                FROM   REF_CODE RC
                       JOIN REF_CODE_ATTRIBUTE RAD ON RAD.DOMAIN_CD = RC.DOMAIN_CD
                                                      AND RAD.REF_CD = 'DEFAULT'
                                                      AND RAD.ATTRIBUTE_CD LIKE 'FIL%'
                       LEFT JOIN REF_CODE_ATTRIBUTE RA ON RA.DOMAIN_CD = RC.DOMAIN_CD
                                                          AND RA.REF_CD = RC.CODE_CD
                                                          AND RA.ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
                       LEFT JOIN (   SELECT CODE_TX ,
                                            REPORT_CD ,
                                            REPORT_DOMAIN_CD ,
                                            REPORT_REF_ATTRIBUTE_CD ,
                                            VALUE_TX
                                     FROM   REPORT_CONFIG RC
                                            JOIN REPORT_CONFIG_ATTRIBUTE RCA ON RCA.REPORT_CONFIG_ID = RC.ID
                                 ) CUSTOM ON CUSTOM.CODE_TX = @ReportConfig
                                             AND CUSTOM.REPORT_DOMAIN_CD = RAD.DOMAIN_CD
                                             AND CUSTOM.REPORT_REF_ATTRIBUTE_CD = RAD.ATTRIBUTE_CD
                                             AND CUSTOM.REPORT_CD = @ReportType
                WHERE  RC.DOMAIN_CD = 'Report_LenderITD'
                       AND RC.CODE_CD = @ReportType;

    BEGIN --Set Filters, Groups, and Sorts
        IF @ReportConfig IS NULL
           OR @ReportConfig = ''
           OR @ReportConfig = '0000'
            BEGIN
                IF @GroupByCode IS NULL
                   OR @GroupByCode = ''
                    SELECT @GroupBySQL = GROUP_TX
                    FROM   REPORT_CONFIG
                    WHERE  CODE_TX = @ReportType;
                ELSE
                    SELECT @GroupBySQL = DESCRIPTION_TX
                    FROM   REF_CODE
                    WHERE  DOMAIN_CD = 'Report_GroupBy'
                           AND CODE_CD = @GroupByCode;
                IF @SortByCode IS NULL
                   OR @SortByCode = ''
                    SELECT @SortBySQL = SORT_TX
                    FROM   REPORT_CONFIG
                    WHERE  CODE_TX = @ReportType;
                ELSE
                    SELECT @SortBySQL = DESCRIPTION_TX
                    FROM   REF_CODE
                    WHERE  DOMAIN_CD = 'Report_SortBy'
                           AND CODE_CD = @SortByCode;
                IF @FilterByCode IS NULL
                   OR @FilterByCode = ''
                    SELECT @FilterBySQL = FILTER_TX
                    FROM   REPORT_CONFIG
                    WHERE  CODE_TX = @ReportType;
                ELSE
                    SELECT @FilterBySQL = DESCRIPTION_TX
                    FROM   REF_CODE
                    WHERE  DOMAIN_CD = 'Report_FilterBy'
                           AND CODE_CD = @FilterByCode;

                SELECT @HeaderTx = HEADER_TX
                FROM   REPORT_CONFIG
                WHERE  CODE_TX = @ReportType;
                SELECT @FooterTx = FOOTER_TX
                FROM   REPORT_CONFIG
                WHERE  CODE_TX = @ReportType;
            END;
        ELSE
            BEGIN
                IF @GroupByCode IS NULL
                   OR @GroupByCode = ''
                    SELECT @GroupBySQL = GROUP_TX
                    FROM   REPORT_CONFIG
                    WHERE  CODE_TX = @ReportConfig;
                ELSE
                    SELECT @GroupBySQL = DESCRIPTION_TX
                    FROM   REF_CODE
                    WHERE  DOMAIN_CD = 'Report_GroupBy'
                           AND CODE_CD = @GroupByCode;
                IF @SortByCode IS NULL
                   OR @SortByCode = ''
                    SELECT @SortBySQL = SORT_TX
                    FROM   REPORT_CONFIG
                    WHERE  CODE_TX = @ReportConfig;
                ELSE
                    SELECT @SortBySQL = DESCRIPTION_TX
                    FROM   REF_CODE
                    WHERE  DOMAIN_CD = 'Report_SortBy'
                           AND CODE_CD = @SortByCode;
                IF @FilterByCode IS NULL
                   OR @FilterByCode = ''
                    SELECT @FilterBySQL = FILTER_TX
                    FROM   REPORT_CONFIG
                    WHERE  CODE_TX = @ReportConfig;
                ELSE
                    SELECT @FilterBySQL = DESCRIPTION_TX
                    FROM   REF_CODE
                    WHERE  DOMAIN_CD = 'Report_FilterBy'
                           AND CODE_CD = @FilterByCode;

                SELECT @HeaderTx = HEADER_TX
                FROM   REPORT_CONFIG
                WHERE  CODE_TX = @ReportConfig;
                SELECT @FooterTx = FOOTER_TX
                FROM   REPORT_CONFIG
                WHERE  CODE_TX = @ReportConfig;
            END;
    END;

    INSERT INTO #tmptable (   [LOAN_TYPE_TX] ,
                              [REQUIREDCOVERAGE_TYPE_TX] ,
                              [REQUIREDCOVERAGE_CODE_TX] ,
                              [LOAN_NUMBER_TX] ,
                              [LOAN_NUMBERSORT_TX] ,
                              [OWNER_LASTNAME_TX] ,
                              [OWNER_FIRSTNAME_TX] ,
                              [OWNER_MIDDLE_INITIAL_TX] ,
                              [OWNER_NAME] ,
                              [OWNER_LINE1_TX] ,
                              [OWNER_LINE2_TX] ,
                              [OWNER_STATE_TX] ,
                              [OWNER_CITY_TX] ,
                              [OWNER_ZIP_TX] ,
                              [LOAN_EFFECTIVE_DT] ,
                              [LOAN_BALANCE_NO] ,
                              [COLLATERAL_CODE_TX] ,
                              [COLLATERAL_NUMBER_NO] ,
                              [LENDER_COLLATERAL_CODE_TX] ,
                              [LOAN_BRANCHCODE_TX] ,
                              [LOAN_DIVISIONCODE_TX] ,
                              [LOAN_OFFICERCODE_TX] ,
                              [LOAN_LENDERCODE_TX] ,
                              [LOAN_LENDERNAME_TX] ,
                              [INSCOMPANY_NAME_TX] ,
                              [INSCOMPANY_POLICY_NO] ,
                              [LOAN_CONTRACTTYPECODE] ,
                              [LOAN_STATUSCODE] ,
                              [COLLATERAL_STATUSCODE] ,
                              [REQUIREDCOVERAGE_STATUSCODE] ,
                              [REQUIREDCOVERAGE_SUBSTATUSCODE] ,
                              [REQUIREDCOVERAGE_INSSTATUSCODE] ,
                              [REQUIREDCOVERAGE_INSSUBSTATUSCODE] ,
                              [EFF_DT] ,
                              [EXP_DT] ,
                              [ISS_DT] ,
                              [INS_TOTAL_NO] ,
                              [INS_PAID_NO] ,
                              [CPI_ISSUEPAID_DT] ,
                              [ISS_REASON_TX] ,
                              [OP_CANCEL_REASON_CD] ,
                              [ISS_EVENT_DT] ,
                              [CANCEL_EVENT_DT] ,
                              [CPI_HOLD_IN] ,
                              [INS_CAN_DT] ,
                              [INS_CAN_TOTAL_NO] ,
                              [INS_CAN_PAID_NO] ,
                              [CPI_CANPAID_DT] ,
                              [INS_TERM] ,
                              [INS_EXPCXL_DT] ,
                              [I_PRM] ,
                              [I_FEE] ,
                              [I_TAX1] ,
                              [I_TAX2] ,
                              [I_TAX3] ,
                              [I_TAX4] ,
                              [I_OTH] ,
                              [C_PRM] ,
                              [C_FEE] ,
                              [C_TAX1] ,
                              [C_TAX2] ,
                              [C_TAX3] ,
                              [C_TAX4] ,
                              [C_OTH] ,
                              [I_TOT_PRM] ,
                              [C_TOT_PRM] ,
                              [I_CNT] ,
                              [C_CNT] ,
                              [P_PRM] ,
                              [P_FEE] ,
                              [P_TAX1] ,
                              [P_TAX2] ,
                              [P_TAX3] ,
                              [P_TAX4] ,
                              [P_OTH] ,
                              [CP_PRM] ,
                              [CP_FEE] ,
                              [CP_TAX1] ,
                              [CP_TAX2] ,
                              [CP_TAX3] ,
                              [CP_TAX4] ,
                              [CP_OTH] ,
                              [LOAN_UNMATCHED_NO] ,
                              [COLL_UNMATCHED_NO] ,
                              [I_PAID_CNT] ,
                              [C_PAID_CNT] ,
                              [PROPERTY_DESCRIPTION] ,
                              [TOTAL_POLICIES_NO] ,
                              [LOAN_CERT_COUNT_NO] ,
                              [REPORT_SORTBY_TX] ,
                              [REPORT_GROUPBY_TX] ,
                              [REPORT_FOOTER_TX]
                          )
                SELECT ISNULL(
                                 RC_DIVISION.DESCRIPTION_TX ,
                                 RC_SC.DESCRIPTION_TX
                             ) AS [LOAN_TYPE_TX] ,
                       ISNULL(RC_COVERAGETYPE.MEANING_TX, '') AS [REQUIREDCOVERAGE_TYPE_TX] ,
                       RC.TYPE_CD AS [REQUIREDCOVERAGE_CODE_TX] ,
                       L.NUMBER_TX AS [LOAN_NUMBER_TX] ,
                       SUBSTRING(@FillerZero, 1, 18 - LEN(L.NUMBER_TX))
                       + CAST(L.NUMBER_TX AS NVARCHAR(18)) AS [LOAN_NUMBERSORT_TX] ,
                       ISNULL(O.LAST_NAME_TX, '') AS [OWNER_LASTNAME_TX] ,
                       ISNULL(O.FIRST_NAME_TX, '') AS [OWNER_FIRSTNAME_TX] ,
                       ISNULL(O.MIDDLE_INITIAL_TX, '') AS [OWNER_MIDDLE_INITIAL_TX] ,
                       CASE WHEN O.FIRST_NAME_TX IS NULL THEN O.LAST_NAME_TX
                            ELSE
                                RTRIM(O.LAST_NAME_TX + ', '
                                      + ISNULL(O.FIRST_NAME_TX, '') + ' '
                                      + ISNULL(O.MIDDLE_INITIAL_TX, '')
                                     )
                       END AS [OWNER_NAME] ,
                       ISNULL(AO.LINE_1_TX, '') AS [OWNER_LINE1_TX] ,
                       ISNULL(AO.LINE_2_TX, '') AS [OWNER_LINE2_TX] ,
                       ISNULL(AO.STATE_PROV_TX, '') AS [OWNER_STATE_TX] ,
                       ISNULL(AO.CITY_TX, '') AS [OWNER_CITY_TX] ,
                       ISNULL(AO.POSTAL_CODE_TX, '') AS [OWNER_ZIP_TX] ,
                       L.EFFECTIVE_DT AS [LOAN_EFFECTIVE_DT] ,
                       C.LOAN_BALANCE_NO AS [LOAN_BALANCE_NO] ,
                       CC.CODE_TX AS [COLLATERAL_CODE_TX] ,
                       C.COLLATERAL_NUMBER_NO AS [COLLATERAL_NUMBER_NO] ,
                       C.LENDER_COLLATERAL_CODE_TX AS [LENDER_COLLATERAL_CODE_TX] ,
                       ( CASE WHEN L.BRANCH_CODE_TX IS NULL
                                   OR L.BRANCH_CODE_TX = '' THEN 'NOBRANCH'
                              ELSE L.BRANCH_CODE_TX
                         END
                       ) AS [LOAN_BRANCHCODE_TX] ,
                       CASE WHEN ISNULL(L.DIVISION_CODE_TX, '') = '' THEN '0'
                            ELSE L.DIVISION_CODE_TX
                       END AS [LOAN_DIVISIONCODE_TX] ,
                       L.OFFICER_CODE_TX AS [LOAN_OFFICERCODE_TX] ,
                       LND.CODE_TX AS [LOAN_LENDERCODE_TX] ,
                       LND.NAME_TX AS [LOAN_LENDERNAME_TX] ,
                       ISNULL(CR.NAME_TX, '') AS [INSCOMPANY_NAME_TX] ,
                       FPC.NUMBER_TX AS [INSCOMPANY_POLICY_NO] ,
                       L.CONTRACT_TYPE_CD AS [LOAN_CONTRACTTYPECODE] ,
                       L.STATUS_CD AS [LOAN_STATUSCODE] ,
                       C.STATUS_CD AS [COLLATERAL_STATUSCODE] ,
                       RC.STATUS_CD AS [REQUIREDCOVERAGE_STATUSCODE] ,
                       RC.SUB_STATUS_CD AS [REQUIREDCOVERAGE_SUBSTATUSCODE] ,
                       RC.SUMMARY_STATUS_CD AS [REQUIREDCOVERAGE_INSSTATUSCODE] ,
                       RC.SUMMARY_SUB_STATUS_CD AS [REQUIREDCOVERAGE_INSSUBSTATUSCODE] ,
                       FPC.EFFECTIVE_DT AS [EFF_DT] ,
                       FPC.EXPIRATION_DT AS [EXP_DT] ,
                       FPC.ISSUE_DT AS [ISS_DT] ,
                       ( ISNULL(CPISQ.IPRM_AMOUNT_NO, 0)
                         + ISNULL(CPISQ.IFEE_AMOUNT_NO, 0)
                         + ISNULL(CPISQ.ITAX1_AMOUNT_NO, 0)
                         + ISNULL(CPISQ.ITAX2_AMOUNT_NO, 0)
                         + ISNULL(CPISQ.ITAX3_AMOUNT_NO, 0)
                         + ISNULL(CPISQ.ITAX4_AMOUNT_NO, 0)
                         + ISNULL(CPISQ.IOTH_AMOUNT_NO, 0)
                       ) AS [INS_TOTAL_NO] ,
                       ( ABS(ISNULL(FINSQ.P_PRM, 0))
                         + ABS(ISNULL(FINSQ.P_FEE, 0))
                         + ABS(ISNULL(FINSQ.P_TAX1, 0))
                         + ABS(ISNULL(FINSQ.P_TAX2, 0))
                         + ABS(ISNULL(FINSQ.P_TAX3, 0))
                         + ABS(ISNULL(FINSQ.P_TAX4, 0))
                         + ABS(ISNULL(FINSQ.P_OTH, 0))
                       ) AS [INS_PAID_NO] ,
                       (   SELECT MAX(TXN_DT)
                           FROM   FINANCIAL_TXN
                           WHERE  TXN_TYPE_CD = 'P'
                                  AND PURGE_DT IS NULL
                                  AND FINANCIAL_TXN.FPC_ID = FPC.ID
                       ) AS CPI_ISSUEPAID_DT ,
                       ISNULL(CPA_I.REASON_CD, '') AS [ISS_REASON_TX] ,
                       ISNULL(CPA_C.REASON_CD, '') AS [OP_CANCEL_REASON_CD] ,
                       CPA_I.PROCESS_DT AS [ISS_EVENT_DT] ,
                       CPA_C.PROCESS_DT AS [CANCEL_EVENT_DT] ,
                       FPC.HOLD_IN AS CPI_HOLD_IN ,
                       FPC.CANCELLATION_DT AS [INS_CAN_DT] ,
                       ( ABS(ISNULL(CPISQ.CPRM_AMOUNT_NO, 0))
                         + ABS(ISNULL(CPISQ.CFEE_AMOUNT_NO, 0))
                         + ABS(ISNULL(CPISQ.CTAX1_AMOUNT_NO, 0))
                         + ABS(ISNULL(CPISQ.CTAX2_AMOUNT_NO, 0))
                         + ABS(ISNULL(CPISQ.CTAX3_AMOUNT_NO, 0))
                         + ABS(ISNULL(CPISQ.CTAX4_AMOUNT_NO, 0))
                         + ABS(ISNULL(CPISQ.COTH_AMOUNT_NO, 0))
                       ) AS [INS_CAN_TOTAL_NO] ,
                       ( ABS(ISNULL(FINSQ.CP_PRM, 0))
                         + ABS(ISNULL(FINSQ.CP_FEE, 0))
                         + ABS(ISNULL(FINSQ.CP_TAX1, 0))
                         + ABS(ISNULL(FINSQ.CP_TAX2, 0))
                         + ABS(ISNULL(FINSQ.CP_TAX3, 0))
                         + ABS(ISNULL(FINSQ.CP_TAX4, 0))
                         + ABS(ISNULL(FINSQ.CP_OTH, 0))
                       ) AS [INS_CAN_PAID_NO] ,
                       (   SELECT MAX(TXN_DT)
                           FROM   FINANCIAL_TXN
                           WHERE  TXN_TYPE_CD = 'CP'
                                  AND PURGE_DT IS NULL
                                  AND FINANCIAL_TXN.FPC_ID = FPC.ID
                       ) AS CPI_CANPAID_DT ,
                       CPQ.TERM_NO AS [INS_TERM] ,
                       ISNULL(FPC.CANCELLATION_DT, FPC.EXPIRATION_DT) AS [INS_EXPCXL_DT] ,
                       ISNULL(CPISQ.IPRM_AMOUNT_NO, 0) AS I_PRM ,
                       ISNULL(CPISQ.IFEE_AMOUNT_NO, 0) AS I_FEE ,
                       ISNULL(CPISQ.ITAX1_AMOUNT_NO, 0) AS I_TAX1 ,
                       ISNULL(CPISQ.ITAX2_AMOUNT_NO, 0) AS I_TAX2 ,
                       ISNULL(CPISQ.ITAX3_AMOUNT_NO, 0) AS I_TAX3 ,
                       ISNULL(CPISQ.ITAX4_AMOUNT_NO, 0) AS I_TAX4 ,
                       ISNULL(CPISQ.IOTH_AMOUNT_NO, 0) AS I_OTH ,
                       ABS(ISNULL(CPISQ.CPRM_AMOUNT_NO, 0)) AS C_PRM ,
                       ABS(ISNULL(CPISQ.CFEE_AMOUNT_NO, 0)) AS C_FEE ,
                       ABS(ISNULL(CPISQ.CTAX1_AMOUNT_NO, 0)) AS C_TAX1 ,
                       ABS(ISNULL(CPISQ.CTAX2_AMOUNT_NO, 0)) AS C_TAX2 ,
                       ABS(ISNULL(CPISQ.CTAX3_AMOUNT_NO, 0)) AS C_TAX3 ,
                       ABS(ISNULL(CPISQ.CTAX4_AMOUNT_NO, 0)) AS C_TAX4 ,
                       ABS(ISNULL(CPISQ.COTH_AMOUNT_NO, 0)) AS C_OTH ,
                       ISNULL(CPA_I.TOTAL_PREMIUM_NO, 0) AS I_TOT_PRM ,
                       ABS(ISNULL(CPA_C.TOTAL_PREMIUM_NO, 0)) AS C_TOT_PRM ,
                       CASE WHEN (( ISNULL(CPISQ.IPRM_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.IFEE_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.ITAX1_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.ITAX2_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.ITAX3_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.ITAX4_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.IOTH_AMOUNT_NO, 0)
                                  )
                                 ) > 0 THEN
                                1
                            ELSE 0
                       END AS I_CNT ,
                       CASE WHEN (( ISNULL(CPISQ.CPRM_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.CFEE_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.CTAX1_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.CTAX2_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.CTAX3_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.CTAX4_AMOUNT_NO, 0)
                                    + ISNULL(CPISQ.COTH_AMOUNT_NO, 0)
                                  )
                                 ) > 0 THEN
                                1
                            ELSE 0
                       END AS C_CNT ,
                       ABS(ISNULL(FINSQ.P_PRM, 0)) AS P_PRM ,
                       ABS(ISNULL(FINSQ.P_FEE, 0)) AS P_FEE ,
                       ABS(ISNULL(FINSQ.P_TAX1, 0)) AS P_TAX1 ,
                       ABS(ISNULL(FINSQ.P_TAX2, 0)) AS P_TAX2 ,
                       ABS(ISNULL(FINSQ.P_TAX3, 0)) AS P_TAX3 ,
                       ABS(ISNULL(FINSQ.P_TAX4, 0)) AS P_TAX4 ,
                       ABS(ISNULL(FINSQ.P_OTH, 0)) AS P_OTH ,
                       ABS(ISNULL(FINSQ.CP_PRM, 0)) AS CP_PRM ,
                       ABS(ISNULL(FINSQ.CP_FEE, 0)) AS CP_FEE ,
                       ABS(ISNULL(FINSQ.CP_TAX1, 0)) AS CP_TAX1 ,
                       ABS(ISNULL(FINSQ.CP_TAX2, 0)) AS CP_TAX2 ,
                       ABS(ISNULL(FINSQ.CP_TAX3, 0)) AS CP_TAX3 ,
                       ABS(ISNULL(FINSQ.CP_TAX4, 0)) AS CP_TAX4 ,
                       ABS(ISNULL(FINSQ.CP_OTH, 0)) AS CP_OTH ,
                       ISNULL(L.EXTRACT_UNMATCH_COUNT_NO, 0) AS [LOAN_UNMATCHED_NO] ,
                       ISNULL(C.EXTRACT_UNMATCH_COUNT_NO, 0) AS [COLL_UNMATCHED_NO] ,
                       CASE WHEN ( ABS(ISNULL(FINSQ.P_PRM, 0))
                                   + ABS(ISNULL(FINSQ.P_FEE, 0))
                                   + ABS(ISNULL(FINSQ.P_TAX1, 0))
                                   + ABS(ISNULL(FINSQ.P_TAX2, 0))
                                   + ABS(ISNULL(FINSQ.P_TAX3, 0))
                                   + ABS(ISNULL(FINSQ.P_TAX4, 0))
                                   + ABS(ISNULL(FINSQ.P_OTH, 0)) > 0
                                 ) THEN 1
                            ELSE 0
                       END AS I_PAID_CNT ,
                       CASE WHEN ( ABS(ISNULL(FINSQ.CP_PRM, 0))
                                   + ABS(ISNULL(FINSQ.CP_FEE, 0))
                                   + ABS(ISNULL(FINSQ.CP_TAX1, 0))
                                   + ABS(ISNULL(FINSQ.CP_TAX2, 0))
                                   + ABS(ISNULL(FINSQ.CP_TAX3, 0))
                                   + ABS(ISNULL(FINSQ.CP_TAX4, 0))
                                   + ABS(ISNULL(FINSQ.CP_OTH, 0)) > 0
                                 ) THEN
                                1
                            ELSE 0
                       END AS C_PAID_CNT ,
                       dbo.fn_GetPropertyDescriptionForReports(C.ID) PROPERTY_DESCRIPTION ,
                       (   SELECT COUNT(*)
                           FROM   FORCE_PLACED_CERTIFICATE
                           WHERE  ID IN (   SELECT   SQFPC.ID
                                            FROM     FORCE_PLACED_CERTIFICATE SQFPC
                                                     JOIN FINANCIAL_TXN SQFIN ON SQFPC.ID = SQFIN.FPC_ID
                                                                                 AND SQFIN.TXN_TYPE_CD = 'P'
                                            WHERE    SQFPC.LOAN_ID = L.ID
                                                     AND SQFPC.PURGE_DT IS NULL
                                                     AND DATEDIFF(
                                                                     DAY ,
                                                                     SQFPC.EFFECTIVE_DT,
                                                                     ISNULL(
                                                                               SQFPC.CANCELLATION_DT ,
                                                                               SQFPC.EXPIRATION_DT
                                                                           )
                                                                 ) > 0
                                            GROUP BY SQFPC.ID
                                        )
                       ) AS [TOTAL_POLICIES_NO] ,
                       (   SELECT COUNT(*)
                           FROM   FORCE_PLACED_CERTIFICATE
                           WHERE  LOAN_ID = L.ID
                                  AND PURGE_DT IS NULL
                                  AND DATEDIFF(
                                                  DAY ,
                                                  EFFECTIVE_DT ,
                                                  ISNULL(
                                                            CANCELLATION_DT ,
                                                            EXPIRATION_DT
                                                        )
                                              ) > 0
                       ) AS [LOAN_CERT_COUNT_NO] ,
                       @SortByCode AS [REPORT_SORTBY_TX] ,
                       @GroupByCode AS [REPORT_GROUPBY_TX] ,
                       REPORT_FOOTER_TX = ''
                FROM   FORCE_PLACED_CERTIFICATE FPC
                       JOIN FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCRCR ON FPCRCR.FPC_ID = FPC.ID
                                                                                 AND FPCRCR.PURGE_DT IS NULL
                       JOIN REQUIRED_COVERAGE RC ON FPCRCR.REQUIRED_COVERAGE_ID = RC.ID
                                                    AND RC.PURGE_DT IS NULL
                       JOIN LOAN L ON L.ID = FPC.LOAN_ID
                                      AND ISNULL(L.RECORD_TYPE_CD, '') IN ( 'A' ,
                                                                            'D' ,
                                                                            'G'
                                                                          )
                                      AND L.PURGE_DT IS NULL
                       JOIN LENDER LND ON LND.ID = L.LENDER_ID
                                          AND LND.PURGE_DT IS NULL
                       JOIN OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID
                                                     AND OLR.PRIMARY_IN = 'Y'
                                                     AND OLR.PURGE_DT IS NULL
                       JOIN [OWNER] O ON O.ID = OLR.OWNER_ID
                                         AND O.PURGE_DT IS NULL
                       JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
                                          AND P.PURGE_DT IS NULL
                       JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
                                            AND C.PURGE_DT IS NULL
                       JOIN CPI_QUOTE CPQ ON CPQ.ID = FPC.CPI_QUOTE_ID
                                             AND CPQ.PURGE_DT IS NULL
                       LEFT JOIN CPI_ACTIVITY CPA_I ON CPA_I.CPI_QUOTE_ID = CPQ.ID
                                                       AND CPA_I.TYPE_CD = 'I'
                                                       AND CPA_I.PURGE_DT IS NULL
                       OUTER APPLY (   SELECT SUM(TOTAL_PREMIUM_NO) AS TOTAL_PREMIUM_NO ,
                                              MAX(REASON_CD) AS REASON_CD ,
                                              MAX(PROCESS_DT) AS PROCESS_DT
                                       FROM   CPI_ACTIVITY C
                                       WHERE  C.CPI_QUOTE_ID = CPQ.ID
                                              AND C.TYPE_CD IN ( 'C', 'R', 'MT' )
                                              AND C.PURGE_DT IS NULL
                                   ) CPA_C
                       OUTER APPLY (   SELECT SUM(   CASE WHEN CD_SQ.TYPE_CD = 'PRM'
                                                               AND CPA_SQ.TYPE_CD = 'I' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS IPRM_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'FEE'
                                                               AND CPA_SQ.TYPE_CD = 'I' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS IFEE_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'OTH'
                                                               AND CPA_SQ.TYPE_CD = 'I' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS IOTH_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX1'
                                                               AND CPA_SQ.TYPE_CD = 'I' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS ITAX1_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX2'
                                                               AND CPA_SQ.TYPE_CD = 'I' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS ITAX2_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX3'
                                                               AND CPA_SQ.TYPE_CD = 'I' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS ITAX3_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX4'
                                                               AND CPA_SQ.TYPE_CD = 'I' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS ITAX4_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'PRM'
                                                               AND CPA_SQ.TYPE_CD = 'C' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CPRM_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'FEE'
                                                               AND CPA_SQ.TYPE_CD = 'C' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CFEE_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'OTH'
                                                               AND CPA_SQ.TYPE_CD = 'C' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS COTH_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX1'
                                                               AND CPA_SQ.TYPE_CD = 'C' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CTAX1_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX2'
                                                               AND CPA_SQ.TYPE_CD = 'C' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CTAX2_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX3'
                                                               AND CPA_SQ.TYPE_CD = 'C' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CTAX3_AMOUNT_NO ,
                                              SUM(   CASE WHEN CD_SQ.TYPE_CD = 'TAX4'
                                                               AND CPA_SQ.TYPE_CD = 'C' THEN
                                                              CD_SQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CTAX4_AMOUNT_NO
                                       FROM   CPI_ACTIVITY CPA_SQ
                                              JOIN CERTIFICATE_DETAIL CD_SQ ON CD_SQ.CPI_ACTIVITY_ID = CPA_SQ.ID
                                                                               AND CPA_SQ.CPI_QUOTE_ID = CPQ.ID
                                                                               AND CD_SQ.PURGE_DT IS NULL
                                       WHERE  CPA_SQ.CPI_QUOTE_ID = CPQ.ID
                                              AND CPA_SQ.PURGE_DT IS NULL
                                   ) CPISQ
                       LEFT JOIN OWNER_ADDRESS AO ON AO.ID = O.ADDRESS_ID
                                                     AND AO.PURGE_DT IS NULL
                       LEFT JOIN CARRIER CR ON CR.ID = FPC.CARRIER_ID
                                               AND CR.PURGE_DT IS NULL
                       OUTER APPLY (   SELECT SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS INS_PAID_NO ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS INS_CAN_PAID_NO ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'R'
                                                               AND FTDSQ.TYPE_CD = 'PRM' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS I_PRM ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'R'
                                                               AND FTDSQ.TYPE_CD = 'FEE' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS I_FEE ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'R'
                                                               AND FTDSQ.TYPE_CD = 'TAX1' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS I_TAX1 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'R'
                                                               AND FTDSQ.TYPE_CD = 'TAX2' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS I_TAX2 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'R'
                                                               AND FTDSQ.TYPE_CD = 'TAX3' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS I_TAX3 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'R'
                                                               AND FTDSQ.TYPE_CD = 'TAX4' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS I_TAX4 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'R'
                                                               AND FTDSQ.TYPE_CD = 'OTH' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS I_OTH ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'C'
                                                               AND FTDSQ.TYPE_CD = 'PRM' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS C_PRM ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'C'
                                                               AND FTDSQ.TYPE_CD = 'FEE' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS C_FEE ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'C'
                                                               AND FTDSQ.TYPE_CD = 'TAX1' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS C_TAX1 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'C'
                                                               AND FTDSQ.TYPE_CD = 'TAX2' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS C_TAX2 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'C'
                                                               AND FTDSQ.TYPE_CD = 'TAX3' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS C_TAX3 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'C'
                                                               AND FTDSQ.TYPE_CD = 'TAX4' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS C_TAX4 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'C'
                                                               AND FTDSQ.TYPE_CD = 'OTH' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS C_OTH ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P'
                                                               AND FTDSQ.TYPE_CD = 'PRM' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS P_PRM ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P'
                                                               AND FTDSQ.TYPE_CD = 'FEE' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS P_FEE ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P'
                                                               AND FTDSQ.TYPE_CD = 'TAX1' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS P_TAX1 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P'
                                                               AND FTDSQ.TYPE_CD = 'TAX2' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS P_TAX2 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P'
                                                               AND FTDSQ.TYPE_CD = 'TAX3' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS P_TAX3 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P'
                                                               AND FTDSQ.TYPE_CD = 'TAX4' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS P_TAX4 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'P'
                                                               AND FTDSQ.TYPE_CD = 'OTH' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS P_OTH ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP'
                                                               AND FTDSQ.TYPE_CD = 'PRM' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CP_PRM ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP'
                                                               AND FTDSQ.TYPE_CD = 'FEE' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CP_FEE ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP'
                                                               AND FTDSQ.TYPE_CD = 'TAX1' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CP_TAX1 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP'
                                                               AND FTDSQ.TYPE_CD = 'TAX2' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CP_TAX2 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP'
                                                               AND FTDSQ.TYPE_CD = 'TAX3' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CP_TAX3 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP'
                                                               AND FTDSQ.TYPE_CD = 'TAX4' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CP_TAX4 ,
                                              SUM(   CASE WHEN FTXSQ.TXN_TYPE_CD = 'CP'
                                                               AND FTDSQ.TYPE_CD = 'OTH' THEN
                                                              FTDSQ.AMOUNT_NO
                                                          ELSE 0
                                                     END
                                                 ) AS CP_OTH
                                       FROM   FINANCIAL_TXN FTXSQ
                                              JOIN FINANCIAL_TXN_DETAIL FTDSQ ON FTDSQ.FINANCIAL_TXN_ID = FTXSQ.ID
                                                                                 AND FTXSQ.FPC_ID = FPC.ID
                                                                                 AND FTDSQ.PURGE_DT IS NULL
                                       WHERE  FTXSQ.FPC_ID = FPC.ID
                                              AND FTXSQ.PURGE_DT IS NULL
                                   ) FINSQ
                       LEFT JOIN REF_CODE RC_COVERAGETYPE ON RC_COVERAGETYPE.DOMAIN_CD = 'Coverage'
                                                             AND RC_COVERAGETYPE.CODE_CD = RC.TYPE_CD
                       LEFT JOIN REF_CODE RC_DIVISION ON RC_DIVISION.DOMAIN_CD = 'ContractType'
                                                         AND RC_DIVISION.CODE_CD = L.DIVISION_CODE_TX
                       LEFT JOIN COLLATERAL_CODE CC ON CC.ID = C.COLLATERAL_CODE_ID
                                                       AND CC.PURGE_DT IS NULL
                       LEFT JOIN REF_CODE RC_SC ON RC_SC.DOMAIN_CD = 'SecondaryClassification'
                                                   AND CC.SECONDARY_CLASS_CD = RC_SC.CODE_CD
                       LEFT JOIN REF_CODE_ATTRIBUTE RCA_PROP ON RC_SC.DOMAIN_CD = RCA_PROP.DOMAIN_CD
                                                                AND RC_SC.CODE_CD = RCA_PROP.REF_CD
                                                                AND RCA_PROP.ATTRIBUTE_CD = 'PropertyType'
                       CROSS APPLY dbo.fn_FilterCollateralByDivisionCd(
                                                                          C.ID ,
                                                                          @Division
                                                                      ) fn_FCBD
                WHERE  LND.CODE_TX = @LenderCode
                       AND (   L.BRANCH_CODE_TX IN (   SELECT STRVALUE
                                                       FROM   @BranchTable
                                                   )
                               OR @Branch IS NULL
                               OR @Branch = 'ALL'
                           )
                       AND RC.STATUS_CD <> 'I'
                       AND fn_FCBD.loanType IS NOT NULL
                       AND (   RC.TYPE_CD = @Coverage
                               OR @Coverage = '1'
                               OR @Coverage IS NULL
                           )
                       AND (   (   @FromDate IS NULL
                                   AND FPC.ISSUE_DT <= @ToDate
                               )
                               OR (   @FromDate IS NOT NULL
                                      AND FPC.ISSUE_DT
                       BETWEEN @FromDate AND @ToDate
                                  )
                           )
                       AND FPC.PURGE_DT IS NULL;

    IF ISNULL(@FilterBySQL, '') <> ''
        BEGIN
            SELECT *
            INTO   #t1
            FROM   #tmptable;
            TRUNCATE TABLE #tmptable;

            SET @sqlstring = N'Insert into #tmpTable
                     Select * from dbo.#t1 where ' + @FilterBySQL;
            --print @sqlstring
            EXECUTE sp_executesql @sqlstring;
        END;

    SET @sqlstring = N'Update #tmpTable Set [REPORT_GROUPBY_TX] = '
                     + @GroupBySQL;
    EXECUTE sp_executesql @sqlstring;

    SET @sqlstring = N'Update #tmpTable Set [REPORT_SORTBY_TX] = '
                     + @SortBySQL;
    EXECUTE sp_executesql @sqlstring;

    IF ISNULL(@HeaderTx, '') <> ''
        BEGIN
            SET @sqlstring = N'Update #tmpTable Set [REPORT_HEADER_TX] = '
                             + @HeaderTx;
            EXECUTE sp_executesql @sqlstring;
        END;

    IF ISNULL(@FooterTx, '') <> ''
        BEGIN
            SET @sqlstring = N'Update #tmpTable Set [REPORT_FOOTER_TX] = '
                             + @FooterTx;
            EXECUTE sp_executesql @sqlstring;
        END;

    SELECT @RecordCount = COUNT(*)
    FROM   #tmptable;

    IF @Report_History_ID IS NOT NULL
        BEGIN
            UPDATE [UNITRAC-REPORTS].[UniTrac].DBO.REPORT_HISTORY_NOXML
            SET    RECORD_COUNT_NO = @RecordCount
            WHERE  ID = @Report_History_ID;
        END;

    SELECT * INTO jcs..INC0323277
    FROM   #tmptable
    WHERE  LOAN_NUMBER_TX IN ( '65393-20', '50426-22', '75011-21', '75011-21' ,
                               '29894-41' ,'68363-20', '51602-20', '66254-21' ,
                               '52484-20' ,'42692-22', '42692-21', '50747-22' ,
                               '63365-20' ,'64949-20', '62204-20', '71288-20' ,
                               '27924-21' ,'56810-21', '51821-20', '59369-20' ,
                               '62708-20' ,'68057-20', '27172-25', '41972-21' ,
                               '66419-20' ,'63257-20', '70718-20', '54089-20' ,
                               '72419-21' ,'64685-20', '63455-20', '64454-20' ,
                               '71702-20' ,'67067-20', '54143-20', '18620-20' ,
                               '56654-21' ,'80399-20', '17788-23', '43352-22' ,
                               '30518-23' ,'67724-20', '67865-20', '48962-20' ,
                               '42389-23' ,'59522-21', '64412-20', '62972-20' ,
                               '48680-20' ,'69779-20', '60167-20', '41672-26' ,
                               '67697-20' ,'50004828-20', '50582-20' ,
                               '50582-20' ,'39473-28', '48854-20', '36626-21' ,
                               '72791-20' ,'23265-25', '56045-20', '64607-21' ,
                               '45935-20' ,'71357-20', '65132-20', '78842-20' ,
                               '35963-23' ,'74582-20', '67811-20', '43253-22' ,
                               '67679-20' ,'70784-20', '71762-20', '13060-27' ,
                               '13060-26' ,'46742-21', '64394-20', '60392-20' ,
                               '69029-20' ,'62276-20', '71882-20', '74783-20' ,
                               '47564-20' ,'70418-20', '73853-20', '64943-21' ,
                               '75920-21' ,'75920-20', '78719-20', '29816-24' ,
                               '47435-21' ,'30774-21', '37388-20', '37178-23' ,
                               '54974-20' ,'54107-20', '53183-20', '5510-21' ,
                               '53300-20' ,'67265-20', '19384-27', '75035-20' ,
                               '73211-20' ,'53849-20', '54539-20', '14606-20' ,
                               '30214-21' ,'52589-20', '74564-20', '66236-20' ,
                               '75575-20' ,'58859-20', '57530-21', '43097-23' ,
                               '63713-20' ,'53897-20', '68495-20', '73442-21' ,
                               '63359-20' ,'41810-25', '70952-20', '70069-20' ,
                               '50051-21' ,'68033-20', '43571-20', '33503-22' ,
                               '30407-29' ,'58175-20', '58175-22', '58175-21' ,
                               '75395-20'
                             );
END;


SELECT * FROM jcs..INC0323277