SELECT *
FROM VEHICLE_INFORMATION
WHERE YEAR_NO = '2016'

--1) Insert 2016 NADA vehicles into temp table
SELECT * INTO #tmpVI2016
FROM VEHICLE_INFORMATION
WHERE YEAR_NO = '2016' AND SOURCE_CD = 'NADA'

--2) Update temp table to 2018 years
UPDATE #tmpVI2016
SET YEAR_NO = '2018'
WHERE YEAR_NO = '2016'

SELECT *
FROM #tmpVI2016

--3) Create temp table of all 2018 vehicles created above that already exist in VEHICLE_INFORMATION table
--SELECT CAST(YEAR_NO AS nvarchar)+'|'+MAKE_TX+'|'+MODEL_TX+'|'+BODY_TX,* FROM #tmpVI2016
SELECT ID INTO #tmpVI2016EXCL FROM #tmpVI2016
WHERE CAST(YEAR_NO AS nvarchar)+'|'+MAKE_TX+'|'+MODEL_TX+'|'+BODY_TX IN 
(SELECT CAST(YEAR_NO AS nvarchar)+'|'+MAKE_TX+'|'+MODEL_TX+'|'+BODY_TX FROM VEHICLE_INFORMATION
WHERE YEAR_NO = '2018' AND SOURCE_CD = 'NADA')

SELECT *
FROM VEHICLE_INFORMATION
WHERE YEAR_NO = '2016' AND SOURCE_CD = 'NADA'
AND ID NOT IN (SELECT ID FROM #tmpVI2016EXCL)

--4) Insert 2018 vehicles into VEHICLE_INFORMATION table
INSERT INTO VEHICLE_INFORMATION (YEAR_NO, MAKE_TX, MODEL_TX, BODY_TX, SOURCE_CD, CREATE_dT, UPDATE_DT, UPDATE_USER_TX, LOCK_ID)
SELECT 2018, MAKE_TX, MODEL_TX, BODY_TX, SOURCE_CD, GETDATE(), GETDATE(), 'Script2018', 1
FROM VEHICLE_INFORMATION
WHERE YEAR_NO = '2016' AND SOURCE_CD = 'NADA'
AND ID NOT IN (SELECT ID FROM #tmpVI2016EXCL)