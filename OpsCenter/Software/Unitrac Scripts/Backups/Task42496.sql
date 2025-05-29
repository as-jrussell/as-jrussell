SELECT DISTINCT bd.LENDER_NAME_TX [Lender Name]
,CONVERT(NVARCHAR(max),bd.LENDER_CODE_TX) [Lender Code]
,CONVERT(NVARCHAR(1),bd.PRODUCT_TYPE_VEHICLE_IN) [Vehicle]
,CONVERT(NVARCHAR(1),bd.PRODUCT_TYPE_MORTGAGE_IN) [Mortgage]
,CONVERT(NVARCHAR(1),bd.PRODUCT_TYPE_ESCROW_IN) [Escrow]
,CONVERT(NVARCHAR(1),bd.PRODUCT_TYPE_REPOPLUS_IN) [RepoPlus]
,CONVERT(INT,bd.LOAN_COUNT) [Loans]
,CONVERT(INT,bd.PROPERTY_VEHICLE_COUNT) [Property Vehicles]
,CONVERT(INT,bd.PROPERTY_REAL_ESTATE_COUNT) [Property Real Estate]
,CONVERT(INT,bd.PROPERTY_OTHER_COUNT) [Property Other]
,CONVERT(INT,bd.RC_PHYSICAL_DAMAGE_COUNT) [RC Physical Damage]
,CONVERT(INT,bd.RC_AUTO_LIABILITY_COUNT) [RC Auto Liabiltiy]
,CONVERT(INT,bd.RC_HAZARD_COUNT) [RC Hazard]
,CONVERT(INT,bd.RC_OTHER_COUNT) [RC Other]
,CONVERT(INT,bd.RC_WIND_COUNT) [RC Wind]
,CONVERT(INT,bd.RC_FLOOD_COUNT) [RC Flood]
,CONVERT(INT,bd.CPI_PHYSICAL_DAMAGE_COUNT) [CPI Physical Damage]
,CONVERT(INT,bd.CPI_HAZARD_COUNT) [CPI Hazard]
,CONVERT(INT,bd.CPI_FLOOD_COUNT) [CPI Flood]
,CONVERT(INT,bd.CPI_WIND_COUNT) [CPI Wind]
,CONVERT(INT,bd.CPI_OTHER_COUNT) [CPI Other]
,CONVERT(INT,bd.CPI_AUTO_LIABILITY_COUNT) [CPI Auto Liabiltiy]
,bd.CPI_PREMIUM [CPI Premium]
,bd.CPI_REFUND [CPI Refund]
,CONVERT(INT,bd.SCANNED_IMAGE_COUNT) [Scanned Docs]
,CONVERT(INT,bd.DIGITAL_IMAGE_COUNT) [Digital Docs]
,CONVERT(INT,bd.EDI_COUNT) [EDI]
,CONVERT(INT,bd.IDR_COUNT) [IDR]
,CONVERT(INT,bd.BSS_COUNT) [BSS]
,CONVERT(INT,bd.UTL_COUNT) [UTL]
,CONVERT(INT,bd.LFP_IMPORT_COUNT) [LFP Import]
,CONVERT(INT,bd.LFP_BACKFEED_COUNT) [Export]
,CONVERT(INT,bd.REPORT_COUNT) [Reports]
,CONVERT(INT,bd.NOTICE_COUNT) [Notices]
,CONVERT(INT,bd.LENDER_PRODUCT_COUNT) [Lender Products]
,CONVERT(INT,bd.IMPORT_CONFIG_COUNT) [Import Configs]
,CONVERT(INT,bd.OUTPUT_BATCH_COUNT) [Output Batches]
,CONVERT(INT,bd.PROCESS_BILLING_COUNT) [Process Billings]
,CONVERT(INT,bd.PROCESS_REGEN_LETTER_COUNT) [Process Regen Letters]
,CONVERT(INT,bd.PROCESS_CYCLE_COUNT) [Process Cycles]
,CONVERT(INT,bd.PROCESS_AUTOOBC_COUNT) [Proces AutoOBC]
,CONVERT(INT,bd.PROCESS_FISERV_INSFILE_COUNT) [Process Fiserv Insfile]
,CONVERT(INT,bd.PROCESS_ESCROW_PAYMENT_COUNT) [Process Escrow Payments]
,CONVERT(INT,bd.PROCESS_EVALUATION_COUNT) [Process Evaluations]
,CONVERT(INT,bd.PROCESS_GOODTHRU_COUNT) [Process GoodThrus]
,CONVERT(INT,bd.WORKITEM_ACTION_REQUEST_COUNT) [WI Action Requests]
,CONVERT(INT,bd.WORKITEM_BILLING_GROUP_COUNT) [WI Billing Groups]
,CONVERT(INT,bd.WORKITEM_CPI_CANCEL_PENDING_COUNT) [WI CPI Cancel Pendings]
,CONVERT(INT,bd.WORKITEM_CYCLE_COUNT) [WI Cycles]
,CONVERT(INT,bd.WORKITEM_ESCROW_BILLING_COUNT) [WI Escrow Billings]
,CONVERT(INT,bd.WORKITEM_INBOUND_CALL_COUNT) [WI Inbound Calls]
,CONVERT(INT,bd.WORKITEM_KEY_IMAGE_COUNT) [WI Key Images]
,CONVERT(INT,bd.WORKITEM_LFP_COUNT) [WI LFPs]
,CONVERT(INT,bd.WORKITEM_UTL_MATCHING_COUNT) [WI UTL Matching]
,CONVERT(INT,bd.WORKING_VERIFICATION_EVENT_COUNT) [WI Verification Events]
,CONVERT(INT,bd.WORKITEM_VERIFY_DATA_COUNT) [WI Verify Data]
,CONVERT(INT,bd.WORKITEM_OTHER_COUNT) [WI Others]
,bd.DATABASE_ELAPSED_RUNTIME [Database Total Time]
,bd.DATABASE_READS [Database Total Reads]
,bd.DATABASE_CPU_TIME [Database Total CPU]
,bd.DATABASE_CPU_PERCENT [Database %CPU]
,bd.REPORT_TIME [Report Total Time]
into UnitracHDStorage..BenchMarking
FROM BENCHMARK_DATA bd
WHERE CONVERT(INT,bd.BENCHMARK_DATA_RUN_ID) = (SELECT MAX(id) FROM BENCHMARK_DATA_RUN bdr) 

