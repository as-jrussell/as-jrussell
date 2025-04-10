USE [UniTrac];
GO

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT L.*
--INTO UniTracHDStorage..INC0328372_C
FROM   LOAN L
       JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE  LL.CODE_TX IN ( '3525' )
       AND L.EXTRACT_UNMATCH_COUNT_NO <> '4'
       AND L.NUMBER_TX IN ( '6379376', '8068486', '15071627', '15071708' ,
                            '15081749' ,'15081804', '15081826', '15091844' ,
                            '15091854' ,'15091871', '15091874', '15091894' ,
                            '15091912' ,'15091934', '15101946', '15101967' ,
                            '15101981' ,'15102004', '15102020', '15102045' ,
                            '16012264' ,'16022368', '16032472', '16032476' ,
                            '114040245' ,'114122385', '115022830' ,
                            '115033523' ,'115033646', '115033676' ,
                            '115043743' ,'115075171', '115075285' ,
                            '115085534' ,'115085623', '115085699' ,
                            '115085812' ,'115085824', '115085841' ,
                            '115085868' ,'115095921', '115095932' ,
                            '115095950' ,'115095997', '115096008' ,
                            '115096032' ,'115096038', '115096045' ,
                            '115096047' ,'115096099', '115096100' ,
                            '115096105' ,'115096108', '115096110' ,
                            '115096119' ,'115096126', '115096128' ,
                            '115096129' ,'115096142', '115096144' ,
                            '115096150' ,'115096164', '115096187' ,
                            '115096192' ,'115096193', '115096196' ,
                            '115096204' ,'115096207', '115096210' ,
                            '115096221' ,'115096223', '115096225' ,
                            '115096229' ,'115096231', '115096233' ,
                            '115096234' ,'115096235', '115096238' ,
                            '115096241' ,'115096242', '115096247' ,
                            '115096249' ,'115096251', '115096255' ,
                            '115096267' ,'115096273', '115096274' ,
                            '115096275' ,'115096276', '115096280' ,
                            '115096282' ,'115096286', '115096289' ,
                            '115096294' ,'115096296', '115106300' ,
                            '115106303' ,'115106307', '115106308' ,
                            '115106314' ,'115106318', '115106319' ,
                            '115106320' ,'115106326', '115106327' ,
                            '115106335' ,'115106343', '115106346' ,
                            '115106350' ,'115106356', '115106363' ,
                            '115106365' ,'115106366', '115106367' ,
                            '115106370' ,'115106379', '115106380' ,
                            '115106381' ,'115106384', '115106386' ,
                            '115106390' ,'115106392', '115106396' ,
                            '115106399' ,'115106402', '115106403' ,
                            '115106405' ,'115106406', '115106407' ,
                            '115106424' ,'115106425', '115106427' ,
                            '115106429' ,'115106431', '115106432' ,
                            '115106440' ,'115106444', '115106449' ,
                            '115106452' ,'115106455', '115106461' ,
                            '115106462' ,'115106465', '115106466' ,
                            '115106467' ,'115106469', '115106470' ,
                            '115106471' ,'115106475', '115106476' ,
                            '115106477' ,'115106478', '115106484' ,
                            '115106485' ,'115106487', '115106489' ,
                            '115106491' ,'115106502', '115106506' ,
                            '115106507' ,'115106510', '115106513' ,
                            '115106514' ,'115106517', '115106518' ,
                            '115106521' ,'115106523', '115106526' ,
                            '115106528' ,'115106530', '115106531' ,
                            '115106535' ,'115106538', '115106539' ,
                            '115106546' ,'115106550', '115106560' ,
                            '115106563' ,'115106567', '115106569' ,
                            '115106579' ,'115106580', '115106584' ,
                            '115106587' ,'115106588', '115106589' ,
                            '115106591' ,'115106595', '115106604' ,
                            '115106605' ,'115106608', '115106609' ,
                            '115106615' ,'115106618', '115106621' ,
                            '115106623' ,'115106637', '115106644' ,
                            '115106648' ,'115106653', '115106655' ,
                            '115106660' ,'115106662', '115106671' ,
                            '115106680' ,'115106682', '115106689' ,
                            '115106691' ,'115106692', '115106694' ,
                            '115106700' ,'115106706', '115106711' ,
                            '115106715' ,'115106716', '115106752' ,
                            '115106755' ,'115106761', '115106764' ,
                            '115106777' ,'115106788', '115116845' ,
                            '115116864' ,'115116868', '115116971' ,
                            '115117006' ,'115117024', '115117073' ,
                            '115127559' ,'116017672', '116017777' ,
                            '116017886' ,'116028167', '116028230' ,
                            '116028236' ,'116028260', '116028336' ,
                            '116028393' ,'116028411', '116028457' ,
                            '116038503' ,'116038520', '116038527' ,
                            '116038540' ,'116038583', '116038615' ,
                            '116038661' ,'116038675', '116038719' ,
                            '116038818' ,'116038867', '116038871' ,
                            '116038882' ,'116038883', '116038922' ,
                            '116038925' ,'116038927', '116038930' ,
                            '116038949' ,'116049438', '116102706' ,
                            '117013703' ,'117013902', '117045070' ,
                            '117045139' ,'117055603', '117055625' ,
                            '117055643' ,'117065783', '200331206', '206865436'
                          );

