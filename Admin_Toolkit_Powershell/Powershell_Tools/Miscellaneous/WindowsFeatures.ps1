#List the related features with "Name" and "Display Name"
Get-WindowsFeature "*msmq*"
#Install the features with the names get from above cmdlet
Install-WindowsFeature -Name "FeatureName"





