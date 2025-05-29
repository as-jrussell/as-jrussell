Get-WmiObject -Class Win32_Product -comp UTSTAGE-APP1 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\staging\UTSTAGE-APP1software.csv" 
Get-WmiObject -Class Win32_Product -comp UTSTAGE-APP2 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\staging\UTSTAGE-APP2software.csv" 
Get-WmiObject -Class Win32_Product -comp UTSTAGE-APP3 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\staging\UTSTAGE-APP3software.csv" 
Get-WmiObject -Class Win32_Product -comp UTSTAGE-APP4 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\staging\UTSTAGE-APP4software.csv" 
Get-WmiObject -Class Win32_Product -comp UTSTAGE01 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\staging\UTSTAGE01software.csv" 
Get-WmiObject -Class Win32_Product -comp UTSTAGE-RPT01 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\staging\UTSTAGERPT01software.csv" 
Get-WmiObject -Class Win32_Product -comp UTQA-SQL | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\QA\UTQA-SQLsoftware.csv" 
Get-WmiObject -Class Win32_Product -comp UTQA-SQL2012 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\QA\UTQA-SQL2012software.csv" 
Get-WmiObject -Class Win32_Product -comp UTQA2-APP1 | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\QA\UTQA2-APP1software.csv" 
Get-WmiObject -Class Win32_Product -comp UniTrac-PreProd | Select Name, Version, InstallDate, __CLASS | Export-Csv -path "C:\temp\UniTrac-PreProd\UniTrac-PreProdsoftware.csv" 