SELECT *
FROM   UniTracHDStorage..INC0328372;

SELECT *
FROM   UniTracHDStorage..INC0328372_C;

UPDATE L
SET    L.RECORD_TYPE_CD = 'G' ,
       L.EXTRACT_UNMATCH_COUNT_NO = '0' ,
       L.STATUS_CD = 'A' ,
       L.UPDATE_DT = GETDATE() ,
       L.UPDATE_USER_TX = 'INC0328372'
--SELECT L.RECORD_TYPE_CD , L.STATUS_CD, L.EXTRACT_UNMATCH_COUNT_NO, *
FROM   dbo.LOAN L
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372
             )
       AND L.EXTRACT_UNMATCH_COUNT_NO = '4';


	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0328372' , 'N' , 
 GETDATE() ,  1 , 
'Make Loan Active', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0328372)

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE




SELECT *
INTO   UniTracHDStorage..INC0328372_Branches
FROM   dbo.LOAN
WHERE  LENDER_ID = 2254
       AND NUMBER_TX IN ( '8157566', '115127373', '117044965', '308196796' ,
                          '109446' ,'170936', '205236', '284806', '318946' ,
                          '332706' ,'384026', '406726', '464806', '4029656' ,
                          '6120346' ,'6133066', '6174066', '6263316' ,
                          '6307776' ,'6341506', '6393166', '6443476' ,
                          '6626116' ,'6706906', '6790696', '6873716' ,
                          '6890326' ,'7025646', '7090216', '7111446' ,
                          '7164076' ,'7192846', '7306656', '7350626' ,
                          '7394936' ,'7457146', '7472796', '7527516' ,
                          '7576596' ,'7606556', '7641506', '7641616' ,
                          '7697426' ,'7717876', '8102436', '8148776' ,
                          '8210046' ,'8274236', '8297426', '8415376' ,
                          '8420366' ,'8433866', '8434876', '8440916' ,
                          '8530206' ,'8550606', '8557496', '8600806' ,
                          '8622326' ,'8625936', '8696056', '8714836' ,
                          '8725326' ,'8732706', '8803116', '8814896' ,
                          '8827336' ,'8970076', '9004476', '9033046' ,
                          '9130296' ,'9148526', '9221766', '9236806' ,
                          '9337326' ,'9408726', '9505566', '9513016' ,
                          '9520126' ,'9557416', '9569356', '9591436' ,
                          '9633366' ,'9690426', '9718026', '9725536' ,
                          '9738956' ,'9853116', '9904926', '9909246' ,
                          '9912326' ,'9927086', '9928566', '9978756' ,
                          '9985846' ,'9990176', '10001126', '10025086' ,
                          '10065006' ,'10095756', '10097466', '10153846' ,
                          '10156626' ,'10207516', '10302586', '10349096' ,
                          '10355906' ,'10359276', '10433846', '10451736' ,
                          '10504076' ,'10504716', '10506506', '10532476' ,
                          '10565406' ,'10625496', '10646926', '10675766' ,
                          '10744806' ,'10765666', '10816196', '10908436' ,
                          '10928076' ,'10958676', '11104496', '11124356' ,
                          '11193036' ,'11423416', '14050131', '14060239' ,
                          '14090483' ,'14090520', '14100649', '14120777' ,
                          '15010861' ,'15010883', '15061511', '15061599' ,
                          '15102008' ,'15102031', '15102050', '15112082' ,
                          '15112127' ,'16022347', '16022390', '16052678' ,
                          '16062832' ,'16062911', '16072986', '16083057' ,
                          '16083098' ,'16093235', '16093308', '16113508' ,
                          '16123591' ,'17053945', '114040250', '114040253' ,
                          '114040269' ,'114050544', '114050579', '114060619' ,
                          '114060681' ,'114060885', '114070929', '114071031' ,
                          '114071108' ,'114081182', '114081235', '114081289' ,
                          '114091522' ,'114091686', '114091692', '114101756' ,
                          '114101889' ,'114101927', '114101936', '114101970' ,
                          '114112075' ,'114112150', '114122288', '114122359' ,
                          '115012452' ,'115012460', '115012491', '115012537' ,
                          '115012602' ,'115012626', '115012634', '115012737' ,
                          '115012740' ,'115012761', '115012768', '115022890' ,
                          '115022942' ,'115022947', '115022996', '115023136' ,
                          '115033259' ,'115033293', '115033309', '115033333' ,
                          '115033481' ,'115033536', '115033552', '115033555' ,
                          '115033710' ,'115043941', '115043958', '115044127' ,
                          '115054305' ,'115054447', '115054506', '115064662' ,
                          '115064860' ,'115064917', '115075130', '115075315' ,
                          '115075380' ,'115075463', '115085554', '115085646' ,
                          '115085697' ,'115085856', '115096142', '115096150' ,
                          '115096235' ,'115106366', '115106438', '115106461' ,
                          '115106677' ,'115106709', '115106767', '115116820' ,
                          '115116873' ,'115116889', '115116911', '115116949' ,
                          '115117055' ,'115117079', '115127231', '115127286' ,
                          '115127315' ,'115127317', '115127462', '115127536' ,
                          '116017610' ,'116017637', '116017799', '116017812' ,
                          '116017932' ,'116028034', '116028111', '116028121' ,
                          '116028194' ,'116028223', '116028230', '116028240' ,
                          '116038538' ,'116038593', '116038604', '116038670' ,
                          '116038674' ,'116038708', '116038763', '116048993' ,
                          '116049030' ,'116049097', '116049144', '116049154' ,
                          '116049158' ,'116049167', '116049326', '116049399' ,
                          '116049525' ,'116050021', '116059548', '116059616' ,
                          '116059625' ,'116060187', '116060245', '116060278' ,
                          '116060288' ,'116060441', '116060518', '116070638' ,
                          '116070662' ,'116070683', '116070721', '116070725' ,
                          '116070733' ,'116070753', '116070772', '116070791' ,
                          '116070838' ,'116071068', '116071100', '116071133' ,
                          '116071207' ,'116081258', '116081338', '116081359' ,
                          '116081421' ,'116081484', '116081508', '116081557' ,
                          '116081581' ,'116081672', '116081744', '116092047' ,
                          '116092132' ,'116092205', '116092301', '116092302' ,
                          '116092338' ,'116102366', '116102447', '116102836' ,
                          '116102841' ,'116102844', '116112856', '116112944' ,
                          '116113046' ,'116113048', '116113075', '116113147' ,
                          '116113216' ,'116123279', '116123353', '116123505' ,
                          '116123531' ,'117013615', '117013731', '117013733' ,
                          '117013760' ,'117013766', '117013786', '117013797' ,
                          '117013898' ,'117023940', '117023958', '117024034' ,
                          '117024101' ,'117024199', '117024216', '117024254' ,
                          '117024259' ,'117034391', '117034544', '117034636' ,
                          '117034704' ,'117034788', '117034805', '117034808' ,
                          '117034850' ,'117034853', '117044868', '117044892' ,
                          '117044918' ,'117044971', '117045068', '117045072' ,
                          '117045081' ,'117045082', '117045134', '117045200' ,
                          '117045293' ,'117055384', '117055471', '117055499' ,
                          '117055510' ,'117055553', '117055617', '117055618' ,
                          '117055648' ,'117065751', '117065777', '117065853' ,
                          '117065859' ,'117065977', '117066009', '117066018' ,
                          '117066085' ,'117076201', '117076403', '117086717' ,
                          '117086741' ,'117086849', '117097125', '117097233' ,
                          '200139456' ,'200232226', '200367366', '206256606' ,
                          '206298546' ,'206446796', '206510006', '206970446' ,
                          '207352936' ,'207559786', '207680956', '208047236' ,
                          '208190136' ,'208363886', '209084416', '209120626' ,
                          '210302586' ,'214040066', '214050157', '214120527' ,
                          '214120528' ,'214120535', '214120539', '215010572' ,
                          '215010606' ,'215020620', '215040868', '215040893' ,
                          '215040894' ,'215040905', '215040957', '306810336' ,
                          '402016676' ,'15081826', '15091854', '15091871' ,
                          '15091894' ,'15091934', '15101981', '15102004' ,
                          '114040245' ,'115085812', '115085841', '115095921' ,
                          '115095932' ,'115096110', '115096229', '115096234' ,
                          '115096286' ,'115106335', '115106407', '115106465' ,
                          '115106467' ,'115106475', '115106484', '115106487' ,
                          '115106523' ,'115106535', '115106584', '115106700' ,
                          '115106777' ,'116038540', '15081749', '115096047' ,
                          '115096196' ,'115096223', '115106319', '115106365' ,
                          '115106367' ,'115106370', '115106431', '115106471' ,
                          '115106563' ,'115106615', '115106662', '115106692' ,
                          '115106788' ,'116028457', '116038719', '116038930'
                        );



