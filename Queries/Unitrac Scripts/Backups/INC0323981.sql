USE UniTrac	

SELECT RH.* FROM dbo.REPORT_HISTORY RH
JOIN dbo.LENDER L ON L.id = rH.LENDER_ID 
WHERE L.CODE_TX = '1977' AND RH.REPORT_ID = '32'
AND rh.UPDATE_DT >= '2017-01-04 '
AND RH.UPDATE_DT <= '2017-03-30 '
AND RH.DOCUMENT_CONTAINER_ID IN (80882750, 80291060,79792544, 79329768, 78875595,
78360812, 77881084, 77434851, 76930480, 76454581, 75992628, 75519998, 74958028)
ORDER BY rh.UPDATE_DT DESC 



USE Unitrac

SELECT RH.* FROM dbo.REPORT_HISTORY RH
JOIN dbo.LENDER L ON L.id = rH.LENDER_ID 
WHERE L.CODE_TX = '1977' AND RH.REPORT_ID = '32'
AND RH.UPDATE_DT >= '2017-03-30 '
AND rh.UPDATE_DT <= '2017-01-04 '

SELECT * FROM dbo.DOCUMENT_CONTAINER
WHERE ID IN (80882750, 80291060,79792544, 79329768, 78875595,
78360812, 77881084, 77434851, 76930480, 76454581, 75992628, 75519998, 74958028)




SELECT     
concat(SERVER_SHARE_TX,'\',RELATIVE_PATH_TX,'\')  as  [Document]
FROM dbo.DOCUMENT_CONTAINER DC 
JOIN dbo.DOCUMENT_MANAGEMENT DM ON DM.ID = DC.DOCUMENT_MANAGEMENT_ID
WHERE DC.ID IN (80882750, 80291060,79792544, 79329768, 78875595,
78360812, 77881084, 77434851, 76930480, 76454581, 75992628, 75519998, 74958028)





--\\unitrac\UTREPORT\ALLIED\RPT\2017\01\04\74958028
--\\unitrac\UTREPORT\ALLIED\RPT\2017\01\11\75519998
--\\unitrac\UTREPORT\ALLIED\RPT\2017\01\18\75992628
--\\unitrac\UTREPORT\ALLIED\RPT\2017\01\25\76454581
--\\unitrac\UTREPORT\ALLIED\RPT\2017\02\01\76930480
--\\unitrac\UTREPORT\ALLIED\RPT\2017\02\08\77434851
--\\unitrac\UTREPORT\ALLIED\RPT\2017\02\15\77881084
--\\unitrac\UTREPORT\ALLIED\RPT\2017\02\22\78360812
--\\unitrac\UTREPORT\ALLIED\RPT\2017\03\01\78875595
--\\unitrac\UTREPORT\ALLIED\RPT\2017\03\08\79329768
--\\unitrac\UTREPORT\ALLIED\RPT\2017\03\15\79792544
--\\unitrac\UTREPORT\ALLIED\RPT\2017\03\22\80291060
--\\unitrac\UTREPORT\ALLIED\RPT\2017\03\30\80882750


UPDATE  [UniTrac].[dbo].[REPORT_HISTORY]
SET     STATUS_CD = 'PEND' ,
        RETRY_COUNT_NO = 0 ,
        MSG_LOG_TX = NULL ,
        RECORD_COUNT_NO = 0 ,
        ELAPSED_RUNTIME_NO = 0,
		UPDATE_DT = GETDATE(), DOCUMENT_CONTAINER_ID = NULL
--SELECT * FROM dbo.REPORT_HISTORY
WHERE   ID IN 
(11189387,11245251,11298467,11350643,11406081,11463012,11519741,11574693,11634462,11694492,11754798,11812385,11882778)