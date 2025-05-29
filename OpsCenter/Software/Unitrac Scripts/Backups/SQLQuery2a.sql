USE UniTrac


SELECT rc.* FROM dbo.PROPERTY P
JOIN dbo.REQUIRED_COVERAGE rc ON rc.PROPERTY_ID = P.ID
WHERE P.VIN_TX = '1N4AL24E58C134421' AND P.LENDER_ID = 1835

SELECT * FROM dbo.COLLATERAL
WHERE

UPDATE rc 
SET SUMMARY_STATUS_CD ='B', RC.SUMMARY_SUB_STATUS_CD = 'C'
--SELECT SUMMARY_STATUS_CD, RC.SUMMARY_SUB_STATUS_CD, CPI_QUOTE_ID,*
FROM dbo.REQUIRED_COVERAGE rc
WHERE rc.ID = 




DECLARE @CPI NVARCHAR(255)
DECLARE @tp NVARCHAR(255)
DECLARE @pe NVARCHAR(255)
DECLARE @pca NVARCHAR(255)
DECLARE @pr NVARCHAR(255)
DECLARE @npa NVARCHAR(255)

SELECT @CPI = CPI_QUOTE_ID
FROM   CPI_ACTIVITY
WHERE  CPI_QUOTE_ID IN (   SELECT fpc.CPI_QUOTE_ID
                           FROM   dbo.FORCE_PLACED_CERTIFICATE FPC
                                  JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR ON FPCR.FPC_ID = FPC.ID
                                  JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = FPCR.REQUIRED_COVERAGE_ID
                           WHERE  RC.ID = 179998422
                       );

SELECT @tp = TOTAL_PREMIUM_NO
FROM   CPI_ACTIVITY
WHERE  CPI_QUOTE_ID IN (   SELECT fpc.CPI_QUOTE_ID
                           FROM   dbo.FORCE_PLACED_CERTIFICATE FPC
                                  JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR ON FPCR.FPC_ID = FPC.ID
                                  JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = FPCR.REQUIRED_COVERAGE_ID
                           WHERE  RC.ID = 179998422
                       );


SELECT @PE = PAYMENT_EFFECTIVE_DT
FROM   CPI_ACTIVITY
WHERE  CPI_QUOTE_ID IN (   SELECT fpc.CPI_QUOTE_ID
                           FROM   dbo.FORCE_PLACED_CERTIFICATE FPC
                                  JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR ON FPCR.FPC_ID = FPC.ID
                                  JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = FPCR.REQUIRED_COVERAGE_ID
                           WHERE  RC.ID = 179998422
                       );

SELECT @PCA = PAYMENT_CHANGE_AMOUNT_NO
FROM   CPI_ACTIVITY
WHERE  CPI_QUOTE_ID IN (   SELECT fpc.CPI_QUOTE_ID
                           FROM   dbo.FORCE_PLACED_CERTIFICATE FPC
                                  JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR ON FPCR.FPC_ID = FPC.ID
                                  JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = FPCR.REQUIRED_COVERAGE_ID
                           WHERE  RC.ID = 179998422
                       );


SELECT @PR = PRIOR_PAYMENT_AMOUNT_NO
FROM   CPI_ACTIVITY
WHERE  CPI_QUOTE_ID IN (   SELECT fpc.CPI_QUOTE_ID
                           FROM   dbo.FORCE_PLACED_CERTIFICATE FPC
                                  JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR ON FPCR.FPC_ID = FPC.ID
                                  JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = FPCR.REQUIRED_COVERAGE_ID
                           WHERE  RC.ID = 179998422
                       );


SELECT @npa = NEW_PAYMENT_AMOUNT_NO
FROM   CPI_ACTIVITY
WHERE  CPI_QUOTE_ID IN (   SELECT fpc.CPI_QUOTE_ID
                           FROM   dbo.FORCE_PLACED_CERTIFICATE FPC
                                  JOIN dbo.FORCE_PLACED_CERT_REQUIRED_COVERAGE_RELATE FPCR ON FPCR.FPC_ID = FPC.ID
                                  JOIN dbo.REQUIRED_COVERAGE RC ON RC.ID = FPCR.REQUIRED_COVERAGE_ID
                           WHERE  RC.ID = 179998422
                       );


