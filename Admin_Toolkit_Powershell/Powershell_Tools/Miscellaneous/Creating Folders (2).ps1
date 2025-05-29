
    $service_names = Get-Content "\\usd-rd02\c$\Powershell Scripts\PowerShell\Deployment Jobs\UTL\TestHarness.txt"
Foreach ($Scoring in $service_names)
{

    New-Item -Path "\\utqa2-app3\E$\Configs\$scoring\" -ItemType Directory

    }