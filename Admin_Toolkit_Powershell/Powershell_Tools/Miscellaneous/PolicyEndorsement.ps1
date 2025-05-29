$deployLogDestination = "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\Logs\PolicyEndorsement"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Start-Transcript -Path $deployLogDestination


New-Item -ItemType "directory" -Path "C:\temp\"

Copy-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\UPC_Codes" "C:\temp\" -Recurse -Force

cd "C:\temp\UPC_Codes"

#Enter in the
Start-Process cmd -ArgumentList "/c lprun Generate_UPC_Codes.linq numberOfCodes=500 filePath=""\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\PolicyEndorsements\generated_codes.xlsx""" 


Start-Sleep -Seconds 90

$range1="A1:A500"
$range2="K2:K500"
$file1 = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\PolicyEndorsements\generated_codes.xlsx' 
$file2 = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\PolicyEndorsements\PolicyEndorsement.xlsx' 
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

Start-Sleep -Seconds 90

$ExcelPath = $file2
$excel = New-Object -ComObject Excel.Application 
$excel.Visible = $true
$workbook = $excel.Workbooks.Open($ExcelPath)
$workbook.ActiveSheet.Cells.Item(1,11) = 'CODE_TX'
$excel.DisplayAlerts = $false
$workbook.SaveAs($ExcelPath)
$workbook.Close($false) 
$excel.Quit()


Write-Output "Which environment database is the data being uploaded to ? (QA - utqa-sql-14; Stage - ut-stg-listener; Production - ut-prd-listener)`n"
$version = Read-Host -Prompt  "(enter uses the default of 'utqa-sql-14')"
if( [string]::IsNullOrEmpty($version)){
   $version = "utqa-sql-14"
   }


$File = $file2
$Instance = $version
$Database = "UnitracHDStorage"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
foreach($sheet in Get-ExcelSheetInfo $File)
{
$data = Import-Excel -Path $File -WorksheetName $sheet.name | ConvertTo-DbaDataTable
$tablename = $fileName 
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $data -AutoCreateTable -Table $tablename
}


Invoke-SQLcmd -Server $version -Database "Unitrac" 'INSERT INTO POLICY_ENDORSEMENT (AGENCY_ID,CODE_TX,NAME_TX,PERCENTAGE_NO,CREATE_DT,UPDATE_DT,UPDATE_USER_TX,LOCK_ID,ACTIVE_IN,IN_USE_IN,VUT_KEY,APPLY_COVERAGE_RANGE_IN,COVERAGE_START_AMOUNT_NO,COVERAGE_END_AMOUNT_NO,RATE_NO,INVOICE_GROUP_CD,LENDER_PAY_IN,LENDER_PAY_SRMF_NO)
SELECT 1,RTrim(LTrim(CODE_TX)),Left([LENDER PAY ENDORSEMENT_NAME],255),0.0000,getdate(),getdate(),''AutoLPInsert'',1,''Y'',''Y'',0,''N'',0.00,0.00,RATE_NO,Upper(INVOICE_GROUP_CD),LENDER_PAY_IN,100.00
FROM UniTracHDStorage.dbo.PolicyEndorsement
WHERE Left([LENDER PAY ENDORSEMENT_NAME],255) IS NOT NULL'



Remove-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\PolicyEndorsements\generated_codes.xlsx"


$PolicyMove ="\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\PolicyEndorsements\Archive\PolicyEndorsement"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".xlsx"

Move-Item "\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_LINQPad\PolicyEndorsements\PolicyEndorsement.xlsx" "$policyMove"


Stop-Transcript