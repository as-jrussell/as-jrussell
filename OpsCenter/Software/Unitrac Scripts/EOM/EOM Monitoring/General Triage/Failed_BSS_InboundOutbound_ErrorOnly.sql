SET NOCOUNT ON
BEGIN 

DECLARE @ErrorMessage AS VARCHAR(100)
DECLARE @ErrorCount AS INT
DECLARE @CheckDuration as int--Minutes
SET @CheckDuration = -10

DECLARE @TPType VARCHAR(10)
SET @TPType = 'BSS_TP'

CREATE TABLE #TMPMsg ( MsgId BIGINT NOT NULL)        

INSERT  INTO #TMPMsg
            SELECT  MI.ID
            FROM    MESSAGE MI ( NOLOCK )
                    JOIN DELIVERY_INFO DI ( NOLOCK ) ON DI.ID = MI.DELIVERY_INFO_ID
                    JOIN TRADING_PARTNER TP ( NOLOCK ) ON TP.ID = DI.TRADING_PARTNER_ID
            WHERE   TP.TYPE_CD = @TPType
                    AND ( MI.SENT_STATUS_CD = 'ERR'
                          OR MI.RECEIVED_STATUS_CD = 'ERR'
                        )
                    AND MI.CREATE_DT <= ( SELECT    DATEADD(MINUTE,
                                                            @CheckDuration,
                                                            GETDATE())
                                        )                

       

      SELECT @ErrorCount = count(DISTINCT MsgId) FROM #TMPMsg t  
      SELECT @ErrorMessage = 'The current error count is ' + CONVERT(VARCHAR(20), count(DISTINCT MsgId)) FROM #TMPMsg t   

	SELECT * FROM #TMPMsg ORDER BY MsgId

       DROP TABLE #TMPMsg

END 

 SELECT *
 FROM   dbo.TRADING_PARTNER_LOG
 WHERE  MESSAGE_ID IN ( 4120842 )
        AND ( LOG_TYPE_CD = 'ERROR'
              OR LOG_SEVERITY_CD = 'ERROR'
            )
  
SELECT  *
FROM    dbo.MESSAGE
WHERE   ID IN ( 4120842, 4120844, 4120846, 4120850, 4120858, 4120860, 4120864,
                4120866, 4120868, 4120870, 4120891, 4120893, 4120895, 4120900,
                4120902, 4120904, 4120907, 4120911, 4120913, 4120916, 4120934,
                4120936, 4120938, 4120941, 4120946, 4120949, 4120951, 4120953,
                4120956, 4120958, 4120978, 4120980, 4120982, 4120984, 4120986,
                4120988, 4120992, 4120996, 4120998, 4121002, 4121022, 4121024,
                4121026, 4121028, 4121030, 4121032, 4121034, 4121036, 4121038,
                4121040, 4121072, 4121078, 4121082, 4121089, 4121091, 4121098,
                4121102, 4121104, 4121106, 4121108 );

----- CHECK FOR RECORD
SELECT * FROM dbo.MESSAGE (NOLOCK) WHERE RELATE_ID_TX IN (3475380)

SELECT  *
FROM    dbo.[TRANSACTION] T ( NOLOCK )
        JOIN dbo.DOCUMENT D ( NOLOCK ) ON D.ID = T.DOCUMENT_ID
        JOIN dbo.MESSAGE M ( NOLOCK ) ON M.ID = D.MESSAGE_ID
WHERE   M.ID IN (995856)

--- RESET FOR PICK UP BY MESSAGE SERVER
UPDATE dbo.MESSAGE
SET RECEIVED_STATUS_CD = 'RCVD', PROCESSED_IN = 'N'
WHERE ID IN (1990111)

-----
SELECT * FROM dbo.DOCUMENT WHERE MESSAGE_ID IN (2143435)


--- RESET FOR PICK UP BY MESSAGE SERVER
UPDATE dbo.MESSAGE
SET RECEIVED_STATUS_CD = 'RCVD', PROCESSED_IN = 'N'
WHERE ID IN (1144820,1144824,1144830,1144831)

UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
(1273945,1273946,1274378,1274379)

-------- 4/22/2013 & 4/29/2013
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'LEN' WHERE ID IN 
--(1097811,1099712,1099711,1119018)

