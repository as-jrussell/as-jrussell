USE UniTrac;
SELECT *
FROM   dbo.LENDER
WHERE  CODE_TX = '7543';

SELECT * --INTO UniTracHDStorage.dbo.LOAN_7543_1
FROM   dbo.LOAN
WHERE  LENDER_ID IN ( 2065 )
       AND NUMBER_TX IN ( '124955', '135456', '418856', '580256', '580258' ,
                          '581358' ,'581359', '723755', '780455', '831656' ,
                          '1230257' ,'1359257', '1389056', '1428855' ,
                          '1479855' ,'1559655', '2679655', '3610255' ,
                          '4850255' ,'5429055', '6554456', '7769855' ,
                          '8320856' ,'8643055', '9266457', '9277856' ,
                          '9435055' ,'9859655', '9959655', '11518455' ,
                          '11624455' ,'11798255', '11869455', '12363255' ,
                          '12588456' ,'13766855', '14122655', '14709455' ,
                          '16060855' ,'17350656', '17733258', '17953055' ,
                          '18521855' ,'19309055', '19328455', '19689656' ,
                          '30210655' ,'50156856', '52018855', '52180455' ,
                          '52414255' ,'52534855', '52620455', '52861255' ,
                          '52861256' ,'943976255', '944404955', '949507455' ,
                          '966514155' ,'972708055', '1001098855', '24905' ,
                          '3550935'
                        );

SELECT *
FROM   UniTracHDStorage.dbo.LOAN_7543_1;

UPDATE LOAN
SET    NUMBER_TX = '1249550000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '124955'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1354560000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '135456'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '4188560000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '418856'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5802560000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '580256'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5802580000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '580258'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5813580000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '581358'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5813590000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '581359'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '7237550000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '723755'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '7804550000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '780455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '8316560000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '831656'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1230257000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '1230257'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1359257000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '1359257'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1389056000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '1389056'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1428855000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '1428855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1479855000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '1479855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1559655000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '1559655'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '2679655000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '2679655'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '3610255000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '3610255'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '4850255000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '4850255'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5429055000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '5429055'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '6554456000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '6554456'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '7769855000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '7769855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '8320856000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '8320856'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '8643055000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '8643055'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9266457000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '9266457'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9277856000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '9277856'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9435055000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '9435055'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9859655000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '9859655'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9959655000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '9959655'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1151845500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '11518455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1162445500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '11624455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1179825500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '11798255'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1186945500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '11869455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1236325500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '12363255'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1258845600' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '12588456'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1376685500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '13766855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1412265500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '14122655'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1470945500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '14709455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1606085500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '16060855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1735065600' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '17350656'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1773325800' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '17733258'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1795305500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '17953055'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1852185500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '18521855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1930905500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '19309055'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1932845500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '19328455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1968965600' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '19689656'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '3021065500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '30210655'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5015685600' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '50156856'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5201885500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '52018855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5218045500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '52180455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5241425500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '52414255'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5253485500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '52534855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5262045500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '52620455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5286125500' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '52861255'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '5286125600' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '52861256'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9439762550' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '943976255'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9444049550' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '944404955'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9495074550' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '949507455'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9665141550' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '966514155'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '9727080550' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '972708055'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '1001098855' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '1001098855'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '2490500000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '24905'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;
UPDATE LOAN
SET    NUMBER_TX = '3550935000' ,
       UPDATE_DT = GETDATE() ,
       UPDATE_USER_TX = 'INC0342751'
WHERE  NUMBER_TX = '3550935'
       AND LENDER_ID = 2065
       AND PURGE_DT IS NULL;




--2) INSERT into PROPERTY_CHANGE table
INSERT INTO PROPERTY_CHANGE (   ENTITY_NAME_TX ,
                                ENTITY_ID ,
                                USER_TX ,
                                ATTACHMENT_IN ,
                                CREATE_DT ,
                                AGENCY_ID ,
                                DETAILS_IN ,
                                FORMATTED_IN ,
                                LOCK_ID ,
                                PARENT_NAME_TX ,
                                PARENT_ID ,
                                TRANS_STATUS_CD ,
                                UTL_IN
                            )
            SELECT 'Allied.UniTrac.Loan' ,
                   LOAN.ID ,
                   'INC0342751' ,
                   'N' ,
                   '2018-03-01 00:00:00.000' ,
                   1 ,
                   'Y' ,
                   'N' ,
                   1 ,
                   'Allied.UniTrac.Loan' ,
                   LOAN.ID ,
                   'PEND' ,
                   'N'
            FROM   LOAN
            WHERE  ID IN (   SELECT ID
                             FROM   UniTracHDStorage.dbo.LOAN_7543_1
                         );
