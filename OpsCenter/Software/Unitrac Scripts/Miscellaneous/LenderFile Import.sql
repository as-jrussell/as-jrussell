--Lender File Import
USE VUT
GO
SELECT * FROM tblLenderExtractConversion


SELECT LL.LenderName, LL.LenderID, L.* FROM vut..tblLenderExtractCategoryMap L
JOIN vut..tblLenderExtractCategory LEC ON L.LenderExtractCategoryKey = LEC.LenderExtractCategoryKey
JOIN vut..tblLenderExtract LE ON LE.LenderExtractKey = LEC.LenderExtractKey
JOIN VUT..tblLender LL ON LL.LenderKey = LE.LenderKey



