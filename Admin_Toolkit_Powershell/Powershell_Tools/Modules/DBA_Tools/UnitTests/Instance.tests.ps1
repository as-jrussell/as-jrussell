$project = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace("Tests\", "")
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".tests.", ".")
#. "$project\$sut"

# alter project path to remove "\Tools\" so we can append "\Modules\"
$project = $project.substring(0,$project.Length - ('\UnitTests\'.Length -1))
# always use '-Force' to load the latest version of the module
Import-Module "$($project)\Modules\Instance-Functions.psm1" -Force

# Define Read only / Constant variables
."$($project)\TestData\Default.data.ps1"

Describe "confirm-online" {
    Context "confirm-InstanceUP" {  
        # arrange
        [string] $status = 'Running'

        # act
        $results = get-SQLServiceStatus $goodTarget.Instance $goodTarget.Services #-verbose
        ForEach( $result in $results ){
            Write-Host `t"Results: $($result.Name) $($result.Status)"
        }

        # assert
        Write-Host `t"Should find $($goodTarget.Services.count) services"
        It "Should find the services "{ $results.DisplayName.count | Should be $goodTarget.Services.count}
        Write-Host `t"Should find $($goodTarget.Services.count) services $status"
        It "Should find the services Running" { ($results | WHERE {$_.status -eq "Running" } | measure-object ).Count | Should Be $goodTarget.Services.count }
    }
}

    ########## offline tests
Describe "confirm-offline" {
    Context "confirm-InstanceDown" {  
        # arrange
        [string] $instance = '.\MSSQLSERVER'
        [string] $status = 'STOPPED'

        # act
        $results = get-SQLServiceStatus $instance $badTarget.Services #-verbose
        ForEach( $result in $results ){
            Write-Host `t"Results: $($result.Name) $($result.Status)"
        }

        # assert
        Write-Host `t"Should find $($goodTarget.Services.count) services"
        It "Should find the services "{ $results.DisplayName.count | Should be $goodTarget.Services.count}
        Write-Host `t"Should find $($goodTarget.Services.count) services $status"
        It "Should find the services STOPPED" { ($results | WHERE {$_.status -eq "STOPPED" } | measure-object ).Count | Should Be $goodTarget.Services.count }
    }
}