--42


--3) INSERT into PROPERTY_CHANGE_UPDATE table
INSERT INTO PROPERTY_CHANGE_UPDATE (   CHANGE_ID ,
                                       TABLE_NAME_TX ,
                                       TABLE_ID ,
                                       COLUMN_NM ,
                                       FROM_VALUE_TX ,
                                       TO_VALUE_TX ,
                                       DATATYPE_NO ,
                                       CREATE_DT ,
                                       DISPLAY_IN ,
                                       OPERATION_CD
                                   )
            SELECT PROPERTY_CHANGE.ID ,
                   'LOAN' ,
                   ENTITY_ID ,
                   'NUMBER_TX' ,
                   UniTracHDStorage.dbo.LOAN_7543_1.NUMBER_TX ,
                   LOAN.NUMBER_TX ,
                   1 ,
                   '2018-03-01 00:00:00.000' ,
                   'Y' ,
                   'U'
            FROM   PROPERTY_CHANGE
                   INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID
                                      AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan'
                   INNER JOIN UniTracHDStorage.dbo.LOAN_7543_1 ON LOAN.ID = UniTracHDStorage.dbo.LOAN_7543_1.ID --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
            WHERE  PROPERTY_CHANGE.CREATE_DT = '2018-03-01 00:00:00.000'
                   AND ENTITY_ID IN (   SELECT ID
                                        FROM   UniTracHDStorage.dbo.LOAN_7543_1
                                    );
--0

---4) Insert into LOAN_NUMBER Table (Leave old numbers for matching purposes)

INSERT INTO LOAN_NUMBER (   LOAN_ID ,
                            NUMBER_TX ,
                            EFFECTIVE_DT ,
                            CREATE_DT ,
                            UPDATE_DT ,
                            UPDATE_USER_TX ,
                            LOCK_ID
                        )
            SELECT dbo.LOAN.ID ,
                   dbo.LOAN.NUMBER_TX ,
                   dbo.LOAN.EFFECTIVE_DT ,
                   GETDATE() ,
                   GETDATE() ,
                   'INC0342751' ,
                   1
            FROM   UniTracHDStorage.dbo.LOAN_7543_1 HD
                   INNER JOIN dbo.LOAN ON HD.ID = LOAN.ID AND LOan.EFFECTIVE_DT IS not NULL;
--42

--5) Full Text Search Updates

--Create updates
SELECT 'EXEC SaveSearchFullText' ,
       PROPERTY.ID
FROM   PROPERTY
       INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
                                AND LOAN_ID IN (   SELECT ID
                                                   FROM   UniTracHDStorage.dbo.LOAN_7543_1
                                               );
--42


