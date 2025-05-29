 Register-PSRepository -InstallationPolicy Trusted -SourceLocation "C:\PowerShell\Modules\"
 Register-PSRepository -InstallationPolicy Trusted -SourceLocation "C:\PowerShell\Functions\" -Name "Powershell_Other_Items"




 #Find Repository Path for a module
 (Get-Module -ListAvailable *FailoverCluster*).path


 #Find Repository Paths
 Get-PSRepository 
