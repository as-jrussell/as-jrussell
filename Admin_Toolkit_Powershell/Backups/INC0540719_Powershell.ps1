


$File = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\Database Uploads\INC0540719_1.xlsx' 
$Instance = "UT-PRD-LISTENER"
$Database = "UnitracHDStorage"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
foreach($sheet in Get-ExcelSheetInfo $File)
{
$data = Import-Excel -Path $File -WorksheetName $sheet.name | ConvertTo-DbaDataTable
$tablename = $fileName 
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $data -AutoCreateTable -Table 'INC0540719_1'
}


$File = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\Database Uploads\INC0540719_2.xlsx' 
$Instance = "UT-PRD-LISTENER"
$Database = "UnitracHDStorage"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
foreach($sheet in Get-ExcelSheetInfo $File)
{
$data = Import-Excel -Path $File -WorksheetName $sheet.name | ConvertTo-DbaDataTable
$tablename = $fileName 
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $data -AutoCreateTable -Table 'INC0540719_2'
}



$File = '\\as.local\shared\InfoTech\Application Administrators\Unitrac\Unitrac_Misc\Database Uploads\INC0540719_3.xlsx' 
$Instance = "UT-PRD-LISTENER"
$Database = "UnitracHDStorage"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
foreach($sheet in Get-ExcelSheetInfo $File)
{
$data = Import-Excel -Path $File -WorksheetName $sheet.name | ConvertTo-DbaDataTable
$tablename = $fileName 
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $data -AutoCreateTable -Table 'INC0540719_3'
}
