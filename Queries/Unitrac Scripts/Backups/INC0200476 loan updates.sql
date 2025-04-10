SELECT  *
INTO    UniTracHDStorage.dbo.LOAN_1630_1
FROM    LOAN
WHERE   NUMBER_TX IN ( '25343L26.7 ', '25343L62.1 ', '28432L62.1 ',
                       '28432L62.2 ', '28432L64   ', '31337L62   ',
                       '31337L64   ', '32449L62.2 ', '35589L62.3 ',
                       '39689L62.3 ', '39689L64   ', '45551L64.1 ',
                       '48842L64   ', '49621L64   ', '49911L62.1 ',
                       '61317L62   ', '63457L62   ', '63831L62   ',
                       '68628L64   ', '70931L62.2 ', '81835L37.1 ',
                       '700438L62.2', '700785L64  ', '702602L64  ',
                       '705083L62  ', '705969L62  ', '709482L62.1',
                       '703540L62  ', '22289L13   ', '11672L62   ',
                       '49911L62   ', '66800L62   ', '28432L62.7 ',
                       '45245L64   ', '702804L62  ', '42527L62.1 ',
                       '42527L62.5 ' )
        AND LENDER_ID = 13;



		SELECT * FROM UniTracHDStorage..LOAN_1630_1


		UPDATE  LOAN
SET     NUMBER_TX = '300987591' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '25343L26.7'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '300987617' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '25343L62.1'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '300999855' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '28432L62.1'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '300999864' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '28432L62.2'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '300999980' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '28432L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301013132' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '31337L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301013141' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '31337L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301019074' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '32449L62.2'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301035895' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '35589L62.3'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301057629' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '39689L62.3'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301057665' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '39689L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301086116' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '45551L64.1'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301103286' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '48842L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301107013' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '49621L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301108566' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '49911L62.1'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301123683' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '61317L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301134172' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '63457L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301136250' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '63831L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301161463' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '68628L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301173584' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '70931L62.2'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301186428' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '81835L37.1'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301230219' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '700438L62.2'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301231879' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '700785L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301241056' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '702602L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301250571' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '705083L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301254416' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '705969L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301342624' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '703540L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301267974' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '709482L62.1'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301342624' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '703540L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301358493' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '22289L13'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301370344' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '11672L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301378694' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '49911L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301382705' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '66800L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301438503' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '28432L62.7'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301440554' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '45245L64'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '301461585' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '702804L62'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '307265982' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '42527L62.1'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		UPDATE  LOAN
SET     NUMBER_TX = '307265991' ,
        UPDATE_DT = GETDATE() ,
        UPDATE_USER_TX = 'INC0200476'
WHERE   NUMBER_TX = '42527L62.5'
        AND LENDER_ID = 13
        AND PURGE_DT IS NULL

		--2) INSERT into PROPERTY_CHANGE table
INSERT INTO PROPERTY_CHANGE (ENTITY_NAME_TX,ENTITY_ID,USER_TX,ATTACHMENT_IN,CREATE_DT,AGENCY_ID,DETAILS_IN,FORMATTED_IN,LOCK_ID,PARENT_NAME_TX,PARENT_ID,TRANS_STATUS_CD,UTL_IN)
SELECT 'Allied.UniTrac.Loan',LOAN.ID,'INC0200476','N','2015-08-24 00:00:00.000',1,'Y','N',1,'Allied.UniTrac.Loan',LOAN.ID,'PEND','N'
FROM LOAN
WHERE ID IN (SELECT ID FROM UnitracHDStorage.dbo.LOAN_1630_1)
--80


--3) INSERT into PROPERTY_CHANGE_UPDATE table

INSERT INTO PROPERTY_CHANGE_UPDATE (CHANGE_ID, TABLE_NAME_TX, TABLE_ID, COLUMN_NM, FROM_VALUE_TX,TO_VALUE_TX,DATATYPE_NO,CREATE_DT,DISPLAY_IN,OPERATION_CD)

select PROPERTY_CHANGE.ID,'LOAN',ENTITY_ID,'NUMBER_TX', UniTracHDStorage..LOAN_1630_1.NUMBER_TX,LOAN.NUMBER_TX,1,'2015-08-24 00:00:00.000','Y','U'
from PROPERTY_CHANGE
INNER JOIN LOAN ON PROPERTY_CHANGE.ENTITY_ID = LOAN.ID AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
INNER JOIN UnitracHDStorage.dbo.LOAN_1630_1 ON LOAN.ID = UniTracHDStorage..LOAN_1630_1.ID --AND ENTITY_NAME_TX = 'Allied.UniTrac.Loan' 
WHERE PROPERTY_CHANGE.CREATE_DT = '2015-08-24 00:00:00.000'
AND ENTITY_ID IN (SELECT ID FROM UnitracHDStorage.dbo.LOAN_1630_1)

---4) Insert into LOAN_NUMBER Table (Leave old numbers for matching purposes)

INSERT INTO LOAN_NUMBER (LOAN_ID,NUMBER_TX,EFFECTIVE_DT,CREATE_DT,UPDATE_DT,UPDATE_USER_TX, LOCK_ID)
SELECT dbo.LOAN.ID, dbo.LOAN.NUMBER_TX,dbo.LOAN.EFFECTIVE_DT,GETDATE(),GETDATE(),'INC0200476',1
FROM UnitracHDStorage.dbo.LOAN_1630_1 HD INNER JOIN dbo.LOAN ON HD.ID = LOAN.ID


--5) Full Text Search Updates

--Create updates
SELECT 'EXEC SaveSearchFullText', PROPERTY.ID 
FROM PROPERTY
INNER JOIN COLLATERAL ON PROPERTY.ID = COLLATERAL.PROPERTY_ID
AND LOAN_ID in (select ID FROM UnitracHDStorage.dbo.LOAN_1630_1)

