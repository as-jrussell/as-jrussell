USE UniTrac

--Finding WI via CODE_TX
----REPLACE #### WITH THE THE Lender ID
SELECT WQ.NAME_TX, WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, *
FROM    UniTrac..WORK_ITEM WI
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE    WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '1615' AND WI.UPDATE_DT >= '2016-06-08 '
--AND WI.STATUS_CD NOT IN ('Complete' ,'Withdrawn' ,'ImportCompleted')
AND WI.WORKFLOW_DEFINITION_ID IN ('10')

, '9')




SELECT * 
--INTO UniTracHDStorage..INC0236911
FROM dbo.WORK_QUEUE
WHERE ID IN --(153,156,155)


('172')

SELECT * FROM dbo.LENDER
WHERE CODE_TX = '1615'






SELECT WI.UPDATE_DT, WQ.NAME_TX, WD.NAME_TX, WI.CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') Lender, WI.*  FROM dbo.WORK_ITEM WI
INNER JOIN dbo.WORKFLOW_DEFINITION WD ON WD.ID = WI.WORKFLOW_DEFINITION_ID
INNER JOIN dbo.WORK_QUEUE WQ ON WQ.ID = WI.CURRENT_QUEUE_ID
WHERE WI.ID = '31970735'


SELECT * FROM dbo.CHANGE C
LEFT JOIN dbo.CHANGE_UPDATE CU ON C.ID=CU.CHANGE_ID
WHERE C.ENTITY_NAME_TX = 'Allied.UniTrac.Workflow.UnitracWorkQueue'
AND C.USER_TX = 'jrussell' AND C.CREATE_DT >= '2016-06-15 '


SELECT * FROM dbo.RULE_CONDITION_BASE
WHERE ID = '117685'



SELECT * FROM dbo.BUSINESS_RULE_BASE
WHERE ID = '10951'


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'CR'


/*

UPDATE dbo.WORK_QUEUE
SET LOCK_ID = LOCK_ID+1, UPDATE_DT = GETDATE(), UPDATE_USER_TX = 'INC0236911',
FILTER_XML = '<Filters>
  <Filter Type="Lender" DisplayValue="7400 / One Washington Financial" Id="1205" />
  <Filter Type="Lender" DisplayValue="1777 / Citizens Community Federal" Id="313" />
  <Filter Type="Lender" DisplayValue="2107 / Ent Federal Credit Union" Id="227" />
  <Filter Type="Lender" DisplayValue="8500 / Texas Dow Employees CU" Id="92" />
  <Filter Type="Lender" DisplayValue="6002 / First Federal Savings Bank" Id="979" />
  <Filter Type="Lender" DisplayValue="6175 / Greater Nevada CU" Id="1446" />
  <Filter Type="Lender" DisplayValue="2028 / 66 Federal Credit Union" Id="168" />
  <Filter Type="Lender" DisplayValue="7100 / Patelco CU" Id="200" />
  <Filter Type="Lender" DisplayValue="2268 / Tyndall Federal Credit Union" Id="1863" />
   <Filter Type="Lender" DisplayValue="1615 / GTE Federal CU DBA GTE Financial" Id="12" />
  <Filter Type="LenderAdmin" DisplayValue="Vondrak, Kylie" />
  <Filter Type="LenderAdmin" DisplayValue="Pierce, Rose" />
  <Filter Type="LenderAdmin" DisplayValue="Cross, Elizabeth" />
  <Filter Type="LenderAdmin" DisplayValue="Dzhavadova, Emiliya" />
  <Filter Type="LenderAdmin" DisplayValue="Rowe, Joan" />
  <Filter Type="LenderAdmin" DisplayValue="Wilbanks, James" />
  <Filter Type="LenderAdmin" DisplayValue="Chui, Lam" />
  <Filter Type="LenderAdmin" DisplayValue="Chhin, Ryan" />
  <Filter Type="LenderAdmin" DisplayValue="Poyner, Theresa" />
  <Filter Type="LenderAdmin" DisplayValue="Wheeler, Antionette" />
  <Filter Type="LenderAdmin" DisplayValue="Orozco, Victor" />
  <Filter Type="LenderAdmin" DisplayValue="Macias, Marisela" />
  <Filter Type="LenderAdmin" DisplayValue="Neideigh, Barbara" />
  <Filter Type="LenderAdmin" DisplayValue="Bravo, Christopher" />
  <Filter Type="LenderAdmin" DisplayValue="Baker, Ambria" />
  <Filter Type="LenderAdmin" DisplayValue="Lusk, DAriq" />
  <Filter Type="LenderAdmin" DisplayValue="Thomas, Angie" />
  <Filter Type="LenderAdmin" DisplayValue="Woodfork, Jamila-Symone" />
  <Filter Type="LenderAdmin" DisplayValue="McFarland, Julie" />
  <Filter Type="LenderAdmin" DisplayValue="Shank, Joseph" />
  <Filter Type="LenderAdmin" DisplayValue="Runnels, Erica" />
  <Filter Type="LenderAdmin" DisplayValue="West, Kellie" />
  <Filter Type="LenderAdmin" DisplayValue="Harris, Kim" />
  <Filter Type="LenderAdmin" DisplayValue="Berryman, Martha" />
  <Filter Type="LenderAdmin" DisplayValue="Nothem, Troy" />
  <Filter Type="LenderAdmin" DisplayValue="Nothem, Troy" />
  <Filter Type="LenderAdmin" DisplayValue="Vondrak, Rhonda" />
</Filters>'
WHERE ID = '138'

*/