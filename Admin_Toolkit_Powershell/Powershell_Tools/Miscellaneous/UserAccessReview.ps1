Remove-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserAccessReview.xlsx"

Copy-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserAccessReview_Template.xlsx" "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserAccessReview_Template2.xlsx"



Invoke-SQLcmd -QueryTimeout 0 -Server 'UTQA-SQL-14' -Database Unitrac 'SELECT USER_NAME_TX, GIVEN_NAME_TX, FAMILY_NAME_TX
FROM users WHERE PURGE_DT IS NULL AND ACTIVE_IN = ''Y'''  | Export-Csv -path "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserData.csv"

$range1="A3:C1637"
$range2="C11:E1637"
$file1 = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserData.csv'
$file2 = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserAccessReview_Template2.xlsx' 
$xl = new-object -c excel.application
$xl.displayAlerts = $false 
$wb1 = $xl.workbooks.open($file1, $null, $true) 
$wb2 = $xl.workbooks.open($file2)
$ws1 = $wb1.WorkSheets.item(1) 
$ws1.activate()  
$range = $ws1.Range($range1).Copy()

$ws2 = $wb2.Worksheets.item(1) 
$ws2.activate()
$x=$ws2.Range($range2).Select()

$ws2.Paste()  
$wb2.Save() 

$wb1.close($false) 
$wb2.close($true) 
$xl.quit()
spps -n excel



Rename-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserAccessReview_Template2.xlsx" "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserAccessReview.xlsx"

Remove-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserData.csv"

$UserAccessReview ="\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\Archive\UserAccessReview"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".xlsx"

Copy-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\YearUserAccessReview\UserAccessReview.xlsx" "$UserAccessReview"