UPDATE L
SET    L.BRANCH_CODE_TX = 'FICS NON ESCROW' ,
       L.UPDATE_DT = GETDATE() ,
       L.UPDATE_USER_TX = 'INC0328372'
--SELECT * 
FROM   dbo.LOAN L
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND L.NUMBER_TX IN ( '15081826', '15091854', '15091871', '15091894' ,
                            '15091934' ,'15101981', '15102004', '114040245' ,
                            '115085812' ,'115085841', '115095921' ,
                            '115095932' ,'115096110', '115096229' ,
                            '115096234' ,'115096286', '115106335' ,
                            '115106407' ,'115106465', '115106467' ,
                            '115106475' ,'115106484', '115106487' ,
                            '115106523' ,'115106535', '115106584' ,
                            '115106700' ,'115106777', '116038540'
                          );


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0328372' , 'N' , 
 GETDATE() ,  1 , 
'FICS NON ESCROW branches', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND L.NUMBER_TX IN ( '15081826', '15091854', '15091871', '15091894' ,
                            '15091934' ,'15101981', '15102004', '114040245' ,
                            '115085812' ,'115085841', '115095921' ,
                            '115095932' ,'115096110', '115096229' ,
                            '115096234' ,'115096286', '115106335' ,
                            '115106407' ,'115106465', '115106467' ,
                            '115106475' ,'115106484', '115106487' ,
                            '115106523' ,'115106535', '115106584' ,
                            '115106700' ,'115106777', '116038540'
                          );
	
	
						  

