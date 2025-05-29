using namespace System
using namespace System.Collections.Generic
using namespace System.IO
using namespace System.IO.Compression
using namespace System.Management.Automation
using namespace System.Net
using namespace System.Net.Http
using namespace System.Threading.Tasks

Microsoft.PowerShell.Core\Set-StrictMode -Version 3

$script:AWSToolsSignatureAmazonSubject = 'CN="Amazon.com, Inc.", O="Amazon.com, Inc.", L=Seattle, S=Washington, C=US'
$script:AWSToolsSignatureAwsSubject = 'CN="Amazon Web Services, Inc.", OU=AWS, O="Amazon Web Services, Inc.", L=Seattle, S=Washington, C=US'
$script:AWSToolsSignatureSDKSubject = 'CN="Amazon Web Services, Inc.", OU=SDKs and Tools, O="Amazon Web Services, Inc.", L=Seattle, S=Washington, C=US'
$script:AWSToolsTempRepoName = 'AWSToolsTemp'
$script:CurrentMinAWSToolsInstallerVersion = '0.0.0.0'
$script:ExpectedModuleCompanyName = 'aws-dotnet-sdk-team'
$script:MaxModulesToFindIndividually = 3
$script:ParallelDownloaderClassCode = @"
using System;
using System.IO;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;

public class ParallelDownloader
{
    private readonly HttpClient Client;
    private readonly CancellationTokenSource CancellationTokenSource = new CancellationTokenSource();

    public ParallelDownloader(HttpClient client)
    {
        Client = client;
    }

    public async Task DownloadToFile(string uri, string filePath)
    {
        using (var httpResponseMessage = await Client.GetAsync(uri, CancellationTokenSource.Token))
        using (var stream = await httpResponseMessage.EnsureSuccessStatusCode().Content.ReadAsStreamAsync())
        using (var fileStream = new FileStream(filePath, FileMode.Create))
        {
            await stream.CopyToAsync(fileStream, 81920, CancellationTokenSource.Token);
        }
    }

    public void Cancel()
    {
        CancellationTokenSource.Cancel();
    }
}
"@

function Get-CleanVersion {
    Param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory, Position = 0)]
        [AllowNull()]
        [Version]
        $Version
    )

    Process {
        if ($null -eq $Version) {
            $Version
        }
        else {
            [int]$major = $Version.Major
            [int]$minor = $Version.Minor
            [int]$build = $Version.Build
            [int]$revision = $Version.Revision

            #PowerShell modules version numbers can have missing fields, that would create problems with
            #matching and sorting versions. Replacing missing fields with 0s
            if ($major -lt 0) {
                $major = 0
            }
            if ($minor -lt 0) {
                $minor = 0
            }
            if ($build -lt 0) {
                $build = 0
            }
            if ($revision -lt 0) {
                $revision = 0
            }

            [Version]::new($major, $minor, $build, $revision)
        }
    }
}

function Get-AWSToolsModule {
    Param(
        [Parameter()]
        [Switch]
        $SkipIfInvalidSignature
    )

    Process {
        #Windows Powershell 5.1 has inconistent behavior where Get-Module could return nothing in %USERPROFILE%\Documents\WindowsPowerShell\Modules.
        [PSModuleInfo[]]$installedAwsToolsModules = Microsoft.PowerShell.Core\Get-Module -Name 'AWS.Tools.*' -ListAvailable -Verbose:$false

        if ($installedAwsToolsModules -and ($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows)) {
            $installedAwsToolsModules = $installedAwsToolsModules | Where-Object {
                [Signature]$signature = Microsoft.PowerShell.Security\Get-AuthenticodeSignature -FilePath $_.Path
                ($signature.Status -eq 'Valid' -or $SkipIfInvalidSignature) -and ($signature.SignerCertificate.Subject -eq $script:AWSToolsSignatureAmazonSubject -or $signature.SignerCertificate.Subject -eq $script:AWSToolsSignatureAwsSubject -or $signature.SignerCertificate.Subject.StartsWith($script:AWSToolsSignatureSDKSubject))
            }
        }

        if($installedAwsToolsModules) {
            $installedAwsToolsModules = $installedAwsToolsModules | Where-Object { $_.Name -ne 'AWS.Tools.Installer' }
        }

        $installedAwsToolsModules
    }
}

<#
.Synopsis
    Uninstalls all currently installed AWS.Tools modules.

.Description
    This cmdlet uses Uninstall-Module to uninstall all currently installed AWS.Tools
    modules.

.Notes

.Example
    Uninstall-AWSToolsModule -ExceptVersion 4.0.0.0

    This example uninstalls all versions of all AWS.Tools modules except for version 4.0.0.0.
