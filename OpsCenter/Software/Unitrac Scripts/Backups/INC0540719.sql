Upload the following files into the database with the table name as the file names

\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\Database Uploads\INC0540719_1.xlsx

\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\Database Uploads\INC0540719_2.xlsx

\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\Database Uploads\INC0540719_3.xlsx



INC0540719.sql 

Ran on UT-PRD-LISTENER

USE UniTrac
USE UniTrac

select * from UniTracHDStorage..INC0540719_1


select * from UniTracHDStorage..INC0540719_2


select * from UniTracHDStorage..INC0540719_3

USE UniTrac

select * INTO  unitrachdstorage..INC0540719_BU_Loan_1
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Loan ID] = LO.ID



select * INTO  unitrachdstorage..INC0540719_BU_Collateral_1
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Collateral ID] = LO.ID



select * INTO  unitrachdstorage..INC0540719_BU_Property_1
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Property ID] = LO.ID




select * INTO  unitrachdstorage..INC0540719_BU_Loan_2
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Loan ID] = LO.ID



select * INTO  unitrachdstorage..INC0540719_BU_Collateral_2
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Collateral ID] = LO.ID



select * INTO  unitrachdstorage..INC0540719_BU_Property_2
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Property ID] = LO.ID




select * INTO  unitrachdstorage..INC0540719_BU_Loan_3
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Loan ID] = LO.ID



select * INTO  unitrachdstorage..INC0540719_BU_Collateral_3
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Collateral ID] = LO.ID



select * INTO  unitrachdstorage..INC0540719_BU_Property_3
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Property ID] = LO.ID



--Process 1


UPDATE LO
SET LO.RECORD_TYPE_CD = 'G', LO.STATUS_CD = 'A', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1, LO.EXTRACT_UNMATCH_COUNT_NO = '0'
--select *
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Loan ID] = LO.ID



UPDATE LO
SET LO.STATUS_CD = 'A', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1, LO.EXTRACT_UNMATCH_COUNT_NO = '0'
--select *
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Collateral ID] = LO.ID



UPDATE LO
SET LO.RECORD_TYPE_CD = 'G', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1
--select *
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Property ID] = LO.ID


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan record types to be set as Good and set to status Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , LO.ID , 'PEND' , 'N'
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Loan ID] = LO.ID

INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan record types to be set as Good and set to status Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , LO.ID , 'PEND' , 'N'
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Collateral ID] = LO.ID


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan record types to be set as Good and set to status Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , LO.ID , 'PEND' , 'N'
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_1 T ON T.[Property ID] = LO.ID



---Process 2


UPDATE LO
SET LO.RECORD_TYPE_CD = 'D', LO.STATUS_CD = 'U', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1
--select *
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Loan ID] = LO.ID



UPDATE LO
SET LO.STATUS_CD = 'U', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1
--select *
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Collateral ID] = LO.ID



UPDATE LO
SET LO.RECORD_TYPE_CD = 'D', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1
--select *
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Property ID] = LO.ID



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan record types to be set as Deleted and set to status Unmatched', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , LO.ID , 'PEND' , 'N'
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Loan ID] = LO.ID

INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan record types to be set as Deleted and set to status Unmatched', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , LO.ID , 'PEND' , 'N'
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Collateral ID] = LO.ID


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan record types to be set as Deleted and set to status Unmatched', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , LO.ID , 'PEND' , 'N'
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_2 T ON T.[Property ID] = LO.ID


---Process 3

UPDATE LO
SET LO.RECORD_TYPE_CD = 'G', LO.STATUS_CD = 'U', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1, LO.NUMBER_TX =T.[NEW LOAN NUMBER]
--select *
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Loan ID] = LO.ID



UPDATE LO
SET LO.STATUS_CD = 'U', LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1
--select STATUS_CD, *
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Collateral ID] = LO.ID



UPDATE LO
SET LO.RECORD_TYPE_CD = 'G' ,LO.UPDATE_DT = GETDATE(), LO.UPDATE_USER_TX = 'INC0540719', lo.LOCK_ID = (lo.LOCK_ID % 255) + 1
--select *
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Property ID] = LO.ID




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan Number Set as Good and unmatched and loan update', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , LO.ID , 'PEND' , 'N'
FROM dbo.LOAN LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Loan ID] = LO.ID

INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan Number Set as Good and unmatched', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , LO.ID , 'PEND' , 'N'
FROM dbo.COLLATERAL LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Collateral ID] = LO.ID


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , LO.ID , 'INC0540719' , 'N' , 
 GETDATE() ,  1 , 
'Loan Number Set as Good and unmatched', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , LO.ID , 'PEND' , 'N'
FROM dbo.PROPERTY LO
JOIN unitrachdstorage..INC0540719_3 T ON T.[Property ID] = LO.ID
 

INSERT INTO PROPERTY_CHANGE_UPDATE (CHANGE_ID, TABLE_NAME_TX, TABLE_ID, COLUMN_NM, FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)
select PROPERTY_CHANGE.ID,'LOAN',ENTITY_ID,'NUMBER_TX',LOAN.NUMBER_TX,UnitracHDStorage.dbo.INC0540719_3.[NEW LOAN NUMBER],1,GETDATE(),'Y','U'
from PROPERTY_CHANGE
INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
INNER JOIN UnitracHDStorage.dbo.INC0540719_3 ON LOAN.ID = UnitracHDStorage.dbo.INC0540719_3.[Loan ID] --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
WHERE PROPERTY_CHANGE.CREATE_DT >= '2020-08-28 00:00:00.000'
AND ENTITY_ID IN (select [Loan ID] FROM UnitracHDStorage.dbo.INC0540719_3)
--0

---4) Insert into LOAN_NUMBER Table (Leave old numbers for matching purposes)

INSERT INTO LOAN_NUMBER (LOAN_ID,NUMBER_TX,EFFECTIVE_DT,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
SELECT dbo.LOAN.ID,[NEW LOAN NUMBER],dbo.LOAN.EFFECTIVE_DT,GETDATE(),GETDATE(),'INC0540719',1
FROM UnitracHDStorage.dbo.INC0540719_3 HD INNER JOIN dbo.LOAN ON HD.[Loan ID] = LOAN.ID
--42

--5) Full Text Search Updates

--Create updates
SELECT 'EXEC SaveSearchFullText', PROPERTY.ID 
FROM PROPERTY
INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
AND LOAN_ID in (select [Loan ID] FROM UnitracHDStorage.dbo.INC0540719_3)
--42


