
#$File = "C:\Downloads\test.xlsx"
#$File = 'C:\Users\jrussell\Downloads\CSH23654_info.xlsx'
$Instance = "UT-SQLDEV-01"
$Database = "UnitracHDStorage"
$fileName =  [System.IO.Path]::GetFileNameWithoutExtension($File)
Write-DbaDataTable -SqlInstance $Instance -Database $Database -InputObject $File -AutoCreateTable -Table $fileName


