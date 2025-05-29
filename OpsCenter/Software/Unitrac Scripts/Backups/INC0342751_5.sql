---- DROP TABLE #TMPINC0342751
SELECT *
FROM   dbo.LENDER
WHERE  CODE_TX IN ( '7543', '7621' );
---- 193

---- DROP TABLE #TMPLOAN
SELECT *
INTO   #TMPLOAN
FROM   LOAN
WHERE  LOAN.LENDER_ID = 2065
       AND NUMBER_TX IN ( '1249550000', '1354560000', '4188560000' ,
                          '5802560000' ,'5802580000', '5813580000' ,
                          '5813590000' ,'5883550000', '7237550000' ,
                          '7804550000' ,'8316560000', '1230257000' ,
                          '1359257000' ,'1389056000', '1428855000' ,
                          '1479855000' ,'1559655000', '2679655000' ,
                          '3610255000' ,'4850255000', '5429055000' ,
                          '6554456000' ,'7769855000', '8320856000' ,
                          '8643055000' ,'9266457000', '9277856000' ,
                          '9435055000' ,'9859655000', '9959655000' ,
                          '1000070100' ,'1000084200', '1000100500' ,
                          '1000100600' ,'1000103000', '1000120400' ,
                          '1000133700' ,'1000163400', '1000197200' ,
                          '1000201200' ,'1000245900', '1000271500' ,
                          '1000343200' ,'1000348100', '1000453900' ,
                          '1000494300' ,'1000529600', '1000531200' ,
                          '1000622900' ,'1000630200', '1000635100' ,
                          '1000649200' ,'1000663300', '1000686400' ,
                          '1000726800' ,'1000735900', '1000749000' ,
                          '1000773000' ,'1000782100', '1000826600' ,
                          '1000838100' ,'1000861300', '1000884500' ,
                          '1000896900' ,'1000906600', '1000920700' ,
                          '1000922300' ,'1000932200', '1000939700' ,
                          '1000966000' ,'1000984300', '1000993400' ,
                          '1001018900' ,'1001027000', '1001029600' ,
                          '1001044500' ,'1001073400', '1001101300' ,
                          '1001114600' ,'1001123700', '1001126000' ,
                          '1001136900' ,'1001193000', '1050559700' ,
                          '1126321400' ,'1130055400', '1139171300' ,
                          '1141070700' ,'1141750400', '1150741000' ,
                          '1151845500' ,'1152471100', '1154066800' ,
                          '1154616500' ,'1154629100', '1154840100' ,
                          '1162092100' ,'1162445500', '1162667800' ,
                          '1163665200' ,'1165314400', '1165466600' ,
                          '1165906700' ,'1166598100', '1167543700' ,
                          '1169390800' ,'1171387500', '1179825500' ,
                          '1186945500' ,'1236325500', '1258845600' ,
                          '1376685500' ,'1412265500', '1470945500' ,
                          '1606085500' ,'1672525500', '1735065600' ,
                          '1773325800' ,'1795305500', '1852185500' ,
                          '1930905500' ,'1932845500', '1968965600' ,
                          '3004075500' ,'3021065500', '5015685600' ,
                          '5201885500' ,'5218045500', '5241425500' ,
                          '5253485500' ,'5262045500', '5286125500' ,
                          '5286125600' ,'9439762550', '9444049550' ,
                          '9495074550' ,'9665141550', '9727080550' ,
                          '1001098855' ,'1603000095', '1603000117' ,
                          '1603000124' ,'1603000125', '1603000127' ,
                          '1604000153' ,'1604000184', '1604000207' ,
                          '1605000157' ,'1605000236', '1605000248' ,
                          '1605000290' ,'1605000301', '1605000302' ,
                          '1606000313' ,'1606000317', '1606000358' ,
                          '1606000368' ,'1606000384', '1606000386' ,
                          '1607000426' ,'1607000441', '1607000458' ,
                          '1607000469' ,'1607000509', '1608000522' ,
                          '1608000523' ,'1608000529', '1608000547' ,
                          '1608000548' ,'1608000552', '1608000562' ,
                          '1608000576' ,'1608000613', '1609000632' ,
                          '1609000655' ,'1609000658', '1609000697' ,
                          '1609000706' ,'1610000736', '1610000737' ,
                          '1610000739' ,'1610000764', '1610000768' ,
                          '1611000815' ,'1611000836', '1611000870' ,
                          '1701000933' ,'1701000939', '1701000955' ,
                          '1702000972' ,'1703001044', '1703001048' ,
                          '1703001060' ,'1703001099', '1705001152' ,
                          '1705001153' ,'1705001155', '1706001205' ,
                          '1706001211' ,'1706001239', '1706001243' ,
                          '1706001252' ,'1706001260', '1707001272' ,
                          '1707001293' ,'1707001297', '1707001318' ,
                          '1707001328' ,'1707001330', '1707001336' ,
                          '1707001337' ,'1708001344', '1708001368' ,
                          '1708001381' ,'1708001386', '1708001440' ,
                          '1709001496' ,'1709001500', '1709001503' ,
                          '1710001510' ,'1710001518', '1711001613' ,
                          '2490500000' ,'3506627000', '3508090000' ,
                          '3550935000' ,'3551260000', '3587759000' ,
                          '3590179000' ,'9108780000', '9116737000' ,
                          '9166756000' ,'3508102100', '1014070410' ,
                          '1015074380' ,'1110003182', '1110003547'
                        );
