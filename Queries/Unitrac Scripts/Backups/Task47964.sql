use unitrac


select DEALER_CODE_TX, * --into UnitracHDStorage..Task47964
from loan
where id in ('224066235',
'224066264',
'224066289',
'224066319',
'224066607',
'224066647',
'224066664',
'224067021',
'224067052',
'224067552',
'224069279',
'224069398',
'224073455',
'224075476',
'224076791',
'224080586',
'224087155',
'224114029',
'224118732',
'224061808',
'224061882',
'224061920',
'224061978',
'224062012',
'224062107',
'224062141',
'224062160',
'224062353',
'224062372',
'224062419',
'224062450',
'224062542',
'224062734',
'224062769',
'224062819',
'224062865',
'224065012',
'224065414',
'224065452',
'224065773',
'224065844',
'224066389',
'224066495',
'224066651',
'224066727',
'224066754',
'224067149',
'224067189',
'224067228',
'224068257',
'224068302',
'224068357',
'224068400',
'224068563',
'224068587',
'224068620',
'224068676',
'224068831',
'224068847',
'224068877',
'224068904',
'224069054',
'224069103',
'224069119',
'224069148',
'224069567',
'224069652',
'224069670',
'224069701',
'224069803',
'224069821',
'224070444',
'224070456',
'224070571',
'224070642',
'224070670',
'224070680',
'224070730',
'224070936',
'224071006',
'224071053',
'224071207',
'224071376',
'224072081',
'224072127',
'224072194',
'224072226',
'224072248',
'224072502',
'224072585',
'224072622',
'224072722',
'224072748',
'224072797',
'224073751',
'224073774',
'224074256',
'224074551',
'224074675',
'224074720',
'224074782',
'224074823',
'224075090',
'224075386',
'224075565',
'224075707',
'224076669',
'224077035',
'224077069',
'224077613',
'224077793',
'224078456',
'224078542',
'224078702',
'224078743',
'224078812',
'224078945',
'224080285',
'224080324',
'224080367',
'224080634',
'224080655',
'224081362',
'224081381',
'224081577',
'224081596',
'224081614',
'224081627',
'224081640',
'224081730',
'224081777',
'224081830',
'224081947',
'224081968',
'224082007',
'224082128',
'224082245',
'224082402',
'224082494',
'224082581',
'224082660',
'224083432',
'224083713',
'224083782',
'224083801',
'224083842',
'224083861',
'224083896',
'224083936',
'224084255',
'224084349',
'224084400',
'224084453',
'224071783',
'224109820',
'224122496',
'224130490',
'224136172',
'224141617',
'224142455',
'224142626',
'224143145',
'224145702',
'224151205',
'224154248',
'224155272',
'224155567',
'224157753',
'224158175',
'224158873',
'224162080',
'224162249',
'224163652',
'224063061',
'224065018',
'224066388',
'224066878',
'224069097',
'224070064',
'224071173',
'224071734',
'224091312',
'224091999',
'224098382',
'224101924',
'224113291',
'224116313',
'224116577',
'224118532',
'224122265',
'224122554',
'224125602',
'224126059',
'224128757',
'224130130',
'224132104',
'224136129',
'224061959',
'224062034',
'224062945',
'224063116',
'224063133',
'224063292',
'224063384',
'224063408',
'224064512',
'224064543',
'224065153',
'224065434',
'224065924',
'224067075',
'224068633',
'224068891',
'224069409',
'224070038',
'224070905',
'224074004',
'224074292',
'224075766',
'224077026',
'224077349',
'224077494',
'224078558',
'224079000',
'224081387',
'224081479',
'224081598',
'224082238',
'224085238',
'224086105',
'224086426',
'224087800',
'224089818',
'224090069',
'224092282',
'224097243',
'224097335',
'224097974',
'224100611',
'224100637',
'224104367',
'224108387',
'224110483',
'224111937',
'224113831',
'224114379',
'224114946',
'224115842',
'224126754',
'224126887',
'224127823',
'224128724',
'224135282',
'224136345',
'224137609',
'224140263',
'224144399',
'224144604',
'224145504',
'224145534',
'224145699',
'224146162',
'224148154',
'224152913',
'224061671',
'224061860',
'224062332',
'224062475',
'224062746',
'224063141',
'224063435',
'224063449',
'224065471',
'224067016',
'224066078',
'224067143',
'224067347',
'224067607',
'224067968',
'224068763',
'224069382',
'224070308',
'224072272',
'224074015',
'224074063',
'224076143',
'224079956',
'224082971',
'224084304',
'224084752',
'224084948',
'224085497',
'224085775',
'224086775',
'224087020',
'224087483',
'224089733',
'224091163',
'224092423',
'224093123',
'224093984',
'224096017',
'224096234',
'224097047',
'224100480',
'224100569',
'224102040',
'224102063',
'224102412',
'224102747',
'224103687',
'224103939',
'224104299',
'224104455',
'224105629',
'224105979',
'224106658',
'224107158',
'224108300',
'224109178',
'224109228',
'224122789',
'224124385',
'224125448',
'224126905',
'224138080',
'224138259',
'224152912',
'224153806',
'224155250',
'224155795',
'224155691',
'224062040',
'224063225',
'224063556',
'224064021',
'224066397',
'224069647',
'224070371',
'224071628',
'224073019',
'224074000',
'224074478',
'224074704',
'224079928',
'224081361',
'224085096',
'224086033',
'224086868',
'224088481',
'224089236',
'224089376',
'224089824',
'224092118',
'224092575',
'224093093',
'224093889',
'224093932',
'224096972',
'224098465',
'224099933',
'224100922',
'224101741',
'224102008',
'224103318',
'224103811',
'224103952',
'224104782',
'224106666',
'224107864',
'224110073',
'224120249',
'224120300',
'224121457',
'224124055',
'224131032',
'224136337',
'224139354',
'224140446',
'224142680',
'224143202',
'224145757',
'224148438',
'224148780',
'224149281',
'224152423',
'224154020',
'224156016',
'224156636',
'224156713',
'224159503',
'224159764',
'224160529',
'224160919',
'224161369',
'224161200',
'224161558',
'224062669',
'224064527',
'224068722',
'224069624',
'224069792',
'224070235',
'224071176',
'224072011',
'224072239',
'224073727',
'224074792',
'224074950',
'224077342',
'224081808',
'224082647',
'224084954',
'224087425',
'224087735',
'224089704',
'224095608',
'224096750',
'224097366',
'224097385',
'224097563',
'224098170',
'224098378',
'224098491',
'224099914',
'224102377',
'224103261',
'224103339',
'224104536',
'224105207',
'224105709',
'224107882',
'224109127',
'224109711',
'224111979',
'224112210',
'224114271',
'224117318',
'224118557',
'224119965',
'224120026',
'224120447',
'224122036',
'224122141',
'224122450',
'224124147',
'224124193',
'224125769',
'224126120',
'224127571',
'224128045',
'224132503',
'224133145',
'224133534',
'224134999',
'224139566',
'224140035',
'224141020',
'224141788',
'224144999',
'224145270',
'224153026',
'224155778',
'224158978',
'224160959',
'224161982',
'224162146',
'224162479',
'224162334',
'224162410',
'224162711',
'224162752',
'224162598',
'224061826',
'224062029',
'224062045',
'224067477',
'224067859',
'224068421',
'224068719',
'224068873',
'224069512',
'224072015',
'224072962',
'224073614',
'224074230',
'224076240',
'224078162',
'224081805',
'224083941',
'224084943',
'224085467',
'224086792',
'224087386',
'224088773',
'224089216',
'224090313',
'224090786',
'224091222',
'224094144',
'224094662',
'224095756',
'224096192',
'224098028',
'224099383',
'224099584',
'224100306',
'224100578',
'224100706',
'224102005',
'224102345',
'224103353',
'224103738',
'224104926',
'224105918',
'224114783',
'224116714',
'224117329',
'224119321',
'224119392',
'224119523',
'224120104',
'224121221',
'224124256',
'224127899',
'224130123',
'224130244',
'224130331',
'224132339',
'224132910',
'224133950',
'224134291',
'224135169',
'224136407',
'224139216',
'224139328',
'224140713',
'224141264',
'224141405',
'224142596',
'224144712',
'224148564',
'224149972',
'224150589',
'224157677',
'224157981',
'224158553',
'224159905',
'224161416',
'224162713',
'224163436',
'224061964',
'224062650',
'224062672',
'224062766',
'224063427',
'224063880',
'224064228',
'224065592',
'224067197',
'224067653',
'224069531',
'224069623',
'224069919',
'224069962',
'224070491',
'224071005',
'224072967',
'224073361',
'224074546',
'224080246',
'224080919',
'224082724',
'224085205',
'224086049',
'224088880',
'224090389',
'224090795',
'224091330',
'224091351',
'224091374',
'224094854',
'224094874',
'224095272',
'224099215',
'224103055',
'224103876',
'224105390',
'224105461',
'224106382',
'224109625',
'224110263',
'224112547',
'224114884',
'224116080',
'224116329',
'224119953',
'224122069',
'224123552',
'224128785',
'224130193',
'224133005',
'224133370',
'224136684',
'224138662',
'224138872',
'224142348',
'224147774',
'224148688',
'224150375',
'224151334',
'224152102',
'224152689',
'224152984',
'224154298',
'224154396',
'224154893',
'224156150',
'224156206',
'224156303',
'224156451',
'224160881',
'224161553',
'224162888',
'224163518',
'224163842',
'224163883',
'224163995',
'224164486',
'224164540',
'224164353',
'224164547',
'224164304',
'224164780',
'224164849',
'224164647',
'224164573',
'224165021',
'224165009',
'224164860',
'224165251',
'224165311',
'224165099',
'224063355',
'224063950',
'224064120',
'224064171',
'224066636',
'224066744',
'224068226',
'224068369',
'224068378',
'224068445',
'224069748',
'224070219',
'224070656',
'224071196',
'224073186',
'224074009',
'224074558',
'224075466',
'224075521',
'224077449',
'224078368',
'224078475',
'224078995',
'224079006',
'224079082',
'224079692',
'224080477',
'224081316',
'224081534',
'224081550',
'224082392',
'224082953',
'224083591',
'224084528',
'224084577',
'224086427',
'224086670',
'224087342',
'224087506',
'224088348',
'224088936',
'224088970',
'224089826',
'224092470',
'224094974',
'224095106',
'224095494',
'224096062',
'224097898',
'224098073',
'224098780',
'224099226',
'224102811',
'224106230',
'224107499',
'224108175',
'224109031',
'224110367',
'224111053',
'224111772',
'224111857',
'224113747',
'224117597',
'224118362',
'224119496',
'224120386',
'224121016',
'224121799',
'224123222',
'224123926',
'224125196',
'224125571',
'224127190',
'224127613',
'224128034',
'224128232',
'224130001',
'224131506',
'224131584',
'224132968',
'224132995',
'224133437',
'224136712',
'224138022',
'224138712',
'224139070',
'224140424',
'224141786',
'224142044',
'224142201',
'224144930',
'224145659',
'224150466',
'224155307',
'224155709',
'224157190',
'224158073',
'224162147',
'224163366',
'224163864',
'224164466',
'224165353',
'224165525',
'224165706',
'224165822',
'224165966',
'224166196',
'224062648',
'224065254',
'224067082',
'224067589',
'224068582',
'224069716',
'224070095',
'224071673',
'224071995',
'224072555',
'224072799',
'224072943',
'224076645',
'224076990',
'224077251',
'224077737',
'224080198',
'224083066',
'224083746',
'224085800',
'224085817',
'224085953',
'224086953',
'224087882',
'224087896',
'224087918',
'224087993',
'224088416',
'224090202',
'224092939',
'224095592',
'224096081',
'224098181',
'224099227',
'224099718',
'224101055',
'224101964',
'224102833',
'224104294',
'224105241',
'224105530',
'224106386',
'224107969',
'224108053',
'224109399',
'224113115',
'224113682',
'224114121',
'224115161',
'224117368',
'224117390',
'224117973',
'224118092',
'224118465',
'224123715',
'224124336',
'224128015',
'224128637',
'224129758',
'224130718',
'224133740',
'224135947',
'224136535',
'224136652',
'224141569',
'224144454',
'224148063',
'224148546',
'224151298',
'224151570',
'224153946',
'224158205',
'224158745',
'224159324',
'224159925',
'224160358',
'224161268',
'224163937',
'224165194',
'224165566',
'224166190',
'224166708',
'224166700',
'224166746',
'224166693',
'224167052',
'224064200',
'224065639',
'224066362',
'224067346',
'224069337',
'224069722',
'224074262',
'224074479',
'224075918',
'224077232',
'224079102',
'224082702',
'224085499',
'224085852',
'224087705',
'224088400',
'224090019',
'224090823',
'224090934',
'224094717',
'224099632',
'224099671',
'224106840',
'224107617',
'224108659',
'224108732',
'224110868',
'224114142',
'224115508',
'224116686',
'224117823',
'224119227',
'224120291',
'224122416',
'224126866',
'224136459',
'224140373',
'224145205',
'224145604',
'224155486',
'224063367',
'224064053',
'224066488',
'224067728',
'224068166',
'224069597',
'224069948',
'224070641',
'224073735',
'224076817',
'224077732',
'224079896',
'224094658',
'224102226',
'224107364',
'224108513',
'224113633',
'224113687',
'224114329',
'224116867',
'224124162',
'224128343',
'224130232',
'224130954',
'224131424',
'224133107',
'224136489',
'224136762',
'224137140',
'224139730',
'224140533',
'224141415',
'224153977',
'224158084',
'224159647',
'224160127',
'224160458',
'224161753',
'224064676',
'224066907',
'224072448',
'224072746',
'224075669',
'224077786',
'224078422',
'224078843',
'224080884',
'224083422',
'224085016',
'224089420',
'224091981',
'224092432',
'224094362',
'224095354',
'224097167',
'224098898',
'224099867',
'224100064',
'224100145',
'224102097',
'224102725',
'224103090',
'224103722',
'224104917',
'224108590',
'224116311',
'224117452',
'224123804',
'224135233',
'224138733',
'224140599',
'224144119',
'224147726',
'224148528',
'224152879',
'224153852',
'224160726',
'224163884',
'224163814',
'224066077',
'224069123',
'224069628',
'224071626',
'224072340',
'224073348',
'224074787',
'224075626',
'224076273',
'224078320',
'224080330',
'224080649',
'224081853',
'224081940',
'224082170',
'224083331',
'224086988',
'224090735',
'224091540',
'224093276',
'224093943',
'224100471',
'224102792',
'224103071',
'224105636',
'224107333',
'224108578',
'224118039',
'224119271',
'224121088',
'224122564',
'224126912',
'224127210',
'224136984',
'224144986',
'224148038',
'224152799',
'224153588',
'224153845',
'224156015',
'224162460',
'224165147',
'224165607',
'224167155',
'224166928',
'224167283',
'224071693',
'224072067',
'224072097',
'224073264',
'224073298',
'224074319',
'224074932',
'224075308',
'224075746',
'224078243',
'224085398',
'224085720',
'224093722',
'224094666',
'224097420',
'224099784',
'224106615',
'224116096',
'224125007',
'224132516',
'224136315',
'224136746',
'224142389',
'224149838',
'224149926',
'224151827',
'224152389',
'224152962',
'224156321',
'224162282',
'224166811',
'224167316',
'224167744',
'224167751',
'224167816',
'224167936',
'224167854',
'224168287',
'224077314',
'224077461',
'224078892',
'224079055',
'224081053',
'224081303',
'224085942',
'224087076',
'224090678',
'224091592',
'224092490',
'224096576',
'224099666',
'224101837',
'224102279',
'224103239',
'224110602',
'224115522',
'224122612',
'224122822',
'224125606',
'224128319',
'224131503',
'224131947',
'224137562',
'224139639',
'224147844',
'224167197',
'224168841',
'224168944',
'224169254',
'224077636',
'224080307',
'224080320',
'224080980',
'224084039',
'224084140',
'224086556',
'224098129',
'224100468',
'224103173',
'224104426',
'224105250',
'224122905',
'224125679',
'224130836',
'224130879',
'224132632',
'224139201',
'224161100',
'224162168',
'224165157',
'224167545',
'224168843',
'224169557',
'224169753',
'224169955',
'224170026',
'224170134',
'224170263',
'224170601',
'224170793',
'224083478',
'224092875',
'224098939',
'224100438',
'224101531',
'224102961',
'224104269',
'224107048',
'224109266',
'224110511',
'224124521',
'224132596',
'224149547',
'224153123',
'224156418',
'224160785',
'224161164',
'224163985',
'224165775',
'224168497',
'224171199',
'224172109',
'224172248',
'224172269',
'224172536',
'224087378',
'224088272',
'224091559',
'224091741',
'224092606',
'224092940',
'224094679',
'224095166',
'224106461',
'224109557',
'224122311',
'224123431',
'224127068',
'224134268',
'224137362',
'224139507',
'224139561',
'224140882',
'224140905',
'224146595',
'224148788',
'224149963',
'224150046',
'224151603',
'224153114',
'224155980',
'224158321',
'224159138',
'224162748',
'224163133',
'224172069',
'224172194',
'224172884',
'224172815',
'224173021',
'224172866',
'224173368',
'224173146',
'224173821',
'224104122',
'224108551',
'224111556',
'224116838',
'224117826',
'224121343',
'224121805',
'224139000',
'224139068',
'224139320',
'224141882',
'224148372',
'224155037',
'224162535',
'224167425',
'224170226',
'224171234',
'224173443',
'224174260',
'224174416',
'224175788',
'224176079',
'224176116',
'224176150',
'224176201',
'224176248',
'224176731',
'224176736',
'224176592',
'224109229',
'224109783',
'224115141',
'224122160',
'224130735',
'224135082',
'224135259',
'224137063',
'224152380',
'224157993',
'224177455',
'224177668',
'224177773',
'224177827',
'224178403',
'224178427',
'224178573',
'224178599',
'224178915',
'224178824',
'224179372',
'224179218',
'224179239',
'224110600',
'224118024',
'224123838',
'224127681',
'224144561',
'224149106',
'224149690',
'224165942',
'224168460',
'224179895',
'224179490',
'224179880',
'224179956',
'224179743',
'224179971',
'224180408',
'224180344',
'224180358',
'224180859',
'224180891',
'224180977',
'224181172',
'224181352',
'224182267',
'224118559',
'224123027',
'224125365',
'224128481',
'224138571',
'224149787',
'224154511',
'224165679',
'224167327',
'224168063',
'224170064',
'224172805',
'224178193',
'224182223',
'224182294',
'224182372',
'224182807',
'224182903',
'224182894',
'224183363',
'224183067',
'224183250',
'224184106',
'224184165',
'224184302',
'224119750',
'224123759',
'224133723',
'224134213',
'224144438',
'224145140',
'224145940',
'224151401',
'224159763',
'224159863',
'224159947',
'224163371',
'224163420',
'224163583',
'224165558',
'224170973',
'224185832',
'253450303',
'224185771',
'224185953',
'224186214',
'224186543',
'224186271',
'224186333',
'224186772',
'224186501',
'224186590',
'224186913',
'228658648',
'224122952',
'224131293',
'224134756',
'224146882',
'224150871',
'224152751',
'257797286',
'224157532',
'224166497',
'224172616',
'249208816',
'224187324',
'224187404',
'224187436',
'224187230',
'255650771',
'224188045',
'236998518',
'224187962',
'224187861',
'224188373',
'224188645',
'224188800',
'224188901',
'224188710',
'224189129',
'226333523',
'225567800',
'257797310',
'225986879',
'224189338',
'263469850',
'227243841',
'227243843',
'224189533',
'226333598',
'224189747',
'230995975',
'224121949',
'224127829',
'225567922',
'253452646',
'234155932',
'226333831',
'224514139',
'227585056',
'227243855',
'237729167',
'225570151',
'233330250',
'231769615',
'227587887',
'227588359',
'229966916',
'253010131',
'225228234',
'269806324',
'269251000',
'231496148',
'229146052',
'269291139',
'229146198',
'246469069',
'234481074',
'242023640',
'241167908',
'235262384',
'247088809',
'240097323',
'241751035',
'246852193',
'246469084',
'264669728',
'268642909',
'242999085',
'241168032',
'249147482',
'253655790',
'246003739',
'251294374',
'253456381',
'259354468',
'247303568',
'251519412',
'269628889',
'252349768',
'269160943',
'268269644',
'265963133',
'269628890',
'269826832',
'268566488',
'257454146',
'269291182',
'259518033',
'269676858',
'268269652',
'263277625',
'260906132',
'261586742',
'259798043',
'269434856',
'268269653',
'266121737',
'263470094',
'264542097',
'261097140',
'263086143',
'268628447',
'268734149',
'269676877',
'268642928',
'268520988',
'268251226',
'265963191',
'268541847',
'270585024',
'269715528',
'268520993',
'268307779',
'268680324',
'268520998',
'268642941',
'269188641',
'268762627',
'268734181',
'268680341',
'269349568',
'269129227',
'269393776',
'269309242',
'269676931',
'269291218',
'269188702',
'269309248',
'270236407',
'269956137',
'269731573',
'224145819',
'224151507',
'224158475',
'224169943',
'224171279',
'224178716',
'224183400',
'224187909',
'224188412',
'224191000',
'224190980',
'224189985',
'224190978',
'224191658',
'224191287',
'224191809',
'224191863',
'224192125',
'224191968',
'224192211',
'224192154',
'224192286',
'224192383',
'224192736',
'224192459',
'224193266',
'224193025',
'224193082',
'224193428',
'224193122',
'224123993',
'224124789',
'224125229',
'224129515',
'224130345',
'224141365',
'224146491',
'224149279',
'224149604',
'224150348',
'224150817',
'224154774',
'224162269',
'224166087',
'224168510',
'224168779',
'224170159',
'224172578',
'224179045',
'224179156',
'224180415',
'224183196',
'224187043',
'224193545',
'224193902',
'224193918',
'224194408',
'224194611',
'224194505',
'224194562',
'224194834',
'224194992',
'224195150',
'224195340',
'224195538',
'224195653',
'224195594',
'224195298',
'224125808',
'224126056',
'224152970',
'224153619',
'224165248',
'224171451',
'224172044',
'224184865',
'224185819',
'224185879',
'224188004',
'224189568',
'224195658',
'224195851',
'224195802',
'224196058',
'224196120',
'224196192',
'224196421',
'224196628',
'224196524',
'224196613',
'224196575',
'224196602',
'224196940',
'224196755',
'224197307',
'224197389',
'224197410',
'224197557',
'224197626',
'224197608',
'227228039',
'270523235',
'268307841',
'268628502') 




update L
set update_dt = GETDATE(), lock_id = lock_id+1, update_user_tx = 'Task47964', DEALER_CODE_TX = 'USDA'
--select *
from LOAN L
where id in (select id from UnitracHDStorage..Task47964)


	
INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'Task47964' , 'N' , 
 GETDATE() ,  1 , 
'Added Loans to have USDA Dealer Code', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..Task47964)