INSERT dbo.CPI_ACTIVITY (   CPI_QUOTE_ID ,
                                 TYPE_CD ,
                                 PROCESS_DT ,
                                 TOTAL_PREMIUM_NO ,
                                 START_DT ,
                                 END_DT ,
                                 REASON_CD ,
                                 CREATE_DT ,
                                 UPDATE_DT ,
                                 UPDATE_USER_TX ,
                                 PURGE_DT ,
                                 LOCK_ID ,
                                 PAYMENT_EFFECTIVE_DT ,
                                 PAYMENT_CHANGE_AMOUNT_NO ,
                                 PRIOR_PAYMENT_AMOUNT_NO ,
                                 NEW_PAYMENT_AMOUNT_NO ,
                                 REPORTING_CANCEL_DT ,
                                 EXECUTION_STEPS_TX ,
                                 COMMENT_TX ,
                                 EARNED_PAYMENT_AMOUNT_NO ,
                                 SUB_REASON_CD
                             )
VALUES (   @CPI ,             -- CPI_QUOTE_ID - bigint
           'QB' ,            -- TYPE_CD - varchar(2)
           SYSDATETIME() , -- PROCESS_DT - datetime2(7)
           @TP ,          -- TOTAL_PREMIUM_NO - decimal(18, 2)
           SYSDATETIME() , -- START_DT - datetime2(7)
           SYSDATETIME() , -- END_DT - datetime2(7)
           N'I' ,           -- REASON_CD - nvarchar(10)
           SYSDATETIME() , -- CREATE_DT - datetime2(7)
           SYSDATETIME() , -- UPDATE_DT - datetime2(7)
           N'jrussell' ,           -- UPDATE_USER_TX - nvarchar(15)
           NULL , -- PURGE_DT - datetime2(7)
           1 ,             -- LOCK_ID - tinyint
           @pe , -- PAYMENT_EFFECTIVE_DT - datetime2(7)
           @pca ,          -- PAYMENT_CHANGE_AMOUNT_NO - decimal(18, 2)
           @pr ,          -- PRIOR_PAYMENT_AMOUNT_NO - decimal(18, 2)
           @npa ,          -- NEW_PAYMENT_AMOUNT_NO - decimal(18, 2)
           NULL , -- REPORTING_CANCEL_DT - datetime2(7)
           N'Carrier/CarrierProduct: Securian Casualty Company/Default
IssueProc:SEC-1, Basis:10065.48, BasisTypeCode:B, EffectiveDate:7/2/2017
Term Type=Annual, Monthly Billing=False
CollateralCode=<DEFAULT>, FloodZone=
PrimaryClassification=PER, SecondaryClassification=VEH, PropertyType=VEH
Monthly Term=12, Expiration Date=7/2/2018
Business Option MaxCollAge=0, MaxAge Opt=None
State MinBalance=5001, BalanceType=Collateral, Round Basis=False
Loan Balance=10065.48, Collateral Balance=10065.48, ACV=20077.00
Business Option MinBal=5001, MinBal Opt=Waive
Business Option MaxBal=50000, MaxBal Opt=Issue on Max Balance
IssProc MaxBal=0, MaxBal Opt=NONE, BalanceType=CONTRACT
Endorsement=-0.4100
CarrierCollCredit=0
Annual Surcharge=0.0000
Type=Premium, Min=0, Max=0
Rule=Percent, RateValue=16.00000, Amount=1610.4768000, Basis=10065.48
Premium 950
Type=Fee, Min=0, Max=0
Rule=Amount, RateValue=0.00000, Amount=0.00000, Basis=950
Fee 0
Type=Other, Min=0, Max=0
Rule=Amount, RateValue=0.00000, Amount=0.00000, Basis=950
Other 0
Type=Tax1, Min=0, Max=0
Rule=Percent, RateValue=0.00000, Amount=0.00000, Basis=950
Tax1 0
Type=Tax2, Min=0, Max=0
Rule=Percent, RateValue=0.00000, Amount=0.00000, Basis=950
Tax2 0
TotalAmount=950
PmtMethod="N" Months
PmtIncr Method="N" Months, Method Value=12, EffectiveDate=8/8/2017 12:00:00 AM, Increase Amt=82.04, FirstMonth=0
StatusCode=0 Status=Issue Ok' ,           -- EXECUTION_STEPS_TX - nvarchar(max)
           NULL ,           -- COMMENT_TX - nvarchar(max)
          N'0.00' ,          -- EARNED_PAYMENT_AMOUNT_NO - decimal(18, 2)
           N'NS'             -- SUB_REASON_CD - nvarchar(4)
       )



