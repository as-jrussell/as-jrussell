$project = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace("Tests\", "")

# alter project path to remove "\Tools\" so we can append "\Modules\"
$project = $project.substring(0,$project.Length - ('\UnitTests\'.Length -1))
# always use '-Force' to load the latest version of the module
Import-Module "$($project)\Modules\Database-Functions.psm1" -Force

# Define Read only / Constant variables
."$($project)\TestData\Default.data.ps1"

Describe "find-database" {
    Context "find-good" {  
        # arrange

        # act
        $results = find-database $($goodTarget.Database) $($goodTarget.Instance) #-verbose
        Write-Host `t"Results: $($results)"

        # assert
        It "Should find db " { $results | Should Be True }
        #It "Should not find db " { $results | Should Be 0 }
    }

    Context "find-bad" { 
        # arrange

        # act
        $results = find-database  $($badTarget.Database) $($goodTarget.Instance) #-verbose
        Write-Host `t"Results: $($results)"

        # assert
        #It "Should find db " { $results.count | Should Be 1 }
        It "Should not find db " { $results | Should Be False }
    }

    Context "find-local" {  
        # arrange

        # act
        $results = find-database $($localTarget.Database) $($localTarget.Instance) #-verbose
        Write-Host `t"Results: $($results)"

        # assert
        It "Should find db " { $results | Should Be True }
        #It "Should not find db " { $results | Should Be 0 }
    }
}

Describe "get-DBstate" {
    Context "confirm-online" {  
        # arrange
        $status = "online"

        # act
        $results = get-DBstate $($goodTarget.Database) $($goodTarget.Instance) #-verbose
        ForEach( $result in $results ){
            Write-Host `t"Results: $($result.Name) $($result.Status) $($result.ServerType)"
        }

        # assert
        Write-Host `t"Should find $($goodTarget.Database.count) database"
        It "Should find DB " { $results.Name.count | Should be $goodTarget.Database.count }
        Write-Host `t"Should find database $status"
        It "Should find DB online "  { ($results | WHERE {$_.status -eq "Online" } | measure-object ).Count | Should Be $goodTarget.Database.count }
    }

}