#>
function Uninstall-AWSToolsModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        ## Specifies the minimum version of the modules to uninstall.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Version]
        $MinimumVersion,

        ## Specifies exact version number of the module to uninstall.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Version]
        $RequiredVersion,

        ## Specifies the maximum version of the modules to uninstall.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Version]
        $MaximumVersion,

        ## Specifies that you want to uninstall all of the other available versions of AWS Tools except this one.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Version]
        $ExceptVersion,

        ## Forces Uninstall-AWSToolsModule to run without asking for user confirmation
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $Force
    )

    Begin {
        $MinimumVersion = Get-CleanVersion $MinimumVersion
        $RequiredVersion = Get-CleanVersion $RequiredVersion
        $MaximumVersion = Get-CleanVersion $MaximumVersion
        $ExceptVersion = Get-CleanVersion $ExceptVersion

        Write-Verbose "[$($MyInvocation.MyCommand)] ConfirmPreference=$ConfirmPreference WhatIfPreference=$WhatIfPreference VerbosePreference=$VerbosePreference Force=$Force"
    }

    Process {
        $ErrorActionPreference = 'Stop'

        Write-Verbose "[$($MyInvocation.MyCommand)] Searching installed modules"
        [PSModuleInfo[]]$InstalledAwsToolsModules = Get-AWSToolsModule

        if ($MinimumVersion -and $InstalledAwsToolsModules) {
            $InstalledAwsToolsModules = $InstalledAwsToolsModules | Where-Object { (Get-CleanVersion $_.Version) -ge $MinimumVersion }
        }
        if ($MaximumVersion -and $InstalledAwsToolsModules) {
            $InstalledAwsToolsModules = $InstalledAwsToolsModules | Where-Object { (Get-CleanVersion $_.Version) -le $MaximumVersion }
        }
        if ($RequiredVersion -and $InstalledAwsToolsModules) {
            $InstalledAwsToolsModules = $InstalledAwsToolsModules | Where-Object { (Get-CleanVersion $_.Version) -eq $RequiredVersion }
        }
        if ($ExceptVersion -and $InstalledAwsToolsModules) {
            $InstalledAwsToolsModules = $InstalledAwsToolsModules | Where-Object { (Get-CleanVersion $_.Version) -ne $ExceptVersion }
        }

        if ($InstalledAwsToolsModules) {
            $versions = $InstalledAwsToolsModules | Group-Object Version

            if ($versions -and ($Force -or $WhatIfPreference -or $PSCmdlet.ShouldProcess("AWS Tools version $([string]::Join(', ', $versions.Name))"))) {
                $ConfirmPreference = 'None'

                $versions | ForEach-Object {
                    Write-Host "Uninstalling AWS.Tools version $($_.Name)"

                    [PSModuleInfo[]]$versionModules = $_.Group

                    while ($versionModules) {
                        [string[]]$dependencyNames = $versionModules | Select-Object -ExpandProperty RequiredModules | Select-Object -ExpandProperty Name | Sort-Object -Unique
                        if ($dependencyNames) {
                            [PSModuleInfo[]]$removableModules = $versionModules | Where-Object { -not $dependencyNames.Contains($_.Name) }
                        }
                        else {
                            [PSModuleInfo[]]$removableModules = $versionModules
                        }

                        if (-not $removableModules) {
                            Write-Error "Remaining modules for version $($_.Name) cannot be removed"
                            break
                        }
                        $removableModules | ForEach-Object {
                            if ($WhatIfPreference) {
                                Write-Host "What if: Uninstalling module $($_.Name)"
                            }
                            else {
                                Write-Host "Uninstalling module $($_.Name)"
                                #We need to use -Force to work around https://github.com/PowerShell/PowerShellGet/issues/542
                                $uninstallModuleParams = @{
                                    Name            = $_.Name
                                    RequiredVersion = $_.Version
                                    Force           = $true
                                    Confirm         = $false
                                    ErrorAction     = 'Continue'
                                }
                                PowerShellGet\Uninstall-Module @uninstallModuleParams
                            }
                        }

                        $versionModules = $versionModules | Where-Object { $_.Name -notin ($removableModules | Select-Object -ExpandProperty Name) }
                    }
                }
            }
        }
    }

    End {
        Write-Verbose "[$($MyInvocation.MyCommand)] End"
    }
}

function Find-AWSToolsModule {
    Param(
        ## Specifies a proxy server for the request, rather than connecting directly to an internet resource.
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory, Position = 0)]
        [string[]]
        $Name,

        ## Specifies a proxy server for the request, rather than connecting directly to an internet resource.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Uri]
        $Proxy,

        ## Specifies a user account that has permission to use the proxy server specified by the Proxy parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCredential]
        $ProxyCredential
    )

    Begin {
        $RequiredVersion = Get-CleanVersion $RequiredVersion
        $MaximumVersion = Get-CleanVersion $MaximumVersion

        Write-Verbose "[$($MyInvocation.MyCommand)] ConfirmPreference=$ConfirmPreference WhatIfPreference=$WhatIfPreference VerbosePreference=$VerbosePreference Name=($Name)"
    }

    Process {
        $proxyParams = @{ }
        if ($Proxy) {
            $proxyParams['Proxy'] = $Proxy
        }
        if ($ProxyCredential) {
            $proxyParams['ProxyCredential'] = $ProxyCredential
        }

        [PSObject[]]$availableModules = @()
        [string[]]$missingModules = $Name

        #'Find-Module AWS.Tools.*' is only slightly slower than Find-Module for a single module
        if ($Name.Count -gt $script:MaxModulesToFindIndividually) {
            $availableModules += PowerShellGet\Find-Module -Name 'AWS.Tools.*' -Repository 'PSGallery' @proxyParams -ErrorAction 'Stop' | Where-Object { $_.Name -in $Name -and $_.CompanyName -ceq $script:ExpectedModuleCompanyName }
            $missingModules = $Name | Where-Object { $_ -notin ($availableModules | Select-Object -ExpandProperty Name) }
            if ($missingModules) {
                Write-Verbose "[$($MyInvocation.MyCommand)] Retrying Find-Module on ($missingModules)"
            }
        }

        if ($missingModules) {
            #'Find-Module AWS.Tools.*' doesn't always return all modules, so we have to retry missing ones
            $missingModules | ForEach-Object {
                $availableModules += PowerShellGet\Find-Module -Name $_ -Repository 'PSGallery' @proxyParams -ErrorAction 'Ignore' | Where-Object { $_.Name -in $Name -and $_.CompanyName -ceq $script:ExpectedModuleCompanyName }
            }

            $missingModules = $Name | Where-Object { $_ -notin ($availableModules | Select-Object -ExpandProperty Name) }
            if ($missingModules) {
                throw "Could not find AWS.Tools module on PSGallery: $([string]::Join(', ', $missingModules))."
            }
        }

        $availableModules
    }

    End {
        Write-Verbose "[$($MyInvocation.MyCommand)] End"
    }
}

