    TRY {
	Remove-Item "E:\Outputfile\*.*"
  } 
    CATCH{ Write-Host 'Do Nothing'}

    TRY {
New-Item -Name IdentityNow -ItemType Directory -Path "E:\Outputfile\"
  } 
    CATCH{ Write-Host 'Do Nothing'}

Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01  -Database Pingfederate 'Select * FROM channel_user' | Export-Csv -path "E:\Outputfile\IdentityNow\channel_user.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM channel_variable' | Export-Csv -path "E:\Outputfile\IdentityNow\channel_variable.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM node_state' | Export-Csv -path "E:\Outputfile\IdentityNow\node_state.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM channel_group' | Export-Csv -path "E:\Outputfile\IdentityNow\channel_group.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM group_membership' | Export-Csv -path "E:\Outputfile\IdentityNow\group_membership.csv"

$ExcelObject=New-Object -ComObject excel.application
$ExcelObject.visible=$true
$ExcelFiles=Get-ChildItem -Path E:\Outputfile\IdentityNow

$Workbook=$ExcelObject.Workbooks.add()
$Worksheet=$Workbook.Sheets.Item("Sheet1")

foreach($ExcelFile in $ExcelFiles){
 
$Everyexcel=$ExcelObject.Workbooks.Open($ExcelFile.FullName)
$Everysheet=$Everyexcel.sheets.item(1)
$Everysheet.Copy($Worksheet)
$Everyexcel.Close()
 
}
$Workbook.SaveAs("E:\Outputfile\IdentityNow\PingFed.xlsx")
$ExcelObject.Quit()
