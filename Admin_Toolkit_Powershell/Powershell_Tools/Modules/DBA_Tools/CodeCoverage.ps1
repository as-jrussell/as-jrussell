#
# Script1.ps1
#
#$project = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace(".Tests", "")
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".tests.", ".")
##. "$project\$sut"
#$modules = $project + "\Modules\*.psm1"

#$modules

#forEach ($mod in $mods){write-output "import $($mod.name)"}
##Import-Module $modules

## https://devblogs.microsoft.com/powershell/code-coverage-now-available-for-powershell-core/
# create a code coverage build.
PS> Start-PSBuild -Configuration CodeCoverage -Publish

# Now that you have a build, save away the build location
PS> $psdir = split-path -parent (get-psoutput)

PS> Import-module $pwd/test/tools/OpenCover

# install the opencover package
PS> Install-OpenCover $env:TEMP

# now invoke a coverage test run
PS> Invoke-OpenCover -OutputLog Coverage.xml -test $PWD/test/powershell -OpenCoverPath $env:Temp/OpenCover -PowerShellExeDirectory $psdir

# first collect the coverage data with the Get-CodeCoverage cmdlet
PS> $coverData = Get-CodeCoverage .\Coverage.xml
# here’s the coverage summary
PS> $coverData.CoverageSummary
NumSequencePoints       : 309755
VisitedSequencePoints   : 123779
NumBranchPoints         : 105816
VisitedBranchPoints     : 39842
SequenceCoverage        : 39.96
BranchCoverage          : 37.65
MaxCyclomaticComplexity : 398
MinCyclomaticComplexity : 1
VisitedClasses          : 2005
NumClasses              : 3309
VisitedMethods          : 14912
NumMethods              : 33910

# you can look at coverage data based on the assembly
PS> $coverData.Assembly | ft AssemblyName, Branch, Sequence

AssemblyName                                     Branch Sequence
------------                                     ------ --------
powershell                                       100    100
Microsoft.PowerShell.CoreCLR.AssemblyLoadContext 45.12  94.75
Microsoft.PowerShell.ConsoleHost                 22.78  23.21
System.Management.Automation                     41.18  42.96
Microsoft.PowerShell.CoreCLR.Eventing            23.33  28.57
Microsoft.PowerShell.Security                    12.62  14.43
Microsoft.PowerShell.Commands.Management         14.69  16.76
Microsoft.PowerShell.Commands.Utility            52.72  54.40
Microsoft.WSMan.Management                       0.36   0.65
Microsoft.WSMan.Runtime                          100    100
Microsoft.PowerShell.Commands.Diagnostics        42.99  46.62
Microsoft.PowerShell.LocalAccounts               0      0
Microsoft.PowerShell.PSReadLine                  6.98   9.86