function Get-AWSToolsModuleDependenciesAndValidate {
    Param(
        ## Path of the manifest file to validate
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [string]
        $Path,

        ## Name of the module to validate
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [string]
        $Name
    )

    Begin {
        Write-Verbose "[$($MyInvocation.MyCommand)] ConfirmPreference=$ConfirmPreference WhatIfPreference=$WhatIfPreference VerbosePreference=$VerbosePreference Name=$Name Path=$Path"
    }

    Process {
        $ErrorActionPreference = 'Stop'

        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
        Add-Type -AssemblyName System.IO.Compression -ErrorAction Stop

        [Stream]$manifestFileStream = $null
        [Stream]$entryStream = $null
        [ZipArchive]$zipArchive = $null
        [string]$temporaryManifestFilePath = $null

        try {
            $zipArchive = [ZipFile]::OpenRead($Path)
            [ZipArchiveEntry]$entry = $zipArchive.GetEntry("$($Name).psd1")
            $entryStream = $entry.Open()
            $temporaryManifestFilePath = Join-Path ([Path]::GetTempPath()) "$([Path]::GetRandomFileName()).psd1"
            $manifestFileStream = [File]::OpenWrite($temporaryManifestFilePath)
            $entryStream.CopyTo($manifestFileStream)
            $manifestFileStream.Close();

            if ($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows) {
                [Signature]$manifestSignature = Microsoft.PowerShell.Security\Get-AuthenticodeSignature -FilePath $temporaryManifestFilePath
                if ($manifestSignature.Status -eq 'Valid' -and ($manifestSignature.SignerCertificate.Subject -eq $script:AWSToolsSignatureAmazonSubject -or $manifestSignature.SignerCertificate.Subject -eq $script:AWSToolsSignatureAwsSubject -or $manifestSignature.SignerCertificate.Subject.StartsWith($script:AWSToolsSignatureSDKSubject))) {
                    Write-Verbose "[$($MyInvocation.MyCommand)] Manifest signature correctly validated"
                }
                else {
                    throw "Error validating manifest signature for $($Name)"
                }
            }
            else {
                Write-Verbose "[$($MyInvocation.MyCommand)] Authenticode signature can only be verified on Windows, skipping"
            }

            [PSObject]$manifestData = Microsoft.PowerShell.Utility\Import-PowerShellDataFile $temporaryManifestFilePath

            if ($manifestData.PrivateData.ContainsKey('MinAWSToolsInstallerVersion')) {
                [Version]$minVersion = Get-CleanVersion $manifestData.PrivateData.MinAWSToolsInstallerVersion
                if ($minVersion -gt $script:CurrentMinAWSToolsInstallerVersion) {
                    throw "$Name version $($manifestData.ModuleVersion) requires at least AWS.Tools.Installer version $minVersion. Run 'Update-Module AWS.Tools.Installer'."
                }
            }

            $manifestData.RequiredModules | ForEach-Object {
                Write-Verbose "[$($MyInvocation.MyCommand)] Found dependency $($_.ModuleName)"
                $_.ModuleName
            }
        }
        finally {
            if ($manifestFileStream) {
                $manifestFileStream.Dispose()
            }
            if ($entryStream) {
                $entryStream.Dispose()
            }
            if ($zipArchive) {
                $zipArchive.Dispose()
            }
            if ($temporaryManifestFilePath) {
                Microsoft.PowerShell.Management\Remove-Item -Path $temporaryManifestFilePath -WhatIf:$false
            }
        }
    }

    End {
        Write-Verbose "[$($MyInvocation.MyCommand)] End"
    }
}

<#
.Synopsis
    Install AWS.Tools modules.

.Description
    This cmdlet uses Install-Module to install AWS.Tools modules.
    Unless -SkipUpdate is specified, this cmdlet also updates all other currently installed AWS.Tools modules to the version being installed.

.Notes
    This cmdlet uses the PSRepository named PSGallery as source.
    Use 'Get-PSRepository -Name PSGallery' for information on the PSRepository used by Update-AWSToolsModule.
    This cmdlet downloads all modules from https://www.powershellgallery.com/api/v2/package/ and considers it a trusted source.

.Example
    Install-AWSToolsModule EC2,S3 -RequiredVersion 4.0.0.0

    This example installs version 4.0.0.0 of AWS.Tools.EC2, AWS.Tools.S3 and their dependencies.
