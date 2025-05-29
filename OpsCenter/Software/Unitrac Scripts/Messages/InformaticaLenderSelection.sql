use unitrac
  
    DECLARE @tmpTP TABLE (
  
   TP_ID bigint,
     NAME_TX nvarchar(max),
	 EXTERNAL_ID_TX nvarchar(15) )

 
 
 insert INTO @tmpTP (TP_ID, NAME_TX, EXTERNAL_ID_TX) SELECT *   FROM OPENQUERY([UT-STG-LISTENER], 'select tp.id , tp.NAME_TX, tp.EXTERNAL_ID_TX  from unitrac.dbo.TRADING_PARTNER tp where  tp.PURGE_DT is null and tp.STATUS_CD = ''ACTIVE'' and tp.TYPE_CD = ''LFP_TP'' ')

 



SELECT  
DISTINCT
-- dd.*, 
--'STOP HERE',
 tp.NAME_TX AS TP_Name, tp.EXTERNAL_ID_TX, di.ID as DI_ID, di.DOCUMENT_TYPE_CD, di.FILESIZE_VARIANCE_NO, di.FILE_FORMAT_TYPE_CD, di.BRANCH_ID, dig.ID AS DIG_ID, dig.NAME_TX AS DIG_Name,r.ID AS DIECR_ID, le.LenderExtractKey, le.BranchKey, le.ContractTypeKey, le.ExtractTypeCode, le.ExtractErrorList, le.VUT_LE_KEY, le.VUT_SERVER, le.ContractOnly, pd.ID as PD_ID, pd.ORDER_NO, pd.TYPE_CD,  pd.CODE_CD,dd.InputFileName,
dd.ExcludeMsgComp,
dd.LenderFile,
dd.OutputFileName,
dd.Compression,
dd.Encryption,
dd.OverrideFileNm,
dd.ExcludeFileMask,
dd.FileFormat,
dd.FileSizeVar,
dd.CreateTxn,
dd.SiteUsername,
dd.SitePassword,
dd.CompressionPass,
dd.Passphrase,
dd.Comments,
dd.IgnoreUnknown,
dd.IgnFileExtChk,
dd.AltFileMask,
dd.SplProcReqd,
dd.IsDocContReq,
dd.IgnFileSzVld,
dd.Refunds,
dd.Charges,
dd.PmtDecrease,
dd.PmtIncrease

INTO #StageTmp
FROM @tmpTP tp
JOIN [UT-STG-LISTENER].unitrac.dbo.DELIVERY_INFO di ON di.TRADING_PARTNER_ID = tp.TP_ID   and di.PURGE_DT is null AND  di.ACTIVE_IN = 'y' and di.DELIVERY_TYPE_CD != 'INFORMATICA' 
join [UT-STG-LISTENER].unitrac.dbo.DELIVERY_INFO_GROUP dig on dig.DELIVERY_INFO_ID = di.id and dig.PURGE_DT is NULL 
JOIN [UT-STG-LISTENER].unitrac.dbo.DELIVERY_INFO_EXTRACT_CONFIG_RELATE r on r.DELIVERY_INFO_ID = di.id  and r.PURGE_DT is null
join [UT-STG-LISTENER].vut.dbo.tbllenderextract le on le.LenderExtractKey = r.RELATE_ID AND ExtractTypeCode = 1
--join vut.dbo.tbllenderextractconversion lec on lec.lenderextractkey = le.lenderextractkey
join [UT-STG-LISTENER].unitrac.dbo.PREPROCESSING_DETAIL pd on pd.DELIVERY_INFO_GROUP_ID = dig.id 
--join PPDATTRIBUTE pa on pa.PREPROCESSING_DETAIL_ID = pd.id 
JOIN (select * from (
	SELECT dd.DELIVERY_INFO_GROUP_ID, dd.VALUE_TX, dd.DELIVERY_CODE_TX 
	FROM [UT-STG-LISTENER].unitrac.dbo.DELIVERY_DETAIL dd  
	WHERE dd.PURGE_DT is NULL
) t 
PIVOT (
	max(VALUE_tX)
	FOR DELIVERY_CODE_TX IN (InputFileName,
ExcludeMsgComp,
LenderFile,
OutputFileName,
Compression,
Encryption,
OverrideFileNm,
ExcludeFileMask,
FileFormat,
FileSizeVar,
CreateTxn,
SiteUsername,
SitePassword,
CompressionPass,
Passphrase,
Comments,
IgnoreUnknown,
IgnFileExtChk,
AltFileMask,
SplProcReqd,
IsDocContReq,
IgnFileSzVld,
Refunds,
Charges,
PmtDecrease,
PmtIncrease) 
) p ) dd ON dd.DELIVERY_INFO_GROUP_ID = dig.ID
--WHERE tp.EXTERNAL_ID_TX in ('1987','1581')




