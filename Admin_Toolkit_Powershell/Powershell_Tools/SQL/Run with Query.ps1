Function Script-Jobs { 
    Param(
    [string]$server
    , [string]$smolibrary
    , [string]$name
    , [string]$path
    )
    Process
    {
        $nl = [Environment]::NewLine
        Add-Type -Path $smolibrary
        $jobserver = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

        foreach ($job in $jobserver.JobServer.Jobs | Where-Object {$_.Name -like "$name*"})
        {
            $newfile = $path + $job.Name + ".sql"
            New-Item $newfile -ItemType file | Out-Null
            "USE msdb" + $nl + "GO" + $nl + $nl + $job.Script() | Out-file $newfile
        }
    }
}

###  Note that the SMO library may be in a different directory, depending on your version of SQL Server
$smo = "C:\Program Files (x86)\Microsoft SQL Server\120\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"

Script-Jobs -server "utqa-sql-14" -smolibrary $smo -name "Report: FindMulti" -path "C:\OurFolder\"