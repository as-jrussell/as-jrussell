New-Website -name "Unitrac APIs"  -HostHeader "unitrac-api-staging.alliedsolutions.net" -PhysicalPath "E:\inetpub\UniTrac APIs"

New-Website -name "UTL API" -HostHeader "unitrac-utlapi-staging.alliedsolutions.net" -PhysicalPath "E:\inetpub\UTL APIs"



New-Website -name "Unitrac QC" -HostHeader "unitrac-qc-staging.alliedsolutions.net" -PhysicalPath "E:\inetpub\UniTrac QC"

New-Website -name "QuickPoint Staging" -HostHeader "quickpoint-staging.alliedsolutions.net" -PhysicalPath "E:\inetpub\QuickPointStaging"

New-Website -name "UT Dashboard" -HostHeader "utdashboard-staging.alliedsolutions.net" -PhysicalPath "E:\inetpub\UTDashboard"

New-Website -name "LenderDashboard" -HostHeader "LD-staging.alliedsolutions.net" -PhysicalPath "E:\inetpub\LenderDashboard"




Stop-Website -name "QuickPoint Staging"
Stop-WebAppPool -Name "UT Dashboard" 

