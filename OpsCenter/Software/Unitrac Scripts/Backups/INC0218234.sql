--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM
WHERE    CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '6681' 
AND STATUS_CD NOT LIKE 'Complete' AND STATUS_CD NOT LIKE 'Withdrawn' AND STATUS_CD NOT LIKE 'ImportCompleted'
AND CURRENT_QUEUE_ID = '20'


SELECT * FROM dbo.WORKFLOW_DEFINITION
WHERE ID = 9


SELECT *
FROM    UniTrac..WORK_ITEM
WHERE  ID IN (28924374)

--  CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '6681' 
--AND STATUS_CD NOT LIKE 'Complete' AND STATUS_CD NOT LIKE 'Withdrawn' AND STATUS_CD NOT LIKE 'ImportCompleted'
--AND CURRENT_QUEUE_ID = '20'


SELECT * FROM dbo.USERS
where ID = 1120

SELECT  *
FROM    dbo.WORK_QUEUE
WHERE  NAME_TX LIKE 'Plano%'


--UPDATE dbo.WORK_QUEUE
--SET LOCK_ID = LOCK_ID+1, FILTER_XML = '<Filters>
--  <Filter Type="Lender" DisplayValue="7400 / One Washington Financial" Id="1205" />
--  <Filter Type="Lender" DisplayValue="7200 / Community &amp; Southern Bank" Id="1067" />
--  <Filter Type="Lender" DisplayValue="7500 / Greater Nevada Mortgage" Id="1833" />
--  <Filter Type="Lender" DisplayValue="1777 / Citizens Community Federal" Id="313" />
--  <Filter Type="Lender" DisplayValue="2107 / Ent Federal Credit Union" Id="227" />
--  <Filter Type="Lender" DisplayValue="2270 / Tampa Bay Federal Credit Union" Id="255" />
--  <Filter Type="Lender" DisplayValue="2088 / Atlantic Coast Bank" Id="827" />
--  <Filter Type="Lender" DisplayValue="1597 / Columbia Credit Union" Id="911" />
--  <Filter Type="Lender" DisplayValue="6471 / Xx Forum Credit Union" Id="865" />
--  <Filter Type="Lender" DisplayValue="8500 / Texas Dow Employees CU" Id="92" />
--  <Filter Type="Lender" DisplayValue="6002 / First Federal Savings Bank" Id="979" />
--  <Filter Type="Lender" DisplayValue="1771 / Pentagon Federal Credit Union" Id="968" />
--  <Filter Type="Lender" DisplayValue="1839 / American First Credit Union" Id="373" />
--  <Filter Type="Lender" DisplayValue="6175 / Greater Nevada CU" Id="1446" />
--  <Filter Type="Lender" DisplayValue="2028 / 66 Federal Credit Union" Id="168" />
--  <Filter Type="Lender" DisplayValue="6162 / Private Label Servicer - Cumanet" Id="1090" />
--  <Filter Type="Lender" DisplayValue="7100 / Patelco CU" Id="200" />
--  <Filter Type="Lender" DisplayValue="4700 / Tri Counties Bank" Id="1207" />
--  <Filter Type="Lender" DisplayValue="2626 / Florida Traditions Bank" Id="1853" />
--  <Filter Type="Lender" DisplayValue="1784 / First Cheyenne FCU" Id="942" Code="1784" />
--  <Filter Type="Lender" DisplayValue="5201 / Nutmeg State FCU" Id="853" Code="5201" />
--  <Filter Type="Lender" DisplayValue="7140 / Chevron FCU" Id="1859" Code="7140" />
--  <Filter Type="Lender" DisplayValue="3200 / TruStone Financial FCU" Id="1062" Code="3200" />
--  <Filter Type="Lender" DisplayValue="2252 / Space Coast Credit Union" Id="962" Code="2252" />
--  <Filter Type="Lender" DisplayValue="4192 / Salin Bank" Id="699" Code="4192" />
--  <Filter Type="Lender" DisplayValue="3040 / State Bank Of Southern Utah" Id="201" Code="3040" />
--  <Filter Type="Lender" DisplayValue="3045 / Evergreendirect CU" Id="1103" Code="3045" />
--  <Filter Type="Lender" DisplayValue="3058 / Utah Independent Bank" Id="1178" Code="3058" />
--  <Filter Type="Lender" DisplayValue="2771 / Pentagon FCU" Id="1810" Code="2771" />
--  <Filter Type="Lender" DisplayValue="1375 / Whitefish CU" Id="966" Code="1375" />
--  <Filter Type="Lender" DisplayValue="7105 / Harbor Community Bank" Id="1809" Code="7105" />
--  <Filter Type="Lender" DisplayValue="1833 / Summit Credit Union" Id="134" Code="1833" />
--  <Filter Type="Lender" DisplayValue="7631 / Los Alamos National Bank" Id="2000" Code="7631" />
--  <Filter Type="Lender" DisplayValue="10010313 / Bank Of Dawson" Id="534" Code="10010313" />
--  <Filter Type="Lender" DisplayValue="2259 / First Clover Leaf Bank" Id="1879" Code="2259" />
--  <Filter Type="Lender" DisplayValue="3140 / CU Mortgage Services, Inc." Id="1882" Code="3140" />
--  <Filter Type="Lender" DisplayValue="3585 / United Federal Credit Union" Id="843" Code="3585" />
--  <Filter Type="Lender" DisplayValue="1844 / Linn Area Credit Union" Id="969" Code="1844" />
--  <Filter Type="Lender" DisplayValue="2261 / The Bridgehampton National Bank" Id="1880" Code="2261" />
--  <Filter Type="Lender" DisplayValue="2257 / Sharonview Federal Credit Union" Id="1878" Code="2257" />
--  <Filter Type="Lender" DisplayValue="3800 / Naugatuck Valley Savings and Loan" Id="1994" Code="3800" />
--  <Filter Type="Lender" DisplayValue="1045 / DHCU Community Credit Union" Id="2047" Code="1045" />
--  <Filter Type="Lender" DisplayValue="1255 / First National Bank &amp; Trust Company" Id="2056" Code="1255" />
--  <Filter Type="Lender" DisplayValue="3750 / Amalgamated Bank" Id="2084" Code="3750" />
--  <Filter Type="Lender" DisplayValue="1938 / Michigan Schools and Government CU" Id="79" Code="1938" />
--  <Filter Type="Lender" DisplayValue="7120 / Alcoa Tenn Federal Credit Union" Id="2069" Code="7120" />
--  <Filter Type="Lender" DisplayValue="7150 / Country Bank for Savings" Id="1870" Code="7150" />
--  <Filter Type="Lender" DisplayValue="2805 / Associated Credit Union" Id="2048" Code="2805" />
--  <Filter Type="Lender" DisplayValue="1831 / Stanford Federal Credit Union" Id="372" Code="1831" />
--  <Filter Type="Lender" DisplayValue="3656 / SpencerBANK" Id="2201" Code="3656" />
--  <Filter Type="Lender" DisplayValue="2324 / The Bryn Mawr Trust Company" Id="2178" Code="2324" />
--  <Filter Type="Lender" DisplayValue="3303 / United Nations Federal Credit Union" Id="2198" Code="3303" />
--  <Filter Type="Lender" DisplayValue="6681 / Central Bank" Id="1023" Code="6681" />
--  <Filter Type="Lender" DisplayValue="3760 / Kellogg Community FCU" Id="2211" Code="3760" />
--  <Filter Type="Lender" DisplayValue="7450 / Community National Bank" Id="2207" Code="7450" />
--  <Filter Type="Lender" DisplayValue="2255 / Guaranty Bank &amp; Trust" Id="2050" Code="2255" />
--  <Filter Type="Lender" DisplayValue="7548 / First Federal Savings Bank of Twin Falls" Id="1986" Code="7548" />
--  <Filter Type="Lender" DisplayValue="2468 / Credit Union of Colorado" Id="1153" Code="2468" />
--  <Filter Type="Lender" DisplayValue="7540 / Community West Bank" Id="1917" Code="7540" />
--  <Filter Type="Lender" DisplayValue="3145 / Member Business Financial Services" Id="2097" Code="3145" />
--  <Filter Type="Lender" DisplayValue="6682 / D.L. Evans Bank" Id="1024" Code="6682" />
--  <Filter Type="Lender" DisplayValue="2302 / CASE Credit Union" Id="2183" Code="2302" />
--  <Filter Type="Lender" DisplayValue="2980 / Texans Credit Union" Id="2229" Code="2980" />
--  <Filter Type="Lender" DisplayValue="2970 / Advantis Credit Union" Id="2226" Code="2970" />
--  <Filter Type="Lender" DisplayValue="2250 / IBM Southeast Employees FCU" Id="252" Code="2250" />
--  <Filter Type="Lender" DisplayValue="7562 / Idaho Independent Bank" Id="1929" Code="7562" />
--  <Filter Type="Lender" DisplayValue="2981 / Bay State Savings Bank" Id="2239" Code="2981" />
--  <Filter Type="Lender" DisplayValue="4750 / Alliant Credit Union" Id="2231" Code="4750" />
--  <Filter Type="Lender" DisplayValue="7130 / Union Bank" Id="2223" Code="7130" />
--  <Filter Type="Lender" DisplayValue="7680 / Clear Mountain Bank" Id="2225" Code="7680" />
--  <Filter Type="Lender" DisplayValue="6285 / Savers Bank" Id="2240" Code="6285" />
--  <Filter Type="Lender" DisplayValue="2281 / Peoples Trust Company of St. Albans" Id="2245" Code="2281" />
--  <Filter Type="Lender" DisplayValue="2277 / SouthCrest Bank" Id="2244" Code="2277" />
--  <Filter Type="Lender" DisplayValue="1732 / Southeast Financial Credit Union" Id="331" Code="1732" />
--  <Filter Type="Lender" DisplayValue="2230 / Travis Credit Union" Id="382" Code="2230" />
--  <Filter Type="Lender" DisplayValue="6485 / Consumers Credit Union" Id="867" Code="6485" />
--  <Filter Type="Lender" DisplayValue="3004 / Community Guaranty Savings Bank" Id="2227" Code="3004" />
--  <Filter Type="Lender" DisplayValue="1729 / Superior Federal Credit Union" Id="306" Code="1729" />
--  <Filter Type="Lender" DisplayValue="1729 / Superior Federal Credit Union" Id="306" Code="1729" />
--  <Filter Type="ServiceCenter" DisplayValue="Plano" />
--  <Filter Type="Lender" DisplayValue="2217 / DATCU" Id="36" Code="2217" />
--  <Filter Type="Lender" DisplayValue="2982 / Wintrust Financial Corporation" Id="2257" Code="2982" />
--  <Filter Type="Lender" DisplayValue="6681 / Central Bank" Id="1023" Code="6681" />
--</Filters>'
----SELECT * FROM WORK_QUEUE
--where ID = '138'


