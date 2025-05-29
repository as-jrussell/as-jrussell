---Need to connected to UTSTAGE-RPT01

USE ReportServer



update D
set link = '7107DF8B-8272-49DE-9DB9-48A18F9465F2'
--SELECT D.Name, * 
FROM dbo.Catalog C
JOIN dbo.DataSource D ON D.ItemID = C.ItemID
WHERE  D.Name IN ('UniTrac_Daily_Snapshot')



update D
set link = 'B9A7968E-DE18-46DC-BF73-F1794D7DB36E'
--SELECT D.Name, * 
FROM dbo.Catalog C
JOIN dbo.DataSource D ON D.ItemID = C.ItemID
WHERE  D.Name IN ( 'UniTrac_DW_Daily_Snapshot')
