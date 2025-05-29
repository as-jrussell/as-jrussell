

SELECT S.*
INTO #tmp
 FROM JCs..SkipQuery S
JOIN dbo.WORK_ITEM WI ON S.[Work Item ID] = WI.ID 
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '4422'


SELECT * FROM dbo.WORK_ITEM
WHERE ID  = '34527955'


SELECT * 
INTO #tmp2
FROM #tmp
WHERE [Loan Number] <> ''

SELECT  T.[Loan Number] ,
        RC2.DESCRIPTION_TX [Loan Record Type] ,
        RC3.DESCRIPTION_TX [Loan Status] ,
        RC4.DESCRIPTION_TX [Loan Type] ,
        T.[Address from UI] ,
        T.[Work Item ID] ,
        T.[Address from WI] ,
        WI.WORKFLOW_DEFINITION_ID ,
        WD.NAME_TX
FROM    #tmp2 T
  LEFT      JOIN dbo.WORK_ITEM WI ON T.[Work Item ID] = WI.ID
   LEFT     JOIN dbo.LOAN L ON L.NUMBER_TX = T.[Loan Number]
        JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
        INNER JOIN dbo.REF_CODE RC2 ON RC2.CODE_CD = L.RECORD_TYPE_CD
                                       AND RC2.DOMAIN_CD = 'RecordType'
        INNER JOIN dbo.REF_CODE RC3 ON RC3.CODE_CD = L.STATUS_CD
                                       AND RC3.DOMAIN_CD = 'LoanStatus'
        INNER JOIN dbo.REF_CODE RC4 ON RC4.CODE_CD = L.TYPE_CD
                                       AND RC4.DOMAIN_CD = 'LoanType'
									   WHERE T.[Loan Number] = '2888190-144'