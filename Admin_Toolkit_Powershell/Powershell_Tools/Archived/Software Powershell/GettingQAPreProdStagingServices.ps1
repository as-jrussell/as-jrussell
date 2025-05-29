$Service = (
"UTSTAGE-APP2",
"UTQA2-APP1",
"UT-QAWEB-1",
"UT-STAGEWEB-1",
"UT-PPDIIS-01"
)



Invoke-Command -ComputerName $Service  -ScriptBlock {Get-WebApplication| select PSComputerName,path,applicationPool,PhysicalPath} | Export-Csv -path "C:\temp\Unitrac-NonProd_Websites.csv"