SELECT  
DISTINCT
-- dd.*, 
--'STOP HERE',
 tp.NAME_TX as TP_Name, tp.EXTERNAL_ID_TX, di.ID as DI_ID, di.DOCUMENT_TYPE_CD, di.FILESIZE_VARIANCE_NO, di.FILE_FORMAT_TYPE_CD, di.BRANCH_ID, dig.ID AS DIG_ID, dig.NAME_TX as DIG_Name,r.ID AS DIECR_ID, le.LenderExtractKey, le.BranchKey, le.ContractTypeKey, le.ExtractTypeCode, le.ExtractErrorList, le.VUT_LE_KEY, le.VUT_SERVER, le.ContractOnly, pd.ID as PD_ID, pd.ORDER_NO, pd.TYPE_CD,  pd.CODE_CD,dd.InputFileName,
dd.ExcludeMsgComp,
dd.LenderFile,
dd.OutputFileName,
dd.Compression,
dd.Encryption,
dd.OverrideFileNm,
dd.ExcludeFileMask,
dd.FileFormat,
dd.FileSizeVar,
dd.CreateTxn,
dd.SiteUsername,
dd.SitePassword,
dd.CompressionPass,
dd.Passphrase,
dd.Comments,
dd.IgnoreUnknown,
dd.IgnFileExtChk,
dd.AltFileMask,
dd.SplProcReqd,
dd.IsDocContReq,
dd.IgnFileSzVld,
dd.Refunds,
dd.Charges,
dd.PmtDecrease,
dd.PmtIncrease
INTO #ProdTmp
FROM TRADING_PARTNER tp
JOIN DELIVERY_INFO di ON di.TRADING_PARTNER_ID = tp.ID and tp.PURGE_DT is null and di.PURGE_DT is null and tp.STATUS_CD = 'ACTIVE' and tp.TYPE_CD = 'LFP_TP' AND  di.ACTIVE_IN = 'y' and di.DELIVERY_TYPE_CD != 'INFORMATICA' 
join DELIVERY_INFO_GROUP dig on dig.DELIVERY_INFO_ID = di.id and dig.PURGE_DT is NULL 
JOIN DELIVERY_INFO_EXTRACT_CONFIG_RELATE r on r.DELIVERY_INFO_ID = di.id  and r.PURGE_DT is null
join vut.dbo.tbllenderextract le on le.LenderExtractKey = r.RELATE_ID AND ExtractTypeCode = 1
--join vut.dbo.tbllenderextractconversion lec on lec.lenderextractkey = le.lenderextractkey
join PREPROCESSING_DETAIL pd on pd.DELIVERY_INFO_GROUP_ID = dig.id 
--join PPDATTRIBUTE pa on pa.PREPROCESSING_DETAIL_ID = pd.id 
JOIN (select * from (
	SELECT dd.DELIVERY_INFO_GROUP_ID, dd.VALUE_TX, dd.DELIVERY_CODE_TX 
	FROM DELIVERY_DETAIL dd  
	WHERE dd.PURGE_DT is NULL
) t 
PIVOT (
	max(VALUE_tX)
	FOR DELIVERY_CODE_TX IN (InputFileName,
ExcludeMsgComp,
LenderFile,
OutputFileName,
Compression,
Encryption,
OverrideFileNm,
ExcludeFileMask,
FileFormat,
FileSizeVar,
CreateTxn,
SiteUsername,
SitePassword,
CompressionPass,
Passphrase,
Comments,
IgnoreUnknown,
IgnFileExtChk,
AltFileMask,
SplProcReqd,
IsDocContReq,
IgnFileSzVld,
Refunds,
Charges,
PmtDecrease,
PmtIncrease) 
) p ) dd ON dd.DELIVERY_INFO_GROUP_ID = dig.ID
--WHERE tp.EXTERNAL_ID_TX in ('1987','1581')