INSERT dbo.CPI_ACTIVITY (   CPI_QUOTE_ID ,
                                 TYPE_CD ,
                                 PROCESS_DT ,
                                 TOTAL_PREMIUM_NO ,
                                 START_DT ,
                                 END_DT ,
                                 REASON_CD ,
                                 CREATE_DT ,
                                 UPDATE_DT ,
                                 UPDATE_USER_TX ,
                                 PURGE_DT ,
                                 LOCK_ID ,
                                 PAYMENT_EFFECTIVE_DT ,
                                 PAYMENT_CHANGE_AMOUNT_NO ,
                                 PRIOR_PAYMENT_AMOUNT_NO ,
                                 NEW_PAYMENT_AMOUNT_NO ,
                                 REPORTING_CANCEL_DT ,
                                 EXECUTION_STEPS_TX ,
                                 COMMENT_TX ,
                                 EARNED_PAYMENT_AMOUNT_NO ,
                                 SUB_REASON_CD
                             )
VALUES (   @CPI ,             -- CPI_QUOTE_ID - bigint
           'I' ,            -- TYPE_CD - varchar(2)
           SYSDATETIME() , -- PROCESS_DT - datetime2(7)
           @TP ,          -- TOTAL_PREMIUM_NO - decimal(18, 2)
           SYSDATETIME() , -- START_DT - datetime2(7)
           SYSDATETIME() , -- END_DT - datetime2(7)
           N'I' ,           -- REASON_CD - nvarchar(10)
           SYSDATETIME() , -- CREATE_DT - datetime2(7)
           SYSDATETIME() , -- UPDATE_DT - datetime2(7)
           N'jrussell' ,           -- UPDATE_USER_TX - nvarchar(15)
           NULL , -- PURGE_DT - datetime2(7)
           1 ,             -- LOCK_ID - tinyint
           @pe , -- PAYMENT_EFFECTIVE_DT - datetime2(7)
           @pca ,          -- PAYMENT_CHANGE_AMOUNT_NO - decimal(18, 2)
           @pr ,          -- PRIOR_PAYMENT_AMOUNT_NO - decimal(18, 2)
           @npa ,          -- NEW_PAYMENT_AMOUNT_NO - decimal(18, 2)
           NULL , -- REPORTING_CANCEL_DT - datetime2(7)
           N'Carrier/CarrierProduct: Securian Casualty Company/Default
IssueProc:SEC-1, Basis:10065.48, BasisTypeCode:B, EffectiveDate:7/2/2017
Term Type=Annual, Monthly Billing=False
CollateralCode=<DEFAULT>, FloodZone=
PrimaryClassification=PER, SecondaryClassification=VEH, PropertyType=VEH
Monthly Term=12, Expiration Date=7/2/2018
Business Option MaxCollAge=0, MaxAge Opt=None
State MinBalance=5001, BalanceType=Collateral, Round Basis=False
Loan Balance=10065.48, Collateral Balance=10065.48, ACV=20077.00
Business Option MinBal=5001, MinBal Opt=Waive
Business Option MaxBal=50000, MaxBal Opt=Issue on Max Balance
IssProc MaxBal=0, MaxBal Opt=NONE, BalanceType=CONTRACT
Endorsement=-0.4100
CarrierCollCredit=0
Annual Surcharge=0.0000
Type=Premium, Min=0, Max=0
Rule=Percent, RateValue=16.00000, Amount=1610.4768000, Basis=10065.48
Premium 950
Type=Fee, Min=0, Max=0
Rule=Amount, RateValue=0.00000, Amount=0.00000, Basis=950
Fee 0
Type=Other, Min=0, Max=0
Rule=Amount, RateValue=0.00000, Amount=0.00000, Basis=950
Other 0
Type=Tax1, Min=0, Max=0
Rule=Percent, RateValue=0.00000, Amount=0.00000, Basis=950
Tax1 0
Type=Tax2, Min=0, Max=0
Rule=Percent, RateValue=0.00000, Amount=0.00000, Basis=950
Tax2 0
TotalAmount=950
PmtMethod="N" Months
PmtIncr Method="N" Months, Method Value=12, EffectiveDate=8/8/2017 12:00:00 AM, Increase Amt=82.04, FirstMonth=0
StatusCode=0 Status=Issue Ok' ,           -- EXECUTION_STEPS_TX - nvarchar(max)
           NULL ,           -- COMMENT_TX - nvarchar(max)
          N'0.00' ,          -- EARNED_PAYMENT_AMOUNT_NO - decimal(18, 2)
           N'NS'             -- SUB_REASON_CD - nvarchar(4)
       )


