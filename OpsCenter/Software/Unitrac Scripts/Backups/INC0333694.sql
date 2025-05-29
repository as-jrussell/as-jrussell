USE UniTrac


SELECT * FROM dbo.LENDER
WHERE CODE_TX = '2134'


SELECT L.NUMBER_TX, 
IH.SPECIAL_HANDLING_XML.value('(/SH/SubTypeDesc)[1]', 'varchar (50)')[SubTypeDesc],
IH.SPECIAL_HANDLING_XML.value('(/SH/ResponseRcvdDate)[1]', 'varchar (50)')[ResponseRcvdDate], 
IH.SPECIAL_HANDLING_XML.value('(/SH/OutboundCallDate)[1]', 'varchar (50)')[OutboundCallDate], 
IH.SPECIAL_HANDLING_XML.value('(/SH/OutboundCallNumber)[1]', 'varchar (50)')[OutboundCallNumber], 
IH.SPECIAL_HANDLING_XML.value('(/SH/OutboundCallStatus)[1]', 'varchar (50)')[OutboundCallStatus],
ih.*,n.*
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
--JOIN dbo.NOTICE_REQUIRED_COVERAGE_RELATE NRC ON NRC.REQUIRED_COVERAGE_ID = IH.SPECIAL_HANDLING_XML.value('(/SH/RC)[1]', 'varchar (50)')
JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID AND IH.SPECIAL_HANDLING_XML.value('(/SH/Sequence)[1]', 'varchar (50)') = N.SEQUENCE_NO
WHERE L.LENDER_ID = 17 AND  IH.SPECIAL_HANDLING_XML.value('(/SH/OutboundCallStatus)[1]', 'varchar (50)') IS NOT NULL


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'NBS'