SELECT DISTINCT * INTO #tmpUnion

FROM #StageTmp S
UNION all
SELECT * FROM  #ProdTmp P


SELECT DISTINCT CASE when COUNT(*) = 2 THEN 'SAME' ELSE 'DIFFERENT' END AS LenderFileSetup , MAX(u.EXTERNAL_ID_TX) AS LenderCode
INTO #tmpDiff
FROM #tmpUnion u
GROUP BY  u.TP_Name, u.EXTERNAL_ID_TX, u.DI_ID, u.DOCUMENT_TYPE_CD, u.FILESIZE_VARIANCE_NO, u.FILE_FORMAT_TYPE_CD, u.BRANCH_ID, u.DIG_ID, u.DIG_Name,u.DIECR_ID, u.LenderExtractKey, u.BranchKey, u.ContractTypeKey, u.ExtractTypeCode, u.ExtractErrorList, u.VUT_LE_KEY, u.VUT_SERVER, u.ContractOnly, u.PD_ID, u.ORDER_NO, u.TYPE_CD,  u.CODE_CD,u.InputFileName,
u.ExcludeMsgComp,
u.LenderFile,
u.OutputFileName,
u.Compression,
u.Encryption,
u.OverrideFileNm,
u.ExcludeFileMask,
u.FileFormat,
u.FileSizeVar,
u.CreateTxn,
u.SiteUsername,
u.SitePassword,
u.CompressionPass,
u.Passphrase,
u.Comments,
u.IgnoreUnknown,
u.IgnFileExtChk,
u.AltFileMask,
u.SplProcReqd,
u.IsDocContReq,
u.IgnFileSzVld,
u.Refunds,
u.Charges,
u.PmtDecrease,
u.PmtIncrease



SELECT DISTINCT
tp.name_tx AS LenderName,
tp.EXTERNAL_ID_TX,
lo.NAME_TX,
	   ec.ExtractCategory,
    
   LenderExtractFieldMasterListKey,ExtractFieldName,	DBFieldName,	DBTable,	FriendlyName,	Description,	CategoryFieldBit,	lefml.ExtractTypeCode,	lefml.SortOrder,	UpdateField,	LenderExtractCategoryMapKey,	lecat.LenderExtractCategoryKey,	Code,	Value
   INTO #TmpStage
from
       vut.dbo.tblLenderExtractCategory lecat
       join vut.dbo.lkuExtractCategory ec on ec.ExtractCategoryCode = lecat.ExtractCategoryCode
       left outer join vut.dbo.tblLenderExtractCategoryFieldOrder lecfo on lecfo.LenderExtractCategoryKey = lecat.LenderExtractCategoryKey
       LEFT join vut.dbo.tblLenderExtractFieldMasterList lefml on lefml.LenderExtractFieldMasterListKey = lecfo.LenderExtractFieldMasterKey
       left outer join vut.dbo.tbllenderextractcategorymap lecatm on lecatm.lenderextractcategorykey = lecat.LenderExtractCategoryKey
       JOIN unitrac.dbo.DELIVERY_INFO_EXTRACT_CONFIG_RELATE r on  r.RELATE_ID = lecat.LenderExtractKey
	   JOIN Unitrac.dbo.DELIVERY_INFO di ON   r.DELIVERY_INFO_ID = di.id  and r.PURGE_DT is NULL AND  di.PURGE_DT is NULL
	   JOIN DELIVERY_INFO_GROUP dig ON dig.DELIVERY_INFO_ID = di.ID

	   JOIN TRADING_PARTNER tp on di.TRADING_PARTNER_ID = tp.ID  
	   join vut.dbo.tbllenderextract le on le.LenderExtractKey = r.RELATE_ID
	   LEFT JOIN LENDER_ORGANIZATION lo ON lo.ID = le.ContractTypeKey 
  