EXEC SaveSearchFullText	1003648
EXEC SaveSearchFullText	1621093
EXEC SaveSearchFullText	1621100
EXEC SaveSearchFullText	1621113
EXEC SaveSearchFullText	1621111
EXEC SaveSearchFullText	21221329
EXEC SaveSearchFullText	80916290
EXEC SaveSearchFullText	1621118
EXEC SaveSearchFullText	1747882
EXEC SaveSearchFullText	1747911
EXEC SaveSearchFullText	1747925
EXEC SaveSearchFullText	1747937
EXEC SaveSearchFullText	1747949
EXEC SaveSearchFullText	1796798
EXEC SaveSearchFullText	1796807
EXEC SaveSearchFullText	1843120
EXEC SaveSearchFullText	1901231
EXEC SaveSearchFullText	1969560
EXEC SaveSearchFullText	1969567
EXEC SaveSearchFullText	1995774
EXEC SaveSearchFullText	2074412
EXEC SaveSearchFullText	2115120
EXEC SaveSearchFullText	2127602
EXEC SaveSearchFullText	10298098
EXEC SaveSearchFullText	10299371
EXEC SaveSearchFullText	14451044
EXEC SaveSearchFullText	2149302
EXEC SaveSearchFullText	2149300
EXEC SaveSearchFullText	2114623
EXEC SaveSearchFullText	2090486
EXEC SaveSearchFullText	2085750
EXEC SaveSearchFullText	1990494
EXEC SaveSearchFullText	1962812
EXEC SaveSearchFullText	1947710
EXEC SaveSearchFullText	1923181
EXEC SaveSearchFullText	1650566
EXEC SaveSearchFullText	983667
EXEC SaveSearchFullText	956331
EXEC SaveSearchFullText	22661003
EXEC SaveSearchFullText	25367589
EXEC SaveSearchFullText	19997434
EXEC SaveSearchFullText	13165631
EXEC SaveSearchFullText	63380877
EXEC SaveSearchFullText	71552168
EXEC SaveSearchFullText	72870557
EXEC SaveSearchFullText	19997378
EXEC SaveSearchFullText	19997389
EXEC SaveSearchFullText	19997423
EXEC SaveSearchFullText	84757540
EXEC SaveSearchFullText	92391990
EXEC SaveSearchFullText	88178883
EXEC SaveSearchFullText	97142607
EXEC SaveSearchFullText	97142608
EXEC SaveSearchFullText	90078771
EXEC SaveSearchFullText	93172666
EXEC SaveSearchFullText	94488667
EXEC SaveSearchFullText	18579073
EXEC SaveSearchFullText	36872484
EXEC SaveSearchFullText	55391265
EXEC SaveSearchFullText	71552163
EXEC SaveSearchFullText	37616487
EXEC SaveSearchFullText	18579062
EXEC SaveSearchFullText	42651724
EXEC SaveSearchFullText	18579061
EXEC SaveSearchFullText	18579057
EXEC SaveSearchFullText	47438184
EXEC SaveSearchFullText	18579054
EXEC SaveSearchFullText	18579046
EXEC SaveSearchFullText	21220532
EXEC SaveSearchFullText	23583477
EXEC SaveSearchFullText	76544114
EXEC SaveSearchFullText	94488666
EXEC SaveSearchFullText	18579041
EXEC SaveSearchFullText	18579045
EXEC SaveSearchFullText	18579039
EXEC SaveSearchFullText	18579038
EXEC SaveSearchFullText	18579035
EXEC SaveSearchFullText	18579031
EXEC SaveSearchFullText	18579029
EXEC SaveSearchFullText	18579025
EXEC SaveSearchFullText	18579011
EXEC SaveSearchFullText	18579003
EXEC SaveSearchFullText	18579000
EXEC SaveSearchFullText	18578992
EXEC SaveSearchFullText	55391267
EXEC SaveSearchFullText	18578991
EXEC SaveSearchFullText	19997394
EXEC SaveSearchFullText	19997410
EXEC SaveSearchFullText	19997397
EXEC SaveSearchFullText	19997411
EXEC SaveSearchFullText	19997399
EXEC SaveSearchFullText	19997409
EXEC SaveSearchFullText	19997403
EXEC SaveSearchFullText	19997420
EXEC SaveSearchFullText	19997426
EXEC SaveSearchFullText	19997437
EXEC SaveSearchFullText	19997434
EXEC SaveSearchFullText	19997452
EXEC SaveSearchFullText	19997435
EXEC SaveSearchFullText	19997446
EXEC SaveSearchFullText	95709488
EXEC SaveSearchFullText	95709489
EXEC SaveSearchFullText	19997445
EXEC SaveSearchFullText	19997466
EXEC SaveSearchFullText	19997448
EXEC SaveSearchFullText	19997462
EXEC SaveSearchFullText	19997455
EXEC SaveSearchFullText	19997467
EXEC SaveSearchFullText	74197030
EXEC SaveSearchFullText	22659305
EXEC SaveSearchFullText	71552162
EXEC SaveSearchFullText	75794240
EXEC SaveSearchFullText	64672704
EXEC SaveSearchFullText	32259410
EXEC SaveSearchFullText	32585071
EXEC SaveSearchFullText	32585076
EXEC SaveSearchFullText	32585079
EXEC SaveSearchFullText	32585081
EXEC SaveSearchFullText	32585084
EXEC SaveSearchFullText	32585086
EXEC SaveSearchFullText	32585088
EXEC SaveSearchFullText	32585094
EXEC SaveSearchFullText	32739997
EXEC SaveSearchFullText	32585103




	SELECT * FROM dbo.PROPERTY_CHANGE