#>
function Install-AWSToolsModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        ## Specifies names of the AWS.Tools modules to install.
        ## The names can be listed either with or without the "AWS.Tools." prefix (i.e. "AWS.Tools.Common" or simply "Common").
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory, Position = 0)]
        [string[]]
        $Name,

        ## Specifies exact version number of the module to install.
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [Version]
        $RequiredVersion,

        ## Specifies the minimum version of the modules to install.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Version]
        $MinimumVersion,

        ## Specifies the maximum version of the modules to install.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Version]
        $MaximumVersion,

        ## Specifies that, after a successful install, all other versions of the AWS Tools modules should be uninstalled.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $CleanUp,

        ## Install-AWSToolsModule by default also updates all currently installed AWS.Tools modules. -SkipUpdate disables the update.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $SkipUpdate,
		
        ## Allows skipping the publisher validation check.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $SkipPublisherCheck,		

        ## Specifies the installation scope of the module. The acceptable values for this parameter are AllUsers and CurrentUser.
        ## The AllUsers scope installs modules in a location that is accessible to all users of the computer:
        ##  $env:ProgramFiles\PowerShell\Modules
        ## The CurrentUser installs modules in a location that is accessible only to the current user of the computer:
        ##  $home\Documents\PowerShell\Modules
        ## When no Scope is defined, the default is CurrentUser.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('CurrentUser', 'AllUsers')]
        [string]
        $Scope = 'CurrentUser',

        ## Overrides warning messages about installation conflicts about existing commands on a computer.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $AllowClobber,

        ## Specifies a proxy server for the request, rather than connecting directly to an internet resource.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Uri]
        $Proxy,

        ## Specifies a user account that has permission to use the proxy server specified by the Proxy parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCredential]
        $ProxyCredential,

        ## Forces an install of each specified module without a prompt to request confirmation
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $Force
    )

    Begin {
        $RequiredVersion = Get-CleanVersion $RequiredVersion
        $MaximumVersion = Get-CleanVersion $MaximumVersion

        Write-Verbose "[$($MyInvocation.MyCommand)] ConfirmPreference=$ConfirmPreference WhatIfPreference=$WhatIfPreference VerbosePreference=$VerbosePreference Force=$Force Name=($Name) RequiredVersion=$RequiredVersion SkipUpdate=$SkipUpdate CleanUp=$CleanUp"
    }

    Process {
        $ErrorActionPreference = 'Stop'

        $Name = $Name | ForEach-Object {
            if ($_.Contains('.')) {
                $_
            }
            else {
                "AWS.Tools.$_"
            }
        } | Sort-Object -Unique

        if ($Name -notlike 'AWS.Tools.*') {
            throw "The Name parameter must contain only AWS.Tools modules."
        }

        if ($Name -eq 'AWS.Tools.Installer') {
            throw "AWS.Tools.Installer cannot be used to install AWS.Tools.Installer. Use Update-Module instead."
        }

        [PSObject[]]$availableModulesToInstall = Find-AWSToolsModule -Name $Name -Proxy $Proxy -ProxyCredential $ProxyCredential

        [Version]$availableVersion = [Version[]]$availableModulesToInstall.Version | Measure-Object -Minimum | Select-Object -Expand Minimum

        $availableVersion = Get-CleanVersion $availableVersion

        if ($MinimumVersion -and $MinimumVersion -gt $availableVersion) {
            throw "The maximum version available is $availableVersion."
        }
        if ($RequiredVersion -and $RequiredVersion -gt $availableVersion) {
            throw "The maximum version available is $availableVersion."
        }
        if ($MinimumVersion -and $RequiredVersion -and $MinimumVersion -gt $RequiredVersion) {
            throw 'Parameter MinimumVersion is greater than RequiredVersion.'
        }
        if ($MaximumVersion -and $RequiredVersion -and $MaximumVersion -lt $RequiredVersion) {
            throw 'Parameter MaximumVersion is less than RequiredVersion.'
        }
        if ($MaximumVersion -and -not $RequiredVersion -and $MaximumVersion -lt $availableVersion) {
            $RequiredVersion = Find-Module -Name 'AWS.Tools.Common' -MaximumVersion $MaximumVersion | Select-Object -Expand Version
        }
        if (-not $RequiredVersion) {
            $RequiredVersion = $availableVersion
        }

        Write-Verbose "[$($MyInvocation.MyCommand)] Installing AWS Tools version $RequiredVersion"

        [string[]]$modulesToInstall = $availableModulesToInstall.Name

        if (-not $SkipUpdate) {
            Write-Verbose "[$($MyInvocation.MyCommand)] Searching installed modules"
            [PSModuleInfo[]]$installedAwsToolsModules = Get-AWSToolsModule -SkipIfInvalidSignature
            if ($installedAwsToolsModules) {
                $modulesToInstall = ($modulesToInstall + ($installedAwsToolsModules | Select-Object -Expand Name)) | Sort-Object -Unique
                Write-Verbose "[$($MyInvocation.MyCommand)] Merging existing modules into the list of modules to install: ($modulesToInstall)"
            }
        }

        $modulesToInstall = $modulesToInstall | Where-Object { -not (Get-Module $_ -ListAvailable -Verbose:$false | Where-Object { (Get-CleanVersion $_.Version) -eq $RequiredVersion }) }
        Write-Verbose "[$($MyInvocation.MyCommand)] Removing already installed modules from the. Final list of modules to install: ($modulesToInstall)"

        if ($modulesToInstall) {
            if ($Force -or $WhatIfPreference -or $PSCmdlet.ShouldProcess("AWS Tools version $RequiredVersion")) {
                $ConfirmPreference = 'None'

                [string]$temporaryRepoDirectory = Join-Path ([Path]::GetTempPath()) ([Path]::GetRandomFileName())
                Write-Verbose "[$($MyInvocation.MyCommand)] Create folder for temporary repository $temporaryRepoDirectory"
                Microsoft.PowerShell.Management\New-Item -ItemType Directory -Path $temporaryRepoDirectory -WhatIf:$false | Out-Null
                try {
                    if (-not $WhatIfPreference) {
                        PowerShellGet\Unregister-PSRepository -Name $script:AWSToolsTempRepoName -ErrorAction 'SilentlyContinue'
                        Write-Verbose "[$($MyInvocation.MyCommand)] Registering temporary repository $script:AWSToolsTempRepoName"
                        PowerShellGet\Register-PSRepository -Name $script:AWSToolsTempRepoName -SourceLocation $temporaryRepoDirectory -ErrorAction 'Stop'
                        PowerShellGet\Set-PSRepository -Name $script:AWSToolsTempRepoName -InstallationPolicy Trusted
                    }

                    Add-Type -AssemblyName System.Net.Http -ErrorAction Stop

                    [HttpClient]$httpClient = $null
                    [HttpClientHandler]$httpClientHandler = $null
                    [List[PSCustomObject]]$tasks = @()

                    Write-Verbose "[$($MyInvocation.MyCommand)] Downloading modules to temporary repository"
                    try {
                        $httpClientHandler = [HttpClientHandler]::new()
                        if ($Proxy) {
                            $httpClientHandler.Proxy = [WebProxy]::new($Proxy)
                            if ($ProxyCredential) {
                                $httpClientHandler.Proxy.Credentials = $ProxyCredential.GetNetworkCredential()
                            }
                        }
                        $httpClient = [HttpClient]::new($httpClientHandler);

                        Add-Type $script:ParallelDownloaderClassCode -ReferencedAssemblies System.Net.Http,System.Threading.Tasks
                        [ParallelDownloader]$parallelDownloader = [ParallelDownloader]::new($httpClient)

                        [string[]]$modulesToDownload = $modulesToInstall
                        [HashSet[string]]$savedModules = New-Object -TypeName System.Collections.Generic.HashSet[string]

                        Write-Verbose "[$($MyInvocation.MyCommand)] Downloading modules ($modulesToDownload)"

                        while ($modulesToDownload) {
                            [string[]]$dependencies = @()

                            $tasks = $modulesToDownload | Where-Object { $savedModules.Add($_) } | ForEach-Object {
                                [string]$nupkgFilePath = Join-Path $temporaryRepoDirectory "$_.$($RequiredVersion).nupkg"
                                Write-Verbose "[$($MyInvocation.MyCommand)] Downloading module $_ to $TemporaryRepoDirectory"
                                [PSCustomObject]@{
                                    Task       = $parallelDownloader.DownloadToFile("https://www.powershellgallery.com/api/v2/package/$_/$RequiredVersion", $nupkgFilePath)
                                    ModuleName = $_
                                    Path       = $nupkgFilePath
                                }
                            }
                            while ($tasks) {
                                [int]$taskIndex = [Task]::WaitAny($tasks.Task)
                                [PSObject]$task = $tasks[$taskIndex]
                                $tasks.RemoveAt($taskIndex)
                                if ($task.Task.IsCompleted) {
                                    $dependencies += Get-AWSToolsModuleDependenciesAndValidate -Path $task.Path -Name $task.ModuleName
                                } else {
                                    throw "Error downloading $($task.ModuleName): $($task.Task.Exception)"
                                }
                            }

                            $modulesToDownload = $dependencies | Sort-Object -Unique
                        }
                    }
                    finally {
                        if ($tasks) {
                            Write-Verbose "[$($MyInvocation.MyCommand)] Cancelling $($tasks.Count) tasks"
                            $parallelDownloader.Cancel()
                            try {
                                [Task]::WaitAll($tasks.Task)
                            } catch {

                            }
                        }

                        if ($httpClient) {
                            $httpClient.Dispose()
                        }
                        if ($httpClientHandler) {
                            $httpClientHandler.Dispose()
                        }
                    }

                    Write-Verbose "[$($MyInvocation.MyCommand)] Installing modules ($modulesToInstall)"
                    $installModuleParams = @{
                        RequiredVersion = $RequiredVersion
                        Scope           = $Scope
                        Repository      = $script:AWSToolsTempRepoName
                        AllowClobber    = $AllowClobber
                        Confirm         = $false
                        ErrorAction     = 'Stop'
						SkipPublisherCheck = $SkipPublisherCheck
                    }
                    $modulesToInstall | ForEach-Object {
                        if (-not $WhatIfPreference) {
                            Write-Host "Installing module $_ version $RequiredVersion"
                            PowerShellGet\Install-Module -Name $_ @installModuleParams
                        }
                        else {
                            Write-Host "What if: Installing module $_ version $RequiredVersion"
                        }
                    }
                    Write-Verbose "[$($MyInvocation.MyCommand)] Modules install complete"
                }
                finally {
                    if (-not $WhatIfPreference) {
                        Write-Verbose "[$($MyInvocation.MyCommand)] Unregistering temporary repository $script:AWSToolsTempRepoName"
                        PowerShellGet\Unregister-PSRepository -Name $script:AWSToolsTempRepoName -ErrorAction 'Continue'
                    }
                    Write-Verbose "[$($MyInvocation.MyCommand)] Delete repository folder $temporaryRepoDirectory"
                    Microsoft.PowerShell.Management\Remove-Item -Path $temporaryRepoDirectory -Recurse -WhatIf:$false
                }
            }
        }
        else {
            Write-Verbose "[$($MyInvocation.MyCommand)] All modules are up to date"
        }

        if ($CleanUp) {
            Uninstall-AWSToolsModule -ExceptVersion $RequiredVersion
        }
    }

    End {
        Write-Verbose "[$($MyInvocation.MyCommand)] End"
    }
}