----- 43123

---- DROP TABLE #TMPLOAN_01
SELECT *
INTO   #TMPLOAN_01
FROM   #TMPLOAN;

---- 230


----- DROP TABLE #TMPRC
SELECT   t1.ID AS LOAN_ID ,
         t1.NUMBER_TX ,
         t1.BRANCH_CODE_TX ,
         t1.DIVISION_CODE_TX ,
         t1.RECORD_TYPE_CD ,
         t1.STATUS_CD AS LN_STATUS_CD ,
         t1.EXTRACT_UNMATCH_COUNT_NO AS LN_EXTRACT_UNMATCH_COUNT_NO ,
         COLL.ID AS COLL_ID ,
         COLL.COLLATERAL_CODE_ID ,
         COLL.PROPERTY_ID ,
         COLL.PRIMARY_LOAN_IN ,
         COLL.STATUS_CD AS COLL_STATUS_CD ,
         COLL.EXTRACT_UNMATCH_COUNT_NO AS COLL_EXTRACT_UNMATCH_COUNT_NO ,
         PR.RECORD_TYPE_CD AS PR_RECORD_TYPE_CD ,
         PR.ADDRESS_ID ,
         OA.LINE_1_TX ,
         OA.CITY_TX ,
         OA.STATE_PROV_TX ,
         OA.POSTAL_CODE_TX ,
         RC.ID AS RC_ID ,
         RC.TYPE_CD AS RC_TYPE_CD ,
         RC.NOTICE_DT ,
         RC.NOTICE_SEQ_NO ,
         RC.NOTICE_TYPE_CD ,
         RC.CPI_QUOTE_ID ,
         RC.LAST_EVENT_DT ,
         RC.LAST_EVENT_SEQ_ID ,
         RC.LAST_SEQ_CONTAINER_ID ,
         RC.RECORD_TYPE_CD AS RC_RECORD_TYPE_CD ,
         CC.CODE_TX AS CC_CODE_TX ,
         CC.DESCRIPTION_TX AS CC_DESCRIPTION_TX ,
         0 AS EXCLUDE
INTO     #TMPRC
FROM     #TMPLOAN_01 t1
         JOIN COLLATERAL COLL ON COLL.LOAN_ID = t1.ID
                                 AND COLL.PURGE_DT IS NULL
                                 AND t1.PURGE_DT IS NULL
         JOIN PROPERTY PR ON PR.ID = COLL.PROPERTY_ID
                             AND PR.PURGE_DT IS NULL
         LEFT JOIN OWNER_ADDRESS OA ON OA.ID = PR.ADDRESS_ID
         JOIN REQUIRED_COVERAGE RC ON RC.PROPERTY_ID = PR.ID
                                      AND RC.PURGE_DT IS NULL
         JOIN COLLATERAL_CODE CC ON CC.ID = COLL.COLLATERAL_CODE_ID
ORDER BY t1.NUMBER_TX;
----459



---24

---- DROP TABLE #TMPRC_01
SELECT   *
INTO     #TMPRC_01
FROM     #TMPRC
WHERE    EXCLUDE = 0
ORDER BY NUMBER_TX;
----- 435

--- DROP TABLE #TMPRC_02
SELECT   *
INTO     #TMPRC_02
FROM     #TMPRC
WHERE    EXCLUDE = 1
ORDER BY NUMBER_TX;
----- 24

SELECT *
FROM   #TMPRC_01;