SELECT * FROM dbo.LENDER
WHERE CODE_TX = '6681'

--1) Main Service Center Query (SERVICE_CENTER_FUNCTION_LENDER_RELATE)
SELECT C.CODE_TX, C.NAME_TX, SCFLR.ID as SCFLR_ID,*
FROM LENDER L
INNER JOIN SERVICE_CENTER_FUNCTION_LENDER_RELATE SCFLR ON L.ID = SCFLR.LENDER_ID AND SCFLR.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER_FUNCTION SCF ON SCFLR.SERVICE_CENTER_FUNCTION_ID = SCF.ID AND SCF.PURGE_DT IS NULL
INNER JOIN SERVICE_CENTER C ON SCF.SERVICE_CENTER_ID = C.ID  AND C.PURGE_DT IS NULL
WHERE L.CODE_TX = '6681'

--SCFLR ROW
SELECT *
FROM SERVICE_CENTER_FUNCTION_LENDER_RELATE
WHERE ID IN (2192)

--Available Service Centers
SELECT *
FROM SERVICE_CENTER 
WHERE CODE_TX NOT LIKE '%/%'

--Update Query
UPDATE SERVICE_CENTER_FUNCTION_LENDER_RELATE
SET SERVICE_CENTER_FUNCTION_ID = '105'
--SELECT * FROM SERVICE_CENTER_FUNCTION_LENDER_RELATE
WHERE ID IN (2192)



SELECT * FROM dbo.PROCESS_DEFINITION
WHERE UPDATE_USER_TX = 'WFSrvr'

SELECT * FROM  dbo.PROCESS_LOG
WHERE PROCESS_DEFINITION_ID = '34'  
AND CAST(UPDATE_DT AS DATE) = CAST(GETDATE() AS DATE)
AND STATUS_CD <> 'Complete'


SELECT * FROM dbo.PROCESS_LOG_ITEM
WHERE PROCESS_LOG_ID IN (30176520)