USE UniTrac

SELECT * FROM dbo.TRADING_PARTNER
		WHERE EXTERNAL_ID_TX = '5310'

SELECT  *
FROM    dbo.TRADING_PARTNER_LOG
WHERE   CAST(CREATE_DT AS DATE) >= CAST(GETDATE()-5 AS DATE)
        AND TRADING_PARTNER_ID = '3068'

		SELECT * FROM dbo.MESSAGE
		WHERE ID IN (XXXXXX)

	

	--Exception Transforming the Documents
Exception : More than one export was found that matches the constraint: 
	ContractName	CAC
	RequiredTypeIdentity	LDHLib.IPPDHelper
Exception Stack Trace :    at System.ComponentModel.Composition.Hosting.ExportProvider.GetExports(ImportDefinition definition, AtomicComposition atomicComposition)
   at System.ComponentModel.Composition.Hosting.ExportProvider.GetExportedValueCore[T](String contractName, ImportCardinality cardinality)
   at LDHLib.PPDMgr.GetPPDHelperByTypeCode(String sHelperTypeCd) in E:\TeamCity\buildAgent3\work\b489a9a698e1534f\3 Upper Business Level\LDH\LDHLib\PPD\PPDMgr.cs:line 136
   at Allied.UniTrac.LenderExtract.TrackingChunkedPPD.Apply(BusinessObjectCollection boColl) in E:\TeamCity\buildAgent3\work\b489a9a698e1534f\3 Upper Business Level\UniTracLib\LenderExtract\TrackingChunkedPPD.cs:line 47
   at LDHLib.Message.FinalizeTransformation() in E:\TeamCity\buildAgent3\work\b489a9a698e1534f\3 Upper Business Level\LDH\LDHLib\Message\Message.cs:line 1259
   at LDHLib.Message.Transform() in E:\TeamCity\buildAgent3\work\b489a9a698e1534f\3 Upper Business Level\LDH\LDHLib\Message\Message.cs:line 1215



		SELECT * FROM dbo.WORK_ITEM
		WHERE WORKFLOW_DEFINITION_ID = '1' AND RELATE_ID IN (17431595,
17431542)


		SELECT TOP 10 PD.NAME_TX, PD.STATUS_CD,  PL.* FROM dbo.PROCESS_LOG PL
INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PD.ID IN (11847,11848)
ORDER BY PL. UPDATE_DT DESC 


		SELECT TOP 50 PD.NAME_TX, PD.STATUS_CD, PL.* FROM dbo.PROCESS_LOG PL
INNER JOIN dbo.PROCESS_DEFINITION PD ON PD.ID = PL.PROCESS_DEFINITION_ID
WHERE PD.ID IN (XXXXXXX)
ORDER BY PL. UPDATE_DT DESC 


SELECT  *
FROM    dbo.TRADING_PARTNER_LOG
WHERE   PROCESS_CD = 'DW'
        AND CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)
        AND TRADING_PARTNER_ID = 'XXX'

SELECT *
	FROM    dbo.TRADING_PARTNER_LOG
		WHERE   --PROCESS_CD = 'DW'
         CAST(CREATE_DT AS DATE) = CAST(GETDATE() AS DATE)
		ORDER BY CREATE_DT DESC 





select * from ref_code_attribute