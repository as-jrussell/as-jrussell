$Unitrac = Get-Content 'C:\Downloads\OCRLIMC.txt'

Get-Hotfix -ComputerName $Unitrac |where {$_.InstalledOn -ge "1/25/2021" }

