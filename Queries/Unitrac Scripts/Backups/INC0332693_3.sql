USE [UniTrac]
GO 


--DROP TABLE UniTracHDStorage.dbo.LOAN_2065_2
SELECT *
INTO   UniTracHDStorage.dbo.LOAN_2065_3
FROM   dbo.LOAN
WHERE  LENDER_ID IN ( 2080 ) AND ID NOT IN (SELECT ID FROM   UniTracHDStorage.dbo.LOAN_2065_2)
       AND NUMBER_TX IN ( '1002179956', '1010001471', '1010001594' ,
                          '1010001997' ,'1026851530', '1037048796' ,
                          '1068756335' ,'1110001538', '1110001617' ,
                          '1110001670' ,'1110001713', '1110001754' ,
                          '1110001864' ,'1110001866', '1110001903' ,
                          '1110001907' ,'1110001912', '1110001913' ,
                          '1110001926' ,'1110001941', '1110001987' ,
                          '1110002006' ,'1110002078', '1110002110' ,
                          '1110002116' ,'1110002151', '1110002160' ,
                          '1110002260' ,'1110002264', '1110002284' ,
                          '1110002285' ,'1110002329', '1110002338' ,
                          '1110002344' ,'1110002377', '1110002389' ,
                          '1110002400' ,'1110002401', '1110002484' ,
                          '1110002500' ,'1110002505', '1110002514' ,
                          '1110002530' ,'1110002830', '1110002842' ,
                          '1110002864' ,'1110002869', '1110002880' ,
                          '1110002883' ,'1110002906', '1110002928' ,
                          '1110002932' ,'1110002935', '1110002953' ,
                          '1110002958' ,'1110002965', '1110002970' ,
                          '1110002982' ,'1110003007', '1110003013' ,
                          '1110003018' ,'1110003025', '1110003028' ,
                          '1110003031' ,'1110003032', '1110003037' ,
                          '1110003049' ,'1110003054', '1110003058' ,
                          '1110003076' ,'1110003083', '1110003089' ,
                          '1110003105' ,'1110003128', '1110003148' ,
                          '1110003160' ,'1110003163', '1110003173' ,
                          '1110003179' ,'1110003181', '1110003193' ,
                          '1110003206' ,'1110003211', '1110003220' ,
                          '1110003226' ,'1110003229', '1110003240' ,
                          '1110003248' ,'1110003262', '1110003263' ,
                          '1110003269' ,'1110003270', '1110003274' ,
                          '1110003288' ,'1110003328', '1110003331' ,
                          '1110003335' ,'1110003339', '1110003352' ,
                          '1110003358' ,'1110003359', '1110003365' ,
                          '1110003372' ,'1110003393', '1110003397' ,
                          '1110003399' ,'1110003400', '1110003411' ,
                          '1110003412' ,'1110003415', '1110003420' ,
                          '1110003426' ,'1110003429', '1110003430' ,
                          '1110003450' ,'1110003461', '1110003466' ,
                          '1110003469' ,'1110003472', '1110003484' ,
                          '1110003487' ,'1110003494', '1110003501' ,
                          '1110003510' ,'1110003515', '1110003517' ,
                          '1110003518' ,'1110003526', '1110003530' ,
                          '1110003543' ,'1110003549', '1110003551' ,
                          '1110003592' ,'1110003601', '1110003605' ,
                          '1110003606' ,'1157018205', '1159774899' ,
                          '1160405824' ,'1194300820', '1202065399' ,
                          '1222302383' ,'1223099856', '1286184697' ,
                          '1292379307' ,'1307613688', '1332487060' ,
                          '1353873894' ,'1359559090', '1391661623' ,
                          '1392628106' ,'1399223646', '1420922019' ,
                          '1427774215' ,'1435087445', '1452900000' ,
                          '1455584569' ,'1456300000', '1466500000' ,
                          '1471800000' ,'1478909545', '1481500000' ,
                          '1498288203' ,'1499200000', '1526165790' ,
                          '1545333061' ,'1548027890', '1587551501' ,
                          '1610322888' ,'1657488254', '1657610865' ,
                          '1694626283' ,'1712624976', '1722670685' ,
                          '1732390581' ,'1757205894', '1771871931' ,
                          '1817184688' ,'1843409830', '1909446619' ,
                          '1927427863' ,'1938414371', '1950796896' ,
                          '1964309368' ,'1970911450', '2004591184' ,
                          '2006053767' ,'2031760476', '2049043250' ,
                          '2050795394' ,'2067187516', '2082360660' ,
                          '2093706028' ,'2097507030', '2109600000' ,
                          '2117800000' ,'2135533581', '2144500000' ,
                          '2159700000' ,'2172200000', '2181900000' ,
                          '2223600000' ,'2247600000', '2266900000' ,
                          '2279100000' ,'2297300000', '2307500000' ,
                          '2311700000' ,'2314300000', '2321900000' ,
                          '2322000000' ,'2324700000', '2329700000' ,
                          '2332300000' ,'2344200000', '2346400000' ,
                          '2354700000' ,'2359600000', '2361100000' ,
                          '2362700000' ,'2378000000', '2385900000' ,
                          '2393200000' ,'2399700000', '2414700000' ,
                          '2436800000' ,'2446000000', '2447600000' ,
                          '2449700000' ,'2454300000', '2455300000' ,
                          '2456500000' ,'2457200000', '2457600000' ,
                          '2458300000' ,'2459900000', '2464000000' ,
                          '2465300000' ,'2468200000', '2469400000' ,
                          '2494000000' ,'2501400000', '2502600000' ,
                          '2510824750' ,'2512000000', '2517400000' ,
                          '2520800000' ,'2531200000', '2541700000' ,
                          '2553500000' ,'2568700000', '2569800000' ,
                          '2576974080' ,'2587600000', '2592300000' ,
                          '2593100000' ,'2607000000', '2613832780' ,
                          '2619200000' ,'2624100000', '2626500000' ,
                          '2626900000' ,'2628500000', '2645500000' ,
                          '2663100000' ,'2665900000', '2668000000' ,
                          '2670900000' ,'2680900000', '2694900000' ,
                          '2701600000' ,'2706600000', '2711600000' ,
                          '2722300000' ,'2723400000', '2725000000' ,
                          '2728400000' ,'2747400000', '2756600000' ,
                          '2761200000' ,'2762300000', '2773000000' ,
                          '2777000000' ,'2777600000', '2779800000' ,
                          '2787800000' ,'2791100000', '2796100000' ,
                          '2803600000' ,'2804400000', '2810800000' ,
                          '2814500000' ,'2816700000', '2818907760' ,
                          '2826000000' ,'2830500000', '2831800000' ,
                          '2832200000' ,'2833500000', '2840500000' ,
                          '2843000000' ,'2860700000', '2878100000' ,
                          '2879800000' ,'2880400000', '2888700000' ,
                          '2900600000' ,'2903000000', '2905600000' ,
                          '2905700000' ,'2918700000', '2922500000' ,
                          '2933600000' ,'2935300000', '2936800000' ,
                          '2940000000' ,'2950000000', '2952700000' ,
                          '2953300000' ,'2954800000', '2964300000' ,
                          '2967800000' ,'2969000000', '2973000000' ,
                          '2979200000' ,'2979400000', '2982000000' ,
                          '2982700000' ,'2983300000', '2986400000' ,
                          '2994100000' ,'2995000000', '2995900000' ,
                          '3002000000' ,'3002100000', '3005900000' ,
                          '3017200000' ,'3018100000', '3019900000' ,
                          '3023700000' ,'3025600000', '3025900000' ,
                          '3027300000' ,'3029500000', '3032200000' ,
                          '3036306730' ,'3051800000', '3052500000' ,
                          '3053500000' ,'3055900000', '3058300000' ,
                          '3066500000' ,'3078100000', '3080700000' ,
                          '3088600000' ,'3095100000', '3095200000' ,
                          '3095700000' ,'3098300000', '3099500000' ,
                          '3100709001' ,'3100714000', '3100917000' ,
                          '3101004000' ,'3101208000', '3102100000' ,
                          '3107600000' ,'3108400000', '3108800000' ,
                          '3110204000' ,'3110429000', '3110614000' ,
                          '3110616000' ,'3110623000', '3112100000' ,
                          '3116700000' ,'3129500000', '3130800000' ,
                          '3133100000' ,'3133600000', '3134200000' ,
                          '3136200000' ,'3137200000', '3137900000' ,
                          '3141500000' ,'3143000000', '3143600000' ,
                          '3145400000' ,'3146700000', '3150700000' ,
                          '3151300000' ,'3157800000', '3160000000' ,
                          '3168000000' ,'3168600000', '3177600000' ,
                          '3181000000' ,'3183300000', '3184400000' ,
                          '3185900000' ,'3189000000', '3190100000' ,
                          '3201300000' ,'3219700000', '3222500000' ,
                          '3223200000' ,'3224800000', '3226700000' ,
                          '3232600000' ,'3237000000', '3242600000' ,
                          '3245500000' ,'3251900000', '3257300000' ,
                          '3267900000' ,'3272300000', '3273800000' ,
                          '3280400000' ,'3282500000', '3283900000' ,
                          '3284800000' ,'3287100000', '3290300000' ,
                          '3290648500' ,'3297100000', '3298000000' ,
                          '3300200000' ,'3301600000', '3314900000' ,
                          '3317200000' ,'3322700000', '3324700000' ,
                          '3325600000' ,'3326400000', '3327000000' ,
                          '3327100000' ,'3333200000', '3333400000' ,
                          '3334300000' ,'3340500000', '3341900000' ,
                          '3344200000' ,'3349500000', '3352300000' ,
                          '3356600000' ,'3364061800', '3365000000' ,
                          '3365600000' ,'3373800000', '3375500000' ,
                          '3376500000' ,'3377400000', '3383200000' ,
                          '3387500000' ,'3393200000', '3398000000' ,
                          '3404800000' ,'3408500000', '3412700000' ,
                          '3419800000' ,'3425500000', '3426322420' ,
                          '3431900000' ,'3433500000', '3437991860' ,
                          '3443600000' ,'3454100000', '3462800000' ,
                          '3471800000' ,'3474500000', '3477400000' ,
                          '3503300000' ,'3509400000', '3516200000' ,
                          '3516500000' ,'3524400000', '3526200000' ,
                          '3526300000' ,'3534600000', '3535379740' ,
                          '3541400000' ,'3547800000', '3547900000' ,
                          '3554600000' ,'3566500000', '3590900000' ,
                          '3603500000' ,'3607300000', '3611800000' ,
                          '3617300000' ,'3621400000', '3629800000' ,
                          '3637100000' ,'3648561160', '3649700000' ,
                          '3668500000' ,'3669200000', '3669700000' ,
                          '3670300000' ,'3685200000', '3690800000' ,
                          '3709000000' ,'3733700000', '3737400000' ,
                          '3740700000' ,'3743500000', '3744900000' ,
                          '3749800000' ,'3756200000', '3762400000' ,
                          '3788900000' ,'3802500000', '3804500000' ,
                          '3823900000' ,'3842900000', '3865800000' ,
                          '3882500000' ,'3896100000', '3896900000' ,
                          '3903900000' ,'3909400000', '3913500000' ,
                          '3919300000' ,'3926968420', '3940300000' ,
                          '3966200000' ,'3973900000', '3980367900' ,
                          '3987600000' ,'4002900000', '4006000000' ,
                          '4032500000' ,'4104132820', '4136000000' ,
                          '4154000000' ,'4161700000', '4174600000' ,
                          '4182400000' ,'4183900000', '4195800000' ,
                          '4200700000' ,'4216200000', '4233300000' ,
                          '4236100000' ,'4253200000', '4256500000' ,
                          '4258000000' ,'4280100000', '4288200000' ,
                          '4297600000' ,'4337600000', '4367900000' ,
                          '4369300000' ,'4387300000', '4431800000' ,
                          '4439200000' ,'4439800000', '4450700000' ,
                          '4457500000' ,'4493400000', '4512100000' ,
                          '4514400000' ,'4543700000', '4552722740' ,
                          '4589800000' ,'4643000000', '4685100000' ,
                          '4704700000' ,'4718900000', '4755597300' ,
                          '4759800000' ,'4772500000', '4778600000' ,
                          '4801900000' ,'4816060230', '4818000000' ,
                          '4825400000' ,'4855800000', '4856200000' ,
                          '4883000000' ,'4884500000', '4895600000' ,
                          '4911732800' ,'4953700000', '4969800000' ,
                          '4974100000' ,'5032100000', '5036900000' ,
                          '5040400000' ,'5119400000', '5142720350' ,
                          '5161100000' ,'5184900000', '5196300000' ,
                          '5245100000' ,'5250900000', '5261000000' ,
                          '5266800000' ,'5268800000', '5280200000' ,
                          '5280500000' ,'5287800000', '5299900000' ,
                          '5307200000' ,'5307800000', '5310200000' ,
                          '5312900000' ,'5315000000', '5315100000' ,
                          '5323000000' ,'5323600000', '5329000000' ,
                          '5329300000' ,'5337000000', '5343000000' ,
                          '5343700000' ,'5347800000', '5353100000' ,
                          '5356300000' ,'5381700000', '5391900000' ,
                          '5397800000' ,'5403544770', '5404100000' ,
                          '5420900000' ,'5421700000', '5422700000' ,
                          '5436600000' ,'5439800000', '5447300000' ,
                          '5469100000' ,'5477800000', '5486900000' ,
                          '5491800000' ,'5498900000', '5527100000' ,
                          '5533200000' ,'5535600000', '5543100000' ,
                          '5559200000' ,'5559600000', '5560200000' ,
                          '5570400000' ,'5576500000', '5578300000' ,
                          '5580200000' ,'5581100000', '5581700000' ,
                          '5589700000' ,'5592400000', '5597300000' ,
                          '5599246200' ,'5614600000', '5618500000' ,
                          '5632400000' ,'5644200000', '5644400000' ,
                          '5646500000' ,'5651900000', '5652500000' ,
                          '5653800000' ,'5659800000', '5663800000' ,
                          '5666000000' ,'5666400000', '5667700000' ,
                          '5675900000' ,'5682800000', '5686100000' ,
                          '5700200000' ,'5713300000', '5730700000' ,
                          '5756300000' ,'5761500000', '5785000000' ,
                          '5802900000' ,'5806400000', '5808800000' ,
                          '5848500000' ,'5855500000', '5911900000' ,
                          '5927300000' ,'5928300000', '5940800000' ,
                          '5992600000' ,'6017600000', '6019800000' ,
                          '6025500000' ,'6036500000', '6047600000' ,
                          '6050200000' ,'6086000000', '6090500000' ,
                          '6108096640' ,'6109000000', '6110200000' ,
                          '6120400000' ,'6133500000', '6134900000' ,
                          '6143000000' ,'6164800000', '6169200000' ,
                          '6186500000' ,'6193800000', '6197700000' ,
                          '6207000000' ,'6210600000', '6215800000' ,
                          '6224000000' ,'6253300000', '6281800000' ,
                          '6307600000' ,'6309500000', '6312900000' ,
                          '6316600000' ,'6317500000', '6326400000' ,
                          '6337700000' ,'6343500000', '6345400000' ,
                          '6346700000' ,'6366287870', '6369000000' ,
                          '6380300000' ,'6384100000', '6384900000' ,
                          '6391000000' ,'6393600000', '6401200000' ,
                          '6401500000' ,'6408600000', '6423400000' ,
                          '6425400000' ,'6426600000', '6427300000' ,
                          '6437200000' ,'6440400000', '6446500000' ,
                          '6469200000' ,'6482100000', '6485400000' ,
                          '6487600000' ,'6508000000', '6521500000' ,
                          '6529000000' ,'6537500000', '6558100000' ,
                          '6559400000' ,'6561000000', '6571600000' ,
                          '6577100000' ,'6580800000', '6584600000' ,
                          '6601300000' ,'6635200000', '6659100000' ,
                          '6667100000' ,'6676900000', '6681400000' ,
                          '6687800000' ,'6689800000', '6707400000' ,
                          '6719000000' ,'6721100000', '6727500000' ,
                          '6748700000' ,'6759013280', '6774300000' ,
                          '6778300000' ,'6779800000', '6780700000' ,
                          '6799620100' ,'6803900000', '6808300000' ,
                          '6810800000' ,'6817800000', '6824000000' ,
                          '6829500000' ,'6831000000', '6832400000' ,
                          '6839400000' ,'6848600000', '6850900000' ,
                          '6851100000' ,'6858300000', '6858800000' ,
                          '6859400000' ,'6864800000', '6865000000' ,
                          '6865600000' ,'6876900000', '6880800000' ,
                          '6882400000' ,'6885800000', '6895500000' ,
                          '6904500000' ,'6904700000', '6908300000' ,
                          '6908900000' ,'6930400000', '6934600000' ,
                          '6934800000' ,'6935700000', '6953300000' ,
                          '6966600000' ,'6969800000', '6974500000' ,
                          '6978400000' ,'6994700000', '6996600000' ,
                          '7002600000' ,'7002900000', '7006500000' ,
                          '7009000000' ,'7012100000', '7012700000' ,
                          '7019600000' ,'7052200000', '7054600000' ,
                          '7059500000' ,'7061100000', '7062100000' ,
                          '7064300000' ,'7068500000', '7074100000' ,
                          '7089800000' ,'7091800000', '7100400000' ,
                          '7117400000' ,'7133400000', '7145500000' ,
                          '7169800000' ,'7173500000', '7180200000' ,
                          '7206800000' ,'7250000000', '7257800000' ,
                          '7265200000' ,'7271800000', '7275800000' ,
                          '7299800000' ,'7301620040', '7328500000' ,
                          '7341500000' ,'7353100000', '7359000000' ,
                          '7368400000' ,'7402600000', '7406278140' ,
                          '7408700000' ,'7418300000', '7432400000' ,
                          '7443600000' ,'7445500000', '7447800000' ,
                          '7453000000' ,'7459100000', '7492700000' ,
                          '7514300000' ,'7515000000', '7542100000' ,
                          '7546280010' ,'7556100000', '7566900000' ,
                          '7570600000' ,'7571600160', '7577500000' ,
                          '7590100000' ,'7619100000', '7627600000' ,
                          '7658100000' ,'7677100000', '7682700000' ,
                          '7684700000' ,'7701200000', '7714900000' ,
                          '7722500000' ,'7736100000', '7744400000' ,
                          '7750100000' ,'7765900000', '7774900000' ,
                          '7794100000' ,'7816600000', '7823500000' ,
                          '7843100000' ,'7876200000', '7880900000' ,
                          '7887330490' ,'7935894730', '7965447600' ,
                          '7977100000' ,'8125373980', '8197507110' ,
                          '8366420570' ,'8572233190', '8885922370' ,
                          '9073008100' ,'9093885030', '9364332790' ,
                          '9674652090' ,'9920236260', '9979892450' ,
                          '1110003123' ,'1127428279', '1353301737' ,
                          '1452124420' ,'1468510661', '2141542684' ,
                          '2188100000' ,'2215100000', '2215700000' ,
                          '2367600000' ,'2376200000', '2388200000' ,
                          '2390900000' ,'2426300000', '2503300000' ,
                          '2503500000' ,'2535700000', '2545000000' ,
                          '2547800000' ,'2619300000', '2646900000' ,
                          '2652600000' ,'2747300000', '2796400000' ,
                          '2797300000' ,'2815800000', '2863800000' ,
                          '2864100000' ,'2871200000', '2934500000' ,
                          '2938200000' ,'2941900000', '2960600000' ,
                          '2961000000' ,'2987600000', '3008500000' ,
                          '3011000000' ,'3012600000', '3056100000' ,
                          '3056400000' ,'3066900000', '3087700000' ,
                          '3096100000' ,'3113900000', '3133000000' ,
                          '3262600000' ,'3410900000', '3412600000' ,
                          '3441000000' ,'3521300000', '3661500000' ,
                          '3715900000' ,'3723400000', '3736700000' ,
                          '3737500000' ,'3746100000', '3869700000' ,
                          '3931400000' ,'4015300000', '4058100000' ,
                          '4104600000' ,'4116400000', '4543300000' ,
                          '4687600000' ,'4771800000', '4806200000' ,
                          '4878900000' ,'4891500000', '4910700000' ,
                          '4985200000' ,'5098300000', '5102200000' ,
                          '5140800000' ,'5222908180', '5223900000' ,
                          '5301600000' ,'5327900000', '5352700000' ,
                          '5367900000' ,'5376000000', '5431500000' ,
                          '5443400000' ,'5482800000', '5525000000' ,
                          '5557000000' ,'5635500000', '5651400000' ,
                          '5696200000' ,'5726900000', '5786300000' ,
                          '5820100000' ,'5852200000', '6053300000' ,
                          '6147400000' ,'6302500000', '6384600000' ,
                          '6466600000' ,'6561200000', '6580300000' ,
                          '6643300000' ,'6678300000', '6718500000' ,
                          '6901800000' ,'7058200000', '7084100000' ,
                          '7164700000' ,'7203300000', '7388500000' ,
                          '7745800000' ,'7798000000', '8984017440' ,
                          '9987870460'
                        )

