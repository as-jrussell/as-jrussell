
$File = "C:\downloads\Unitrac Stage Updates.xlsx"
$Instance = "UT-SQLSTG-01"
$Database = "UnitracHDStorage"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
foreach($sheet in Get-ExcelSheetInfo $File)
{
$data = Import-Excel -Path $File -WorksheetName $sheet.name | ConvertTo-DbaDataTable
$tablename = $fileName 
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $data -AutoCreateTable -Table $fileName
}





Remove-Item "C:\downloads\Unitrac Stage Updates.xlsx"