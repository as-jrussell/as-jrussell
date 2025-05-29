--Loan Search Details
SELECT TOP 10 *
FROM SEARCH_FULLTEXT

select TOP 10 *
from LOAN
WHERE LENDER_ID = 968 AND RECORD_TYPE_CD = 'G' AND CREATE_DT >= '2015-04-01'

SELECT *
FROM LENDER
WHERE ID = 968


--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
select * from LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
WHERE L.NUMBER_TX = '29870535-80-3' AND L.LENDER_ID = 968

--LOAN HISTORY SEARCH INFORMATION
SELECT TOP 10 *
FROM INTERACTION_HISTORY
WHERE PROPERTY_ID = 85507662

--DOCUMENT STORAGE LOCATIONS BY TYPE/AGENCY
SELECT *
FROM DOCUMENT_MANAGEMENT

--Notice Information by Loan
SELECT DC.*
FROM LOAN L 
inner join NOTICE N on L.ID = n.LOAN_ID
left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
WHERE L.NUMBER_TX = '29870535-80-3' 


--FPC Information by Loan
SELECT DC.*
FROM LOAN L 
inner join FORCE_PLACED_CERTIFICATE FPC on L.ID = fpc.LOAN_ID
left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate' AND DC.PURGE_DT IS NULL	
WHERE L.NUMBER_TX = '115511L1' 

SELECT *
FROM LOAN L 
inner join FORCE_PLACED_CERTIFICATE FPC on L.ID = FPC.LOAN_ID
left outer join document_container dc on dc.relate_id = FPC.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate' AND DC.PURGE_DT IS NULL
WHERE L.NUMBER_TX = '039-007806' AND L.LENDER_ID = 2216

--Cycle Process Definitions by Lender
SELECT *
FROM PROCESS_DEFINITION
WHERE NAME_TX LIKE '%1036%' AND PROCESS_TYPE_CD = 'CYCLEPRC' AND ACTIVE_IN = 'Y'

--Log of Process Runs
SELECT *
FROM PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = 10416
ORDER BY START_DT DESC

--Certificates created by Process
SELECT dc.*
		from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.forceplacedcertificate'
						inner join FORCE_PLACED_CERTIFICATE fpc on fpc.id = pli.relate_id 
			left outer join document_container dc on dc.relate_id = fpc.id and dc.relate_class_name_tx = 'allied.unitrac.forceplacedcertificate'
WHERE PROCESS_DEFINITION_ID = 10416 AND PL.ID = 23400728

--Notices created by Process
SELECT dc.*
								from
			PROCESS_LOG pl
			inner join process_log_item pli on pli.PROCESS_LOG_ID = pl.id and pli.relate_type_cd = 'allied.unitrac.notice'
			inner join NOTICE N on N.id = pli.relate_id 
			inner join LOAN L on L.ID = n.LOAN_ID
			left outer join document_container dc on dc.relate_id = n.id and dc.relate_class_name_tx = 'allied.unitrac.notice' AND DC.PURGE_DT IS NULL	
	WHERE PROCESS_DEFINITION_ID = 10416 AND PL.ID = 23400728

--Output Batches by Process	
SELECT *
FROM OUTPUT_BATCH	
WHERE PROCESS_LOG_ID = 23400728

--Printers/Output Paths
SELECT *
FROM OUTPUT_DEVICE

--Output Batches with Name, LOCATION and PATH
SELECT OD.NAME_TX, OD.LOCATION_TX, OD.UNC_PATH_TX, OB.* FROM dbo.OUTPUT_BATCH OB
INNER JOIN dbo.OUTPUT_CONFIGURATION OC ON OC.ID = OB.OUTPUT_CONFIGURATION_ID
INNER JOIN dbo.OUTPUT_DEVICE OD ON OD.ID = OC.OUTPUT_DEVICE_ID



--Work Item Search by Process			
SELECT * 
FROM WORK_ITEM 
WHERE RELATE_ID = 23400728

--Database Version 
SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'System'
AND CODE_CD = 'DBVER'

---Search for message server XMLs