SELECT DISTINCT
tp.name_tx AS LenderName,
tp.EXTERNAL_ID_TX,
lo.NAME_TX,
	   ec.ExtractCategory,
    
   LenderExtractFieldMasterListKey,ExtractFieldName,	DBFieldName,	DBTable,	FriendlyName,	Description,	CategoryFieldBit,	lefml.ExtractTypeCode,	lefml.SortOrder,	UpdateField,	LenderExtractCategoryMapKey,	lecat.LenderExtractCategoryKey,	Code,	Value

	   INTO #TmpProd
from
       [UT-STG-LISTENER].vut.dbo.tblLenderExtractCategory lecat
       join [UT-STG-LISTENER].vut.dbo.lkuExtractCategory ec on ec.ExtractCategoryCode = lecat.ExtractCategoryCode
       left outer join [UT-STG-LISTENER].vut.dbo.tblLenderExtractCategoryFieldOrder lecfo on lecfo.LenderExtractCategoryKey = lecat.LenderExtractCategoryKey
       LEFT join [UT-STG-LISTENER].vut.dbo.tblLenderExtractFieldMasterList lefml on lefml.LenderExtractFieldMasterListKey = lecfo.LenderExtractFieldMasterKey
       left outer join [UT-STG-LISTENER].vut.dbo.tbllenderextractcategorymap lecatm on lecatm.lenderextractcategorykey = lecat.LenderExtractCategoryKey
       JOIN [UT-STG-LISTENER].unitrac.dbo.DELIVERY_INFO_EXTRACT_CONFIG_RELATE r on  r.RELATE_ID = lecat.LenderExtractKey
	   JOIN [UT-STG-LISTENER].Unitrac.dbo.DELIVERY_INFO di ON   r.DELIVERY_INFO_ID = di.id  and r.PURGE_DT is NULL AND  di.PURGE_DT is NULL
	   JOIN [UT-STG-LISTENER].unitrac.dbo.DELIVERY_INFO_GROUP dig ON dig.DELIVERY_INFO_ID = di.ID

	   JOIN @tmpTP tp on di.TRADING_PARTNER_ID = tp.tp_ID  

	   join [UT-STG-LISTENER].vut.dbo.tbllenderextract le on le.LenderExtractKey = r.RELATE_ID
	   LEFT JOIN [UT-STG-LISTENER].unitrac.dbo.LENDER_ORGANIZATION lo ON lo.ID = le.ContractTypeKey  
	   	   


SELECT DISTINCT * INTO #tmpLFICUnion

FROM #TmpStage S
UNION all
SELECT * FROM  #TmpProd P


SELECT DISTINCT CASE when COUNT(*) = 2 THEN 'SAME' ELSE 'DIFFERENT' END AS LenderFileSetup , MAX(u.EXTERNAL_ID_TX) AS LenderCode
INTO #tmpGroup
FROM #tmpLFICUnion u
GROUP BY 
LenderName,
EXTERNAL_ID_TX,
NAME_TX,
	   ExtractCategory,
    
   LenderExtractFieldMasterListKey,ExtractFieldName,	DBFieldName,	DBTable,	FriendlyName,	Description,	CategoryFieldBit,	ExtractTypeCode,	SortOrder,	UpdateField,	LenderExtractCategoryMapKey,	LenderExtractCategoryKey,	Code,	Value