<#
.Synopsis
    Updates all currently installed AWS.Tools modules.

.Description
    This cmdlet uses Install-Module to update all AWS.Tools modules.

.Notes
    This cmdlet uses the PSRepository named PSGallery as source.
    Use 'Get-PSRepository -Name PSGallery' for information on the PSRepository used by Update-AWSToolsModule.
    This cmdlet downloads all modules from https://www.powershellgallery.com/api/v2/package/ and considers it a trusted source.

.Example
    Update-AWSToolsModule -CleanUp

    This example updates all installed AWS.Tools modules to the latest version available on the PSGallery and uninstalls all other versions.
#>
function Update-AWSToolsModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        ## Specifies the exact version of the modules to update to.
        [Parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [Version]
        $RequiredVersion,

        ## Specifies the maximum version of the modules to update to.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Version]
        $MaximumVersion,

        ## Specifies that, after a successful install, all other versions of the AWS Tools modules should be uninstalled.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $CleanUp,
		
        ## Allows skipping the publisher validation check.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $SkipPublisherCheck,			

        #Specifies the installation scope of the module. The acceptable values for this parameter are AllUsers and CurrentUser.
        #The AllUsers scope installs modules in a location that is accessible to all users of the computer:
        # $env:ProgramFiles\PowerShell\Modules
        #The CurrentUser installs modules in a location that is accessible only to the current user of the computer:
        # $home\Documents\PowerShell\Modules
        #When no Scope is defined, the default is CurrentUser.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('CurrentUser', 'AllUsers')]
        [string]
        $Scope = 'CurrentUser',

        #Overrides warning messages about installation conflicts about existing commands on a computer.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $AllowClobber,

        #Specifies a proxy server for the request, rather than connecting directly to an internet resource.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Uri]
        $Proxy,

        ## Specifies a user account that has permission to use the proxy server specified by the Proxy parameter.
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCredential]
        $ProxyCredential,

        ## Forces an update of each specified module without a prompt to request confirmation
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $Force
    )

    Begin {
        $RequiredVersion = Get-CleanVersion $RequiredVersion
        $MaximumVersion = Get-CleanVersion $MaximumVersion

        Write-Verbose "[$($MyInvocation.MyCommand)] ConfirmPreference=$ConfirmPreference WhatIfPreference=$WhatIfPreference VerbosePreference=$VerbosePreference Force=$Force"
    }

    Process {
        $ErrorActionPreference = 'Stop'

        Write-Verbose "[$($MyInvocation.MyCommand)] Searching installed modules"
        [PSModuleInfo[]]$installedAwsToolsModules = Get-AWSToolsModule -SkipIfInvalidSignature
        [string[]]$installedAwsToolsModuleNames = $installedAwsToolsModules | Select-Object -Expand Name | Sort-Object -Unique

        if ($installedAwsToolsModuleNames) {
            Write-Verbose "[$($MyInvocation.MyCommand)] Found modules ($installedAwsToolsModuleNames)"

            $installAWSToolsModuleParams = @{
                Name            = $installedAwsToolsModuleNames
                RequiredVersion = $RequiredVersion
                MaximumVersion  = $MaximumVersion
                Scope           = $Scope
                AllowClobber    = $AllowClobber
                CleanUp         = $CleanUp
                Force           = $Force
                SkipUpdate      = $true
                Proxy           = $Proxy
                ProxyCredential = $ProxyCredential
				SkipPublisherCheck = $SkipPublisherCheck
            }
            Install-AWSToolsModule @installAWSToolsModuleParams
        }
    }

    End {
        Write-Verbose "[$($MyInvocation.MyCommand)] End"
    }
}