SELECT  *
FROM    PROCESS_DEFINITION pd
WHERE   PROCESS_TYPE_CD = 'MSGSRV'
        AND ACTIVE_IN = 'Y'
        AND ONHOLD_IN = 'N'

 ---Work Item within on LOAN
 SPECIAL_HANDLING_XML.value('(/SH/Misc/VerifyDataWorkItemId)[1]', 'varchar (50)') [Work Item Id]
 
 ---Lender on WI
 CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)')
 
 ---COVERAGE type on WI
 CONTENT_XML.value('(/Content/Coverage/Type)[1]', 'varchar (50)')
 
 ---Error on WI
 CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)')
 
 
 --Error on WI with data
SELECT  CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)')
, *
FROM dbo.WORK_ITEM WIBacking up data and deploying scripts
WHERE WI.STATUS_CD = 'Error'
AND   CAST(UPDATE_DT AS DATE) = CAST(GETDATE()AS DATE)
AND WORKFLOW_DEFINITION_ID <> '1'
AND PURGE_DT IS NULL AND CONTENT_XML.value('(/Content/EvaluationError)[1]', 'varchar (85)') NOT LIKE '%Unable to load%'

 
 --XML for Process Log Item
 SELECT  INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (50)') MESSAGE_LOG,  INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') AS USER_ACTION, *
FROM PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID = 26561193 


SELECT INFO_XML.value('(/INFO_LOG/RELATE_INFO)[1]', 'varchar (50)') [Loan Number], 
INFO_XML.value('(/INFO_LOG/MESSAGE_LOG)[1]', 'varchar (100)') [Message], 
PLI.* FROM dbo.PROCESS_LOG_ITEM PLI
LEFT JOIN dbo.LOAN L ON L.ID = PLI.RELATE_ID 
WHERE PROCESS_LOG_ID IN (44764806, 44764877) AND PLI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan'




		if @excludesWind is NULL and @opXML IS NOT NULL
		BEGIN
			--Insert PolicyExcludesWind Node with value of Y
			update OWNER_POLICY
			set SPECIAL_HANDLING_XML.modify('insert <PolicyExcludesWind>Y</PolicyExcludesWind> into (/SH[1])'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = 'Task40213',
			LOCK_ID = (LOCK_ID % 255) + 1
			Where  id = @opId
		END

		if @excludesWind = 'N' AND @opXML IS NOT NULL
		BEGIN			
			-- Change value of PolicyExcludesWind
			update OWNER_POLICY
			set SPECIAL_HANDLING_XML.modify('replace value of (/SH/PolicyExcludesWind[. = sql:variable("@oldValue")]/text())[1]
			with sql:variable("@newValue")'),
			UPDATE_DT = getdate(), UPDATE_USER_TX = 'Task40213',
			LOCK_ID = (LOCK_ID % 255) + 1
			Where  id = @opId			
		END		

--XML for Reports
rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE

---Special Handling for INTERACTION_HISTORY

SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/Id)[1]', 'varchar (50)')


---Update XML for User Action

UPDATE PLI
SET INFO_XML.modify('insert <USER_ACTION>Reject</USER_ACTION> into (/INFO_LOG)[1]'),
        LOCK_ID = LOCK_ID + 1
--SELECT pli.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') AS USER_ACTION
FROM PROCESS_LOG_ITEM pli
WHERE pli.ID IN (1948277722,1948277724,1948277725,1948277726,1948277727)


UPDATE PLI
SET INFO_XML.modify('insert <USER_ACTION>Reject</USER_ACTION> into (/INFO_LOG)[1]'),
       pli LOCK_ID = pli.LOCK_ID + 1
--SELECT pli.INFO_XML.value('(/INFO_LOG/USER_ACTION)[1]', 'varchar (50)') AS USER_ACTION, *
FROM PROCESS_LOG_ITEM pli
JOIN dbo.WORK_ITEM_PROCESS_LOG_ITEM_RELATE WIPLIR ON WIPLIR.PROCESS_LOG_ITEM_ID = pli.ID
WHERE WIPLIR.WORK_ITEM_ID = 42074450



-----Error Status
SELECT rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE, 
rh.REPORT_DATA_XML.value( '(/ReportData/Report/ProcessLogID/@value)[1]', 'varchar(500)' ) as ProcessLogID,
rh.REPORT_DATA_XML.value( '(/ReportData/Report/RelateId/@value)[1]', 'varchar(500)' ) as Relate_ID, * 
FROM    REPORT_HISTORY rh
WHERE   STATUS_CD = 'ERR'
        AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
        AND GENERATION_SOURCE_CD = 'u'
        AND MSG_LOG_TX IS NOT NULL
		ORDER BY rh.REPORT_DATA_XML.value( '(/ReportData/Report/RelateId/@value)[1]', 'varchar(500)' ) DESC

--Update to XML for Process Definition

UPDATE  PROCESS_DEFINITION
SET     SETTINGS_XML_IM.modify('replace value of (/ProcessDefinitionSettings/TargetServiceList/TargetService/text())[1] with "UnitracBusinessServiceCycle2"') ,
        LOCK_ID = LOCK_ID + 1
		
		
----
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)


