$Service = (
"Unitrac-APP04",
"utprod-api-01",
"UTPROD-WEB-1"
)



Invoke-Command -ComputerName $Service  -ScriptBlock {Get-WebApplication| select PSComputerName,path,applicationPool,PhysicalPath} | Export-Csv -path "C:\temp\Unitrac-Production_Websites.csv"