USE [UniTrac]
GO 

SELECT * FROM dbo.LENDER
WHERE ID = '2047'


--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE
SELECT DISTINCT L.NUMBER_TX,L.DIVISION_CODE_TX, P.DESCRIPTION_TX, VIN_TX, MAKE_TX, MODEL_TX,YEAR_TX, BODY_TX, P.UPDATE_USER_TX, P.UPDATE_DT
--INTO UniTracHDStorage..INC0236401Loan
FROM    LOAN L
        INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
        INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
WHERE   L.LENDER_ID IN ( '2047' )
        AND L.NUMBER_TX IN ('1893305010')
		


		
		 ( '1893305010')

SELECT * FROM dbo.COLLATERAL
WHERE LOAN_ID = '130977015'

SELECT * FROM dbo.PROPERTY
WHERE ID IN (103835411,
103835412,
103835413,
103835414,
103835415,
103835416,
103835417,
103835418,
103835419,
103835420,
103835421,
103835422,
103835423,
103835424,
103835425,
103835426,
103835427,
103835428,
103835429,
103835430,
103835431,
103835432,
103835433,
103835434,
103835435,
103835436,
103835437,
103835438,
103835439,
103835440,
103835441,
103835442,
103835443,
103835444,
103835445,
103835446,
103835448,
103835449,
103835450,
103835451,
103835452,
103835453,
103835454,
103835455,
103835456,
103835457,
103835458,
103835459,
103835460,
103835461,
103835462,
103835463,
103835464,
103835465,
103835466,
103835467,
103835468,
103835469,
103835470,
103835471,
103835472,
103835473,
103835474,
103835475,
103835476,
103835477,
103835478,
103835479,
103835480,
103835481,
103835482,
103835483,
103835484,
103835485,
103835486,
103835487,
103835488,
103835489,
103835490,
103835491,
103835492,
103835493,
103835494,
103835495)
/*
		( '1560795017', '1741465028', '1741465028',
                             '17791450', '17791450', '17791450', '177914503',
                             '177914504', '177914507', '179625502',
                             '180859502', '181076501', '182761503',
                             '182904506', '182904506', '182904506',
                             '182904506', '182904506', '182904507',
                             '182904507', '183865504', '183865504',
                             '183865505', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330507', '189330507', '189330507',
                             '189330507', '189330507', '189330507',
                             '189330507', '189330507', '189330507',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189888501', '189888501', '191087504',
                             '196420501', '199473501', '202175502',
                             '202793504', '202793504', '202793504',
                             '204157503', '204157507', '204157507',
                             '207249501', '207249501', '208745502',
                             '30000159135', '30000180495', '30000188580',
                             '30000188580', '30000188639' ) */

SELECT L.ID, L.NUMBER_TX 
FROM    LOAN L
WHERE   L.LENDER_ID IN ( '2047' )
        AND L.NUMBER_TX IN 
		
		( '1560795017', '1741465028', '1741465028',
                             '17791450', '17791450', '17791450', '177914503',
                             '177914504', '177914507', '179625502',
                             '180859502', '181076501', '182761503',
                             '182904506', '182904506', '182904506',
                             '182904506', '182904506', '182904507',
                             '182904507', '183865504', '183865504',
                             '183865505', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305010', '1893305010',
                             '1893305010', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305013',
                             '1893305013', '1893305013', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '1893305014', '1893305014', '1893305014',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330503', '189330503',
                             '189330503', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330506', '189330506', '189330506',
                             '189330507', '189330507', '189330507',
                             '189330507', '189330507', '189330507',
                             '189330507', '189330507', '189330507',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330508', '189330508',
                             '189330508', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189330509', '189330509', '189330509',
                             '189888501', '189888501', '191087504',
                             '196420501', '199473501', '202175502',
                             '202793504', '202793504', '202793504',
                             '204157503', '204157507', '204157507',
                             '207249501', '207249501', '208745502',
                             '30000159135', '30000180495', '30000188580',
                             '30000188580', '30000188639' )

SELECT * FROM  UniTracHDStorage..INC0236401 


