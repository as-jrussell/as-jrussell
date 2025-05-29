USE UniTrac


SELECT * FROM dbo.LENDER
WHERE CODE_TX = '2134'

SELECT TOP 50
 L.NUMBER_TX, 
IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/OwnerPolicyTxnType)[1]', 'varchar (50)') [OwnerPolicyTxnType],
IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/StatusCode)[1]', 'varchar (50)') [StatusCode],
IH.*
--INTO jcs..INC0333694
FROM LOAN L
INNER JOIN COLLATERAL C ON L.ID = C.LOAN_ID
INNER JOIN PROPERTY P ON C.PROPERTY_ID = P.ID
INNER JOIN dbo.LENDER LL ON LL.ID = L.LENDER_ID
INNER JOIN dbo.INTERACTION_HISTORY IH ON IH.PROPERTY_ID = P.ID 
INNER JOIN dbo.OWNER_LOAN_RELATE OLR ON OLR.LOAN_ID = L.ID
INNER JOIN dbo.NOTICE N ON N.LOAN_ID = L.ID
JOIN dbo.OWNER O ON O.ID = OLR.OWNER_ID
WHERE -- L.LENDER_ID = 17  AND 
IH.TYPE_CD = 'OWNERPOLICY' AND IH.UPDATE_DT >= DateAdd(DAY, -30, getdate())
AND IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/OwnerPolicyTxnType)[1]', 'varchar (50)') ='NBS' and
IH.SPECIAL_HANDLING_XML.value('(/SH/OwnerPolicy/StatusCode)[1]', 'varchar (50)') = 'C'
ORDER BY L.NUMBER_TX ASC


SELECT * FROM dbo.REF_CODE
WHERE CODE_CD = 'NBS'







SELECT DISTINCT L.NUMBER_TX, op.ID ,
                    op.POLICY_NUMBER_TX ,
                    op.STATUS_CD ,
                    op.SUB_STATUS_CD ,
                    op.SOURCE_CD ,
                    op.EFFECTIVE_DT ,
                    op.EXPIRATION_DT ,
                    op.CANCELLATION_DT ,
                    op.CANCEL_REASON_CD ,
                    op.MOST_RECENT_TXN_TYPE_CD 
--INTO Jcs..INC0336154
SELECT COUNT(L.NUMBER_TX)
FROM dbo.OWNER_POLICY op
JOIN dbo.PROPERTY_OWNER_POLICY_RELATE pop ON pop.OWNER_POLICY_ID = op.ID
JOIN dbo.PROPERTY p ON p.ID = pop.PROPERTY_ID
JOIN dbo.COLLATERAL C ON C.PROPERTY_ID = p.ID
JOIN dbo.LOAN L ON L.ID = C.LOAN_ID
WHERE op.MOST_RECENT_TXN_TYPE_CD = 'NBS'
 AND op.SOURCE_CD = 'EDI'
AND op.UPDATE_DT >= DateAdd(DAY, -30, getdate())
AND OP.PURGE_DT IS NULL
AND L.RECORD_TYPE_CD = 'E'


DROP TABLE Jcs..INC0336154

SELECT TOP 5 * FROM dbo.OWNER_POLICY

SELECT * FROM dbo.REF_CODE
WHERE DOMAIN_CD = 'OwnerPolicySubStatus'
--130497





Problem Event Name:	PowerShell
  NameOfExe:	powershell_ise.exe
  FileVersionOfSystemManagementAutomation:	6.2.9200.22198
  InnermostExceptionType:	System.IO.FileFormatException
  OutermostExceptionType:	System.Reflection.TargetInvocation
  DeepestPowerShellFrame:	indows.PowerShell.GuiExe.Internal.GPowerShell.Main
  DeepestFrame:	System.RuntimeMethodHandle.InvokeMethod
  ThreadName:	unknown
  OS Version:	6.1.7601.2.1.0.274.10
  Locale ID:	1033

Read our privacy statement online:
  http://go.microsoft.com/fwlink/?linkid=104288&clcid=0x0409

If the online privacy statement is not available, please read our privacy statement offline:
  C:\Windows\system32\en-US\erofflps.txt
