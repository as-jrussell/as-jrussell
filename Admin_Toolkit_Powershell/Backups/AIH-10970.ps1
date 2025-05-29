Remove-Item "C:\Users\jrussell\Downloads\IdentityNow\*.xlsx"

New-Item -Name IdentityNow -ItemType Directory -Path "C:\Users\jrussell\Downloads\"

Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01  -Database Pingfederate 'Select * FROM channel_user' | Export-Csv -path "C:\Users\jrussell\Downloads\IdentityNow\channel_user.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM channel_variable' | Export-Csv -path "C:\Users\jrussell\Downloads\IdentityNow\channel_variable.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM node_state' | Export-Csv -path "C:\Users\jrussell\Downloads\IdentityNow\node_state.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM channel_group' | Export-Csv -path "C:\Users\jrussell\Downloads\IdentityNow\channel_group.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM group_membership' | Export-Csv -path "C:\Users\jrussell\Downloads\IdentityNow\group_membership.csv"

$ExcelObject=New-Object -ComObject excel.application
$ExcelObject.visible=$true
$ExcelFiles=Get-ChildItem -Path C:\Users\jrussell\Downloads\IdentityNow

$Workbook=$ExcelObject.Workbooks.add()
$Worksheet=$Workbook.Sheets.Item("Sheet1")

foreach($ExcelFile in $ExcelFiles){
 
$Everyexcel=$ExcelObject.Workbooks.Open($ExcelFile.FullName)
$Everysheet=$Everyexcel.sheets.item(1)
$Everysheet.Copy($Worksheet)
$Everyexcel.Close()
 
}
$Workbook.SaveAs("C:\Users\jrussell\Downloads\IdentityNow\AIH-10970.xlsx")
$ExcelObject.Quit()

Remove-Item "C:\Users\jrussell\Downloads\IdentityNow\*.csv"