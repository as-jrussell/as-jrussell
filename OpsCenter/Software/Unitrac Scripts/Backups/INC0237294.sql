USE UniTrac





SELECT L.NUMBER_TX,  IH.SPECIAL_HANDLING_XML.value('(/SH/InsuranceDocument/Policy/MailDate)[1]','varchar (50)') [Policy Mail Date],
IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/MostRecentMailDate)[1]', 'varchar (50)') [Most Recent Mail Date],			
IH.SPECIAL_HANDLING_XML.value('(/SH/MailDate)[1]', 'varchar (50)') [Mail Date display in Unitrac],						  
									  *
									  --INTO UniTracHDStorage..Lend4846_Loan_030013822_20160627_OwnerPolicy
									   FROM dbo.LOAN L
INNER JOIN dbo.COLLATERAL C ON C.LOAN_ID = L.ID
INNER JOIN	dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = C.PROPERTY_ID
INNER JOIN dbo.OWNER_POLICY OP ON OP.ID = IH.RELATE_ID AND IH.RELATE_CLASS_TX = 'Allied.UniTrac.OwnerPolicy'
WHERE  L.NUMBER_TX IN ('030-013822')



UPDATE dbo.INTERACTION_HISTORY
SET     SPECIAL_HANDLING_XML.modify('replace value of (/SH/MailDate/text())[1] with "2016-03-10"') ,
LOCK_ID = LOCK_ID+1
WHERE ID IN (222972643,230360831,234311947)


UPDATE dbo.INTERACTION_HISTORY
SET     SPECIAL_HANDLING_XML.modify('replace value of (/SH/InsuranceDocument/Policy/MailDate/text())[1] with "2016-03-10"') ,
LOCK_ID = LOCK_ID+1
WHERE ID IN (222972643,230360831,234311947)

UPDATE dbo.INTERACTION_HISTORY
SET     SPECIAL_HANDLING_XML.modify('replace value of (/SH/OwnerPolicy/MostRecentMailDate/text())[1] with "2016-03-11T00:00:00"') ,
LOCK_ID = LOCK_ID+1
WHERE ID IN (222972643,230360831,234311947)

UPDATE dbo.OWNER_POLICY
SET MOST_RECENT_MAIL_DT = '2016-03-11T00:00:00'
WHERE ID = '131326943'



SELECT * FROM UniTracHDStorage..Lend4846_Loan_030013822_20160627_IH
