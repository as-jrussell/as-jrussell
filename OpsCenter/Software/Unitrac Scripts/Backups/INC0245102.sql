USE UniTrac


--Finding WI via Number
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID = 'XXXXXXXX'



--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
SELECT CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WD.NAME_TX [Definition], 
WQ.NAME_TX [Queue], WI.*
FROM  WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') IN ('2771', '8500', '5150')
AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WI.WORKFLOW_DEFINITION_ID = '8'



UPDATE dbo.WORK_QUEUE
SET LOCK_ID = LOCK_ID+1, UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0245102',
FILTER_XML = '<Filters>
  <Filter Type="Lender" DisplayValue="2028 / Truity CU" Id="168" />
  <Filter Type="CoverageType" DisplayValue="Hazard" />
  <Filter Type="CoverageType" DisplayValue="Windstorm and Hail" />
  <Filter Type="CoverageType" DisplayValue="Flood" />
  <Filter Type="CoverageType" DisplayValue="Earthquake" />
  <Filter Type="Lender" DisplayValue="2626 / Florida Traditions Bank" Id="1853" />
  <Filter Type="Lender" DisplayValue="1771 / Pentagon Federal Credit Union" Id="968" Code="1771" />
  <Filter Type="Lender" DisplayValue="2252 / Space Coast Credit Union" Id="962" Code="2252" />
  <Filter Type="Lender" DisplayValue="3200 / TruStone Financial FCU" Id="1062" Code="3200" />
  <Filter Type="Lender" DisplayValue="8500 / Texas Dow Employees CU" Id="92" Code="8500" />
  <Filter Type="Lender" DisplayValue="6162 / PRIVATE LABEL SERVICER - CUMAnet" Id="1090" Code="6162" />
  <Filter Type="Lender" DisplayValue="1839 / American First Credit Union" Id="373" Code="1839" />
  <Filter Type="Lender" DisplayValue="7140 / Chevron FCU" Id="1859" Code="7140" />
  <Filter Type="Lender" DisplayValue="1597 / Columbia Credit Union" Id="911" Code="1597" />
  <Filter Type="Lender" DisplayValue="2107 / ENT FEDERAL CREDIT UNION" Id="227" Code="2107" />
  <Filter Type="Lender" DisplayValue="4700 / Tri Counties Bank" Id="1207" Code="4700" />
  <Filter Type="Lender" DisplayValue="1784 / First Cheyenne FCU" Id="942" Code="1784" />
  <Filter Type="Lender" DisplayValue="7400 / PRIVATE LABEL SERV - One Washington Fin." Id="1205" Code="7400" />
  <Filter Type="Lender" DisplayValue="7100 / Patelco CU" Id="200" Code="7100" />
  <Filter Type="Lender" DisplayValue="4192 / Salin Bank" Id="699" Code="4192" />
  <Filter Type="Lender" DisplayValue="2270 / Tampa Bay Federal Credit Union" Id="255" Code="2270" />
  <Filter Type="Lender" DisplayValue="2088 / Atlantic Coast Bank" Id="827" Code="2088" />
  <Filter Type="Lender" DisplayValue="7500 / Greater Nevada Mortgage" Id="1833" Code="7500" />
  <Filter Type="Lender" DisplayValue="2771 / Pentagon FCU" Id="1810" Code="2771" />
  <Filter Type="Lender" DisplayValue="5201 / Nutmeg State FCU" Id="853" Code="5201" />
  <Filter Type="Lender" DisplayValue="1375 / Whitefish CU" Id="966" Code="1375" />
  <Filter Type="Lender" DisplayValue="1833 / Summit Credit Union" Id="134" Code="1833" />
  <Filter Type="Lender" DisplayValue="7105 / Harbor Community Bank" Id="1809" Code="7105" />
  <Filter Type="Lender" DisplayValue="1777 / Citizens Community Federal" Id="313" Code="1777" />
  <Filter Type="Lender" DisplayValue="2259 / First Clover Leaf Bank" Id="1879" Code="2259" />
  <Filter Type="Lender" DisplayValue="2261 / The Bridgehampton National Bank" Id="1880" Code="2261" />
  <Filter Type="Lender" DisplayValue="3140 / CU Mortgage Services, Inc." Id="1882" Code="3140" />
  <Filter Type="Lender" DisplayValue="2257 / Sharonview Federal Credit Union" Id="1878" Code="2257" />
  <Filter Type="Lender" DisplayValue="3800 / Naugatuck Valley Savings and Loan" Id="1994" Code="3800" />
  <Filter Type="Lender" DisplayValue="3585 / United Federal Credit Union" Id="843" Code="3585" />
  <Filter Type="Lender" DisplayValue="1844 / Linn Area Credit Union" Id="969" Code="1844" />
  <Filter Type="Lender" DisplayValue="1255 / First National Bank &amp; Trust Company" Id="2056" Code="1255" />
  <Filter Type="Lender" DisplayValue="1045 / DHCU Community Credit Union" Id="2047" Code="1045" />
  <Filter Type="Lender" DisplayValue="3750 / Amalgamated Bank" Id="2084" Code="3750" />
  <Filter Type="Lender" DisplayValue="7150 / Country Bank for Savings" Id="1870" Code="7150" />
  <Filter Type="Lender" DisplayValue="7120 / Alcoa Tenn Federal Credit Union" Id="2069" Code="7120" />
  <Filter Type="Lender" DisplayValue="2217 / DATCU" Id="36" Code="2217" />
  <Filter Type="Agency" DisplayValue="Allied Solutions LLC" />
  <Filter Type="Lender" DisplayValue="2217 / DATCU" Id="36" Code="2217" />
  <Filter Type="Lender" DisplayValue="2771 / Pentagon Federal Credit Union" Id="1810" Code="2771" />
  <Filter Type="Lender" DisplayValue="5150 / Tinker Federal Credit Union" Id="2283" Code="5150" />
  <Filter Type="Lender" DisplayValue="8500 / Texas Dow Employees Credit Union" Id="92" Code="8500" />
</Filters>'
--SELECT * FROM dbo.WORK_QUEUE
WHERE ID = 170


SELECT * FROM dbo.LENDER
WHERE CODE_TX IN ('2771', '8500', '5150')