UPDATE L
SET    L.BRANCH_CODE_TX = 'FICS CONDO' ,
       L.UPDATE_DT = GETDATE() ,
       L.UPDATE_USER_TX = 'INC0328372'
--SELECT * 
FROM   dbo.LOAN L
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND L.NUMBER_TX IN ( '109446', '170936', '205236', '284806', '318946' ,
                            '332706' ,'384026', '406726', '464806', '4029656' ,
                            '6120346' ,'6133066', '6174066', '6263316' ,
                            '6307776' ,'6341506', '6393166', '6443476' ,
                            '6626116' ,'6706906', '6790696', '6873716' ,
                            '6890326' ,'7025646', '7090216', '7111446' ,
                            '7164076' ,'7192846', '7306656', '7350626' ,
                            '7394936' ,'7457146', '7472796', '7527516' ,
                            '7576596' ,'7606556', '7641506', '7641616' ,
                            '7697426' ,'7717876', '8102436', '8148776' ,
                            '8210046' ,'8274236', '8297426', '8415376' ,
                            '8420366' ,'8433866', '8434876', '8440916' ,
                            '8530206' ,'8550606', '8557496', '8600806' ,
                            '8622326' ,'8625936', '8696056', '8714836' ,
                            '8725326' ,'8732706', '8803116', '8814896' ,
                            '8827336' ,'8970076', '9004476', '9033046' ,
                            '9130296' ,'9148526', '9221766', '9236806' ,
                            '9337326' ,'9408726', '9505566', '9513016' ,
                            '9520126' ,'9557416', '9569356', '9591436' ,
                            '9633366' ,'9690426', '9718026', '9725536' ,
                            '9738956' ,'9853116', '9904926', '9909246' ,
                            '9912326' ,'9927086', '9928566', '9978756' ,
                            '9985846' ,'9990176', '10001126', '10025086' ,
                            '10065006' ,'10095756', '10097466', '10153846' ,
                            '10156626' ,'10207516', '10302586', '10349096' ,
                            '10355906' ,'10359276', '10433846', '10451736' ,
                            '10504076' ,'10504716', '10506506', '10532476' ,
                            '10565406' ,'10625496', '10646926', '10675766' ,
                            '10744806' ,'10765666', '10816196', '10908436' ,
                            '10928076' ,'10958676', '11104496', '11124356' ,
                            '11193036' ,'11423416', '14050131', '14060239' ,
                            '14090483' ,'14090520', '14100649', '14120777' ,
                            '15010861' ,'15010883', '15061511', '15061599' ,
                            '15102008' ,'15102031', '15102050', '15112082' ,
                            '15112127' ,'16022347', '16022390', '16052678' ,
                            '16062832' ,'16062911', '16072986', '16083057' ,
                            '16083098' ,'16093235', '16093308', '16113508' ,
                            '16123591' ,'17053945', '114040250', '114040253' ,
                            '114040269' ,'114050544', '114050579' ,
                            '114060619' ,'114060681', '114060885' ,
                            '114070929' ,'114071031', '114071108' ,
                            '114081182' ,'114081235', '114081289' ,
                            '114091522' ,'114091686', '114091692' ,
                            '114101756' ,'114101889', '114101927' ,
                            '114101936' ,'114101970', '114112075' ,
                            '114112150' ,'114122288', '114122359' ,
                            '115012452' ,'115012460', '115012491' ,
                            '115012537' ,'115012602', '115012626' ,
                            '115012634' ,'115012737', '115012740' ,
                            '115012761' ,'115012768', '115022890' ,
                            '115022942' ,'115022947', '115022996' ,
                            '115023136' ,'115033259', '115033293' ,
                            '115033309' ,'115033333', '115033481' ,
                            '115033536' ,'115033552', '115033555' ,
                            '115033710' ,'115043941', '115043958' ,
                            '115044127' ,'115054305', '115054447' ,
                            '115054506' ,'115064662', '115064860' ,
                            '115064917' ,'115075130', '115075315' ,
                            '115075380' ,'115075463', '115085554' ,
                            '115085646' ,'115085697', '115085856' ,
                            '115096142' ,'115096150', '115096235' ,
                            '115106366' ,'115106438', '115106461' ,
                            '115106677' ,'115106709', '115106767' ,
                            '115116820' ,'115116873', '115116889' ,
                            '115116911' ,'115116949', '115117055' ,
                            '115117079' ,'115127231', '115127286' ,
                            '115127315' ,'115127317', '115127462' ,
                            '115127536' ,'116017610', '116017637' ,
                            '116017799' ,'116017812', '116017932' ,
                            '116028034' ,'116028111', '116028121' ,
                            '116028194' ,'116028223', '116028230' ,
                            '116028240' ,'116038538', '116038593' ,
                            '116038604' ,'116038670', '116038674' ,
                            '116038708' ,'116038763', '116048993' ,
                            '116049030' ,'116049097', '116049144' ,
                            '116049154' ,'116049158', '116049167' ,
                            '116049326' ,'116049399', '116049525' ,
                            '116050021' ,'116059548', '116059616' ,
                            '116059625' ,'116060187', '116060245' ,
                            '116060278' ,'116060288', '116060441' ,
                            '116060518' ,'116070638', '116070662' ,
                            '116070683' ,'116070721', '116070725' ,
                            '116070733' ,'116070753', '116070772' ,
                            '116070791' ,'116070838', '116071068' ,
                            '116071100' ,'116071133', '116071207' ,
                            '116081258' ,'116081338', '116081359' ,
                            '116081421' ,'116081484', '116081508' ,
                            '116081557' ,'116081581', '116081672' ,
                            '116081744' ,'116092047', '116092132' ,
                            '116092205' ,'116092301', '116092302' ,
                            '116092338' ,'116102366', '116102447' ,
                            '116102836' ,'116102841', '116102844' ,
                            '116112856' ,'116112944', '116113046' ,
                            '116113048' ,'116113075', '116113147' ,
                            '116113216' ,'116123279', '116123353' ,
                            '116123505' ,'116123531', '117013615' ,
                            '117013731' ,'117013733', '117013760' ,
                            '117013766' ,'117013786', '117013797' ,
                            '117013898' ,'117023940', '117023958' ,
                            '117024034' ,'117024101', '117024199' ,
                            '117024216' ,'117024254', '117024259' ,
                            '117034391' ,'117034544', '117034636' ,
                            '117034704' ,'117034788', '117034805' ,
                            '117034808' ,'117034850', '117034853' ,
                            '117044868' ,'117044892', '117044918' ,
                            '117044971' ,'117045068', '117045072' ,
                            '117045081' ,'117045082', '117045134' ,
                            '117045200' ,'117045293', '117055384' ,
                            '117055471' ,'117055499', '117055510' ,
                            '117055553' ,'117055617', '117055618' ,
                            '117055648' ,'117065751', '117065777' ,
                            '117065853' ,'117065859', '117065977' ,
                            '117066009' ,'117066018', '117066085' ,
                            '117076201' ,'117076403', '117086717' ,
                            '117086741' ,'117086849', '117097125' ,
                            '117097233' ,'200139456', '200232226' ,
                            '200367366' ,'206256606', '206298546' ,
                            '206446796' ,'206510006', '206970446' ,
                            '207352936' ,'207559786', '207680956' ,
                            '208047236' ,'208190136', '208363886' ,
                            '209084416' ,'209120626', '210302586' ,
                            '214040066' ,'214050157', '214120527' ,
                            '214120528' ,'214120535', '214120539' ,
                            '215010572' ,'215010606', '215020620' ,
                            '215040868' ,'215040893', '215040894' ,
                            '215040905' ,'215040957', '306810336', '402016676'
                          );



INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0328372' , 'N' , 
 GETDATE() ,  1 , 
'FICS CONDO branches', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND  L.NUMBER_TX IN ( '109446', '170936', '205236', '284806', '318946' ,
                            '332706' ,'384026', '406726', '464806', '4029656' ,
                            '6120346' ,'6133066', '6174066', '6263316' ,
                            '6307776' ,'6341506', '6393166', '6443476' ,
                            '6626116' ,'6706906', '6790696', '6873716' ,
                            '6890326' ,'7025646', '7090216', '7111446' ,
                            '7164076' ,'7192846', '7306656', '7350626' ,
                            '7394936' ,'7457146', '7472796', '7527516' ,
                            '7576596' ,'7606556', '7641506', '7641616' ,
                            '7697426' ,'7717876', '8102436', '8148776' ,
                            '8210046' ,'8274236', '8297426', '8415376' ,
                            '8420366' ,'8433866', '8434876', '8440916' ,
                            '8530206' ,'8550606', '8557496', '8600806' ,
                            '8622326' ,'8625936', '8696056', '8714836' ,
                            '8725326' ,'8732706', '8803116', '8814896' ,
                            '8827336' ,'8970076', '9004476', '9033046' ,
                            '9130296' ,'9148526', '9221766', '9236806' ,
                            '9337326' ,'9408726', '9505566', '9513016' ,
                            '9520126' ,'9557416', '9569356', '9591436' ,
                            '9633366' ,'9690426', '9718026', '9725536' ,
                            '9738956' ,'9853116', '9904926', '9909246' ,
                            '9912326' ,'9927086', '9928566', '9978756' ,
                            '9985846' ,'9990176', '10001126', '10025086' ,
                            '10065006' ,'10095756', '10097466', '10153846' ,
                            '10156626' ,'10207516', '10302586', '10349096' ,
                            '10355906' ,'10359276', '10433846', '10451736' ,
                            '10504076' ,'10504716', '10506506', '10532476' ,
                            '10565406' ,'10625496', '10646926', '10675766' ,
                            '10744806' ,'10765666', '10816196', '10908436' ,
                            '10928076' ,'10958676', '11104496', '11124356' ,
                            '11193036' ,'11423416', '14050131', '14060239' ,
                            '14090483' ,'14090520', '14100649', '14120777' ,
                            '15010861' ,'15010883', '15061511', '15061599' ,
                            '15102008' ,'15102031', '15102050', '15112082' ,
                            '15112127' ,'16022347', '16022390', '16052678' ,
                            '16062832' ,'16062911', '16072986', '16083057' ,
                            '16083098' ,'16093235', '16093308', '16113508' ,
                            '16123591' ,'17053945', '114040250', '114040253' ,
                            '114040269' ,'114050544', '114050579' ,
                            '114060619' ,'114060681', '114060885' ,
                            '114070929' ,'114071031', '114071108' ,
                            '114081182' ,'114081235', '114081289' ,
                            '114091522' ,'114091686', '114091692' ,
                            '114101756' ,'114101889', '114101927' ,
                            '114101936' ,'114101970', '114112075' ,
                            '114112150' ,'114122288', '114122359' ,
                            '115012452' ,'115012460', '115012491' ,
                            '115012537' ,'115012602', '115012626' ,
                            '115012634' ,'115012737', '115012740' ,
                            '115012761' ,'115012768', '115022890' ,
                            '115022942' ,'115022947', '115022996' ,
                            '115023136' ,'115033259', '115033293' ,
                            '115033309' ,'115033333', '115033481' ,
                            '115033536' ,'115033552', '115033555' ,
                            '115033710' ,'115043941', '115043958' ,
                            '115044127' ,'115054305', '115054447' ,
                            '115054506' ,'115064662', '115064860' ,
                            '115064917' ,'115075130', '115075315' ,
                            '115075380' ,'115075463', '115085554' ,
                            '115085646' ,'115085697', '115085856' ,
                            '115096142' ,'115096150', '115096235' ,
                            '115106366' ,'115106438', '115106461' ,
                            '115106677' ,'115106709', '115106767' ,
                            '115116820' ,'115116873', '115116889' ,
                            '115116911' ,'115116949', '115117055' ,
                            '115117079' ,'115127231', '115127286' ,
                            '115127315' ,'115127317', '115127462' ,
                            '115127536' ,'116017610', '116017637' ,
                            '116017799' ,'116017812', '116017932' ,
                            '116028034' ,'116028111', '116028121' ,
                            '116028194' ,'116028223', '116028230' ,
                            '116028240' ,'116038538', '116038593' ,
                            '116038604' ,'116038670', '116038674' ,
                            '116038708' ,'116038763', '116048993' ,
                            '116049030' ,'116049097', '116049144' ,
                            '116049154' ,'116049158', '116049167' ,
                            '116049326' ,'116049399', '116049525' ,
                            '116050021' ,'116059548', '116059616' ,
                            '116059625' ,'116060187', '116060245' ,
                            '116060278' ,'116060288', '116060441' ,
                            '116060518' ,'116070638', '116070662' ,
                            '116070683' ,'116070721', '116070725' ,
                            '116070733' ,'116070753', '116070772' ,
                            '116070791' ,'116070838', '116071068' ,
                            '116071100' ,'116071133', '116071207' ,
                            '116081258' ,'116081338', '116081359' ,
                            '116081421' ,'116081484', '116081508' ,
                            '116081557' ,'116081581', '116081672' ,
                            '116081744' ,'116092047', '116092132' ,
                            '116092205' ,'116092301', '116092302' ,
                            '116092338' ,'116102366', '116102447' ,
                            '116102836' ,'116102841', '116102844' ,
                            '116112856' ,'116112944', '116113046' ,
                            '116113048' ,'116113075', '116113147' ,
                            '116113216' ,'116123279', '116123353' ,
                            '116123505' ,'116123531', '117013615' ,
                            '117013731' ,'117013733', '117013760' ,
                            '117013766' ,'117013786', '117013797' ,
                            '117013898' ,'117023940', '117023958' ,
                            '117024034' ,'117024101', '117024199' ,
                            '117024216' ,'117024254', '117024259' ,
                            '117034391' ,'117034544', '117034636' ,
                            '117034704' ,'117034788', '117034805' ,
                            '117034808' ,'117034850', '117034853' ,
                            '117044868' ,'117044892', '117044918' ,
                            '117044971' ,'117045068', '117045072' ,
                            '117045081' ,'117045082', '117045134' ,
                            '117045200' ,'117045293', '117055384' ,
                            '117055471' ,'117055499', '117055510' ,
                            '117055553' ,'117055617', '117055618' ,
                            '117055648' ,'117065751', '117065777' ,
                            '117065853' ,'117065859', '117065977' ,
                            '117066009' ,'117066018', '117066085' ,
                            '117076201' ,'117076403', '117086717' ,
                            '117086741' ,'117086849', '117097125' ,
                            '117097233' ,'200139456', '200232226' ,
                            '200367366' ,'206256606', '206298546' ,
                            '206446796' ,'206510006', '206970446' ,
                            '207352936' ,'207559786', '207680956' ,
                            '208047236' ,'208190136', '208363886' ,
                            '209084416' ,'209120626', '210302586' ,
                            '214040066' ,'214050157', '214120527' ,
                            '214120528' ,'214120535', '214120539' ,
                            '215010572' ,'215010606', '215020620' ,
                            '215040868' ,'215040893', '215040894' ,
                            '215040905' ,'215040957', '306810336', '402016676'
                          );



