 [cmdletbinding(SupportsShouldProcess=$True)]
<#
.SYNOPSIS

Deploys trusted scripts to servers known to the CMS.

.DESCRIPTION

Runs scripts against administrative databases and attempts to create them where missing.

.PARAMETER 

Specifies the

.PARAMETER 

Specifies the 

.PARAMETER 

Specifies the 

.PARAMETER

Specifies the 

.PARAMETER dryRun

Specifies if the user wants to perform what if.

.INPUTS

None. You cannot pipe objects to Add-Extension.

.OUTPUTS

None.  You cannot pass output from this script to another.

.EXAMPLE

.\deployDB.ps1 -targetDB "DBA" -cmsGroup "DEV" -dryRun 0 -verbose

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -repoFolder "Create"

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -targetCMS "DBA-SQLPRD-01\I01" -dryRun 0 -verbose

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -repoRoot "C:\Users\hbrotherton\source\Workspaces\DBA\InventoryDWH" -repoFolder "StoredProcedure"

.EXAMPLE

.\deployDB.ps1 -targetDB "InventoryDWH" -targetHost ".\HKB1" -repoRoot "EXEC DBA.deploy.SetSysConfiguration" -repoFolder "EXEC"

.LINK

http://tfs-server-04:8080/tfs/defaultcollection/DBA/DBA%20Team/_versionControl/changesets?itemPath=%24%2FDBA%2FPowerShell

#>
PARAM(
        [Parameter(Mandatory=$true)] [string] $targetDB = "InventoryDWH",
        [string] $cmsGroup = "NonProd", 
		[string] $repoRoot = "",
        #[ValidateSet("Auto","EXEC","PowerShell","SSRS","Role","Schema")]
		[string] $repoFolder = "Auto", #Create, Auto, PowerShell, Command
    ## rerun variables - not yet ready
    ##    [string] DeployID, 
    ##    [string] repoVersion, 
        [Parameter( Mandatory = $FALSE,
                HelpMessage = 'Supply a credential object to access Azure.')]
                [ValidateNotNull()]
                [System.Management.Automation.PSCredential]
                [System.Management.Automation.Credential()]
                $Credential = [System.Management.Automation.PSCredential]::Empty,
        [string] $targetInvServer = "DBA-SQLPRD-01\I01",  # should be optional and if not specified do not record failures
        [string] $targetInvDB = "InventoryDWH",           # should be optional and if not specified do not record failures
        [string] $fileFilter = '*.sql',
        [boolean] $configure = $false,                    # used during inital set up of instance
        [boolean] $notify = $True,                        # automated jobs should use this to alert team
        [boolean] $force = $False,
		[boolean] $dryRun = $True
	)

$ErrorActionPreference="Continue";	

$dotnetversion = [Environment]::Version            
IF(!($dotnetversion.Major -ge 4 -and $dotnetversion.Build -ge 30319)) 
{            
    write-error "You are not having Microsoft DotNet Framework 4.5 installed. Script exiting"            
    exit(1)            
}            

# Import dotnet libraries            
[Void][Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')      

$project = (Split-Path -Parent $MyInvocation.MyCommand.Path)
# always use '-Force' to load the latest version of the module
#Import-Module "$($project)\Modules\Host-Functions.psm1" -Force
$ScriptPath = "$($project)\deployDB.ps1"
##########################################################################################################################################


## Prompt for credentials to admin SQL auth instances?
$myCred = Get-Credential
Write-Host "[AUTO] No target instance supplied - looking at Inventory for CMS groups $($cmsGroup)"
If( $cmsGroup -eq "nonprod"){
    $selectSQL = "SELECT DISTINCT [ServerEnvironment] as CMSGroup FROM [InventoryDWH].[inv].[Instance] WHERE ServerEnvironment != 'PROD' AND ServerEnvironment != 'ADMIN' AND ServerEnvironment != '_DCOM' ORDER BY ServerEnvironment"
}
ELSEIf( $cmsGroup -eq "allprod"){
    $selectSQL = "SELECT DISTINCT [ServerEnvironment] as CMSGroup FROM [InventoryDWH].[inv].[Instance] WHERE ServerEnvironment = 'PROD' OR ServerEnvironment = 'ADMIN' ORDER BY ServerEnvironment"
}
ELSEIf( $cmsGroup -eq "all"){
    $selectSQL = "SELECT DISTINCT [ServerEnvironment] as CMSGroup FROM [InventoryDWH].[inv].[Instance] ORDER BY ServerEnvironment"
}
ELSE{
    $selectSQL = "SELECT DISTINCT [ServerEnvironment] as CMSGroup FROM [InventoryDWH].[inv].[Instance] WHERE ServerEnvironment = '$($cmsGroup)' "
}
 

Write-Host `t"$($selectSQL)"
Write-Verbose `t"invoke-sqlcmd -ServerInstance $($TargetInvServer) -Database $($TargetInvDB) -Query $selectSQL "
$CMSList = @( invoke-sqlcmd -ServerInstance $($TargetInvServer) -Database $($TargetInvDB) -Query $selectSQL)

[int] $CMSCounter = 1
ForEach ( $CMS in $CMSList ){
    Write-Host "[  Processing: $($CMSCounter) of $($CMSList.Count)  ]"
    Write-Host " ] CMS Group: $($currentCMS) "
 $CMSGroup.CMSGroup
    Write-Host ".\deployDB.ps1 -targetDB $($targetDB) -cmsgroup $($currentCMS) -reporoot $($repoRoot) -dryRun $($dryRun)"
    .\deployDB.ps1 -targetDB $($targetDB) -cmsgroup $($currentCMS) -reporoot $($repoRoot) -Credential $myCred -dryRun $($dryRun)
    #Start-Job -Name "DEPPLOY-$($currentCMS)" -FilePath $ScriptPath -ArgumentList @( "$($targetDB)", "$($currentCMS)", "$($repoRoot)", $myCred, "$($dryRun)" )

    $CMSCounter = $CMSCounter +1
}
<#
get-job
Stop-Job -id ##
Stop-Job -State Blocked
removejob -d ##

#>