SELECT * FROM dbo.WORK_QUEUE
WHERE DESCRIPTION_TX LIKE '%atp%'


SELECT CONTENT_XML.value('(/Content/Property/Description)[1]', 'varchar (50)') [Description], 
* FROM dbo.WORK_ITEM
WHERE RELATE_ID = '10270513'
CURRENT_QUEUE_ID IN (8,92,101,105) AND  CONTENT_XML.value('(/Content/Lender/Code)[1]', 'varchar (50)') = '5014'

SELECT * FROM dbo.WORK_ITEM_ACTION
WHERE WORK_ITEM_ID = '3760907'



sELECT * FROM dbo.REPORT
WHERE DISPLAY_NAME_TX LIKE '%work%'
--34	WorkItem	Work Item Report	Work Item Report
--72	CPLoanStatusInformation	Insurance Verification Workbook	Insurance Verification Workbook


SELECT * FROM dbo.REPORT_HISTORY
WHERE REPORT_ID = '72'



--Real Estate	1624264	4	NULL	932996	Allied.UniTrac.KeyImage	Complete	105	924	Y	2013-10-15 14:47:27.607	NULL	2013-12-23 07:45:46.540	ebrown	94	6088381	0	0	NULL	0	NULL	<Content><Property><Description>Real Estate</Description></Property><Collateral /><Coverage /><Loan /><Owner /><Lender><Name>Blue Chip Federal C U</Name><Code>5014</Code><Id>721</Id><LastCycleDate /><NextCycleDate /></Lender><Information>Last User: Server, UnitracBusinessService
--Lender Admin: Wesseler, Lorie
--</Information></Content>	2013-12-23 06:11:39.757	USER	NULL	NULL	NULL	NULL


SELECT * FROM dbo.LOAN

JOIN vut..tblimagequeue ON 
WHERE id IN (10270513)


SELECT * FROM dbo.LOAN
WHERE NUMBER_TX = '2736-S'




SELECT * FROM dbo.LENDER
WHERE ID IN (721)


select  V.* from LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN REQUIRED_COVERAGE RC ON P.ID = RC.PROPERTY_ID
INNER JOIN OWNER_LOAN_RELATE OL ON L.ID = OL.LOAN_ID
INNER JOIN OWNER O ON OL.OWNER_ID = O.ID
INNER JOIN OWNER_ADDRESS OA ON O.ADDRESS_ID = OA.ID
INNER JOIN vut..tblimagequeue V ON V.LenderKey = L.LENDER_ID
INNER JOIN dbo.WORK_ITEM WI ON WI.RELATE_ID = V.ID 
WHERE L.LENDER_ID = '721' AND WI.CURRENT_QUEUE_ID IN (8,92,101,105)




SELECT TOP 5 * FROM dbo.POLICY_COVERAGE



sle