SELECT L.PURGE_DT, L.RECORD_TYPE_CD, P.PURGE_DT, P.RECORD_TYPE_CD, C.PURGE_DT, RC.PURGE_DT, RC.RECORD_TYPE_CD,
L.ID, P.ID, C.ID, RC.ID
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage.dbo.LOAN_2065_3)




/*
--Delete them back

UPDATE dbo.REQUIRED_COVERAGE
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'D', PURGE_DT = NULL
--SELECT * FROM dbo.REQUIRED_COVERAGE
WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_RC)

UPDATE LOAN 
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0332693', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'D', PURGE_DT = NULL
--SELECT * FROM LOAN
WHERE ID IN (SELECT ID FROM UniTracHDStorage.dbo.LOAN_2065_3)


UPDATE PROPERTY
SET  UPDATE_DT = GETDATE(),UPDATE_USER_TX = 'INC0XXXXXX', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END, RECORD_TYPE_CD = 'D', PURGE_DT = NULL
--SELECT * FROM PROPERTY
WHERE ID IN (SELECT ID FROM  UniTracHDStorage..INC0XXXXXX_P)


INSERT --INTOPROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0XXXXXX' , 'N' , 
 GETDATE() ,  1 , 
 'Marked back to deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_RC)

INSERT --INTOPROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Loan' , L.ID , 'INC0XXXXXX' , 'N' , 
 GETDATE() ,  1 , 
 'Marked back to deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Loan' , L.ID , 'PEND' , 'N'
FROM LOAN L 
WHERE L.ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_L)



INSERT --INTOPROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , P.ID , 'INC0XXXXXX' , 'N' , 
 GETDATE() ,  1 , 
 'Marked back to deleted', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , P.ID , 'PEND' , 'N'
FROM PROPERTY P
WHERE P.ID IN (SELECT ID FROM UniTracHDStorage..INC0XXXXXX_P)

*/






