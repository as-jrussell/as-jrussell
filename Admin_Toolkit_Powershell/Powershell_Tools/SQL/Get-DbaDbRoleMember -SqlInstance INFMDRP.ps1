Get-DbaDbRoleMember -SqlInstance INFMDRPRD01 | Select-Object Database,Role, UserName, Login, SMORole | Where-Object {$_.SMORole -like '*APP*'  }| Format-Table 



Get-DbaUserPermission -SqlInstance INFMDRPRD01 -Database DPM_DOC | Format-Table 

Get-DbaDbRole -SqlInstance INFMDRPRD01 -Database DPM_DOC | Format-Table 