--SELECT DISTINCT NUMBER_TX , BRANCH_CODE_TX , CC_CODE_TX  , RECORD_TYPE_CD FROM #TMPRC_02
--SELECT * FROM LENDER WHERE CODE_TX = '1729' AND PURGE_DT IS NULL
---- 306

--SELECT * FROM #TMPRC_01

---- 'Type' - for those that say HELOC - map to the HOM EQUITY under 1729, those that say 1st Mortgage - map to Mortgage/<Default>.
/*
SELECT * FROM LENDER_COLLATERAL_CODE_GROUP WHERE LENDER_ID = 306
SELECT CC.ID , CC.CODE_TX FROM LCCG_COLLATERAL_CODE_RELATE REL
JOIN COLLATERAL_CODE CC ON CC.ID = REL.COLLATERAL_CODE_ID
WHERE REL.PURGE_DT IS NULL
AND CC.PURGE_DT IS NULL
AND REL.LCCG_ID = 1462
/*
ID	CODE_TX
2	<DEFAULT>
41	HOM EQUITY
*/
*/


SELECT NUMBER_TX ,
       LOAN_ID ,
       WI.*
INTO   #TMPWI
FROM   WORK_ITEM WI
       JOIN #TMPRC_01 T1 ON T1.LOAN_ID = WI.RELATE_ID
WHERE  WI.STATUS_CD NOT IN ( 'Complete', 'Error', 'Withdrawn' )
       AND WI.PURGE_DT IS NULL
       AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan';
----- 2


--SELECT *
--INTO   UniTracHDStorage.dbo.tmpINC0342751_ORIG
--FROM   #TMPINC0342751;
------ 193

--SELECT *
--INTO   UniTracHDStorage.dbo.tmpINC0342751_LN
--FROM   #TMPLOAN;
------ 43123


--SELECT *
--INTO   UniTracHDStorage.dbo.tmpINC0342751_LN_01
--FROM   #TMPLOAN_01;
------ 230

--SELECT *
--INTO   UniTracHDStorage.dbo.tmpINC0342751_RC
--FROM   #TMPRC;
------ 459


--SELECT *
--INTO   UniTracHDStorage.dbo.tmpINC0342751_RC_01
--FROM   #TMPRC_01;
------ 435


--SELECT *
--INTO   UniTracHDStorage.dbo.tmpINC0342751_RC_02
--FROM   #TMPRC_02;
------ 24

--SELECT *
--INTO   UniTracHDStorage.dbo.tmpINC0342751_WI
--FROM   #TMPWI;
------ 2


SELECT *
FROM   dbo.LENDER_ORGANIZATION
WHERE  LENDER_ID = 2080;


UPDATE LN
SET    BRANCH_CODE_TX = '5431' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = LN.LOCK_ID % 255 + 1
---- SELECT *
FROM   LOAN LN
       JOIN #TMPRC_01 T1 ON T1.LOAN_ID = LN.ID;

---- 6




UPDATE LN
SET    LENDER_ID = 2080 ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = LN.LOCK_ID % 255 + 1
---- SELECT DISTINCT LN.ID , LN.LENDER_ID , LN.STATUS_CD , LN.EXTRACT_UNMATCH_COUNT_NO , LN.DIVISION_CODE_TX
FROM   LOAN LN
       JOIN #TMPRC_01 T1 ON T1.LOAN_ID = LN.ID;
---- 218


UPDATE PR
SET    LENDER_ID = 2080 ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = PR.LOCK_ID % 255 + 1
---- SELECT DISTINCT PR.ID , PR.RECORD_TYPE_CD
FROM   PROPERTY PR
       JOIN #TMPRC_01 T1 ON T1.PROPERTY_ID = PR.ID;

----- 182


INSERT INTO PROPERTY_CHANGE (   ENTITY_NAME_TX ,
                                ENTITY_ID ,
                                USER_TX ,
                                ATTACHMENT_IN ,
                                CREATE_DT ,
                                AGENCY_ID ,
                                DESCRIPTION_TX ,
                                DETAILS_IN ,
                                FORMATTED_IN ,
                                LOCK_ID ,
                                PARENT_NAME_TX ,
                                PARENT_ID ,
                                TRANS_STATUS_CD ,
                                UTL_IN
                            )
            SELECT DISTINCT 'Allied.UniTrac.Loan' ,
                   LOAN_ID ,
                   'INC0342751' ,
                   'N' ,
                   GETDATE() ,
                   1 ,
                   'Moved Loan from Lender 7543 to 7621' ,
                   'N' ,
                   'Y' ,
                   1 ,
                   'Allied.UniTrac.Loan' ,
                   LOAN_ID ,
                   'PEND' ,
                   'N'
            FROM   #TMPRC_01;
