---Need to connected to UTSTAGE-RPT01

USE ReportServer


--DataSources
SELECT  C.Name, C.Path, ItemID, ParentID FROM dbo.Catalog C
WHERE Path LIKE '/Data Sources/%'


---Reports that will get moved over to UTSTAGE02
SELECT C.ParentID [Adhoc Parent ID], C.Name, C.Path, D.Link [Datasource Link ID]	 FROM dbo.Catalog C
JOIN dbo.DataSource D ON D.ItemID = C.ItemID
WHERE ParentID = '8B21A2BC-CFCC-4495-888B-0A32DD0CCBC7'



UPDATE D 
SET D.Link = '7107DF8B-8272-49DE-9DB9-48A18F9465F2', D.NAME = 'Unitrac_Snapshot'
--SELECT *
FROM dbo.DataSource D 
JOIN dbo.Catalog C ON D.ItemID = C.ItemID
WHERE C.ParentID = '8B21A2BC-CFCC-4495-888B-0A32DD0CCBC7'
--44