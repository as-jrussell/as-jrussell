
#Import-Module -Name "C:\PowerShell\Modules\dbatools\dbatools.psm1" -Force -Verbose


Set-Location "C:\PowerShell\Functions"

Import-Module .\GetExcelTable.ps1  -Force -Verbose



$File = "C:\downloads\UTDB Updates P3.xlsx"
#$Instance = "ON-SQLCLSTPRD-1"
$Instance = "UT-SQLDEV-01"
$Database = "HDTSTORAGE"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
foreach($sheet in Get-ExcelSheetInfo $File)
{
$data = Import-Excel -Path $File -WorksheetName $sheet.name | ConvertTo-DbaDataTable
$tablename = $fileName 
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $data -AutoCreateTable -Table $fileName
}



#Remove-Item $File