EXEC SaveSearchFullText	54699070
EXEC SaveSearchFullText	54700202
EXEC SaveSearchFullText	54700223
EXEC SaveSearchFullText	54700231
EXEC SaveSearchFullText	54700257
EXEC SaveSearchFullText	54700274
EXEC SaveSearchFullText	54700333
EXEC SaveSearchFullText	54700341
EXEC SaveSearchFullText	54700392
EXEC SaveSearchFullText	54700399
EXEC SaveSearchFullText	54700405
EXEC SaveSearchFullText	54700420
EXEC SaveSearchFullText	54700449
EXEC SaveSearchFullText	54700482
EXEC SaveSearchFullText	54700539
EXEC SaveSearchFullText	54700544
EXEC SaveSearchFullText	54700728
EXEC SaveSearchFullText	54700772
EXEC SaveSearchFullText	54700897
EXEC SaveSearchFullText	54700915
EXEC SaveSearchFullText	54700939
EXEC SaveSearchFullText	54701006
EXEC SaveSearchFullText	54701142
EXEC SaveSearchFullText	54701144
EXEC SaveSearchFullText	54701182
EXEC SaveSearchFullText	54701184
EXEC SaveSearchFullText	54701186
EXEC SaveSearchFullText	54701198
EXEC SaveSearchFullText	54701208
EXEC SaveSearchFullText	54701209
EXEC SaveSearchFullText	54701213
EXEC SaveSearchFullText	54701229
EXEC SaveSearchFullText	54701233
EXEC SaveSearchFullText	54701244
EXEC SaveSearchFullText	54701253
EXEC SaveSearchFullText	54701268
EXEC SaveSearchFullText	54701350
EXEC SaveSearchFullText	54701351
EXEC SaveSearchFullText	54701457
EXEC SaveSearchFullText	54701460
EXEC SaveSearchFullText	54701463
EXEC SaveSearchFullText	54701467
EXEC SaveSearchFullText	54701708
EXEC SaveSearchFullText	54701719
EXEC SaveSearchFullText	54701730
EXEC SaveSearchFullText	54701897
EXEC SaveSearchFullText	54701931
EXEC SaveSearchFullText	54701936
EXEC SaveSearchFullText	54701965
EXEC SaveSearchFullText	54702020
EXEC SaveSearchFullText	54702023
EXEC SaveSearchFullText	54702025
EXEC SaveSearchFullText	54702032
EXEC SaveSearchFullText	54702059
EXEC SaveSearchFullText	54702062
EXEC SaveSearchFullText	54702069
EXEC SaveSearchFullText	54702071
EXEC SaveSearchFullText	54702119
EXEC SaveSearchFullText	54702141
EXEC SaveSearchFullText	54702142
EXEC SaveSearchFullText	54702162
EXEC SaveSearchFullText	54702284
EXEC SaveSearchFullText	54702457
EXEC SaveSearchFullText	54699070
EXEC SaveSearchFullText	54700341
EXEC SaveSearchFullText	54700392
EXEC SaveSearchFullText	54701351
EXEC SaveSearchFullText	54701209
EXEC SaveSearchFullText	54701229
EXEC SaveSearchFullText	54702069
EXEC SaveSearchFullText	54701708
EXEC SaveSearchFullText	54701233
EXEC SaveSearchFullText	54701198
EXEC SaveSearchFullText	54701182
EXEC SaveSearchFullText	54700399
EXEC SaveSearchFullText	54700420
EXEC SaveSearchFullText	54700482
EXEC SaveSearchFullText	54700544
EXEC SaveSearchFullText	54701931
EXEC SaveSearchFullText	54700274
EXEC SaveSearchFullText	54701006
EXEC SaveSearchFullText	54702071
EXEC SaveSearchFullText	54702023
EXEC SaveSearchFullText	54701350
EXEC SaveSearchFullText	54701244
EXEC SaveSearchFullText	54701213
EXEC SaveSearchFullText	54701208
EXEC SaveSearchFullText	54701144
EXEC SaveSearchFullText	86534593
EXEC SaveSearchFullText	54701463
EXEC SaveSearchFullText	54701184
EXEC SaveSearchFullText	54701186
EXEC SaveSearchFullText	54701142
EXEC SaveSearchFullText	54701460
EXEC SaveSearchFullText	54701467
EXEC SaveSearchFullText	54700257
EXEC SaveSearchFullText	54700202
EXEC SaveSearchFullText	54701457
EXEC SaveSearchFullText	54700223
EXEC SaveSearchFullText	54700333
EXEC SaveSearchFullText	54700231
EXEC SaveSearchFullText	54702457
EXEC SaveSearchFullText	54700405
EXEC SaveSearchFullText	54700449
EXEC SaveSearchFullText	54701936
EXEC SaveSearchFullText	56021826
EXEC SaveSearchFullText	54700728
EXEC SaveSearchFullText	54700772
EXEC SaveSearchFullText	54701965
EXEC SaveSearchFullText	54700897
EXEC SaveSearchFullText	54700915
EXEC SaveSearchFullText	54700939
EXEC SaveSearchFullText	54701897
EXEC SaveSearchFullText	54702025
EXEC SaveSearchFullText	54702020
EXEC SaveSearchFullText	54701719
EXEC SaveSearchFullText	54702141
EXEC SaveSearchFullText	54701730
EXEC SaveSearchFullText	54702032
EXEC SaveSearchFullText	54701253
EXEC SaveSearchFullText	54701268
EXEC SaveSearchFullText	54702062
EXEC SaveSearchFullText	54702119
EXEC SaveSearchFullText	54702059
EXEC SaveSearchFullText	54702028
EXEC SaveSearchFullText	54702162
EXEC SaveSearchFullText	54702142
EXEC SaveSearchFullText	206828471
EXEC SaveSearchFullText	206828662