--Inserts into existing backed up table
INSERT INTO PROCESS_DEFINITION (NAME_TX,DESCRIPTION_TX,EXECUTION_FREQ_CD,PROCESS_TYPE_CD,PRIORITY_NO,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,INCLUDE_WEEKENDS_IN,INCLUDE_HOLIDAYS_IN,ONHOLD_IN,FREQ_MULTIPLIER_NO, USE_LAST_SCHEDULED_DT_IN)
SELECT * FROM PROCESS_DEFINITION
WHERE ID = 7920

--TRANSACTION


DATA.value( '(/Lender/Lender/CurrentLenderSummaryMatchResult/TotalExtractRecords)[1]', 'varchar(500)' ) as LoanCount,

--- Masterpiece
USE [UniTrac]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[jcs..INC0296880]') AND type IN (N'P', N'PC'))
   DROP PROCEDURE [dbo].[jcs..INC0296880]
GO


SELECT  RC.TYPE_CD ,
        RC1.DESCRIPTION_TX [Coverage Status] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
		CONCAT(RC6.DESCRIPTION_TX, ' ', RC5.DESCRIPTION_TX) AS [Insurance Coverage Status],
        L.EFFECTIVE_DT ,
        L.NUMBER_TX ,
        L.BRANCH_CODE_TX [Branch Code] ,
        RC.ID [RC_ID] ,
        L.ID [LoanID]
--INTO    UniTracHDStorage..AAAINC0230023
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
        INNER JOIN dbo.LENDER_PRODUCT LP ON LP.ID = RC.LENDER_PRODUCT_ID
        INNER JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = RC.STATUS_CD
                                       AND RC1.DOMAIN_CD = 'RequiredCoverageStatus'
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        LEFT JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
        LEFT JOIN dbo.REF_CODE RC5 ON RC5.CODE_CD = RC.INSURANCE_STATUS_CD
                                       AND RC5.DOMAIN_CD = 'RequiredCoverageInsStatus'
        LEFT JOIN dbo.REF_CODE RC6 ON RC6.CODE_CD = RC.INSURANCE_SUB_STATUS_CD
                                       AND RC6.DOMAIN_CD = 'RequiredCoverageInsSubStatus'
        LEFT JOIN dbo.REF_CODE RC7 ON RC7.CODE_CD = RC.SUB_STATUS_CD
                                       AND RC7.DOMAIN_CD = 'RequiredCoverageSubStatus'
		LEFT JOIN dbo.LENDER_ORGANIZATION LO ON LO.LENDER_ID = LL.ID 
									    AND LO.TYPE_CD = 'DIV' AND LO.CODE_TX = L.DIVISION_CODE_TX							   
---Search by Service


	SELECT *
		FROM    dbo.PROCESS_DEFINITION
        WHERE   ACTIVE_IN = 'Y' AND ONHOLD_IN = 'N'
                AND SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/TargetServiceList/TargetService)[1]',
                                          'nvarchar(max)') IN ( 'DashboardService' )
        ORDER BY ID ASC


		
---Finding Crosslink Loans
		