UPDATE L
SET    L.BRANCH_CODE_TX = 'ESCROW' ,
       L.UPDATE_DT = GETDATE() ,
       L.UPDATE_USER_TX = 'INC0328372'
--SELECT * 
FROM   dbo.LOAN L
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND L.NUMBER_TX IN ( '8157566',
'115127373',
'117044965',
'308196796'
                          );
						  


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0328372' , 'N' , 
 GETDATE() ,  1 , 
'ESCROW branches', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND L.NUMBER_TX IN ( '8157566',
'115127373',
'117044965',
'308196796')

						  
UPDATE L
SET    L.BRANCH_CODE_TX = 'PUD' ,
       L.UPDATE_DT = GETDATE() ,
       L.UPDATE_USER_TX = 'INC0328372'
--SELECT * 
FROM   dbo.LOAN L
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND L.NUMBER_TX IN ( '15081749', '115096047', '115096196', '115096223' ,
                            '115106319' ,'115106365', '115106367' ,
                            '115106370' ,'115106431', '115106471' ,
                            '115106563' ,'115106615', '115106662' ,
                            '115106692' ,'115106788', '116028457' ,
                            '116038719' ,'116038930'
                          );
	

INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0328372' , 'N' , 
 GETDATE() ,  1 , 
'PUD  branches', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE  ID IN (   SELECT ID
                 FROM   UniTracHDStorage..INC0328372_Branches
             )
       AND L.NUMBER_TX IN ( '15081749', '115096047', '115096196', '115096223' ,
                            '115106319' ,'115106365', '115106367' ,
                            '115106370' ,'115106431', '115106471' ,
                            '115106563' ,'115106615', '115106662' ,
                            '115106692' ,'115106788', '116028457' ,
                            '116038719' ,'116038930'
                          );
				  