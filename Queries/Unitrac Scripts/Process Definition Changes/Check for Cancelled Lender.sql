USE UniTrac 



SELECT  L.CODE_TX AS 'Lender Code' ,
        L.NAME_TX AS 'Lender Name' ,
        L.AGENCY_ID AS 'Agency' ,
        L.TAX_ID_TX AS 'Tax ID' ,
        L.CREATE_DT AS 'Create Date' ,
        L.STATUS_CD AS 'Lender Status' ,
        L.ACTIVE_DT AS 'Active Date' ,
        L.CANCEL_DT AS 'Cancelled Date' ,
		L.UPDATE_DT AS 'Last Update Date',
        L.ID AS 'UniTrac Code' 
INTO    #TMPNEWLENDERINFO
--SELECT L.* 
FROM    LENDER L
WHERE   L.UPDATE_DT > GETDATE() - 30
        AND L.TEST_IN = 'N'
        AND L.STATUS_CD IN ( 'CANCEL', 'SUSPEND', 'MERGED' )
ORDER BY L.CREATE_DT ,
        L.CODE_TX DESC



SELECT 
 SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') [Lender] ,
     *
FROM    PROCESS_DEFINITION P
WHERE   P.ONHOLD_IN = 'N' 
        AND ACTIVE_IN = 'Y' AND P.PROCESS_TYPE_CD = 'GOODTHRUDT'
		AND P.SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/LenderList/LenderID)[1]',
                              'nvarchar(max)') IN (SELECT [Lender Code] FROM #TMPNEWLENDERINFO)
ORDER BY CAST(SETTINGS_XML_IM.value('(/ProcessDefinitionSettings/AnticipatedNextScheduledDate)[1]',
                                    'varchar(50)') AS DATETIME) ASC




--DROP TABLE #TMPNEWLENDERINFO
 SELECT * FROM #TMPNEWLENDERINFO									



 select * from work_item_action

							