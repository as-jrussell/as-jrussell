USE [UniTrac]
GO 

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT L.NUMBER_TX INTO #tmpL
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '6229' ) --AND RC.SUMMARY_STATUS_CD = 'N'
        AND L.NUMBER_TX IN ( '1249-1200', '132004-1401', '13310-2800',
                             '1479-2002', '155200-2000', '162270-1000',
                             '164240-1001', '165290-2001', '1669-1201',
                             '168450-2000', '168600-1201', '168920-1000',
                             '169100-1203', '169100-2003', '171270-1001',
                             '171723-2200', '173400-1202', '18590-1201',
                             '18810-1200', '19430-1200', '20780-1201',
                             '2119-1000', '221180-2001', '221180-2002',
                             '221310-1000', '221430-1201', '221430-1202',
                             '221460-1208', '221940-1200', '222050-2000',
                             '222050-2000', '222600-2000', '222650-1200',
                             '223422-2003', '224002-1200', '224042-1400',
                             '224092-2000', '231370-2001', '231370-2001',
                             '233535-1202', '234905-1200', '236090-1201',
                             '236156-1200', '236466-1201', '236466-2000',
                             '236636-1200', '236926-2000', '237056-1200',
                             '237115-2000', '237779-2000', '237779-2001',
                             '237869-2004', '238078-1202', '238239-1200',
                             '238959-1201', '238959-2000', '239108-1203',
                             '239168-1200', '239239-1400', '239298-1200',
                             '239519-1201', '239840-1201', '24020-2003',
                             '240209-1202', '240480-2001', '241081-2002',
                             '242703-1202', '242943-2001', '243203-2000',
                             '244685-1401', '245027-2000', '245177-1000',
                             '245207-1001', '245747-1000', '24760-1001',
                             '247709-1201', '248200-2000', '248690-1200',
                             '250805-2000', '25150-1200', '253789-1201',
                             '253999-1200', '25460-1200', '254739-1200',
                             '254849-1000', '256019-1200', '256039-2003',
                             '256059-1000', '256069-1204', '256353-1201',
                             '256363-1201', '256363-2001', '26040-1000',
                             '260595-1001', '260615-2000', '260685-1000',
                             '260920-1000', '261222-1201', '261530-2003',
                             '261535-1202', '261664-2000', '261715-2001',
                             '261775-1200', '261925-1201', '262075-2000',
                             '262760-1201', '262784-1201', '263074-2000',
                             '263377-1201', '264177-2000', '264200-2000',
                             '264390-1200', '264390-1204', '264510-1000',
                             '266930-1000', '266950-2000', '267360-2001',
                             '268250-1205', '269242-1000', '269402-2001',
                             '269675-1200', '270422-1200', '270605-1202',
                             '270605-2001', '270692-1201', '270692-2001',
                             '27090-2000', '270962-1201', '271110-1800',
                             '271140-1000', '271140-2001', '271200-1800',
                             '271482-2002', '271622-1001', '271792-1201',
                             '272032-1202', '272032-2000', '272530-1201',
                             '273840-1201', '274300-1400', '274350-1000',
                             '274540-1001', '274622-1000', '274622-1001',
                             '274782-1204', '274802-1200', '274802-2004',
                             '275019-1000', '275945-1800', '276475-1000',
                             '3061420-2000', '3061900-2000', '3062000-1000',
                             '3062000-1200', '3062830-1200', '3063090-1202',
                             '3063580-2000', '3063580-2000', '3064170-1400',
                             '3064320-1000', '3064530-1200', '3064590-1800',
                             '3064600-2000', '3065460-1201', '3066160-1200',
                             '3066240-1200', '3066430-1000', '3067680-1200',
                             '3068120-2002', '3068120-2002', '3069210-1200',
                             '3069620-1202', '3069680-1200', '3069800-1200',
                             '3070250-1202', '3071130-1201', '3072260-1207',
                             '3073000-1203', '3073050-2000', '3073310-1200',
                             '3073310-2000', '3073520-1200', '3074400-1201',
                             '3074400-2000', '3075030-2001', '3075500-2001',
                             '3075500-2002', '3075690-1000', '3075690-1003',
                             '3076040-2003', '3077330-1201', '3078820-2000',
                             '3080330-1203', '3080450-1000', '3080630-1203',
                             '3080740-1201', '3081010-2000', '3081320-1200',
                             '3081430-2000', '3082010-1000', '3082680-1200',
                             '3082940-2000', '3083020-2000', '3085490-1200',
                             '3085810-2000', '3086980-1200', '3087180-2000',
                             '3087360-1200', '3087860-2000', '3088700-1201',
                             '3089200-2000', '3089430-1201', '3089430-2002',
                             '3089580-1201', '3090810-1200', '3091000-1200',
                             '3091130-1200', '3091240-2003', '3091510-2000',
                             '3092030-1204', '3092700-2001', '3092700-2001',
                             '3093380-2000', '3094060-1201', '3094270-1201',
                             '3094470-2000', '3095010-1200', '3096200-1201',
                             '3096370-1001', '3096440-1200', '3096530-1201',
                             '3096550-2000', '3096590-2000', '3096730-1200',
                             '3097240-1200', '3097940-1400', '3098070-1200',
                             '3098950-1000', '3099000-1200', '3099000-2000',
                             '3099000-2001', '3099040-1400', '3100280-1201',
                             '3100550-1200', '3101290-1001', '3101520-2000',
                             '3102500-2001', '3102580-2000', '3103510-2000',
                             '3103760-1202', '3104520-1200', '3104520-1201',
                             '3104520-2000', '3104520-2001', '3104730-1200',
                             '3105470-2000', '3105570-1400', '3105730-2000',
                             '3106140-1200', '3106390-2000', '3106970-1202',
                             '3107260-1200', '3107590-2000', '3108140-1400',
                             '33560-2000', '341310-2000', '341840-2000',
                             '36310-2800', '4000076-2000', '4000208-2800',
                             '4000287-1200', '4000308-1800', '4000316-1000',
                             '4000521-2001', '4000767-1201', '4000791-2000',
                             '4000960-1202', '4000995-2000', '4001088-2001',
                             '4001113-2000', '4001179-1200', '4001265-1200',
                             '4001327-1201', '4001327-1202', '4001407-1201',
                             '4001472-1200', '4001556-1207', '4001738-1200',
                             '4001794-1200', '4001796-1200', '4001905-1200',
                             '4001946-1800', '4002211-2000', '4002396-1401',
                             '4002599-2001', '4002633-1400', '4002636-2000',
                             '4002653-1200', '4002716-1200', '4002728-1400',
                             '4002807-1202', '4002906-2000', '4002915-1200',
                             '4002915-2000', '4002915-2001', '4002949-1200',
                             '4003056-1200', '4003068-2800', '4003075-1200',
                             '4003100-1200', '4003100-1201', '4003112-2800',
                             '4003193-1401', '4003274-1200', '4003320-1200',
                             '4003332-2800', '4003392-1801', '4003447-2000',
                             '4003491-2800', '4003573-1201', '4003623-2800',
                             '4003633-1200', '4003713-1200', '4003718-1400',
                             '4003733-1200', '4003742-1202', '4003779-1400',
                             '4003831-1800', '4003924-2800', '4004042-1400',
                             '4004064-2800', '4004070-1200', '4004075-1200',
                             '4004159-2000', '4004159-2000', '4004219-1200',
                             '4004254-1200', '4004291-1401', '4004297-1200',
                             '4004349-1400', '4004386-1000', '4004386-1001',
                             '4004454-1200', '4004517-1200', '4004637-1400',
                             '4004638-1200', '4004640-1200', '4004686-1201',
                             '4004694-1400', '4004751-1400', '4004771-2800',
                             '4004807-2000', '4004993-1001', '4004997-1000',
                             '4005120-2001', '4005174-1400', '4005178-2000',
                             '4005213-1800', '4005249-1200', '4005287-1400',
                             '4005343-1200', '4005611-1201', '4005614-2800',
                             '4005618-1200', '4005661-1200', '4005782-1401',
                             '4005832-2000', '4005917-1201', '4006042-1400',
                             '4006164-1000', '4006202-2800', '4006336-1200',
                             '4006375-1200', '4006420-1202', '4006424-1800',
                             '4006451-2000', '4006508-1000', '4006624-1400',
                             '4006642-1800', '4006642-2000', '4006727-1200',
                             '4006766-1400', '4006877-1200', '4006902-1800',
                             '4006954-1200', '4006976-1400', '4007050-1400',
                             '4007062-1400', '4007154-1200', '4007168-2000',
                             '4007194-1200', '4007202-1200', '4007360-1400',
                             '4007398-2000', '4007428-1400', '4007480-2800',
                             '4007531-1400', '4007618-1400', '4007758-1400',
                             '4007765-1402', '4007968-1200', '4008003-1200',
                             '4008106-1200', '4008106-2000', '4008153-1400',
                             '4008278-1200', '4008448-1200', '4008531-1201',
                             '4008548-1200', '4008581-1000', '4008603-1200',
                             '4008699-1000', '4008729-1400', '4008919-2000',
                             '4009044-1400', '4009127-2800', '4009135-2000',
                             '4009143-1200', '4009217-1400', '4009259-1400',
                             '4009263-2000', '4009401-1200', '4009488-1400',
                             '4009501-1200', '4009566-1400', '4009718-1201',
                             '4009763-1400', '4009768-1800', '4009866-2000',
                             '4009885-2000', '4009956-2800', '4009972-1400',
                             '4009987-1200', '4010130-1400', '4010203-1200',
                             '4010254-1200', '4010276-1200', '4010334-1401',
                             '4010393-1400', '4010512-1200', '4010576-2000',
                             '4010637-1800', '4010648-2000', '4010774-1400',
                             '4010788-1400', '4010809-2000', '4010896-1000',
                             '4010921-1400', '4010974-1400', '4010998-1200',
                             '4011039-2000', '4011232-1200', '4011255-1200',
                             '4011281-1200', '4011501-1400', '4011584-1200',
                             '4011585-1200', '4011888-1400', '4011898-1600',
                             '4011946-1200', '4012033-1200', '4012097-1400',
                             '4012127-1200', '4012141-2000', '4012193-1200',
                             '4012227-1800', '449460-2000', '449810-1200',
                             '450290-1200', '454200-1200', '455340-2003',
                             '455650-2000', '50060-2000', '501320-1000',
                             '502730-1200', '503150-2002', '504990-1200',
                             '505370-1203', '508910-1200', '509320-1200',
                             '514040-2000', '514970-1200', '514970-2001',
                             '516630-2001', '516890-1002', '519400-1201',
                             '523670-2000', '527750-1202', '528330-1000',
                             '528420-1200', '528600-2001', '529620-1201',
                             '530200-2000', '531540-1201', '534200-2000',
                             '534750-1000', '535800-1200', '535800-1201',
                             '538210-1200', '540840-1201', '542840-2000',
                             '545850-2001', '546230-1000', '546630-1201',
                             '546630-1201', '547830-1200', '548800-2001',
                             '548800-2001', '548800-2001', '548800-2001',
                             '548800-2001', '550150-1200', '565440-1201',
                             '569480-1400', '571190-1800', '574-2000',
                             '575310-1200', '578040-2005', '578630-1000',
                             '578630-2001', '578800-2000', '581310-2002',
                             '582440-1201', '582782-1400', '583090-1000',
                             '585180-1200', '585300-1200', '585540-1000',
                             '586690-1201', '587740-1000', '588150-1201',
                             '590140-2000', '591540-2000', '593837-2000',
                             '593849-1400', '594154-2000', '594169-2000',
                             '594722-1003', '594982-1000', '595792-1200',
                             '596335-1201', '596343-1000', '597416-1004',
                             '597416-2000', '598467-2001', '601133-1200',
                             '601133-1201', '601233-1202', '601733-1200',
                             '60190-1200', '602173-2000', '602704-1202',
                             '604112-1201', '604785-1800', '605420-1204',
                             '605990-1200', '606280-1000', '606520-1205',
                             '608050-1201', '608574-1202', '608902-1203',
                             '609114-1203', '609271-1203', '609284-1200',
                             '610177-1201', '610286-2000', '610306-1000',
                             '610351-2001', '610437-1200', '610559-1400',
                             '610830-1000', '610931-1200', '610986-1200',
                             '611311-1200', '611311-1201', '611351-1202',
                             '611449-1201', '611449-1202', '611521-2001',
                             '611831-2001', '611890-2800', '612039-1201',
                             '612519-2000', '612899-1200', '613103-1201',
                             '613470-1001', '613789-2000', '613929-1000',
                             '614583-1000', '615930-1203', '616369-1201',
                             '616789-1001', '616820-1000', '618129-1200',
                             '619791-1201', '619990-1200', '620180-1200',
                             '625-1001', '627-1202', '644080-1200',
                             '646230-1200', '647190-2000', '647190-2002',
                             '647250-1202', '648260-1200', '654440-2000',
                             '656700-1200', '659810-1205', '660163-1400',
                             '670480-1201', '670850-1000', '676070-1000',
                             '676070-1201', '676640-1200', '676640-2000',
                             '676910-1201', '677240-1201', '677900-1200',
                             '681-1202', '687050-1200', '691650-1001',
                             '693230-1200', '693340-1000', '693570-1200',
                             '695040-1000', '695240-1201', '697390-1001',
                             '697390-1003', '698640-1200', '698710-1203',
                             '699-1000', '699-1201', '699730-1001',
                             '704690-1201', '704700-2001', '705193-1001',
                             '705290-1000', '706120-1000', '708260-1000',
                             '708323-1202', '708323-1600', '708460-1001',
                             '708460-2000', '710240-1000', '710850-1202',
                             '711540-1202', '711540-1203', '712240-1200',
                             '713800-1200', '715390-2000', '715670-1200',
                             '716640-2000', '716830-2000', '718810-1000',
                             '718970-1000', '718970-1200', '721-2004',
                             '723220-1002', '723240-2000', '723790-1000',
                             '724800-2000', '725690-1200', '725720-1000',
                             '726110-1201', '726240-1000', '729730-1000',
                             '729730-1202', '732850-1201', '732890-1201',
                             '733090-1000', '734920-1200', '740890-2000',
                             '741900-2001', '742650-1000', '743270-1400',
                             '744750-1000', '745190-1200', '745540-2000',
                             '745650-1000', '745850-1203', '746200-1000',
                             '746720-2000', '748150-2000', '748300-2000',
                             '748870-2000', '750620-2003', '750620-2004',
                             '752120-2000', '753290-1200', '753460-1002',
                             '754010-1201', '755010-1201', '758360-1200',
                             '758770-1000', '758860-1201', '759150-1200',
                             '759980-2000', '760070-1201', '760570-1200',
                             '760910-1202', '761080-1400', '761320-1000',
                             '761390-1200', '763550-1207', '763550-2002',
                             '764210-1002', '764500-1000', '764690-1201',
                             '765680-1202', '766310-2000', '766810-1201',
                             '767080-1201', '767770-2000', '767940-1204',
                             '768150-2000', '768440-1201', '768860-1200',
                             '768980-2000', '769760-1200', '772-1205',
                             '802940-1000', '803585-1000', '803665-1201',
                             '803795-1200', '80390-1200', '805065-2001',
                             '805185-1400', '805606-2000', '805650-1201',
                             '805700-2001', '805856-1200', '806665-1200',
                             '806765-1201', '806895-2001', '806915-1400',
                             '806920-1200', '807125-1000', '807135-1203',
                             '807670-2000', '807975-2000', '809485-1001',
                             '811375-1201', '811620-1001', '813810-2000',
                             '813855-1200', '814150-2000', '814905-1001',
                             '815240-1203', '815385-1200', '815730-2001',
                             '815785-1000', '816510-1201', '817155-1200',
                             '817205-2000', '817830-1000', '818330-2000',
                             '81890-1200', '819595-2000', '825950-1202',
                             '829560-2005', '833160-2001', '833350-1201',
                             '833400-1200', '836070-1000', '845080-2000',
                             '849330-1200', '850330-1000', '852120-2000',
                             '852650-1201', '855820-1007', '856880-1000',
                             '858450-2000', '860240-2000', '870620-1201',
                             '871200-2000', '871880-1201', '872660-2000',
                             '874580-1002', '879490-1000', '879930-1001',
                             '882430-1200', '886530-2000', '887640-1201',
                             '888540-1202', '890990-1203', '891100-2000',
                             '892140-1200', '893300-2001', '896160-1200',
                             '898180-1001', '933-2002' )