---- 218


UPDATE SEARCH_FULLTEXT
SET    LENDER_ID = 2080 ,
       UPDATE_DT = GETDATE()
----- SELECT DISTINCT SF.PROPERTY_ID
FROM   #TMPRC_01 t
       JOIN SEARCH_FULLTEXT sf ON sf.PROPERTY_ID = t.PROPERTY_ID;
----- 182

UPDATE WI
SET    CONTENT_XML.modify('replace value of (/Content/Lender/Code/text())[1] with ("7621")') ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = ( WI.LOCK_ID + 1 ) % 256
----- SELECT *
FROM   WORK_ITEM WI
       JOIN #TMPRC_01 T1 ON T1.LOAN_ID = WI.RELATE_ID
WHERE  WI.STATUS_CD NOT IN ( 'Complete', 'Error', 'Withdrawn' )
       AND WI.PURGE_DT IS NULL
       AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan';
----- 2

UPDATE WI
SET    CONTENT_XML.modify('replace value of (/Content/Lender/Id/text())[1] with ("2080")') ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = ( WI.LOCK_ID + 1 ) % 256
----- SELECT *
FROM   WORK_ITEM WI
       JOIN #TMPRC_01 T1 ON T1.LOAN_ID = WI.RELATE_ID
WHERE  WI.STATUS_CD NOT IN ( 'Complete', 'Error', 'Withdrawn' )
       AND WI.PURGE_DT IS NULL
       AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan';
----- 2

UPDATE WI
SET    CONTENT_XML.modify('replace value of (/Content/Lender/Name/text())[1] with ("Wescom Credit Union")') ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = ( WI.LOCK_ID + 1 ) % 256
----- SELECT *
FROM   WORK_ITEM WI
       JOIN #TMPRC_01 T1 ON T1.LOAN_ID = WI.RELATE_ID
WHERE  WI.STATUS_CD NOT IN ( 'Complete', 'Error', 'Withdrawn' )
       AND WI.PURGE_DT IS NULL
       AND WI.RELATE_TYPE_CD = 'Allied.UniTrac.Loan';
----- 2

UPDATE eq
SET    PURGE_DT = GETDATE() ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = ( eq.LOCK_ID + 1 ) % 256
---- SELECT EQ.*
FROM   #TMPRC_01 t
       INNER JOIN EVALUATION_QUEUE eq ON t.RC_ID = eq.REQUIRED_COVERAGE_ID
                                         AND eq.PURGE_DT IS NULL;
----- 0

UPDATE ee
SET    STATUS_CD = 'CLR' ,
       PURGE_DT = GETDATE() ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = ( ee.LOCK_ID + 1 ) % 256
---- SELECT *
FROM   #TMPRC_01 t
       INNER JOIN EVALUATION_EVENT ee ON ee.REQUIRED_COVERAGE_ID = t.RC_ID
                                         AND ee.PURGE_DT IS NULL
WHERE  ee.STATUS_CD = 'PEND';
----- 0

---- NO CPI QUOTE & NO NOTICE CYCLE
UPDATE rc
SET    UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751' ,
       LOCK_ID = ( rc.LOCK_ID + 1 ) % 256 ,
       GOOD_THRU_DT = NULL ,
       LENDER_PRODUCT_ID = NULL ,
       LCGCT_ID = NULL ,
       NOTICE_DT = NULL ,
       NOTICE_TYPE_CD = NULL ,
       NOTICE_SEQ_NO = NULL ,
       CPI_QUOTE_ID = NULL ,
       LAST_EVENT_SEQ_ID = NULL ,
       LAST_EVENT_DT = NULL ,
       LAST_SEQ_CONTAINER_ID = NULL ,
       RECORD_TYPE_CD = CASE WHEN rc.RECORD_TYPE_CD IN ( 'D', 'A' ) THEN 'G'
                             ELSE rc.RECORD_TYPE_CD
                        END
---- SELECT RC.RECORD_TYPE_CD , RC.CPI_QUOTE_ID , RC.NOTICE_SEQ_NO ,  *
FROM   #TMPRC_01 t
       INNER JOIN REQUIRED_COVERAGE rc ON rc.ID = t.RC_ID
                                          AND rc.PURGE_DT IS NULL;
---- 435