﻿USE Unitrac

SELECT  --INTO UniTracHDStorage..INC0321295_IH_Memo
FROM dbo.INTERACTION_HISTORY IH
JOIN dbo.PROPERTY P ON IH.PROPERTY_ID = P.ID
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE LL.CODE_TX ='3102' 
AND IH.TYPE_CD = 'MEMO' AND ih.PURGE_DT IS NOT NULL

--DROP TABLE #tmp

SELECT *  FROM dbo.INTERACTION_HISTORY
WHERE ID IN (SELECT DISTINCT ID FROM UniTracHDStorage..INC0321295_IH_Memo)
AND CREATE_USER_TX LIKE 'LDH%' AND PROPERTY_ID IN (SELECT DISTINCT PROPERTY_ID FROM UniTracHDStorage..INC0321295_IH_Memo)
AND PURGE_DT IS NULL

SELECT * FROM UniTracHDStorage..INC0321295


SELECT PROPERTY_ID, COUNT(PROPERTY_ID [Count]  
INTO #tmpPD
FROM dbo.INTERACTION_HISTORY
WHERE ID IN (SELECT DISTINCT ID FROM UniTracHDStorage..INC0321295_IH_Memo)
AND CREATE_USER_TX LIKE 'LDH%' AND PROPERTY_ID IN (SELECT DISTINCT PROPERTY_ID FROM UniTracHDStorage..INC0321295_IH_Memo)
GROUP BY PROPERTY_ID 
HAVING COUNT(PROPERTY_ID) >= '2'
ORDER BY COUNT(PROPERTY_ID) DESC

UPDATE ih
SET    ih.IN_HOUSE_ONLY_IN = 'Y' ,
       ih.UPDATE_DT = ih.CREATE_DT,
       ih.LOCK_ID = ih.LOCK_ID + 1 ,
       ih.UPDATE_USER_TX = 'INC0321295' ,
       ih.PURGE_DT = ih.CREATE_DT
--SELECT PURGE_DT, * 
FROM   dbo.INTERACTION_HISTORY ih
WHERE  ID IN (   SELECT ID
                 FROM   #tmp
             )
       AND ID NOT IN ( '324816259', '324816273', '327549535', '295124071' ,
                       '327549464' ,'295117922', '295117967', '295118041' ,
                       '295118144' ,'295124074', '295118300', '295124080' ,
                       '295118543' ,'295124085', '295118797', '295124098' ,
                       '295118948' ,'295118999', '295124105', '295119134' ,
                       '295119146' ,'295124125', '295124091', '324816365' ,
                       '324816512' ,'324816518', '324816459', '324816370' ,
                       '327550340' ,'295119242', '324816538', '318575136' ,
                       '324816253' ,'324816274', '327549374', '327550111' ,
                       '327550172' ,'327550248', '318575120', '318575126' ,
                       '324816465' ,'324816233', '295124113', '322509848' ,
                       '295119476' ,'295126134', '295126151', '322510231' ,
                       '322510031' ,'295124119', '322510255', '322224323' ,
                       '322223926' ,'295124127', '322510025', '295124161' ,
                       '322509970' ,'322510364', '322510189', '322510381' ,
                       '322509841' ,'346860758', '318574909', '322510296' ,
                       '322509804' ,'295124140', '295124133', '322510384' ,
                       '322510401' ,'322224319', '322510420', '322509845' ,
                       '322510156' ,'322509957', '322510138', '318575196' ,
                       '295120146' ,'318575020', '322509799', '322510098' ,
                       '322224453' ,'295124152', '295120185', '322510223' ,
                       '322510393' ,'322509913', '318575095', '295124167' ,
                       '333475854' ,'299438816', '322510059', '322509855' ,
                       '295120257' ,'322510355', '336960906', '322509917' ,
                       '295125865' ,'295124157', '295120344', '295125908' ,
                       '338760770' ,'322224058', '322224398', '322224275' ,
                       '322510238' ,'322510227', '322510141', '322510213' ,
                       '322224307' ,'322510390', '322510294', '322224372' ,
                       '295124171' ,'322510427', '322509863', '295125600' ,
                       '295120651' ,'295124175', '322510204', '322509793' ,
                       '322509779' ,'322509807', '322510447', '322510455' ,
                       '322510268' ,'322510214', '322510367', '322510449' ,
                       '322510454' ,'295125700', '295125740', '295120913' ,
                       '295120916' ,'295120959', '295120990', '295121001' ,
                       '295121006' ,'295121008', '295121043', '295121066' ,
                       '295121080' ,'295121099', '295121097', '322221840' ,
                       '322218465' ,'322221139', '318574962', '331753480' ,
                       '322221436' ,'295121185', '322222287', '318575118' ,
                       '318575310' ,'322222079', '322220380', '330422847' ,
                       '318574309' ,'318575308', '322222495', '318575279' ,
                       '322220343' ,'295121245', '295121286', '295121298' ,
                       '295121309' ,'295121330', '295121334', '295121405' ,
                       '295121424' ,'295121438', '295121442', '322219085' ,
                       '318575282' ,'322219689', '295121534', '318575108' ,
                       '322220163' ,'318574926', '318575291', '322220363' ,
                       '295121626' ,'295121638', '318575286', '295121683' ,
                       '322218738' ,'322221885', '295121720', '318575237' ,
                       '295121725' ,'295121730', '318575260', '322219296' ,
                       '322219469' ,'295121747', '295121753', '295121758' ,
                       '322221730' ,'318575268', '295121787', '295121800' ,
                       '295121811' ,'322219321', '295121827', '322222557' ,
                       '295121841' ,'295121842', '331753751', '322221652' ,
                       '322218924' ,'295121899', '318574854', '331753541' ,
                       '295121922' ,'322223160', '322223266', '295121949' ,
                       '322219147' ,'295121960', '295121965', '295125363' ,
                       '295121980' ,'295121981', '295121986', '295122001' ,
                       '295125391' ,'295122015', '295125418', '295122108' ,
                       '295122149' ,'295125466', '295122183', '295122210' ,
                       '295122247' ,'295122249', '295122271', '295122282' ,
                       '295122290' ,'295122303', '295122318', '295124334' ,
                       '318574984' ,'318575314', '318575318', '318575321' ,
                       '322220298' ,'322222591', '322221921', '331754248' ,
                       '318575306' ,'322220668', '295122512', '322220080' ,
                       '322220231' ,'295122565', '295122583', '295122605' ,
                       '295122603' ,'295124370', '295124355', '295124363' ,
                       '295122665' ,'295125120', '322220560', '295124381' ,
                       '322219177' ,'295122774', '322222724', '322222616' ,
                       '322223078' ,'322222716', '322220657', '295125071' ,
                       '318574870' ,'318575088', '318574866', '322221646' ,
                       '295125088' ,'322222298', '295122860', '322220981' ,
                       '322218480' ,'322222026', '322219467', '318574788' ,
                       '322218483' ,'295124976', '318575028', '295124983' ,
                       '322219697' ,'318575200', '295123013', '295124999' ,
                       '295125015' ,'318574824', '295124935', '295124950' ,
                       '318575300' ,'322218365', '322219599', '318575274' ,
                       '322219725' ,'322220910', '295123232', '295123252' ,
                       '322220272' ,'295124757', '318575324', '318575326' ,
                       '318575255' ,'318575328', '295124769', '322219079' ,
                       '318574967' ,'322221811', '318574314', '322219308' ,
                       '322219394' ,'322219512', '295124800', '322223008' ,
                       '322223065' ,'295124819', '322219828', '295124829' ,
                       '318575133' ,'295124843', '295124873', '318575137' ,
                       '295124883' ,'318575325', '295124905', '295123409' ,
                       '295123414' ,'295123422', '295124700', '295123485' ,
                       '295123490' ,'295123542', '295124628', '295124610' ,
                       '295124621' ,'295123624', '295123653', '295124409' ,
                       '295123691' ,'295123700', '295123765', '324816070' ,
                       '324816528' ,'295123776', '322510351', '322510357' ,
                       '295123833' ,'331753452', '331753620', '324816061' ,
                       '295123843' ,'295123845', '295123850', '295123857' ,
                       '295123861' ,'295123878', '295123887', '295123893' ,
                       '295123900' ,'295123911', '295123917', '295123932' ,
                       '295123953' ,'295123969', '295124026', '295124041' ,
                       '295124043' ,'295124057', '295124062', '324815977' ,
                       '324815978' ,'324815992', '322510210', '324816073' ,
                       '322510262' ,'322510265', '324816044', '322510015' ,
                       '330424408' ,'331753403', '322510137', '322509955' ,
                       '322510362' ,'327549552', '331753393', '322510370' ,
                       '322510032' ,'331753409', '322510391', '322510320' ,
                       '318574883' ,'324816059', '322510186', '324816486' ,
                       '324816050' ,'327549550', '322510340', '322510016' ,
                       '322509977' ,'331753375', '322509946', '327549526' ,
                       '322510091' ,'322510058', '322509998', '322510361' ,
                       '331753578' ,'322510035', '322510411', '322509952' ,
                       '322510066' ,'331753287', '322510308', '322510239' ,
                       '322510349' ,'327549499', '324816087', '322509874' ,
                       '322510169' ,'318574783', '322509969', '331753548' ,
                       '330424694' ,'322510347', '322510286', '324816484' ,
                       '331753492' ,'331753498', '324816069', '322510382' ,
                       '322510133' ,'322510309', '331753333', '331753669' ,
                       '322510287' ,'324816505', '322510418', '331753301' ,
                       '327549501' ,'322510440', '324816511', '322510404' ,
                       '324816072' ,'331753293', '324816080', '331753472' ,
                       '331753317' ,'322510306', '331753434', '322510345' ,
                       '322510143' ,'322510352', '324816071', '330424730' ,
                       '322510341' ,'330424731', '324816531', '324816499' ,
                       '327549591' ,'324816517', '324816498', '322510150' ,
                       '331753559' ,'322510135', '330424720', '331753471' ,
                       '330424604' ,'322510346', '322510283', '327549493' ,
                       '322510376' ,'351278156', '322510245', '322510280' ,
                       '322510356' ,'322510369', '322510284', '322509916' ,
                       '331753416' ,'330424766', '331753600', '324816497' ,
                       '322510115' ,'322510325', '322510307', '322509933' ,
                       '330424355' ,'322510336', '327549603', '331753406' ,
                       '322510285' ,'324816502', '322510443', '322510333' ,
                       '322509976' ,'322510243', '322510375', '324816492' ,
                       '331753531' ,'330424398', '324816474', '331753388' ,
                       '324816479' ,'324816081', '322510303', '331753681' ,
                       '322510234' ,'327549569', '322510203', '327549530' ,
                       '330425035' ,'322510299', '322509932', '322510330' ,
                       '322509993' ,'331753294', '324816534', '331753496' ,
                       '331753506' ,'322509897', '322510233', '322510108' ,
                       '322510408' ,'331753503', '322510416', '327549502' ,
                       '322510428' ,'322510212', '322510365', '327549512' ,
                       '322510170' ,'331753574', '322509990', '322509997' ,
                       '322221599' ,'324816480', '322221813', '322510003' ,
                       '322509891' ,'322509884', '324816515', '322510250' ,
                       '322509954' ,'322510313', '324816085', '322510049' ,
                       '322510323' ,'322510360', '324816542', '331753478' ,
                       '322223417' ,'322510113', '327549574', '327549532' ,
                       '322510282' ,'322510236', '322510065', '322510295' ,
                       '322510211' ,'327549546', '327549513', '322510070' ,
                       '322222030' ,'327549563', '322510068', '327549571' ,
                       '322510398' ,'327549536', '322509862', '322509854' ,
                       '327549561' ,'324816516', '322510038', '330424814' ,
                       '331753529' ,'322509999', '331753433', '322510334' ,
                       '322510322' ,'322510173', '330424300', '322510350' ,
                       '324816478' ,'324816482', '331753359', '322509833' ,
                       '330424515' ,'331753383', '331753274', '331753595' ,
                       '331753627' ,'324816532', '331753380', '322509890' ,
                       '322510397' ,'322510405', '331753526', '331753462' ,
                       '327549565' ,'322510413', '322510263', '322510111' ,
                       '331753504' ,'331753425', '324816075', '322510343' ,
                       '322510146' ,'322510112', '322510372', '322510438' ,
                       '322510014' ,'322509924', '322510380', '331753316' ,
                       '324816058' ,'327549500', '331753556', '327549507' ,
                       '322509928' ,'322509880', '322510053', '324816079' ,
                       '324816056' ,'330424595', '324816530', '322510298' ,
                       '322510435' ,'322509885', '322510181', '322510324' ,
                       '322510388' ,'322510114', '331753696', '322510368' ,
                       '331753562' ,'322510379', '331753565', '327549274' ,
                       '322509878' ,'322510327', '322510099', '324816483' ,
                       '324816082' ,'322510110', '322510159', '331753584' ,
                       '331753518' ,'322510399', '322510387', '324816540' ,
                       '324816541' ,'322510426', '324815975', '324816504' ,
                       '324816519' ,'331753324', '331753827', '335231622' ,
                       '330422175' ,'338760909', '342291953', '340478034' ,
                       '338760859' ,'340477682', '331754183', '340477625' ,
                       '338761457' ,'340478044', '338761045', '340477787' ,
                       '340478192' ,'342292008', '342292086', '342292023' ,
                       '342291415' ,'333476272', '340478171', '335231908' ,
                       '340477503' ,'340477858', '335231337', '338761351' ,
                       '342292062' ,'342292130', '342292017', '335231961' ,
                       '340477824' ,'342291933', '335231503', '340477712' ,
                       '331753693' ,'336959290', '336959339', '342292031' ,
                       '342292066' ,'340478083', '342292090', '340477611' ,
                       '340478027' ,'331754150', '340478112', '338761106' ,
                       '342292188' ,'338760934', '338761156', '336959944' ,
                       '330425088' ,'336959925', '342291651', '338761789' ,
                       '340478031' ,'342291706', '335231366', '338761551' ,
                       '338761609' ,'330425095', '342291419', '342292035' ,
                       '342291642' ,'330425098', '340478193', '342291640' ,
                       '340477699' ,'336959995', '340477943', '342292356' ,
                       '335231275' ,'340478006', '342292171', '340477648' ,
                       '342292353' ,'335231742', '338761698', '330424109' ,
                       '331754207' ,'338761518', '342292286', '331753906' ,
                       '335232520' ,'333475901', '335231870', '333475925' ,
                       '338761144' ,'333475991', '336960964', '340477046' ,
                       '340477895' ,'340478105', '342291340', '336959741' ,
                       '342292039' ,'331753999', '340478120', '338761064' ,
                       '340477696' ,'340477834', '336959300', '330424742' ,
                       '338761006' ,'342292053', '335232268', '336960482' ,
                       '331753795' ,'340478204', '342291767', '342292140' ,
                       '338761756' ,'330424889', '331754172', '340477898' ,
                       '340478194' ,'342291724', '354441657', '356622845' ,
                       '356617786' ,'356620299', '356618525', '356621370' ,
                       '354440106' ,'356618877', '356619784', '356621023' ,
                       '356621091' ,'356619514', '356622818', '352673745' ,
                       '356619880' ,'356620973', '356618288', '356620549' ,
                       '356619009' ,'356621164', '356623327'
                     )


UPDATE IH
SET ih.IN_HOUSE_ONLY_IN = 'Y', ih.UPDATE_DT = GETDATE(), ih.LOCK_ID = ih.LOCK_ID+1, ih.UPDATE_USER_TX = 'INC0321295', ih.PURGE_DT = NULL 
--SELECT * 
FROM dbo.INTERACTION_HISTORY ih
WHERE ih.PROPERTY_ID IN (162558786)


--DROP TABLE  #tmpIH



SELECT ih.PROPERTY_ID, COUNT(ih.PROPERTY_ID) [Count]
INTO #tmpProperty2
FROM dbo.INTERACTION_HISTORY ih
WHERE id IN (SELECT id  FROM #tmp)
GROUP BY ih.PROPERTY_ID 
HAVING COUNT(ih.PROPERTY_ID) = '2'

SELECT * FROM  #tmpProperty
ORDER BY COUNT ASC


SELECT * 
INTO UniTracHDStorage..INC0321295zz
FROM #tmp
 WHERE PROPERTY_ID IN (SELECT PROPERTY_ID FROM #tmpProperty)