UPDATE P 
SET P.UPDATE_DT = I.UPDATE_DT, P.UPDATE_USER_TX = I.UPDATE_USER_TX, P.DESCRIPTION_TX = I.DESCRIPTION_TX,
P.VIN_TX = I.VIN_TX, P.YEAR_TX = I.YEAR_TX, P.MAKE_TX = I.MAKE_TX, P.MODEL_TX = I.MODEL_TX
--SELECT P.*
FROM dbo.PROPERTY P 
INNER JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
JOIN UniTracHDStorage..INC0236401 I ON I.LoanNumber_TX = L.NUMBER_TX AND I.EquipmentDescription_TX = P.DESCRIPTION_TX



UPDATE P 
SET P.UPDATE_DT = I.UPDATE_DT , P.UPDATE_USER_TX = I.UPDATE_USER_TX, 
P.VIN_TX = I.VIN_TX, P.YEAR_TX = I.YEAR_TX, P.MAKE_TX = I.MAKE_TX, P.MODEL_TX = I.MODEL_TX
--SELECT P.*
FROM dbo.PROPERTY P 
INNER JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
JOIN UniTracHDStorage..INC0236401Prop I ON I.ID = P.ID -- AND I.VehicleVIN_TX = P.VIN_TX
WHERE L.NUMBER_TX = '1893305010'


SELECT * FROM UniTracHDStorage..INC0236401Prop
SELECT * FROM UniTracHDStorage..INC0236401

DROP TABLE #tmp

SELECT L.NUMBER_TX, P.VIN_TX, P.YEAR_TX, P.MAKE_TX, P.MAKE_TX --, P.UPDATE_DT, P.UPDATE_USER_TX  
FROM #tmp P
INNER JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LOAN L ON L.ID = C.LOAN_ID




SELECT L.NUMBER_TX, VIN_TX, YEAR_TX, MAKE_TX, MODEL_TX, DESCRIPTION_TX
FROM    #tmp P
        INNER JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
        INNER JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
        JOIN UniTracHDStorage..INC0236401 I ON I.LoanNumber_TX = L.NUMBER_TX
                                                AND I.VehicleVIN_TX = P.VIN_TX
--WHERE   L.NUMBER_TX = '1893305010'
ORDER BY L.NUMBER_TX ASC 


SELECT L.NUMBER_TX, VIN_TX, YEAR_TX, MAKE_TX, MODEL_TX, DESCRIPTION_TX
FROM dbo.PROPERTY P 
INNER JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
--JOIN UniTracHDStorage..INC0236401 I ON I.LoanNumber_TX = L.NUMBER_TX AND I.VehicleVIN_TX = P.VIN_TX
WHERE L.NUMBER_TX = '1893305010'
ORDER BY L.NUMBER_TX ASC 

UPDATE C
SET C.UPDATE_DT = I.UPDATE_DT, C.UPDATE_USER_TX = I.UPDATE_USER_TX, C.LENDER_COLLATERAL_CODE_TX = I.LENDER_COLLATERAL_CODE_TX
--SELECT C.* 
FROM dbo.COLLATERAL C
JOIN UniTracHDStorage..INC0236401Coll I ON I.ID = C.ID


INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Property' , P.ID , ' INC0236401' , 'N' , 
 GETDATE() ,  1 , 
 'Updated Vin, Vehicle Year, Make and Model per ticket',
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Property' , P.ID , 'PEND' , 'N'
FROM PROPERTY P
WHERE P.ID IN (SELECT ID FROM UniTracHDStorage..INC0236401Prop)




INSERT INTO PROPERTY_CHANGE
 ( ENTITY_NAME_TX , ENTITY_ID , USER_TX , ATTACHMENT_IN , 
 CREATE_DT , AGENCY_ID , DESCRIPTION_TX ,  DETAILS_IN , FORMATTED_IN ,
 LOCK_ID , PARENT_NAME_TX , PARENT_ID , TRANS_STATUS_CD , UTL_IN )
 SELECT DISTINCT 'Allied.UniTrac.Collateral' , P.ID , ' INC0236401' , 'N' , 
 GETDATE() ,  1 , 
 'Updated Vin, Vehicle Year, Make and Model per ticket',
 'Y' , 'N' , 1 ,  'Allied.UniTrac.Collateral' , P.ID , 'PEND' , 'N'