--SELECT  *
SELECT DISTINCT L.NUMBER_TX
FROM    dbo.PROPERTY_CHANGE PC
        INNER JOIN  dbo.COLLATERAL C ON PC.ENTITY_ID = C.ID
        INNER JOIN  dbo.PROPERTY P ON P.ID = C.PROPERTY_ID
        INNER JOIN  dbo.LOAN L ON L.ID = C.LOAN_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON P.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   PC.ENTITY_NAME_TX = 'Allied.UniTrac.Collateral'
        AND PC.NOTE_TX LIKE '%Crosslink%' AND LL.CODE_TX = 'XXXX'		
		
		
		
---Join multiple tables to do an update
	--UPDATE LN 
	--SET LN.SPECIAL_HANDLING_XML = (L.SPECIAL_HANDLING_XML),
	--LN.PURGE_DT = (L.PURGE_DT),
	--LN.UPDATE_USER_TX = (L.UPDATE_USER_TX)
	----SELECT LN.* 
	--FROM dbo.LOAN LN
	--INNER JOIN UniTracHDStorage..INC0220830_Loans L ON LN.ID = L.ID
	
	
UPDATE dbo.REQUIRED_COVERAGE
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = ' INC0XXXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'G'
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_RC)
	
	
	

declare @rowcount int = 1000
while @rowcount >= 1000
BEGIN
 BEGIN TRY

 UPDATE TOP (1000) L
SET division_code_tx = '99',UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXXX',LOCK_ID = LOCK_ID % 255 + 1;
FROM LOAN l
where  ISNULL(division_code_tx, '') != '99'
and id in (select id from unitrachdstorage..INC0434969)


--88291

 select @rowcount = @@rowcount
 END TRY
 BEGIN CATCH
  select Error_number(),
      error_message(),
      error_severity(),
    error_state(),
    error_line()
   THROW
   BREAK
 END CATCH
END
		
	
	
	
	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0XXXXXX' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_L)




CREATE TABLE #tmpWI
    (
      WI_ID NVARCHAR(4000) ,
      LoanNumber NVARCHAR(4000)
    )
INSERT  INTO #tmpWI
        SELECT  ID ,
                CONTENT_XML.value('(/Content/Loan/Number)[1]', 'varchar (50)')
        FROM    dbo.WORK_ITEM
        WHERE   STATUS_CD IN ( 'Withdrawn', 'Complete' )
                AND WORKFLOW_DEFINITION_ID = '3'
                AND CREATE_DT >= '2016-10-01'
                AND CREATE_DT <= '2016-10-31' 
				


Declare @LenderID as bigint
Select @LenderID=ID from LENDER where CODE_TX = @LenderCode and PURGE_DT is null

Declare @RD_MISC1_ID as bigint
Select @RD_MISC1_ID = ID from RELATED_DATA_DEF where NAME_TX = 'Misc1'
			


--drop table #tmpPD
select id
into #tmpPD 
--select *
from process_definition
where id in (284074)

--drop table #tmpPL
select id 
into #tmpPL
--select *
from process_log
where process_definition_id in (select * from #tmpPD)
and update_dt >= '2019-02-01'


--drop table #tmpWI
select id 
into #tmpWI
--select * 
from work_item
where relate_id in  (select * from #tmpPL) and workflow_definition_id = 9


--drop table #tmpRH
SELECT RELATE_ID INTO #tmpRH FROM dbo.PROCESS_LOG_ITEM
WHERE process_log_id IN  (select * from #tmpPL)
AND RELATE_TYPE_CD = 'Allied.UniTrac.ReportHistory'

--drop table #tmpRH
SELECT L.Name_tx, L.CODE_TX, 
rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) as TITLE,
	rh.REPORT_DATA_XML.value( '(/ReportData/Report/Division/@value)[1]', 'varchar(500)' ) AS Division,
rh.*
 FROM dbo.REPORT_HISTORY rh
join lender L on L.ID = RH.LENDER_ID
join #tmpRH R on R.RELATE_ID = RH.ID
where --rh.REPORT_DATA_XML.value( '(/ReportData/Report/Title/@value)[1]', 'varchar(500)' ) = 'Uninsured Loan Status Report - Uninsured'
rh.report_id = 32
order by update_dt desc 

