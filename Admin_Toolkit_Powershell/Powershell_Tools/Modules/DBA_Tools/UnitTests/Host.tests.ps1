$project = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace("Tests\", "")

# alter project path to remove "\Tools\" so we can append "\Modules\"
$project = $project.substring(0,$project.Length - ('\UnitTests\'.Length -1))
# always use '-Force' to load the latest version of the module
Import-Module "$($project)\Modules\Host-Functions.psm1" -Force

# Define Read only / Constant variables
."$($project)\TestData\Default.data.ps1"

Describe "ping-Host" {
    Context "ping-good" {  
        # arrange

        # act
        $results = ping-host $($goodTarget.Host) #-verbose
        Write-Host `t"Results: $($results)"

        # assert
        It "Should find host " { $results | Should Be True }
        #It "$host unreachable " { $results | Should Be 0 }
    }

    Context "ping-bad" { 
        # arrange

        # act
        $results = ping-host $badTarget.Host #-verbose
        Write-Host `t"Results: $($results)"

        # assert
        #It "Should find host " { $results.count | Should Be 1 }
        It "Should not find host " { $results | Should Be False }
    }
}

Describe "find-mounts" {
    Context "mounts-return2" {  
        # arrange

        # act
        $results = Get-RemoteMountPoints $goodTarget.Host #-verbose
        $driveCount = 0
        ForEach($result in $results){
            If( $result.Label -eq "Data" -OR  $result.Label -eq "LogS" ){
                Write-Host `t"Results: $($result.DriveLetter) $($result.Label) $($result.'Free(%)') %FREE"
                $driveCount++
            }
        }

        $dataIndex = $results.Label.ToUpper().IndexOf( "DATA" )
        $logsIndex = $results.Label.ToUpper().IndexOf( "LOGS" )

        # assert
        It "Should find 2 mounts " { $driveCount | Should Be 2 }
        It "Should find Data" { $results.Label[$dataIndex] | Should Be "DATA" }
        It "Should find Logs" { $results.Label[$logsIndex] | Should Be "LOGS" }
    }
}

 Describe "Get-Reboot" {
    Context "reboot-return" {  
        # arrange

        # act
        $results = Get-HostLastReboot $goodTarget.Host #-verbose
        # $driveCount = 0
        ForEach($result in $results){
            Write-Host `t"Results: $($result.PSComputerName) $($result.User) $($result.Time)"
        }
        #$results | Format-Table -AutoSize
        #$dataIndex = $results.Label.ToUpper().IndexOf( "DATA" )
        #$logsIndex = $results.Label.ToUpper().IndexOf( "LOGS" )

        # assert
        It "Should find 2 mounts " { $driveCount | Should Be 2 }
        It "Should find Data" { $results.Label[$dataIndex] | Should Be "DATA" }
        It "Should find Logs" { $results.Label[$logsIndex] | Should Be "LOGS" }
    }
}