FROM PROPERTY P
WHERE P.ID IN (SELECT ID FROM UniTracHDStorage..INC0236401COll)



--Loan Screen Information - LOAN/COLLATERAL/PROPERTY/OWNER/REQUIRED COVERAGE









SELECT * FROM UniTracHDStorage..INC0236401


SELECT * FROM #tmp






SELECT DISTINCT  P.ID
        INTO #tmpPD
FROM dbo.PROPERTY P 
INNER JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
JOIN UniTracHDStorage..INC0236401 I ON I.LoanNumber_TX = L.NUMBER_TX --AND I.VehicleVIN_TX = P.VIN_TX
WHERE   L.DIVISION_CODE_TX = '9'




SELECT * 
INTO #tmp
FROM dbo.PROPERTY
WHERE ID IN (SELECT * FROM #tmpPD)




UPDATE T
SET T.UPDATE_DT = GETDATE(), T.UPDATE_USER_TX = 'INC0236401', T.LOCK_ID = T.LOCK_ID+1,
T.DESCRIPTION_TX = D.EquipmentDescription_TX, T.MODEL_TX = D.VehicleModel,T.MAKE_TX = D.VehicleMake_TX,T.YEAR_TX = D.VehicleYear_TX,T.VIN_TX = D.VehicleVIN_TX
--SELECT * 
FROM dbo.PROPERTY T 
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = T.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
JOIN UniTracHDStorage..INC0236401 D ON D.LoanNumber_TX = L.NUMBER_TX AND T.DESCRIPTION_TX = D.EquipmentDescription_TX AND L.DIVISION_CODE_TX = '9'



INSERT  INTO PROPERTY_CHANGE
        ( ENTITY_NAME_TX ,
          ENTITY_ID ,
          USER_TX ,
          ATTACHMENT_IN ,
          CREATE_DT ,
          AGENCY_ID ,
          DESCRIPTION_TX ,
          DETAILS_IN ,
          FORMATTED_IN ,
          LOCK_ID ,
          PARENT_NAME_TX ,
          PARENT_ID ,
          TRANS_STATUS_CD ,
          UTL_IN
        )
        SELECT DISTINCT
                'Allied.UniTrac.Property' ,
                ID ,
                'INC0236401' ,
                'N' ,
                GETDATE() ,
                1 ,
                'Update Desc, Make, Model, Year and Vin per ticket' ,
                'N' ,
                'Y' ,
                1 ,
                'Allied.UniTrac.Property' ,
                ID ,
                'PEND' ,
                'N'
        FROM    dbo.PROPERTY
	WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0236401_20160621)




SELECT L.NUMBER_TX [Loan Number] , T.DESCRIPTION_TX,
        T.YEAR_TX ,
        T.MAKE_TX ,
        T.MODEL_TX ,
        T.BODY_TX ,
        T.VIN_TX
FROM    #tmp T 
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = T.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
JOIN UniTracHDStorage..INC0236401 D ON D.LoanNumber_TX = L.NUMBER_TX AND T.DESCRIPTION_TX = D.EquipmentDescription_TX AND L.DIVISION_CODE_TX = '9'


SELECT T.* 
--INTO UniTracHDStorage..INC0236401_20160621
FROM dbo.PROPERTY T 
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = T.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
JOIN UniTracHDStorage..INC0236401 D ON D.LoanNumber_TX = L.NUMBER_TX AND T.DESCRIPTION_TX = D.EquipmentDescription_TX AND L.DIVISION_CODE_TX = '9'


UPDATE dbo.PROPERTY
SET DESCRIPTION_TX = '', UPDATE_DT = GETDATE(), LOCK_ID = LOCK_ID+1, UPDATE_USER_TX = 'INC0236401'
--SELECT  * FROM           dbo.PROPERTY
	WHERE ID IN (SELECT ID FROM UniTracHDStorage..INC0236401_20160621)


DROP TABLE #tmp