# SIG # Begin signature block
# MIIfKwYJKoZIhvcNAQcCoIIfHDCCHxgCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCD7Imx30ehYnZlP
# FBqMOXtm3Bpfv9v2W3rtyXj4fKeUN6CCDlkwggawMIIEmKADAgECAhAIrUCyYNKc
# TJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0z
# NjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0
# JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJr
# Q5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhF
# LqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+F
# LEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh
# 3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJ
# wZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQay
# g9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbI
# YViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchAp
# QfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRro
# OBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IB
# WTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+
# YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAC
# hjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAED
# MAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql
# +Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFF
# UP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1h
# mYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3Ryw
# YFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5Ubdld
# AhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw
# 8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnP
# LqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatE
# QOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bn
# KD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQji
# WQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbq
# yK+p/pQd52MbOoZWeE4wggehMIIFiaADAgECAhALyko14sGCglkXWPsT8gmbMA0G
# CSqGSIb3DQEBCwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjExMjI4MDAwMDAwWhcNMjMwMTAz
# MjM1OTU5WjCB9jEdMBsGA1UEDwwUUHJpdmF0ZSBPcmdhbml6YXRpb24xEzARBgsr
# BgEEAYI3PAIBAxMCVVMxGTAXBgsrBgEEAYI3PAIBAhMIRGVsYXdhcmUxEDAOBgNV
# BAUTBzQxNTI5NTQxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdTZWF0dGxlMSIwIAYDVQQKExlBbWF6b24gV2ViIFNlcnZpY2VzLCBJ
# bmMuMRcwFQYDVQQLEw5TREtzIGFuZCBUb29sczEiMCAGA1UEAxMZQW1hem9uIFdl
# YiBTZXJ2aWNlcywgSW5jLjCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGB
# AKHRLdQSyJ6AfhQ8U7Gi6le7gshUhu34xQ7jaTCfpKaKQRGu+oNfAYDRSSfh498e
# K+jFnGHU/TMzVHEgBb4TUrc1e2f5LHhXAtYTJK0uis9OJ5n3MjHwOJt/uGSSMUAI
# IIselvbSF2mOE0lIz0CNMIlUiXI9O+y9+FJP7Vsg/NU/zAVsQ4Ok0GLd+Yp566nR
# uj9aNU+L+TxRhSHA7KKjJ9oE0mVblUGQaeNrOd1Ql9djJy0pg6oT2s9Peh8lqB3t
# UsMaoQ/FMV0P/e1S6V3yFg/I1OvQdtm29ryJTdg9ZvIV/FGnIYdW5s5T8t//nf+7
# LToQVhpML/ZWEhFRAa6We80Y8zs9glIPDZyYmi6OPbpY7kVHa4dr8S49tPwrVMjC
# 3hk9v9S6poDx/hR9kytwVt1Lo4LjAlpmKLeHVmOnn5uenpXqFOJMbTMYmciwHz8y
# WJwZYMKKLJPCGa79xaAkZj9HCop5yPUPccqjyz2i0v/Pt8yFH77s8q86e99O2a+/
# oQIDAQABo4ICNTCCAjEwHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIw
# HQYDVR0OBBYEFGmlIp+0bnVEmnOvWcJjnCup9DbsMC4GA1UdEQQnMCWgIwYIKwYB
# BQUHCAOgFzAVDBNVUy1ERUxBV0FSRS00MTUyOTU0MA4GA1UdDwEB/wQEAwIHgDAT
# BgNVHSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8v
# Y3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JT
# QTQwOTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0
# MjAyMUNBMS5jcmwwPQYDVR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIBFhto
# dHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGEMCQG
# CCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUHMAKG
# UGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENv
# ZGVTaWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3J0MAwGA1UdEwEB/wQCMAAw
# DQYJKoZIhvcNAQELBQADggIBALlYa6PSDPPulVJbqEi7XGz23lFZwYa1PiXk+PkJ
# O2HDXv2zep26LZriwBHT2yA/KbDvbwZpf4VOBKn5lQC9R+DsgwW/xZbNq7y3cWf9
# Ad1AQ9Do/FXfBqVO1if+GpqFbqUme5wOjn8/8dc4nFR4erbDgkM4ICn/astBigYn
# fM5wTO+J8ex+7fE2D1kFAwfZAuiRNdDreVMDlYXpJMQ4CtTKVLHYentLR747zzRj
# O4PqgL1exvbvpOMZlSDLWhaDjtKwUDb645ziHDA3DXe8K51+hIFuadKTinJa8Pfs
# bgg2W7aTfBdi2gTyXkeVJ836631Ks4KD3cXui9Jx2PWRAVxKIEvXuebZ09Mph2ji
# BH75urqS57i1mpS7OA5lIj7a7NIYsVl26PVpJUEr3LRKV8GO3tRC7KP0zE7sB7k2
# VQKwBXbsifq/vpcmeyy4OeQbZ1i8GwZLPHuygP9exTWK2o2wWByJs62Wdk6JmSRE
# vr9Wr59BVNbQfRSRaF9q058bBK68hGZtDBpJ9gJX4V12DI2UpSbcGf10+afL1J4z
# FDv98GIGkgmfLQJUpJeC/FnNrEXJbINndCsOb6gdLvLX1grMdUPmPkpRZyvG3HEy
# EMCV5ODMItTx7K6TDyeZDIXXP5oBnBMK9EjtRD3XkEb9dDfuzCrdlTpEoTElt2mG
# uEE7MYIQKDCCECQCAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNl
# cnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWdu
# aW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhALyko14sGCglkXWPsT8gmbMA0G
# CWCGSAFlAwQCAQUAoHwwEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwG
# CisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZI
# hvcNAQkEMSIEID5sdAI8aDI4LejcRRoUmX1yDM8NRbmF4+PF2RxNryq6MA0GCSqG
# SIb3DQEBAQUABIIBgFFPCGxQCcqmtTKOgjAds8R2oQwbBPK+nlDG/jVXzPLxsa+V
# +vcin4VDNZE/wrPK2csd5xSAeB+2EShibKWUJHnSHdCS+DMT0vugZwbBCk2Dse7d
# 1vkxtXP7DeglfFZqdFtVQ+/vynsj+bi7lU/lwJ4o7uqYhaOfaqNMJUel6Mhi+nVq
# rQqK6WhsMUfU/sJLmtgQD1nxeP9eRNCsWW8MhcP4Y6BtYJoriSzt/YG1rFPrr4Qf
# JbDJ2KBxF3FtsJvZzD58CLkhTmRYL/ywYSMsufy/tEJcsocCrKzT6mZw4Cp0XM48
# ci1a8jsND0ZbFEqmhu7Qxd2w4YyD6TgOWc7Kj8ClpSTM/CPzVsIRiL1+ufTLJIv/
# 2NuMUCBHAB18nD4k4zBPd3ETdu9xl3G2VQJ35Zdo3D35Bu6lrJQPPHorXqlng5f4
# ljztg/VIIGB2tpS3GwtNPgcTTzn4hL3C3iN6RMPQ1FM1pdTyvgzWnXSIe59ifQY+
# ZJR7bsv0AV2vZ1ymKqGCDX4wgg16BgorBgEEAYI3AwMBMYINajCCDWYGCSqGSIb3
# DQEHAqCCDVcwgg1TAgEDMQ8wDQYJYIZIAWUDBAIBBQAweAYLKoZIhvcNAQkQAQSg
# aQRnMGUCAQEGCWCGSAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCAWJupfcHMuecP/
# 7xxo0jJLOPNAH4UW/D83fasNX6UszwIRANKAADX7H1FN0gxzXVEGOA0YDzIwMjIw
# MjI4MjIxNjEzWqCCCjcwggT+MIID5qADAgECAhANQkrgvjqI/2BAIc4UAPDdMA0G
# CSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0
# IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwHhcNMjEwMTAxMDAwMDAw
# WhcNMzEwMTA2MDAwMDAwWjBIMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNl
# cnQsIEluYy4xIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFtcCAyMDIxMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwuZhhGfFivUNCKRFymNrUdc6EUK9
# CnV1TZS0DFC1JhD+HchvkWsMlucaXEjvROW/m2HNFZFiWrj/ZwucY/02aoH6Kfjd
# K3CF3gIY83htvH35x20JPb5qdofpir34hF0edsnkxnZ2OlPR0dNaNo/Go+EvGzq3
# YdZz7E5tM4p8XUUtS7FQ5kE6N1aG3JMjjfdQJehk5t3Tjy9XtYcg6w6OLNUj2vRN
# eEbjA4MxKUpcDDGKSoyIxfcwWvkUrxVfbENJCf0mI1P2jWPoGqtbsR0wwptpgrTb
# /FZUvB+hh6u+elsKIC9LCcmVp42y+tZji06lchzun3oBc/gZ1v4NSYS9AQIDAQAB
# o4IBuDCCAbQwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/
# BAwwCgYIKwYBBQUHAwgwQQYDVR0gBDowODA2BglghkgBhv1sBwEwKTAnBggrBgEF
# BQcCARYbaHR0cDovL3d3dy5kaWdpY2VydC5jb20vQ1BTMB8GA1UdIwQYMBaAFPS2
# 4SAd/imu0uRhpbKiJbLIFzVuMB0GA1UdDgQWBBQ2RIaOpLqwZr68KC0dRDbd42p6
# vDBxBgNVHR8EajBoMDKgMKAuhixodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vc2hh
# Mi1hc3N1cmVkLXRzLmNybDAyoDCgLoYsaHR0cDovL2NybDQuZGlnaWNlcnQuY29t
# L3NoYTItYXNzdXJlZC10cy5jcmwwgYUGCCsGAQUFBwEBBHkwdzAkBggrBgEFBQcw
# AYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME8GCCsGAQUFBzAChkNodHRwOi8v
# Y2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEyQXNzdXJlZElEVGltZXN0
# YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBIHNy16ZojvOca5yAOjmdG
# /UJyUXQKI0ejq5LSJcRwWb4UoOUngaVNFBUZB3nw0QTDhtk7vf5EAmZN7WmkD/a4
# cM9i6PVRSnh5Nnont/PnUp+Tp+1DnnvntN1BIon7h6JGA0789P63ZHdjXyNSaYOC
# +hpT7ZDMjaEXcw3082U5cEvznNZ6e9oMvD0y0BvL9WH8dQgAdryBDvjA4VzPxBFy
# 5xtkSdgimnUVQvUtMjiB2vRgorq0Uvtc4GEkJU+y38kpqHNDUdq9Y9YfW5v3LhtP
# Ex33Sg1xfpe39D+E68Hjo0mh+s6nv1bPull2YYlffqe0jmd4+TaY4cso2luHpoov
# MIIFMTCCBBmgAwIBAgIQCqEl1tYyG35B5AXaNpfCFTANBgkqhkiG9w0BAQsFADBl
# MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
# d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJv
# b3QgQ0EwHhcNMTYwMTA3MTIwMDAwWhcNMzEwMTA3MTIwMDAwWjByMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0
# YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvdAy7kvN
# j3/dqbqCmcU5VChXtiNKxA4HRTNREH3Q+X1NaH7ntqD0jbOI5Je/YyGQmL8TvFfT
# w+F+CNZqFAA49y4eO+7MpvYyWf5fZT/gm+vjRkcGGlV+Cyd+wKL1oODeIj8O/36V
# +/OjuiI+GKwR5PCZA207hXwJ0+5dyJoLVOOoCXFr4M8iEA91z3FyTgqt30A6XLdR
# 4aF5FMZNJCMwXbzsPGBqrC8HzP3w6kfZiFBe/WZuVmEnKYmEUeaC50ZQ/ZQqLKfk
# dT66mA+Ef58xFNat1fJky3seBdCEGXIX8RcG7z3N1k3vBkL9olMqT4UdxB08r8/a
# rBD13ays6Vb/kwIDAQABo4IBzjCCAcowHQYDVR0OBBYEFPS24SAd/imu0uRhpbKi
# JbLIFzVuMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNl
# cnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRo
# dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3JsMFAGA1UdIARJMEcwOAYKYIZIAYb9bAACBDAqMCgGCCsG
# AQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAsGCWCGSAGG/WwH
# ATANBgkqhkiG9w0BAQsFAAOCAQEAcZUS6VGHVmnN793afKpjerN4zwY3QITvS4S/
# ys8DAv3Fp8MOIEIsr3fzKx8MIVoqtwU0HWqumfgnoma/Capg33akOpMP+LLR2HwZ
# YuhegiUexLoceywh4tZbLBQ1QwRostt1AuByx5jWPGTlH0gQGF+JOGFNYkYkh2OM
# kVIsrymJ5Xgf1gsUpYDXEkdws3XVk4WTfraSZ/tTYYmo9WuWwPRYaQ18yAGxuSh1
# t5ljhSKMYcp5lH5Z/IwP42+1ASa2bKXuh1Eh5Fhgm7oMLSttosR+u8QlK0cCCHxJ
# rhO24XxCQijGGFbPQTS2Zl22dHv1VjMiLyI2skuiSpXY9aaOUjGCAoYwggKCAgEB
# MIGGMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNz
# dXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0ECEA1CSuC+Ooj/YEAhzhQA8N0wDQYJYIZI
# AWUDBAIBBQCggdEwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3
# DQEJBTEPFw0yMjAyMjgyMjE2MTNaMCsGCyqGSIb3DQEJEAIMMRwwGjAYMBYEFOHX
# gqjhkb7va8oWkbWqtJSmJJvzMC8GCSqGSIb3DQEJBDEiBCCPOxwTYIAexjgsFmxt
# s/BTIDkUBrqmKe6xViVUZXjY/DA3BgsqhkiG9w0BCRACLzEoMCYwJDAiBCCzEJAG
# vArZgweRVyngRANBXIPjKSthTyaWTI01cez1qTANBgkqhkiG9w0BAQEFAASCAQCf
# JtS6tMwtDpcc29O4ukgr2ZJ34RAhblAsXdR4JB2bKHeeFcjj28CoTQMKqiPDjWXN
# bSd2K8ESkmmspeB1bpzOCmMD2qUThHyWnmUKIj/kM1umPdrPgkBqqttq3rjIjhG7
# tEk/Su0BhbAJlyjwiXYCeu7JUAx6Do+yOjEgd/oX9WaQaqRaAKTdrjfgcTJ6UsPd
# 99HLztZ7npQHyMasEv1jy5O7XODu3lkEs/0tdqHhu2p05Gnz2XuOySNbJ3z83JRR
# eThs5zDKSuAor4RbUKppIzc3unKDcmVcilc90HhwgALsz07xXjUxFIB4qOwgxatk
# FQvDYDa5acDwHhtyJ2No
# SIG # End signature block