UPDATE t1
SET LENDERFILESETUP = 'DIFFERENT'
FROM #tmpGroup t1
join #tmpGroup t2 ON t2.LenderCode = t1.LenderCode
WHERE t1.LenderFileSetup = 'DIFFERENT' OR t2.LenderFileSetup = 'DIFFERENT'

--SELECT DISTINCT * FROM #tmpGroup


select 
DISTINCT
tp.EXTERNAL_ID_TX AS lendercode
,pd.VALUE_TX as dj
,le.LenderExtractKey as config
INTO #tmpdj

from TRADING_PARTNER tp
join DELIVERY_INFO di on di.TRADING_PARTNER_ID = tp.id and tp.PURGE_DT is null and di.PURGE_DT is null and tp.STATUS_CD = 'ACTIVE' and di.ACTIVE_IN = 'Y' and tp.TYPE_CD = 'LFP_TP'
join [UT-STG-LISTENER].Unitrac.dbo.DELIVERY_INFO diStage on diStage.TRADING_PARTNER_ID = tp.id and tp.PURGE_DT is null and diStage.PURGE_DT is null and tp.STATUS_CD = 'ACTIVE' and diStage.ACTIVE_IN = 'Y' and tp.TYPE_CD = 'LFP_TP' 
join DELIVERY_INFO_GROUP dig on dig.DELIVERY_INFO_ID = di.id and dig.PURGE_DT is NULL 
join DELIVERY_INFO_EXTRACT_CONFIG_RELATE r on r.DELIVERY_INFO_ID = di.id  and r.PURGE_DT is null
join vut.dbo.tbllenderextract le on le.LenderExtractKey = r.RELATE_ID
join vut.dbo.tbllenderextractconversion lec on lec.lenderextractkey = le.lenderextractkey
left join PREPROCESSING_DETAIL pd on pd.DELIVERY_INFO_GROUP_ID = dig.id 
left join PPDATTRIBUTE pa on pa.PREPROCESSING_DETAIL_ID = pd.id 
left join LENDER_ORGANIZATION lo on le.ContractTypeKey = lo.ID 
join lender ldr on ldr.CODE_TX = tp.EXTERNAL_ID_TX and ldr.PURGE_DT is null
join AGENCY a on a.id = ldr.AGENCY_ID and a.PURGE_DT is NULL

where  
 pd.VALUE_TX LIKE '%.djs'
  and  lo.PURGE_DT is null  
 and pd.PURGE_DT is null 
 AND tp.PURGE_DT is NULL
 AND di.PURGE_DT is NULL
 AND diStage.PURGE_DT is NULL
 AND dig.PURGE_DT IS NULL
 AND r.PURGE_DT is NULL
 AND pa.PURGE_DT is NULL
 AND lo.PURGE_DT is NULL
 AND ldr.PURGE_DT is NULL
 AND di.DELIVERY_TYPE_CD = 'DW'
 AND diStage.DELIVERY_TYPE_CD = 'DW'




select 
a.SHORT_NAME_TX as Agency,
tp.NAME_TX
,tp.EXTERNAL_ID_TX
,le.LenderExtractKey
,MAX(d.LenderFileSetup) AS LenderFileSetupCompare_Prod_vs_Stage
,MAX(tg.LenderFileSetup) AS LenderFileImportConfigCompare_Prod_vs_Stage

, count(DISTINCT le.BranchKey) as CountBranches
, count(DISTINCT le.ContractTypeKey) as CountDivisions
, count(DISTINCT pd.id) as CountPPDs
,count(distinct dig.id) as CountInputFiles
, COUNT(DISTINCT dj.dj) AS CountPreDJs
, COUNT(DISTINCT lec.ConversionProgram) AS CountFinalDJs
, sum(distinct le.TotalDBContracts) as TotalLoans
, min(case when le.ContractTypeKey = 0 then 'All' else lo.name_tx END )  as MinDivisionType
,  max(case when le.ContractTypeKey = 0 then 'All' else lo.name_tx END ) as MaxDivisionType

