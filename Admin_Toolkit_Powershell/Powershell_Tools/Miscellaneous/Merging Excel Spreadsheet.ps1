New-Item -Name Pingfederate -ItemType Directory -Path "C:\Users\jrussell\Downloads\"

Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM channel_user' | Export-Csv -path "C:\Users\jrussell\Downloads\PingFederate\channel_user.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM channel_variable' | Export-Csv -path "C:\Users\jrussell\Downloads\PingFederate\channel_variable.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM node_state' | Export-Csv -path "C:\Users\jrussell\Downloads\PingFederate\node_state.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM channel_group' | Export-Csv -path "C:\Users\jrussell\Downloads\PingFederate\channel_group.csv"
Invoke-SQLcmd -QueryTimeout 0 -Server Pingfed-DB-01 -Database Pingfederate 'Select * FROM group_membership' | Export-Csv -path "C:\Users\jrussell\Downloads\PingFederate\group_membership.csv"

$ExcelObject=New-Object -ComObject excel.application
$ExcelObject.visible=$true
$ExcelFiles=Get-ChildItem -Path C:\Users\jrussell\Downloads\Pingfederate

$Workbook=$ExcelObject.Workbooks.add()
$Worksheet=$Workbook.Sheets.Item("Sheet1")

foreach($ExcelFile in $ExcelFiles){
 
$Everyexcel=$ExcelObject.Workbooks.Open($ExcelFile.FullName)
$Everysheet=$Everyexcel.sheets.item(1)
$Everysheet.Copy($Worksheet)
$Everyexcel.Close()
 
}
$Workbook.SaveAs("C:\Users\jrussell\Downloads\Pingfederate\AIH_6725.xlsx")
$ExcelObject.Quit()

