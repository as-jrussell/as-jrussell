USE [UniTrac]
GO 



SELECT COUNT(*)
 FROM UniTracHDStorage..INC0241090_Original
WHERE Status_CD = 'I'

--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT  NUMBER_TX ,
        RC.* --INTO UniTracHDStorage..INC0241090
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
        INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
        INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
        INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
        INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
        INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
WHERE   LL.CODE_TX IN ( '2258' )
        AND L.NUMBER_TX IN ( '5441', '5640', '5640', '6104', '6104', '6173',
                             '6173', '6178', '6178', '6316', '6316', '6789',
                             '6789', '6855', '6855', '6862', '6862', '7116',
                             '7116', '7181', '7181', '7336', '7336', '7337',
                             '7337', '7345', '7345', '7365', '7365', '7366',
                             '7366', '7413', '7413', '7702', '7702', '7752',
                             '7752', '7991', '7991', '8193', '8193', '8211',
                             '8211', '8360', '8360', '8406', '8406', '8597',
                             '8597', '8732', '8732', '8763', '8763',
                             '20040229', '20040229', '20080150', '20080150',
                             '20080164', '20080164', '1491', '1491', '1491',
                             '1741', '1741', '1741', '3962', '3962', '3962',
                             '4126', '4126', '4126', '5725', '5725', '5725',
                             '6628', '6628', '6628', '7612', '7612', '7612',
                             '2389', '2389', '2464', '2464', '3113', '3113',
                             '3613', '3613', '4496', '4496', '4865', '4865',
                             '5577', '5577', '7419', '7419', '7804', '7804',
                             '8311', '8311', '8400', '8400', '8854', '8854',
                             '20040131', '20040131', '20050426', '20050426',
                             '20070120', '20070120', '3115', '3115', '3115',
                             '3115', '2471', '2471', '2471', '4859', '4859',
                             '4859', '5115', '5115', '5115', '5835', '5835',
                             '5835', '20040180', '20040180', '20040180',
                             '2139', '2139', '2139', '6242', '6242', '6242',
                             '1666', '1666', '814', '814', '1394', '1394',
                             '1485', '1485', '1557', '1557', '1588', '1588',
                             '1605', '1605', '1663', '1663', '2375', '2375',
                             '2548', '2548', '2672', '2672', '2785', '2785',
                             '3556', '3556', '3738', '3738', '3851', '3851',
                             '3905', '3905', '3991', '3991', '4030', '4030',
                             '4167', '4167', '4252', '4252', '4287', '4287',
                             '4291', '4291', '4328', '4328', '4380', '4380',
                             '4583', '4583', '4659', '4659', '4737', '4737',
                             '4770', '4770', '5103', '5103', '5113', '5113',
                             '5119', '5119', '5259', '5259', '5425', '5425',
                             '5426', '5426', '5573', '5573', '5704', '5704',
                             '5772', '5772', '6270', '6270', '6454', '6454',
                             '6642', '6642', '6866', '6866', '7108', '7108',
                             '7495', '7495', '7506', '7506', '7527', '7527',
                             '7848', '7848', '7922', '7922', '7951', '7951',
                             '7993', '7993', '7996', '7996', '8228', '8228',
                             '8255', '8255', '8427', '8427', '8682', '8682',
                             '8746', '8746', '20040016', '20040016',
                             '20050439', '20050439', '20070065', '20070065',
                             '1420', '1420', '1420', '2985', '2985', '2985',
                             '3258', '3258', '3258', '3486', '3486', '3486',
                             '20080166', '20080166', '20080166', '5021',
                             '5021', '5021', '5449', '5449', '5449', '7489',
                             '7489', '7489', '7932', '7932', '7932',
                             '20050272', '20050272', '20050272', '20050410',
                             '20050410', '20050410', '751', '751', '770',
                             '770', '1307', '1307', '20040006', '20040006',
                             '2581', '2581', '2649', '2649', '2746', '2746',
                             '3100', '3100', '3461', '3461', '6210', '6210',
                             '6240', '6240', '6900', '6900', '6994', '6994',
                             '7114', '7114', '7321', '7321', '8697', '8697',
                             '20090131', '20090131', '3581', '3581', '3581',
                             '3793', '3793', '3793', '8718', '8718', '8718',
                             '811', '811', '1066', '1066', '1381', '1381',
                             '2775', '2775', '2989', '2989', '3476', '3476',
                             '3535', '3535', '3659', '3659', '3955', '3955',
                             '3982', '3982', '4231', '4231', '4579', '4579',
                             '4846', '4846', '4942', '4942', '5034', '5034',
                             '5293', '5293', '5441', '5441' ) AND RC.STATUS_CD = 'I'

UPDATE RC SET RC.UPDATE_DT = GETDATE() , RC.UPDATE_USER_TX = 'INC0241090' ,
RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END, RC.STATUS_CD = 'M'
--SELECT DISTINCT RC.ID, NUMBER_TX
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0241090)
--682


--3) Insert History into PROPERTY_CHANGE table
 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0241090' , 'N' , 
 GETDATE() ,  1 , 
 'Moved Loan to  Maintenance Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT ID FROM UniTracHDStorage..INC0241090)
--592




UPDATE RC SET RC.UPDATE_DT = GETDATE() , RC.UPDATE_USER_TX = 'INC0241090' ,
RC.LOCK_ID = CASE WHEN RC.LOCK_ID >= 255 THEN 1 ELSE RC.LOCK_ID + 1 END, RC.STATUS_CD = 'I'
--SELECT DISTINCT RC.ID, NUMBER_TX
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT ID FROM #tmp)





 INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.RequiredCoverage' , RC.ID , 'INC0241090' , 'N' , 
 GETDATE() ,  1 , 
 'Moved Loan to Back to Inactive Status', 
 'Y' , 'N' , 1 ,  'Allied.UniTrac.RequiredCoverage' , RC.ID , 'PEND' , 'N'
FROM REQUIRED_COVERAGE RC 
INNER JOIN PROPERTY P ON RC.PROPERTY_ID = P.ID
INNER JOIN COLLATERAL C ON P.ID = C.PROPERTY_ID
INNER JOIN LOAN L ON L.ID = C.LOAN_ID
WHERE RC.ID IN (SELECT ID FROM #tmp)