EXEC SaveSearchFullText	135382725
EXEC SaveSearchFullText	254240197
EXEC SaveSearchFullText	254239666
EXEC SaveSearchFullText	95707764
EXEC SaveSearchFullText	133906581
EXEC SaveSearchFullText	97299520
EXEC SaveSearchFullText	254240490
EXEC SaveSearchFullText	541973
EXEC SaveSearchFullText	254238633
EXEC SaveSearchFullText	17564346
EXEC SaveSearchFullText	98552969
EXEC SaveSearchFullText	20314133
EXEC SaveSearchFullText	104262187
EXEC SaveSearchFullText	66322704
EXEC SaveSearchFullText	66322517
EXEC SaveSearchFullText	254240253
EXEC SaveSearchFullText	254240976
EXEC SaveSearchFullText	538302
EXEC SaveSearchFullText	66322782
EXEC SaveSearchFullText	254240211
EXEC SaveSearchFullText	541238
EXEC SaveSearchFullText	63444598
EXEC SaveSearchFullText	19771909
EXEC SaveSearchFullText	542900
EXEC SaveSearchFullText	145377147
EXEC SaveSearchFullText	254239380
EXEC SaveSearchFullText	541019
EXEC SaveSearchFullText	40978147
EXEC SaveSearchFullText	61422946
EXEC SaveSearchFullText	542640
EXEC SaveSearchFullText	254240654
EXEC SaveSearchFullText	70062659
EXEC SaveSearchFullText	102972236
EXEC SaveSearchFullText	102971693
EXEC SaveSearchFullText	542759
EXEC SaveSearchFullText	539009
EXEC SaveSearchFullText	77751323
EXEC SaveSearchFullText	541880
EXEC SaveSearchFullText	254239526
EXEC SaveSearchFullText	40978155
EXEC SaveSearchFullText	66322016
EXEC SaveSearchFullText	254240043
EXEC SaveSearchFullText	254238681
EXEC SaveSearchFullText	87308592
EXEC SaveSearchFullText	47368342
EXEC SaveSearchFullText	254238962
EXEC SaveSearchFullText	18445371
EXEC SaveSearchFullText	254240439
EXEC SaveSearchFullText	540948
EXEC SaveSearchFullText	541880
EXEC SaveSearchFullText	540567
EXEC SaveSearchFullText	540530
EXEC SaveSearchFullText	254239246
EXEC SaveSearchFullText	254239776
EXEC SaveSearchFullText	574116
EXEC SaveSearchFullText	254240698
EXEC SaveSearchFullText	538737
EXEC SaveSearchFullText	40978146
EXEC SaveSearchFullText	542419
EXEC SaveSearchFullText	254238523
EXEC SaveSearchFullText	542187
EXEC SaveSearchFullText	19030790
EXEC SaveSearchFullText	542344
EXEC SaveSearchFullText	40978137
EXEC SaveSearchFullText	254240589
EXEC SaveSearchFullText	254241192
EXEC SaveSearchFullText	254240848
EXEC SaveSearchFullText	71673370
EXEC SaveSearchFullText	111274043
EXEC SaveSearchFullText	254238743
EXEC SaveSearchFullText	32725606
EXEC SaveSearchFullText	738759
EXEC SaveSearchFullText	254240558
EXEC SaveSearchFullText	32725576
EXEC SaveSearchFullText	145377141
EXEC SaveSearchFullText	538849
EXEC SaveSearchFullText	24712262
EXEC SaveSearchFullText	540590
EXEC SaveSearchFullText	254240223
EXEC SaveSearchFullText	26526812
EXEC SaveSearchFullText	254240268
EXEC SaveSearchFullText	254240920
EXEC SaveSearchFullText	541891
EXEC SaveSearchFullText	540948
EXEC SaveSearchFullText	254239978
EXEC SaveSearchFullText	254240837
EXEC SaveSearchFullText	538670
EXEC SaveSearchFullText	541002
EXEC SaveSearchFullText	14927864
EXEC SaveSearchFullText	130766553
EXEC SaveSearchFullText	130766511
EXEC SaveSearchFullText	140626727
EXEC SaveSearchFullText	540193
EXEC SaveSearchFullText	538923
EXEC SaveSearchFullText	254238633
EXEC SaveSearchFullText	254238665
EXEC SaveSearchFullText	540186
EXEC SaveSearchFullText	538849
EXEC SaveSearchFullText	119366278
EXEC SaveSearchFullText	254238657
EXEC SaveSearchFullText	101580470
EXEC SaveSearchFullText	254240626
EXEC SaveSearchFullText	102972244
EXEC SaveSearchFullText	145377116
EXEC SaveSearchFullText	66322362
EXEC SaveSearchFullText	254240607
EXEC SaveSearchFullText	18445371
EXEC SaveSearchFullText	565987
EXEC SaveSearchFullText	61422946
EXEC SaveSearchFullText	541931
EXEC SaveSearchFullText	140627612
EXEC SaveSearchFullText	376968
EXEC SaveSearchFullText	15548065
EXEC SaveSearchFullText	33502179
EXEC SaveSearchFullText	135382725
EXEC SaveSearchFullText	538923
EXEC SaveSearchFullText	19771947
EXEC SaveSearchFullText	539193
EXEC SaveSearchFullText	539193
EXEC SaveSearchFullText	23989713
EXEC SaveSearchFullText	254239617
EXEC SaveSearchFullText	538776
EXEC SaveSearchFullText	542444
EXEC SaveSearchFullText	541931
EXEC SaveSearchFullText	538397
EXEC SaveSearchFullText	541019
EXEC SaveSearchFullText	538302
EXEC SaveSearchFullText	137156287
EXEC SaveSearchFullText	254239951
EXEC SaveSearchFullText	541985
EXEC SaveSearchFullText	254240803
EXEC SaveSearchFullText	132160707
EXEC SaveSearchFullText	111223382
EXEC SaveSearchFullText	254239972
EXEC SaveSearchFullText	145377145
EXEC SaveSearchFullText	40978106
EXEC SaveSearchFullText	76651981
EXEC SaveSearchFullText	133906581
EXEC SaveSearchFullText	98552981
EXEC SaveSearchFullText	14927850
EXEC SaveSearchFullText	542275
EXEC SaveSearchFullText	29669298
EXEC SaveSearchFullText	109802037
EXEC SaveSearchFullText	541506
EXEC SaveSearchFullText	254240498
EXEC SaveSearchFullText	97299537
EXEC SaveSearchFullText	104262243
EXEC SaveSearchFullText	538823
EXEC SaveSearchFullText	145377145
EXEC SaveSearchFullText	145376260
EXEC SaveSearchFullText	119366275
EXEC SaveSearchFullText	138755756
EXEC SaveSearchFullText	254240267
EXEC SaveSearchFullText	254240229
EXEC SaveSearchFullText	254240022
EXEC SaveSearchFullText	538168
EXEC SaveSearchFullText	541382
EXEC SaveSearchFullText	254240967
EXEC SaveSearchFullText	35765990
EXEC SaveSearchFullText	254240661
EXEC SaveSearchFullText	254240254
EXEC SaveSearchFullText	538776
EXEC SaveSearchFullText	41334554
EXEC SaveSearchFullText	98552969
EXEC SaveSearchFullText	41334554
EXEC SaveSearchFullText	28615595
EXEC SaveSearchFullText	140626871
EXEC SaveSearchFullText	108476897
EXEC SaveSearchFullText	20314133
EXEC SaveSearchFullText	11669093
EXEC SaveSearchFullText	66322704
EXEC SaveSearchFullText	150005967
EXEC SaveSearchFullText	18445405
EXEC SaveSearchFullText	254238530
EXEC SaveSearchFullText	254241216
EXEC SaveSearchFullText	2445302
EXEC SaveSearchFullText	574116
EXEC SaveSearchFullText	150005974
EXEC SaveSearchFullText	254240496
EXEC SaveSearchFullText	61984368
EXEC SaveSearchFullText	26526812
EXEC SaveSearchFullText	540907
EXEC SaveSearchFullText	18445405
EXEC SaveSearchFullText	775988
EXEC SaveSearchFullText	35042008
EXEC SaveSearchFullText	254241007
EXEC SaveSearchFullText	140626866
EXEC SaveSearchFullText	541097
EXEC SaveSearchFullText	538823
EXEC SaveSearchFullText	541291
EXEC SaveSearchFullText	541116
EXEC SaveSearchFullText	540634
EXEC SaveSearchFullText	63444417
EXEC SaveSearchFullText	254240221
EXEC SaveSearchFullText	145377133
EXEC SaveSearchFullText	538973
EXEC SaveSearchFullText	540530
EXEC SaveSearchFullText	102971693
EXEC SaveSearchFullText	254240283
EXEC SaveSearchFullText	254241233
EXEC SaveSearchFullText	254239406
EXEC SaveSearchFullText	254239365
EXEC SaveSearchFullText	57773636
EXEC SaveSearchFullText	254240235
EXEC SaveSearchFullText	540467
EXEC SaveSearchFullText	541870
EXEC SaveSearchFullText	63444417
EXEC SaveSearchFullText	102971693
EXEC SaveSearchFullText	16162183
EXEC SaveSearchFullText	254240917
EXEC SaveSearchFullText	254239683
EXEC SaveSearchFullText	254240262
EXEC SaveSearchFullText	14927864
EXEC SaveSearchFullText	558520
EXEC SaveSearchFullText	254239981
EXEC SaveSearchFullText	145377116
EXEC SaveSearchFullText	254240648
EXEC SaveSearchFullText	541726
EXEC SaveSearchFullText	540907
EXEC SaveSearchFullText	254238739
EXEC SaveSearchFullText	254238787
EXEC SaveSearchFullText	148524314
EXEC SaveSearchFullText	727973
EXEC SaveSearchFullText	541081
EXEC SaveSearchFullText	97299520
EXEC SaveSearchFullText	254240013
EXEC SaveSearchFullText	812763
EXEC SaveSearchFullText	66322449
EXEC SaveSearchFullText	254240319
EXEC SaveSearchFullText	812769
EXEC SaveSearchFullText	88695607
EXEC SaveSearchFullText	540602
EXEC SaveSearchFullText	148524324
EXEC SaveSearchFullText	107153261
EXEC SaveSearchFullText	541726
EXEC SaveSearchFullText	107153237
EXEC SaveSearchFullText	23989713
EXEC SaveSearchFullText	254239358
EXEC SaveSearchFullText	812763
EXEC SaveSearchFullText	254238855
EXEC SaveSearchFullText	254239510
EXEC SaveSearchFullText	254239910
EXEC SaveSearchFullText	254240166
EXEC SaveSearchFullText	140626871
EXEC SaveSearchFullText	20955764
EXEC SaveSearchFullText	254238734
EXEC SaveSearchFullText	49105882
EXEC SaveSearchFullText	254240641
EXEC SaveSearchFullText	579013
EXEC SaveSearchFullText	538373
EXEC SaveSearchFullText	137156337
EXEC SaveSearchFullText	540550
EXEC SaveSearchFullText	47368342
EXEC SaveSearchFullText	538734
EXEC SaveSearchFullText	66322016
EXEC SaveSearchFullText	540310
EXEC SaveSearchFullText	30789591
EXEC SaveSearchFullText	254239692
EXEC SaveSearchFullText	52669524
EXEC SaveSearchFullText	254239984
EXEC SaveSearchFullText	13533751
EXEC SaveSearchFullText	540744
EXEC SaveSearchFullText	540550
EXEC SaveSearchFullText	539074
EXEC SaveSearchFullText	148524324
EXEC SaveSearchFullText	140626727
EXEC SaveSearchFullText	32725606
EXEC SaveSearchFullText	26526828
EXEC SaveSearchFullText	138755778
EXEC SaveSearchFullText	254241221
EXEC SaveSearchFullText	254240742
EXEC SaveSearchFullText	541116
EXEC SaveSearchFullText	35765990
EXEC SaveSearchFullText	254239630
EXEC SaveSearchFullText	542640
EXEC SaveSearchFullText	540193
EXEC SaveSearchFullText	28095011
EXEC SaveSearchFullText	836031
EXEC SaveSearchFullText	254239350
EXEC SaveSearchFullText	61984368
EXEC SaveSearchFullText	19030787
EXEC SaveSearchFullText	254240011
EXEC SaveSearchFullText	254239478
EXEC SaveSearchFullText	145376260
EXEC SaveSearchFullText	254240549
EXEC SaveSearchFullText	541264
EXEC SaveSearchFullText	70062636
EXEC SaveSearchFullText	541211
EXEC SaveSearchFullText	145377114
EXEC SaveSearchFullText	254240487
EXEC SaveSearchFullText	254241194
EXEC SaveSearchFullText	21652350
EXEC SaveSearchFullText	63444488
EXEC SaveSearchFullText	85879264
EXEC SaveSearchFullText	24712262
EXEC SaveSearchFullText	32725576
EXEC SaveSearchFullText	107153236
EXEC SaveSearchFullText	14927850
EXEC SaveSearchFullText	254240649
EXEC SaveSearchFullText	254238551
EXEC SaveSearchFullText	137156287
EXEC SaveSearchFullText	145376287
EXEC SaveSearchFullText	254240603
EXEC SaveSearchFullText	542275
EXEC SaveSearchFullText	20955784
EXEC SaveSearchFullText	254240190
EXEC SaveSearchFullText	254241107
EXEC SaveSearchFullText	102972244
EXEC SaveSearchFullText	540986
EXEC SaveSearchFullText	254239784
EXEC SaveSearchFullText	254240694
EXEC SaveSearchFullText	540390
EXEC SaveSearchFullText	254239724
EXEC SaveSearchFullText	541156
EXEC SaveSearchFullText	254239996
EXEC SaveSearchFullText	254239514
EXEC SaveSearchFullText	254239086
EXEC SaveSearchFullText	540690
EXEC SaveSearchFullText	254239256
EXEC SaveSearchFullText	659114
EXEC SaveSearchFullText	254239641
EXEC SaveSearchFullText	254238856
EXEC SaveSearchFullText	254241120
EXEC SaveSearchFullText	21652349
EXEC SaveSearchFullText	540502
EXEC SaveSearchFullText	14927853
EXEC SaveSearchFullText	148524332
EXEC SaveSearchFullText	143747587
EXEC SaveSearchFullText	254239862
EXEC SaveSearchFullText	148524314
EXEC SaveSearchFullText	106121798
EXEC SaveSearchFullText	145377147
EXEC SaveSearchFullText	538817
EXEC SaveSearchFullText	20955785
EXEC SaveSearchFullText	541687
EXEC SaveSearchFullText	254238825
EXEC SaveSearchFullText	9043025
EXEC SaveSearchFullText	812770
EXEC SaveSearchFullText	254240032
EXEC SaveSearchFullText	541821
EXEC SaveSearchFullText	66322362
EXEC SaveSearchFullText	541850
EXEC SaveSearchFullText	254240665
EXEC SaveSearchFullText	254240076
EXEC SaveSearchFullText	254240788
EXEC SaveSearchFullText	95707764
EXEC SaveSearchFullText	542444
EXEC SaveSearchFullText	836031
EXEC SaveSearchFullText	540953
EXEC SaveSearchFullText	254241294
EXEC SaveSearchFullText	97299537
EXEC SaveSearchFullText	140626724
EXEC SaveSearchFullText	254240434
EXEC SaveSearchFullText	20955764
EXEC SaveSearchFullText	14927839
EXEC SaveSearchFullText	254241169
EXEC SaveSearchFullText	254238863
EXEC SaveSearchFullText	17564359
EXEC SaveSearchFullText	20314141
EXEC SaveSearchFullText	254240435
EXEC SaveSearchFullText	35041987
EXEC SaveSearchFullText	254239464
EXEC SaveSearchFullText	19030787
EXEC SaveSearchFullText	541081
EXEC SaveSearchFullText	254240174
EXEC SaveSearchFullText	111274043
EXEC SaveSearchFullText	254240402
EXEC SaveSearchFullText	254239376
EXEC SaveSearchFullText	541019
EXEC SaveSearchFullText	143747587
EXEC SaveSearchFullText	540744
EXEC SaveSearchFullText	540690
EXEC SaveSearchFullText	540634
EXEC SaveSearchFullText	541156
EXEC SaveSearchFullText	540526
EXEC SaveSearchFullText	541870
EXEC SaveSearchFullText	254241015
EXEC SaveSearchFullText	631956
EXEC SaveSearchFullText	16162183
EXEC SaveSearchFullText	88695607
EXEC SaveSearchFullText	254240658
EXEC SaveSearchFullText	538734
EXEC SaveSearchFullText	71673370
EXEC SaveSearchFullText	98552981
EXEC SaveSearchFullText	775988
EXEC SaveSearchFullText	70062659
EXEC SaveSearchFullText	17564359
EXEC SaveSearchFullText	254239967
EXEC SaveSearchFullText	541011
EXEC SaveSearchFullText	71673370
EXEC SaveSearchFullText	254241240
EXEC SaveSearchFullText	376968
EXEC SaveSearchFullText	66322517
EXEC SaveSearchFullText	148524306
EXEC SaveSearchFullText	132160713
EXEC SaveSearchFullText	20955774
EXEC SaveSearchFullText	540953
EXEC SaveSearchFullText	538168
EXEC SaveSearchFullText	140626720
EXEC SaveSearchFullText	541985
EXEC SaveSearchFullText	21652349
EXEC SaveSearchFullText	254240945
EXEC SaveSearchFullText	565987
EXEC SaveSearchFullText	254240926
EXEC SaveSearchFullText	145377141
EXEC SaveSearchFullText	542187
EXEC SaveSearchFullText	23989713
EXEC SaveSearchFullText	254238601
EXEC SaveSearchFullText	150005974
EXEC SaveSearchFullText	540467
EXEC SaveSearchFullText	16162183
EXEC SaveSearchFullText	254239552
EXEC SaveSearchFullText	49105882
EXEC SaveSearchFullText	254239453
EXEC SaveSearchFullText	254239877
EXEC SaveSearchFullText	106121798
EXEC SaveSearchFullText	106121799
EXEC SaveSearchFullText	540502
EXEC SaveSearchFullText	812769
EXEC SaveSearchFullText	28615595
EXEC SaveSearchFullText	542344
EXEC SaveSearchFullText	108476897
EXEC SaveSearchFullText	254239165
EXEC SaveSearchFullText	254239308
EXEC SaveSearchFullText	254240152
EXEC SaveSearchFullText	541765
EXEC SaveSearchFullText	542508
EXEC SaveSearchFullText	66322782
EXEC SaveSearchFullText	538973
EXEC SaveSearchFullText	111274043
EXEC SaveSearchFullText	19771909
EXEC SaveSearchFullText	16162183
EXEC SaveSearchFullText	145376287
EXEC SaveSearchFullText	254238739
EXEC SaveSearchFullText	541211
EXEC SaveSearchFullText	19771909
EXEC SaveSearchFullText	541264
EXEC SaveSearchFullText	63444598
EXEC SaveSearchFullText	254240617
EXEC SaveSearchFullText	140626866
EXEC SaveSearchFullText	538373
EXEC SaveSearchFullText	538397
EXEC SaveSearchFullText	579032
EXEC SaveSearchFullText	20955784
EXEC SaveSearchFullText	113304475
EXEC SaveSearchFullText	40978137
EXEC SaveSearchFullText	9043025
EXEC SaveSearchFullText	254240300
EXEC SaveSearchFullText	35042008
EXEC SaveSearchFullText	140626724
EXEC SaveSearchFullText	34566839
EXEC SaveSearchFullText	542508
EXEC SaveSearchFullText	70062642
EXEC SaveSearchFullText	76651981
EXEC SaveSearchFullText	254241282
EXEC SaveSearchFullText	254240348
EXEC SaveSearchFullText	541850
EXEC SaveSearchFullText	254240802
EXEC SaveSearchFullText	541946
EXEC SaveSearchFullText	379167
EXEC SaveSearchFullText	542054
EXEC SaveSearchFullText	540562
EXEC SaveSearchFullText	102971693
EXEC SaveSearchFullText	254238764
EXEC SaveSearchFullText	254240563
EXEC SaveSearchFullText	23989713
EXEC SaveSearchFullText	87308592
EXEC SaveSearchFullText	254239593
EXEC SaveSearchFullText	254240576
EXEC SaveSearchFullText	254240998
EXEC SaveSearchFullText	107153237
EXEC SaveSearchFullText	34566862
EXEC SaveSearchFullText	14927864
EXEC SaveSearchFullText	540986
EXEC SaveSearchFullText	40978106
EXEC SaveSearchFullText	254238779
EXEC SaveSearchFullText	541238
EXEC SaveSearchFullText	579032
EXEC SaveSearchFullText	132160707
EXEC SaveSearchFullText	254240673
EXEC SaveSearchFullText	541506
EXEC SaveSearchFullText	821133
EXEC SaveSearchFullText	26526828
EXEC SaveSearchFullText	133906565
EXEC SaveSearchFullText	70062636
EXEC SaveSearchFullText	119366275
EXEC SaveSearchFullText	63444488
EXEC SaveSearchFullText	254239349
EXEC SaveSearchFullText	132160713
EXEC SaveSearchFullText	107153236
EXEC SaveSearchFullText	254239743
EXEC SaveSearchFullText	21652350
EXEC SaveSearchFullText	254239912
EXEC SaveSearchFullText	558520
EXEC SaveSearchFullText	254240143
EXEC SaveSearchFullText	11669093
EXEC SaveSearchFullText	20955764
EXEC SaveSearchFullText	254240555
EXEC SaveSearchFullText	17564346
EXEC SaveSearchFullText	254240684
EXEC SaveSearchFullText	14927839
EXEC SaveSearchFullText	17564364
EXEC SaveSearchFullText	254238775
EXEC SaveSearchFullText	379167
EXEC SaveSearchFullText	116289103
EXEC SaveSearchFullText	254239716
EXEC SaveSearchFullText	542054
EXEC SaveSearchFullText	33502179
EXEC SaveSearchFullText	2445295
EXEC SaveSearchFullText	541097
EXEC SaveSearchFullText	137156337
EXEC SaveSearchFullText	145377133
EXEC SaveSearchFullText	540590
EXEC SaveSearchFullText	113304475
EXEC SaveSearchFullText	88695609
EXEC SaveSearchFullText	812770
EXEC SaveSearchFullText	254240062
EXEC SaveSearchFullText	20314141
EXEC SaveSearchFullText	254240343
EXEC SaveSearchFullText	659114
EXEC SaveSearchFullText	812769
EXEC SaveSearchFullText	254239940
EXEC SaveSearchFullText	70062642
EXEC SaveSearchFullText	28095011
EXEC SaveSearchFullText	88695607
EXEC SaveSearchFullText	254238868
EXEC SaveSearchFullText	30789591
EXEC SaveSearchFullText	538758
EXEC SaveSearchFullText	13533751
EXEC SaveSearchFullText	254238831
EXEC SaveSearchFullText	254241154
EXEC SaveSearchFullText	538737
EXEC SaveSearchFullText	15548065
EXEC SaveSearchFullText	145377114
EXEC SaveSearchFullText	254239604
EXEC SaveSearchFullText	541211
EXEC SaveSearchFullText	148524313
EXEC SaveSearchFullText	836016
EXEC SaveSearchFullText	20955785