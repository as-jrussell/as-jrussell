--All CPI Cancel Pending Complete
USE UniTrac

--Create table to change 1 to Y and 0 to N
CREATE TABLE #tmpRD
    (
      RD_ID NVARCHAR(4000) ,
      RD_IDD NVARCHAR(255)
    )
INSERT  INTO #tmpRD
        ( RD_ID, RD_IDD )
VALUES  ( N'1', -- RD_ID - nvarchar(4000)
          N'Y'  -- RD_IDD - nvarchar(255)
          )
		  
INSERT  INTO #tmpRD
VALUES  ( N'0', -- RD_ID - nvarchar(4000)
          N'N'  -- RD_IDD - nvarchar(255)
          )

--Pull all WI's IDs and loan number for CPI Cancel per dates needed
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
				 


--Pull needed information
SELECT DISTINCT
        wi.id Work_Item_ID ,
        CONVERT(DATE, wi.CREATE_DT) AS [WI Create Date] ,
        wi.CONTENT_XML.value('(/Content/LenderAdmin/Name)[1]', 'varchar (50)') [Lender Admin] ,
        wd.NAME_TX [Workflow] ,
        rc.MEANING_TX AS 'Status' ,
        wi.STATUS_CD AS 'StatusColor' ,
        wq.NAME_TX [Queue] ,
        'QueueAge' = CEILING(CAST(( GETDATE() - wi.CREATE_DT ) AS FLOAT)) ,
        'ActionAge' = CEILING(CAST(( GETDATE() - wia.CREATE_DT ) AS FLOAT)) ,
        wia.ACTION_CD [Last Action] ,
        wia.UPDATE_DT ,
        LL.NAME_TX [Lender] ,
        LL.CODE_TX [Lender Code] ,
        RC1.DESCRIPTION_TX [LoanType] , RD.VALUE_TX,
        T.RD_IDD [Hotwatch] ,
        RDD.VALUE_TX [File Type] ,
        Wi.CURRENT_QUEUE_ID ,
        RDE.VALUE_TX [FileAlert] ,
        wi.CONTENT_XML.value('(/Content/Lender/NextCycleDate)[1]',
                             'varchar (50)') [Next Cycle Date] ,
        wi.CONTENT_XML.value('(/Content/Lender/DaysUntilNextCycle)[1]',
                             'varchar (50)') [Days until Next Cycle]
--INTO JCs..INC0214994_CPI_Complete
FROM    WORK_ITEM AS wi
        INNER JOIN #tmpWI TL ON TL.WI_ID = WI.ID
                                AND WI.STATUS_CD = 'Complete'
        LEFT OUTER JOIN WORK_QUEUE wq ON wi.CURRENT_QUEUE_ID = wq.ID
        LEFT OUTER JOIN WORKFLOW_DEFINITION wd ON wi.WORKFLOW_DEFINITION_ID = wd.ID
        LEFT JOIN WORK_ITEM_ACTION wia ON wi.LAST_WORK_ITEM_ACTION_ID = wia.ID
        LEFT OUTER JOIN USERS u ON wi.CURRENT_OWNER_ID = u.ID
        LEFT OUTER JOIN dbo.USERS uu ON uu.id = wia.ACTION_USER_ID
        LEFT OUTER JOIN REF_CODE rc ON ( rc.DOMAIN_CD = 'CPICancelPendingStatus'
                                         AND rc.CODE_CD = wi.STATUS_CD
                                       )
        LEFT JOIN dbo.LENDER LL ON LL.ID = wi.LENDER_ID
        LEFT JOIN dbo.TRADING_PARTNER TP ON TP.EXTERNAL_ID_TX = LL.CODE_TX
        LEFT JOIN dbo.DELIVERY_INFO DI ON DI.TRADING_PARTNER_ID = TP.ID
        LEFT JOIN dbo.RELATED_DATA RD2 ON RD2.RELATE_ID = DI.ID
                                          AND RD2.DEF_ID = '95'
        LEFT JOIN dbo.LENDER_ORGANIZATION LO ON LO.ID = RD2.VALUE_TX
		        LEFT JOIN dbo.RELATED_DATA RDD ON RDD.RELATE_ID = DI.ID
                                          AND RDD.DEF_ID = '96'
        LEFT JOIN dbo.RELATED_DATA RDE ON RDE.RELATE_ID = DI.ID
                                          AND RDE.DEF_ID = '115'
        LEFT JOIN dbo.LOAN L ON L.NUMBER_TX = TL.LoanNumber
                                AND L.LENDER_ID = WI.LENDER_ID
 		LEFT JOIN dbo.RELATED_DATA RD ON RD.RELATE_ID = di.ID AND RD.DEF_ID = '10' AND rd.RELATE_ID = RD2.RELATE_ID AND rD2.RELATE_ID = lo.id                                
       LEFT JOIN #tmpRD T ON T.RD_ID = RD.VALUE_TX
        LEFT JOIN dbo.REF_CODE RC1 ON RC1.CODE_CD = L.TYPE_CD
                                      AND RC1.DOMAIN_CD = 'LoanType'
WHERE   RDD.VALUE_TX = 'IMPORT'  

ORDER BY CONVERT(DATE, wi.CREATE_DT) DESC
				
				
DROP TABLE #tmpRD	
DROP TABLE #tmpWI 		 

--4949


