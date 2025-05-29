---Need to connected to UTSTAGE-RPT01

USE ReportServer

--Reports
SELECT C.ParentID,  D.Link,* FROM dbo.Catalog C
JOIN dbo.DataSource D ON D.ItemID = C.ItemID
WHERE C.ParentID = '4FF472F7-DA90-49ED-99D9-DAB354347D9E'
and C.[Name] = 'Process Def Late Cycles'
ORDER BY D.Link ASC 


select * from SecData


--Datasources
SELECT C.ParentID,  D.Link,* FROM dbo.Catalog C
JOIN dbo.DataSource D ON D.ItemID = C.ItemID
WHERE C.ParentID = '57700717-FD21-40DD-B86F-E8A67BC6D314'

--UniTrac_Daily_Snapshot
SELECT C.ParentID,  D.Link, D.ItemID, * FROM dbo.Catalog C
JOIN dbo.DataSource D ON D.ItemID = C.ItemID
WHERE D.Link = '71096B8D-1012-4734-8880-0CE04352185B'

select * from DBUpgradeHistory


select * from ExecutionLogStorage
where TimeStart >= '2020-01-08 16:00'


select * from Schedule


select * from Users
where --UserName like '%cwilliams%'
userid = --'BE8873EE-372A-432C-BB2D-1CFB45E59CFC'
--D7B8EDA6-3658-4FD6-A5A9-8C4703166167

'ED2A613A-FFBB-4CF8-9DFD-C2181A61F88E'




--UPDATE D 
--SET D.Link = '7107DF8B-8272-49DE-9DB9-48A18F9465F2', D.NAME = 'Unitrac_Snapshot'
----SELECT *
--FROM dbo.DataSource D 
--JOIN dbo.Catalog C ON D.ItemID = C.ItemID
--WHERE C.ParentID = '8B21A2BC-CFCC-4495-888B-0A32DD0CCBC7'




--Reports
SELECT C.ParentID,  D.Link,* FROM dbo.Catalog C
JOIN dbo.DataSource D ON D.ItemID = C.ItemID
WHERE C.ParentID = '4FF472F7-DA90-49ED-99D9-DAB354347D9E'
and C.[Name] = 'Process Def Late Cycles'
ORDER BY D.Link ASC 


select * from Users
where --UserName like '%cwilliams%'
userid = --'BE8873EE-372A-432C-BB2D-1CFB45E59CFC'
--D7B8EDA6-3658-4FD6-A5A9-8C4703166167

'ED2A613A-FFBB-4CF8-9DFD-C2181A61F88E'


select * from Schedule
where CreatedById  = 'ED2A613A-FFBB-4CF8-9DFD-C2181A61F88E'



select * from ConfigurationInfo


select * from Policies
where PolicyID = '4A40A571-ABD8-4BDE-AA89-8E022AF8DE36'