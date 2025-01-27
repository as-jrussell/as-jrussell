USE unitrac


SELECT * FROM dbo.LOAN L
JOIN dbo.LENDER LL ON L.LENDER_ID = LL.ID 
WHERE L.NUMBER_TX = '2006721646'


SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'LoanStatus'

SELECT  L.*
--INTO    UniTracHDStorage..INC0298691
FROM    dbo.LOAN L
        JOIN dbo.LENDER LL ON L.LENDER_ID = LL.ID
WHERE  L.LENDER_ID = 92 and  L.NUMBER_TX IN ( '2006721646', '201600466', '2093314129', '2072497055',
                         '2001110040', '2483385437', '2494107948',
                         '2494107948', '2436606728', '2001737094', '85888512',
                         '2158314451', '2212659055', '2071691747',
                         '2061128055', '2057065215', '2024881094',
                         '5083716328', '31515711', '31515711', '2410065882',
                         '38527055', '2197401598', '2401515338', '2311128944',
                         '2053940055', '201506739', '2060723055', '2426058280',
                         '2426058280', '55371482', '55371482', '14345055',
                         '14345055', '2265288556', '2436648706', '5068885638',
                         '2448408336', '2011326223', '2347011581',
                         '5158231002', '2510523916', '2048165693',
                         '2398578205', '2398578205', '1167231084',
                         '2405073187', '2405073187', '51788171', '51788171',
                         '37397727', '37397727', '34239094', '2430888874',
                         '2074938055', '48064094', '2039967055', '11756094',
                         '2341353441', '2364822920', '2009697055',
                         '2003638055', '2001972055', '18891740', '18891740',
                         '2127675120', '22580866', '22580866', '51397094',
                         '2477295719', '2477295719', '29494055', '2071471055',
                         '2051756493', '2051756676', '2009883055',
                         '2071648055', '2198043740', '2051135000',
                         '2051135000', '37292332', '2231286055', '21977055',
                         '2186892055', '1209322000', '2028734879',
                         '2028734879', '52646542', '52646542', '2384673916',
                         '2072942055', '2476239307', '39553241', '39553241',
                         '2165358055', '2454033520', '75158094', '2061824351',
                         '2067273345', '2019845182', '2019845182',
                         '2277375918', '25742793', '71837055', '86978094',
                         '2426892073', '19859094', '2327997723', '2211264634',
                         '2051036055', '2405298496', '16605094', '2197692055',
                         '2098161055', '2086544464', '2099156055',
                         '2519175070', '2230059236', '201506613', '2004165055',
                         '2058132055', '2476707074', '2066889055',
                         '2473608583', '2059129499', '2353707179', '79134236',
                         '51266055', '2066246055', '2488812055', '2488812055',
                         '2198187461', '2018141101', '2018141101',
                         '2009085055', '14615055', '2060195055', '2060195055',
                         '2116269055', '53100042', '53100156', '53100158',
                         '53100183', '2273667222', '2107955055', '2058796055',
                         '2058796094', '2392626691', '2531088092',
                         '2103960813', '2070099055', '2286315011',
                         '2326548176', '2499909872', '2464473130',
                         '2464473130', '2230779092', '2060327055',
                         '2026468055', '32399355', '2392566427', '2173881217',
                         '2004261055', '2004261094', '54090080', '16934294',
                         '75576055', '2093152271', '2230281261', '2023356055',
                         '201600255', '201505588', '2385888308', '2393085234',
                         '2337057378', '2087084062', '2068587055',
                         '2068587094', '2051885307', '2383737846',
                         '2368242358', '2072775055', '1151602716',
                         '1151602716', '2064212650', '2276799461',
                         '2176710253', '6701091055', '24649094', '2238555055',
                         '52749615', '52749615', '2096008594', '2389965527',
                         '2009912055', '2046440949', '1022030780',
                         '2387211952', '54541197', '54541197', '1200530055',
                         '1508770055', '84199055', '5029520045', '2089510953',
                         '2089510953', '2427405867', '2427405867',
                         '2109964524', '2076849055', '2412999161',
                         '2012528850', '2012528850', '2283846762', '16420055',
                         '2014448844', '2464602395', '2464602395',
                         '2449941314', '2378358743', '5026270033',
                         '1003910245', '2480124183', '1120620055',
                         '20591790555', '2324670405', '11525055', '2025055055',
                         '60528071', '2008590055', '53998525', '53998525',
                         '2382882902', '2415051542', '2003497032', '84460219',
                         '2040384055', '33872861', '33872861', '2078898264',
                         '2078898264', '2078898686', '2035608055',
                         '2008060107', '2169813374', '2142099055',
                         '2024883055', '2273664341', '2282250527',
                         '2397444239', '2365962235', '5025980384',
                         '2276025949', '2173785225', '2173785225',
                         '2343849320', '1009560055', '49095055', '2498928486',
                         '50551817', '2129061085', '2129061085', '2102768055',
                         '2024436055', '2024436055', '77428094', '2383656097',
                         '2383656097', '2525475280', '2089955397', '22433169',
                         '1400530828', '22218055', '2348484544', '55535055',
                         '2039842055', '3020843134', '3020843134',
                         '2097476055', '2086512868', '2086512871',
                         '1156700484', '2287203029', '2048644094', '34610650',
                         '2351439969', '2351439969', '2352897049',
                         '2160666055', '2033885069', '72783930', '30622724',
                         '32041683', '32041683', '2172828003', '2172828003',
                         '30734094', '86786055', '2049390183', '2081224001',
                         '2270388223', '36514137', '36514137', '2012030055',
                         '2023859055', '2023859055', '20288127', '6204460',
                         '2177421164', '2177421164', '2046960055',
                         '3070804738', '9326055', '2004264055', '2004264942',
                         '1773250055', '2060523923', '2301066055',
                         '2528172509', '2528172509', '2026848094',
                         '2340288585', '2340288585', '57205079', '2436570303',
                         '2436570303', '2166621239', '2123694549',
                         '2123694549', '2381685055', '2381685055',
                         '2437473788', '77176094', '2110470924', '2110470924',
                         '87476055', '29660098', '29660098', '81965055',
                         '2071784055', '6601030055', '13513752', '17321080',
                         '75030046', '2196492852', '2052970055', '808055',
                         '20902055', '20902055', '2273934304', '2273934304',
                         '2311428219', '5092810477', '58594055', '2334987958',
                         '2013570094', '2099590619', '2096983373',
                         '2241933055', '2063381110', '2281590818',
                         '2484393603', '2129484021', '76562055', '2061158940',
                         '2212563611', '2416875386', '57257036', '2399622077',
                         '2065790926', '2209692812', '1512650055',
                         '5083945462', '2294817029', '2381034605',
                         '2048286702', '55730510', '2046124952', '2343738440',
                         '2322789312', '2104859055', '2001759055',
                         '2117367055', '2320155883', '1121332685',
                         '2012120696', '59161094', '57478094', '201506296',
                         '2094041055', '2094041055', '26232055', '1154450699',
                         '1177560728', '2417289293', '2005443055',
                         '2460459166', '5024760006', '2522475530',
                         '2522475530', '2074057055', '2343105493',
                         '2342691147', '2342691147', '2519289868',
                         '2489709170', '2489709170', '2175984055',
                         '2030051094', '201508770', '2045932993', '2012635055',
                         '39326087', '2460402622', '2373192273', '2025573797',
                         '201600078', '36471004', '2045767055', '2045767094',
                         '2045767194', '2451294232', '2147694781', '75630581',
                         '2022333672', '2022333672', '50791827', '2472819938',
                         '201600229', '2348013055', '81086055', '2411979488',
                         '2411979488', '2195259111', '2422143581',
                         '2080551055', '2091359931', '5500993834',
                         '2113239055', '2475039966', '2475039966', '76029055',
                         '84239094', '65249309', '2024255079', '2456148979',
                         '2250555894', '39665055', '39665055', '2326890591',
                         '34889094', '2070645390', '2128782055', '78202317',
                         '3013872319', '2068718055', '2062085055', '201507972',
                         '2003024094', '201507972', '2029007978', '2029007978',
                         '2044554055', '2272281427', '3060074055',
                         '2437077165', '82894055', '2046397055', '2187654055',
                         '2506275459', '2074042055', '201508795', '42832055',
                         '2357049136', '2357049136', '34099055', '2052352055',
                         '2516211665', '2079658369', '2251518405', '68191295',
                         '2001780055', '2001780055', '5028330399',
                         '2072934055', '201506966', '2085639055', '2085639055',
                         '2490738495', '2490738495', '5002520269',
                         '2412462651', '2040197055', '87542055', '2002309894',
                         '2004870055', '2174265156', '2174265156',
                         '2405958393', '2084336710', '2084336710',
                         '2077951064', '2077951064', '2307519770',
                         '2307519770', '2062003055', '2036727614',
                         '2036727614', '2498715797', '2429712578',
                         '2228982055', '201507693', '2046487055', '2080518944',
                         '45906600', '45906600', '2059125496', '2087694055',
                         '2505444347', '2505444347', '2171988737',
                         '2171988737', '2073674055', '2066364055',
                         '2050368440', '2480997272', '2055249624', '32368019',
                         '2060221055', '2069213180', '2318895634',
                         '2318895634', '9989253', '2497815427', '84467295',
                         '84467295', '2075204055', '64385055', '2396928084',
                         '2396928084', '2104575291', '2296623055',
                         '2496633434', '53226115', '2095502055', '2071159055',
                         '2010517055', '2010517055', '2102443283',
                         '2190540551', '2190540551', '54614885', '2111824877',
                         '2092464897', '2347926629', '2090140296',
                         '2062909055', '2050613055', '2053881055',
                         '2053881094', '2072589055', '2495874193',
                         '2086896055', '2009945024', '2031878823',
                         '2273835585', '2185623055', '2050848411',
                         '2429574566', '2505852173', '2280576620', '46431055',
                         '2010151094', '2040458001', '2040458001',
                         '2391846539', '201508814', '1114708835', '2013046446',
                         '201508119', '33649055', '2380740302', '2380740302',
                         '2112971184', '29848106', '29848797', '29848106',
                         '29848797', '83653055', '1017820941', '29830055',
                         '2166840308', '2166840532', '201509191', '2483394559',
                         '2066312055', '2294991798', '201507351', '2006660600',
                         '2006660600', '24056055', '2505882253', '2410419678',
                         '1511360799', '2430243366', '22423055', '2423232209',
                         '2423232209', '2089406233', '2292294055',
                         '2292294055', '2040542055', '2209605094',
                         '2125602055', '51433094', '46450754', '2467230173',
                         '2335515246', '54610307', '63750055', '2407269462',
                         '2407269462', '2356248251', '2356248251',
                         '2436294935', '2413323364', '59338033', '59338033',
                         '2430633491', '33100992', '50967094', '2052631055',
                         '2052631094', '2019606951', '2113546079', '33621094',
                         '72867279', '72867279', '2049040055', '2372226487',
                         '2372226487', '43245055', '2084664362', '68813483',
                         '47257424', '47257424', '2086274679', '2025249416',
                         '2025249416', '2051773055', '2056647055',
                         '2451273734', '2297202846', '2243610946', '47322598',
                         '47322598', '2080460055', '2020259055', '2085348055',
                         '201506743', '23270094', '2024489055', '2272404426',
                         '2421747926', '65081055', '2350791945', '57495194',
                         '2349210491', '2196933055', '2399973335',
                         '2002081055', '5314691570', '2038253966',
                         '2400576479', '2097847803', '2097847890',
                         '2073589055', '2466525866', '89257194', '2020534094',
                         '2099427055', '9748094', '2400111276', '201508738',
                         '2151180714', '201508738', '2151180714', '2055645820',
                         '57216370', '57216370', '2370612035', '3400090055',
                         '2210979152', '2109410694', '23711930', '23711930',
                         '2010376826', '2220762807', '2220762807',
                         '2004462055', '2210439762', '86024055', '35101055',
                         '59769055', '54342055', '2357262875', '2020526055',
                         '5479732671', '5479732671', '54057055', '41351412',
                         '2089175665', '26996647', '2216409497', '2491065054',
                         '2074061055', '2073758055', '2500821433',
                         '3055420921', '68811403', '72526168', '2236227222',
                         '2258322858', '36844169', '3016675882', '2381754426',
                         '67459193', '67459193', '31602055', '201503061',
                         '201600466', '201605688', '201605688', '201603470',
                         '201603470', '201605910', '2012549131', '201604446',
                         '201508790', '201602383', '201602198', '201602400',
                         '201605472', '201606517', '201606517', '201606210',
                         '201606210', '201604307', '201605932', '201605932',
                         '201506739', '201605162', '201606646', '201509212',
                         '201604079', '201603011', '201609063', '201604644',
                         '201604644', '201608515', '201608515', '201605993',
                         '201601921', '201601921', '201605573', '201605573',
                         '201604451', '201602881', '201603628', '201603628',
                         '201608601', '201603747', '201603747', '201508885',
                         '201506879', '201700687', '201700687', '201608597',
                         '201608597', '201700013', '201700013', '201604408',
                         '201605594', '201604200', '201604026', '2009168598',
                         '201603106', '201603705', '201606951', '201606951',
                         '201600406', '201602159', '201507348', '201508300',
                         '2531628585', '201506613', '201604641', '201606706',
                         '201606706', '2112820055', '201604799', '201606005',
                         '201600876', '201602518', '201608991', '201508210',
                         '201509292', '201507509', '201604830', '201605337',
                         '201605337', '201604162', '201601671', '2538093604',
                         '201507241', '201608260', '201605219', '201601123',
                         '201608506', '201506871', '201602689', '201600255',
                         '201603807', '201603807', '201508668', '201505588',
                         '201604122', '201508317', '201700001', '201507425',
                         '201600233', '201508972', '201603385', '201602993',
                         '201602993', '201606984', '201700214', '201508909',
                         '201605632', '201602866', '201605210', '201608133',
                         '201608133', '201507630', '201602947', '201607223',
                         '201700209', '201603301', '201601614', '201507960',
                         '201608504', '201506640', '201606037', '201606037',
                         '201600424', '201600615', '201605156', '201606449',
                         '201606449', '201604082', '201507209', '201509232',
                         '201607878', '201607878', '201507153', '201507879',
                         '201605172', '201605172', '201608721', '201700351',
                         '201602761', '201605823', '201605823', '201506021',
                         '201602874', '201607588', '83791744', '201609167',
                         '201609167', '201607689', '201602779', '201602181',
                         '201700415', '201507119', '201604590', '201605939',
                         '201604790', '201601125', '201602906', '201602906',
                         '201603592', '201604600', '201601195', '201607182',
                         '201607182', '201605299', '201605299', '201608437',
                         '201608437', '201600286', '201607661', '201607776',
                         '201607776', '201601187', '201608787', '201608787',
                         '201700576', '201700576', '201603378', '201507955',
                         '201508456', '2281836409', '201506296', '201507901',
                         '201600484', '201607604', '201606143', '201602745',
                         '201600287', '201605295', '201606887', '201701152',
                         '201606692', '201508093', '201508770', '201601200',
                         '201604554', '201604554', '201602295', '201601519',
                         '201508097', '201509249', '201701127', '201605176',
                         '201602836', '201505389', '201506870', '201607202',
                         '201607202', '201602587', '201608901', '201600640',
                         '201604351', '201604309', '201602156', '2102005364',
                         '201604773', '201605988', '201508795', '201604272',
                         '201602387', '201605782', '201605782', '201608123',
                         '201504062', '201605075', '2225757055', '201607079',
                         '201507555', '201607832', '201605547', '201601610',
                         '201601610', '201605855', '201605855', '201603559',
                         '201605368', '201506966', '201506720', '201506798',
                         '201604876', '201600336', '201600799', '201602586',
                         '201600949', '201506831', '201604034', '201604479',
                         '201607408', '201603317', '201507190', '201700440',
                         '201507693', '201508512', '201600591', '201602570',
                         '201507206', '201607598', '201607598', '201602130',
                         '201602879', '201507690', '2077396151', '201608245',
                         '201507244', '201604787', '201605999', '2095502055',
                         '201602888', '201607990', '201601362', '201604870',
                         '201602634', '201604822', '201507670', '201600678',
                         '201605940', '201604260', '201604260', '201601860',
                         '201601860', '201602381', '201604018', '201507978',
                         '201506633', '201603173', '201603173', '201508814',
                         '201608218', '201608218', '201601308', '201601308',
                         '201508119', '201603394', '201607343', '201509191',
                         '201605362', '201605362', '201507351', '201603056',
                         '201607563', '201607563', '201604178', '201605800',
                         '201604910', '201609007', '201603980', '201607287',
                         '201601261', '201601261', '201507196', '201605443',
                         '201508324', '201603991', '201603991', '201602484',
                         '201602747', '201509106', '201607262', '201607262',
                         '201604821', '201602575', '201608201', '201603022',
                         '201602754', '201602563', '201607821', '201607821',
                         '201509305', '201508306', '201602945', '201508653',
                         '201506743', '201601653', '201601653', '2540286055',
                         '201606722', '201600176', '201600500', '201602560',
                         '201602520', '201605119', '201607780', '201607780',
                         '201607192', '201607192', '201606654', '201601343',
                         '201603992', '201603992', '201603604', '201602571',
                         '201602348', '201509327', '2530623953', '201508149',
                         '201602922', '201600171', '201605293', '201604027',
                         '201604027', '201606033', '201606033', '201604457',
                         '201604457' )



UPDATE L
SET  UPDATE_DT = GETDATE(),L.UPDATE_USER_TX = I.UPDATE_USER_TX, l.LOCK_ID = CASE WHEN l.LOCK_ID >= 255 THEN 1 ELSE l.LOCK_ID + 1 END, L.STATUS_CD = I.STATUS_CD
--SELECT *
FROM dbo.LOAN L
JOIN UniTracHDStorage..INC0298691 I ON I.ID = L.ID 
WHERE L.LENDER_ID <> '92'



SELECT * FROM dbo.LENDER
WHERE ID = 92


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0298691' , 'N' , 
 GETDATE() ,  1 , 
'converted back to appropriate status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0298691)
AND  L.LENDER_ID <> '92'
