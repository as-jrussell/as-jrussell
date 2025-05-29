


Invoke-SQLcmd -Server $version -Database "Unitrac" '
UPDATE pe SET pe.PURGE_DT = GETDATE(), pe.UPDATE_USER_TX = ''AutoLPInsert_BO'', pe.UPDATE_DT = GETDATE(), pe.LOCK_ID = pe.LOCK_ID+1
--SELECT * 
FROM unitrac.dbo.POLICY_ENDORSEMENT pe
JOIN UniTracHDStorage.dbo.PolicyEndorsement EP ON EP.CODE_TX = PE.CODE_TX
WHERE UPDATE_USER_TX = ''AutoLPInsert'' '
