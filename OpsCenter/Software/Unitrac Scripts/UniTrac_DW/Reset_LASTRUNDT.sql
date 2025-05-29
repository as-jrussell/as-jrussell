/*
Usage:				Reset the last run date for the SSIS Packages if needed to 
					re-run a previous or current month
Developed by:		Steve Moran
Last Updated:		2010-09-10 07:49:03.093		
Description:		Replace the Package_Name_TX (With one of the packages below)
					with the package that needs its Last_Run_DT set
					Last_Run_DT = Last Run Date
					
ID                   PACKAGE_NAME_TX
-------------------- --------------------------------------------------
13                   AccountingPackage
3                    CertificateDataPointsPackage
9                    CiscoCallCountsPackage
12                   DataStorePackage
4                    DimensionsPackage
1                    DocumentDataPointsPackage
15                   ExceptionDataProcessingPackage
14                   HeadCountsPackage
6                    LenderSummaryPackage
5                    LoanCountsPackage
2                    NoticeDataPointsPackage
11                   OMRClaimPackage
8                    OutstandingQueuePackage
7                    PremiumsPackage
10                   ProcessDataPointsPackage
*/


USE UniTrac_DW

UPDATE  SSIS_Control_Detail
SET     Last_RUN_DT = '2014-11-01 00:00:00.000'
FROM    SSIS_Control_Main
        INNER JOIN SSIS_Control_Detail ON SSIS_Control_Main.ID = SSIS_Control_Detail.SSIS_CONTROL_MAIN_ID
WHERE   Package_Name_TX = 'HeadCountsPackage'
Select getdate()


SELECT * FROM UniTrac_DW..SSIS_CONTROL_DETAIL