SELECT SUMMARY_STATUS_CD, SUMMARY_SUB_STATUS_CD, INSURANCE_STATUS_CD, INSURANCE_SUB_STATUS_CD, * 
--INTO UniTracHDStorage..INC0271852
FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT * FROM #tmpRC)




UPDATE dbo.REQUIRED_COVERAGE
SET SUMMARY_STATUS_CD = 'A', INSURANCE_STATUS_CD = 'A', 
UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0271852', GOOD_THRU_DT = NULL
WHERE ID IN (SELECT * FROM #tmpRC)



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , ' INC0271852' , 'N' , 
 GETDATE() ,  1 , 
 'Placed loans into Audit Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0271852)



SELECT L.NUMBER_TX,P.ID INTO #tmpP FROM dbo.REQUIRED_COVERAGE RC
JOIN UniTracHDStorage..INC0271852 I ON I.ID = RC.ID
JOIN dbo.PROPERTY P ON P.ID = RC.PROPERTY_ID
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID


SELECT L.NUMBER_TX,RC.SUMMARY_STATUS_CD,  L.* FROM dbo.REQUIRED_COVERAGE RC
JOIN dbo.PROPERTY P ON P.ID = RC.PROPERTY_ID
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (141220142,146257856,44358434,76640266,28009297,32195643,93880343,3821710,107708936,76640266,4015381,76640266)