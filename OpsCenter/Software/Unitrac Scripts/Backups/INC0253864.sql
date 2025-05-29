


SELECT * FROM dbo.CHANGE C
JOIN dbo.CHANGE_UPDATE CU ON C.ID =CU.CHANGE_ID
WHERE C.USER_TX = 'jrussell' AND C.CREATE_DT >= '2016-11-07 '
ORDER BY C.CREATE_DT DESC 



SELECT * --INTO UniTracHDStorage..INC0253864
FROM vut..tblLenderExtract


select L.LenderName,  OptionMinNewContracts, OptionMaxNewContracts, OptionNewCollChange,OptionClosedContracts, OptionContUnmatchChange, 
OptionCollUnmatchChange, OptionNameChange, OptionAddressChange, OptionContractInfoChange, 
OptionBalanceChange, OptionMinBalDecrease from vut..tblLenderExtract LE
join vut..tblLender l on L.LenderKey = LE.LenderKey


UPDATE LE
SET
OptionMinNewContracts = '0', OptionMaxNewContracts  = '10', OptionNewCollChange  = '10',OptionClosedContracts  = '100', OptionContUnmatchChange  = '10', 
OptionCollUnmatchChange = '10', OptionNameChange  = '15', OptionAddressChange  = '15', OptionContractInfoChange  = '15', 
OptionBalanceChange  = '10', OptionMinBalDecrease  = '25'
--SELECT *
FROM vut..tblLenderExtract LE