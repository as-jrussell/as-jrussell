
<#
####Rename File

Rename-Item aws.tools.rds.4.1.326.nupkg aws.tools.rds.4.1.326.zip

Rename-Item *.nupkg *.zip


Rename-Item az.accounts.2.12.2.nupkg  az.accounts.2.12.2.zip

Rename-Item azure.5.3.1.nupkg azure.5.3.1.zip        

Rename-Item azure.storage.4.6.1.nupkg azure.storage.4.6.1.zip

###Expand to Folder
Expand-Archive -Path azurerm.profile.5.8.4.zip -DestinationPath C:\PowerShell\Modules\AzureProfile\
Expand-Archive -Path aws.tools.installer.1.0.2.4.zip -DestinationPath C:\PowerShell\Modules\AmazonInstallerRDS\


#>


Import-Module -Name "C:\PowerShell\Modules\Snowflake\SnowSQL.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\dbatools\dbatools.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\Database-Functions.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\File-Functions.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\GitHub-Functions.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\Host-Functions.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\Instance-Functions.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\Inventory-Functions.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\SQLSupport-Functions.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\SSRS-Functions.psm1" -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\process-Zipfile.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\UserRights.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\SwitchUACLevel.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\AmazonToolsRDS\AWS.Tools.RDS.Aliases.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\AmazonInstallerRDS\AWS.Tools.Installer.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\AmazonCommonRDS\AWS.Tools.Common.Completers.psm1"  -Force -Verbose
Import-Module -Name "C:\PowerShell\Modules\AmazonCommonRDS\AWS.Tools.Common.Aliases.psm1"  -Force -Verbose


