USE OspreyDashboard
--1) Insert Lender Information into DATASOURCE_CACHE_LOOKUP on UNITRAC-DB01 (OspreyDashboard Database)
INSERT INTO DATASOURCE_CACHE_LOOKUP (LOOKUP_KEY_CD,LOOKUP_VALUE,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
VALUES ('LENDER_CODE','4824',GETDATE(),GETDATE(),'Script',1)


--2) Insert Lender Information into AGENCY on UNITRAC-DB01 (OspreyDashboard Database)
--a)  Choose one word description or Lender Code to enter as short description in select

INSERT INTO AGENCY (SHORT_NAME_TX,NAME_TX,WEB_ADDRESS_TX,TAX_ID_TX,ACTIVE_IN,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
SELECT 'Nicholas',NAME_TX,WEB_ADDRESS_TX,TAX_ID_TX,'Y',GETDATE(),GETDATE(),'Script',1
FROM Unitrac.dbo.LENDER
WHERE CODE_TX = '4824'


--3) Insert Lender Information into RELATED_DATA on UNITRAC-DB01 (OspreyDashboard Database)
--a) Insert ID created in previous query as RELATE_ID
--b) Use Unitrac Lender CODE_TX as VALUE_TX

SELECT ID
FROM AGENCY
where SHORT_NAME_TX = 'Nicholas'

INSERT INTO RELATED_DATA (DEF_ID,RELATE_ID,VALUE_TX,COMMENT_TX,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
VALUES(1,66,'4824','UniTrac lender code',GETDATE(),GETDATE(),'Script',1)


--4) Insert Lender Information into DATASOURCE_CACHE_LOOKUP on UTPROD-SUB-01 (OspreyDashboard Database)
INSERT INTO DATASOURCE_CACHE_LOOKUP (LOOKUP_KEY_CD,LOOKUP_VALUE,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID)
VALUES ('LENDER_CODE','4824',GETDATE(),GETDATE(),'Script',1)

--5) Recycle App Pool on WEBSVC-DMZ when completed





--6) Verification Queries
SELECT *
FROM DATASOURCE_CACHE_LOOKUP

SELECT *
FROM AGENCY

SELECT *
FROM RELATED_DATA 

SELECT
rdd.NAME_TX
, rdd.DESC_TX
, rdd.RELATE_CLASS_NM
, a.NAME_TX
, a.SHORT_NAME_TX
, rd.VALUE_TX
FROM RELATED_DATA rd
JOIN AGENCY a ON a.ID = rd.RELATE_ID
JOIN RELATED_DATA_DEF rdd ON rd.DEF_ID = rdd.ID





/* Pilot Lenders
4824	Nicholas Financial
1105	Professional Financial Services
8500	Texas Dow
6497	Landmark Credit Union
2230	Travis Credit Union
4105	San Diego County Credit Union
4204	Reliable Credit Association
1595	Washington State Employees CU
5280	Alliant Credit Union
2244	Grow Financial Credit Union
*/





    