USE UniTrac;


SELECT   LE.CODE_TX AS LENDER_CODE ,
         LE.NAME_TX AS LENDER_NAME ,
         LP.DESCRIPTION_TX AS LENDER_PRODUCT_NAME ,
         ESC.DESCRIPTION_TX AS EVENT_SEQ_NAME ,
         ISNULL(CC.CODE_TX, '') AS Collateral_Code ,
         ES.ORDER_NO AS ORDER_NUMBER ,
         ISNULL(RF1.MEANING_TX, '') AS EVENT_TYPE ,
         ES.TIMING_FROM_LAST_EVENT_DAYS_NO AS TIMING ,
         ISNULL(RF2.MEANING_TX, '') AS NOTICE_TYPE ,
         ESC.START_DT ,
         ESC.END_DT
		 INTO jcs..INC0313554
FROM     EVENT_SEQUENCE ES
         INNER JOIN EVENT_SEQ_CONTAINER ESC ON ESC.ID = ES.EVENT_SEQ_CONTAINER_ID
                                               AND ESC.PURGE_DT IS NULL
         INNER JOIN LENDER_PRODUCT LP ON LP.ID = ESC.LENDER_PRODUCT_ID
                                         AND LP.PURGE_DT IS NULL
         INNER JOIN LENDER LE ON LE.ID = LP.LENDER_ID
                                 AND LE.PURGE_DT IS NULL
         LEFT JOIN REF_CODE RF1 ON RF1.CODE_CD = ES.EVENT_TYPE_CD
                                   AND RF1.DOMAIN_CD = 'EventSequenceEventType'
         LEFT JOIN REF_CODE RF2 ON RF2.CODE_CD = ES.NOTICE_TYPE_CD
                                   AND RF2.DOMAIN_CD = 'NoticeType'
         LEFT JOIN COLLATERAL_CODE CC ON CC.ID = ESC.COLLATERAL_CODE_ID
                                         AND CC.PURGE_DT IS NULL
WHERE    LE.CODE_TX IN ( '2908', '3631', '2909', '2086', '7073', '2949', '7120' ,
                         '3170' ,'2910', '2323', '41010066', '1640', '5115' ,
                         '034000' ,'4475', '019800', '41010108', '41010100' ,
                         '6573' ,'41020143', '019900', '1574', '2901', '4262' ,
                         '2911' ,'2912', '6361', '4356', '1593', '2302', '4058' ,
                         '4401' ,'7224', '2913', '41010158', '2902', '6536' ,
                         '1597' ,'7533', '1607', '2301', '3186', '6486', '0130' ,
                         '7651' ,'41010085', '4078', '6401', '1015', '6485' ,
                         '4284' ,'2076', '2948', '1738', '1948', '1889', '5310' ,
                         '2915' ,'0101', '021000', '6531', '2916', '6260' ,
                         '2903' ,'7544', '1863', '2944', '3045', '3045', '2946' ,
                         '2904' ,'6493', '41016300', '7654', '3132', '3037' ,
                         '1770' ,'4267', '2905', '6463', '6551', '41012700' ,
                         '2289' ,'5528', '41010019', '1215', '4400', '4150' ,
                         '2918' ,'6233', '6235', '4096', '6157', '1980', '4220' ,
                         '1897' ,'6403', '3224', '6254', '1838', '6519', '0259' ,
                         '9991' ,'3068', '41015100', '1727', '1996', '1619' ,
                         '6258' ,'7559', '3551', '2405', '2919', '1594', '1636' ,
                         '6522' ,'2038', '3760', '3131', '6490', '1588', '2295' ,
                         '1921' ,'6453', '2933', '2920', '2921', '2011' ,
                         '41010097' ,'23040027', '6459', '2922', '2923' ,
                         '41010101' ,'7571', '2942', '2042', '6484', '1873' ,
                         '1938' ,'2943', '6610', '1919', '1945', '1952', '2935' ,
                         '0005' ,'3413', '2950', '6599', '1858', '6262', '1598' ,
                         '2924' ,'1871', '2925', '2926', '2927', '1790', '2931' ,
                         '2495' ,'1757', '2937', '1205', '1811', '7400', '2906' ,
                         '5215' ,'844457', '1764', '027000', '2938', '4368' ,
                         '1958' ,'2907', '6556', '1961', '1580', '3544', '2947' ,
                         '2095' ,'1822', '1025', '1627', '1836', '1716', '1733' ,
                         '1732' ,'2939', '2932', '3055', '3055', '3054', '3054' ,
                         '4100' ,'7604', '1721', '2940', '6224', '2045', '1981' ,
                         '028000' ,'BKTEST-EO', 'BKTEST-FUL', '1280', '4188' ,
                         '2945' ,'2347', '3560', '6801', '4340', '1766' ,
                         '030000' ,'2929', '035000', '1925', '6443', '3585' ,
                         '1984' ,'2930', '6150', '1683', '7026', '2941', '1798' ,
                         '1595' ,'3089', '4299', '2240', '1827', '4118', '1767' ,
                         '1888' ,'7623', '1587', '4336', '6386', '1955', '6501' ,
                         '6085V' ,'6085', '2242', '2215', '6200', '6324' ,
                         '3379' ,'6226', '3338', '6517', '1180', '6308', '6244' ,
                         '41010150' ,'41015800', '1604', '6257', '4312', '3189' ,
                         '6221' ,'6550', '6368', '6544', '0072', '5000', '6409' ,
                         '6532' ,'1270', '6206', '7072', '4366', '6369', '2917' ,
                         '41010078' ,'6385', '1765', '2022', '6261', '6428' ,
                         '2072' ,'1963', '024000', '1596', '6184', '3346' ,
                         '6194' ,'4106', '4182', '6253', '4068', '1864', '4178' ,
                         '2389' ,'6352', '6377', '1639', '4338', '1834', '1585' ,
                         '6417' ,'6170', '1792', '6278', '2936', '7071', '6160' ,
                         '3072' ,'6245', '6420', '026000', '4112', '1878' ,
                         '6309' ,'1944', '6230', '6533', '6418', '6552', '4094' ,
                         '6482' ,'6256', '6188', '1950', '4240', '3122', '4136' ,
                         '6346' ,'4098', '6416', '3494', '4244', '6263', '4358' ,
                         '41016700' ,'41010061', '41010094', '23040038' ,
                         '41010092' ,'41010013', '23040025', '41010112' ,
                         '41016500' ,'41010075', '41020147', '41010161' ,
                         '41014200' ,'41014500', '41010144', '41010174' ,
                         '41010138' ,'41015900', '41012500', '2914', '3336' ,
                         '6410' ,'1935', '1892', '6271', '7028', '1740', '1886' ,
                         '6255' ,'1608', '4376', '6264', '6393', '6537', '4250' ,
                         '3320' ,'9905', '3354', '3312', '4374', '6143', '4263' ,
                         '6398' ,'1828', '4104', '2928', '6307', '6481', '1592' ,
                         '6243' ,'1720', '6422'
                       )
         AND ES.PURGE_DT IS NULL
ORDER BY LE.CODE_TX ,
         LP.DESCRIPTION_TX ,
         ESC.DESCRIPTION_TX ,
         CC.CODE_TX ,
         ES.ORDER_NO;