USE Unitrac

UPDATE M
SET 
--SELECT * 
FROM dbo.MESSAGE M
WHERE ID IN ( 10783109, 10783111, 10787298, 10787305, 10789364, 10789368)


SELECT * FROM dbo.TRADING_PARTNER
WHERE ID =1437


SELECT ModifiedDate, * FROM vut..tblLenderExtractConversion 
WHERE ConversionProgram LIKE '%1574%'