from TRADING_PARTNER tp
join DELIVERY_INFO di on di.TRADING_PARTNER_ID = tp.id and tp.PURGE_DT is null and di.PURGE_DT is null and tp.STATUS_CD = 'ACTIVE' and di.ACTIVE_IN = 'Y' and tp.TYPE_CD = 'LFP_TP'
join [UT-STG-LISTENER].Unitrac.dbo.DELIVERY_INFO diStage on diStage.TRADING_PARTNER_ID = tp.id and tp.PURGE_DT is null and diStage.PURGE_DT is null and tp.STATUS_CD = 'ACTIVE' and diStage.ACTIVE_IN = 'Y' and tp.TYPE_CD = 'LFP_TP' 
join DELIVERY_INFO_GROUP dig on dig.DELIVERY_INFO_ID = di.id and dig.PURGE_DT is NULL 
join DELIVERY_INFO_EXTRACT_CONFIG_RELATE r on r.DELIVERY_INFO_ID = di.id  and r.PURGE_DT is null
join vut.dbo.tbllenderextract le on le.LenderExtractKey = r.RELATE_ID
join vut.dbo.tbllenderextractconversion lec on lec.lenderextractkey = le.lenderextractkey
left join PREPROCESSING_DETAIL pd on pd.DELIVERY_INFO_GROUP_ID = dig.id 
left join PPDATTRIBUTE pa on pa.PREPROCESSING_DETAIL_ID = pd.id 
left join LENDER_ORGANIZATION lo on le.ContractTypeKey = lo.ID 
join lender ldr on ldr.CODE_TX = tp.EXTERNAL_ID_TX and ldr.PURGE_DT is null
join AGENCY a on a.id = ldr.AGENCY_ID and a.PURGE_DT is NULL
JOIN #tmpDiff d ON d.LenderCode = tp.EXTERNAL_ID_TX
join #tmpGroup tg on tg.LenderCode = tp.EXTERNAL_ID_TX
LEFT JOIN #tmpdj dj ON dj.lendercode = tp.EXTERNAL_ID_TX AND le.LenderExtractKey =  dj.config
where  
 diStage.DELIVERY_TYPE_CD != 'INFORMATICA' 
 and di.DELIVERY_TYPE_CD != 'INFORMATICA'  
and  lo.PURGE_DT is null and ldr.STATUS_CD = 'ACTIVE' and pd.PURGE_DT is null and isnull(pa.VALUE_TX,'')  NOT IN  ('SANT','HUNT','RELI', 'CAC','SCUSA','FICS','DANDH','MB','HSHYBRID','fargo','cac')   
AND ExtractTypeCode = 1 AND
 diStage.DELIVERY_TYPE_CD = 'DW'
 and  lo.PURGE_DT is null  
 and pd.PURGE_DT is null 
 AND tp.PURGE_DT is NULL
 AND di.PURGE_DT is NULL
 AND diStage.PURGE_DT is NULL
 AND dig.PURGE_DT IS NULL
 AND r.PURGE_DT is NULL
 AND pa.PURGE_DT is NULL
 AND lo.PURGE_DT is NULL
 AND ldr.PURGE_DT is NULL
 AND lec.ConversionProgram IS NOT NULL
 AND lec.ConversionProgram != ''
 group by a.SHORT_NAME_TX,tp.NAME_TX, tp.EXTERNAL_ID_TX, le.LenderExtractKey
order by   a.SHORT_NAME_TX --, CountImportconfigs, CountBranches, CountDivisions, CountPPDs, CountInputFiles, TotalLoans


--DROP table #tmpDiff
--DROP TABLE #tmpUnion
--DROP TABLE #StageTmp
--DROP TABLE #ProdTmp

--DROP TABLE #TmpProd
--DROP TABLE #TmpStage
--DROP TABLE #tmpLFICUnion
--DROP TABLE #tmpGroup

--DROP TABLE #tmpdj





----'FICS','DANDH',