SELECT  --ID, bd.LENDER_NAME_TX, bd.LENDER_CODE_TX, bd.BENCHMARK_DATA_RUN_ID  
*
FROM BENCHMARK_DATA bd
WHERE bd.LENDER_CODE_TX = '0004'


brett.mitchell@alliedsolutions.net;tim.holtz@alliedsolutions.net;mike.breitsch@alliedsolutions.net;joey.nemeroff@alliedsolutions.net;
robyn.brewster@alliedsolutions.net;julie.seery@alliedsolutions.net;erik.gold@ospreysoftware.com;jerry.lamb@ospreysoftware.com;
bob.paquette@ospreysoftware.com;mayank.agarwal@ospreysoftware.com;nancy.mcmahon@ospreysoftware.com;
lisa.mcanulty@ospreysoftware.com;mike.funiciello@ospreysoftware.com;raelee.grimm@ospreysoftware.com;lindsey.cusson@ospreysoftware.com; timothy.russell@alliedsolutions.net
;



CREATE TABLE `Excel Destination` (
    `Lender Name` NVARCHAR (10),
    `Lender Code` NVARCHAR (10),
    `Vehicle` NVARCHAR (10),
    `Mortgage` NVARCHAR (10),
    `Escrow` NVARCHAR (10),
    `RepoPlus`NVARCHAR (10),
    `Loans` INT,
    `Property Vehicles` INT,
    `Property Real Estate` INT,
    `Property Other` INT,
    `RC Physical Damage` INT,
    `RC Auto Liabiltiy` INT,
    `RC Hazard` INT,
    `RC Other` INT,
    `RC Wind` INT,
    `RC Flood` INT,
    `CPI Physical Damage` INT,
    `CPI Hazard` INT,
    `CPI Flood` INT,
    `CPI Wind` INT,
    `CPI Other` INT,
    `CPI Auto Liabiltiy` INT,
    `CPI Premium` Decimal(18,2),
    `CPI Refund` Decimal(18,2),
    `Scanned Docs` INT,
    `Digital Docs` INT,
    `EDI` INT,
    `IDR` INT,
    `BSS` INT,
    `UTL` INT,
    `LFP Import` INT,
    `Export` INT,
    `Reports` INT,
    `Notices` INT,
    `Lender Products` INT,
    `Import Configs` INT,
    `Output Batches` INT,
    `Process Billings` INT,
    `Process Regen Letters` INT,
    `Process Cycles` INT,
    `Proces AutoOBC` INT,
    `Process Fiserv Insfile` INT,
    `Process Escrow Payments` INT,
    `Process Evaluations` INT,
    `Process GoodThrus` INT,
    `WI Action Requests` INT,
    `WI Billing Groups` INT,
    `WI CPI Cancel Pendings` INT,
    `WI Cycles` INT,
    `WI Escrow Billings` INT,
    `WI Inbound Calls` INT,
    `WI Key Images` INT,
    `WI LFPs` INT,
    `WI UTL Matching` INT,
    `WI Verification Events` INT,
    `WI Verify Data` INT,
    `WI Others` INT,
    `Database Total Time` Decimal(27,6),
    `Database Total CPU` Decimal(27,6),
    `Database %CPU` Decimal(27,6),
    `Report Total Time` Decimal(27,6)
)


SELECT * FROM dbo.BENCHMARK_DATA_RUN


EXEC dbo.ProcessBenchmarkInfo 


sp_columns BENCHMARK_DATA




EXEC msdb.dbo.sp_send_dbmail @profile_name = 'Unitrac-prod',
 @recipients ='brett.mitchell@alliedsolutions.net;tim.holtz@alliedsolutions.net;mike.breitsch@alliedsolutions.net;joey.nemeroff@alliedsolutions.net;
robyn.brewster@alliedsolutions.net;julie.seery@alliedsolutions.net;erik.gold@ospreysoftware.com;jerry.lamb@ospreysoftware.com;lisa.mcanulty@ospreysoftware.com;
bob.paquette@ospreysoftware.com;mayank.agarwal@ospreysoftware.com;nancy.mcmahon@ospreysoftware.com;
mike.funiciello@ospreysoftware.com;raelee.grimm@ospreysoftware.com;lindsey.cusson@ospreysoftware.com; timothy.russell@alliedsolutions.net
;joseph.russell@alliedsolutions.net', 
@subject = 'Benchmark Matrix File',
 @body = 'Attached is the Benchmark Matrix File.
',
 @file_attachments = 'D:\SQL\Benchmark Matrix File.xls'