-------- 5/5/2013 These have been reset -----
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'LEN' WHERE ID IN 
--(1144507,1144667,1145257,1145292,1144666)

-------- 5/5/2013 These have been re-held -----
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'LEN' WHERE ID IN 
--(1144507,1124853)

-------- 5/20/2013 These have been re-held -----
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1184116)

-------- 7/4/2013 These have been re-held -----
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1323741,1323742)

-------- 7/4/2013 These have been re-held -----
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1379663,1379664)

-------- 10/23/2013 Need to go back and fix
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1714900,1714905,1714915)

--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1730256,1730257)

-------- 1/14/2014
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1936708)

-------- 1/29/2014
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1990111,1990112)

-------- 2/1/2014
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', sent_status_cd = 'sent', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(1327120)

-------- 3/17/2014
--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', sent_status_cd = 'sent', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(2143395,2143396)

--UPDATE dbo.[MESSAGE] SET PROCESSED_IN = 'Y', sent_status_cd = 'sent', RECEIVED_STATUS_CD = 'PRSD' WHERE ID IN 
--(2143435)

-------- 4/10/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2216229, 2216230 )

-------- 4/22/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2246473, 2246474 )

-------- 5/23/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2349382,2349383 )

-------- 5/27/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2355789, 2356604)

-------- 6/17/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2434515,
--2434516,2434527,
--2434528)

-------- 7/2/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2475795,2488379,
--2488380)

-------- 7/15/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2525505,2525506)


---------- 7/15/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2544588,2544589)

-------- 7/18/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2563113,2563114)

-------- 8/4/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2054033,2583850,2583851,2604540,2604541)

-------- 8/11/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2681711, 2681713)

-------- 8/28/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2774116, 2774117 )

-------- 9/5/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2796967,2823126, 2823127)

-------- 9/7/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2827904,2827905 )

---------- 9/17/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2882179, 2882194, 2882200, 2882203, 2882206, 2882208, 2882210,
--                2882216, 2882224, 2882232, 2882236, 2882247, 2882251, 2882253,
--                2882259, 2882263, 2882267, 2882269, 2882271, 2882273, 2882279,
--                2882291, 2882293, 2882297, 2882299, 2882305 )

---------- 10/14/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 101295, 2985621, 2985622 )

---------- 10/21/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3047336 )

---------- 10/27/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 2056789 )

---------- 11/3/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3127397,3130196,3130197 )

---------- 11/19/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3213953, 3213955 )

---------- 12/11/2014
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3281689, 3281690,3291283 )


------------ 1/5/2015
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3387062,3387063)

------------ 1/21/2015 Outbound Message Errors Under LDHSrvc (manually created, OB from 1/17/15 colo move)
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        SENT_STATUS_CD = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3459368, 3459369, 3475380, 3475382, 3475384, 3475386, 3475388,
--                3475390, 3475401, 3475403, 3475405, 3475407, 3475413, 3475415,
--                3475425, 3475427, 3475429, 3475431, 3475439, 3475441, 3475443,
--                3475447, 3475457, 3475459, 3475461, 3475463, 3475467, 3475473,
--                3475475, 3475481, 3475483, 3475489, 3475491, 3475501, 3475503,
--                3475505, 3475507, 3475519, 3475521, 3475525, 3475527, 3475533,
--                3475535, 3475537, 3475539, 3475549, 3475551, 3475553, 3475555,
--                3475561, 3475563, 3475567, 3475577, 3475579, 3475581, 3475589,
--                3475591, 3475593, 3475595, 3475605, 3475607, 3475609, 3475611,
--                3475616, 3475622, 3475624, 3475632, 3475634, 3475638, 3475640 )

------------ 4/7/2015
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3820538,3820579 )

-------------- 4/29/2015
--UPDATE  dbo.[MESSAGE]
--SET     PROCESSED_IN = 'Y' ,
--        sent_status_cd = 'sent' ,
--        RECEIVED_STATUS_CD = 'PRSD'
--WHERE   ID IN ( 3957899,3957900 )


------------ 6/1/2015
UPDATE  dbo.[MESSAGE]
SET     PROCESSED_IN = 'Y' ,
        SENT_STATUS_CD = 'sent' ,
        RECEIVED_STATUS_CD = 'PRSD'
WHERE   ID IN ( 4115129, 4115130 )