
New-WebAppPool -Name "SADashboard"

Stop-WebAppPool -Name "SADashboard" 

New-Website -name "SADashboard" -HostHeader "utsa-dashboard.alliedsolutions.net" -PhysicalPath "E:\inetpub\SADashboard"
Stop-Website -name "SADashboard"

New-WebVirtualDirectory -Site "UnitracWeb" -Name SADashUI -physicalPath "E:\inetpub\UnitracWeb\SADashUI"
ConvertTo-WebApplication "IIS:\Sites\UnitracWeb\SADashUI"

Set-ItemProperty "IIS:\Sites\UnitracWeb\SADashUI" applicationPool  SADashboard


Start-WebAppPool -Name "SADashboard"
Start-Website -name "SADashboard"