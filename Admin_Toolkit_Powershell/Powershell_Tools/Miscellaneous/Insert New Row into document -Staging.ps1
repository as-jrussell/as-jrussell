
$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\*.config”
$Pattern = "<add key=""UTLRematchApi"" value=""http://unitrac-utlapi-qa.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "        <add key = ""RPAService.ProcessTool"" value = ""RPA"" />
            <add key = ""RPAService.Vehicle"" value = ""http://rpaservices-test.alliedsolutions.net/RPAInbound/RPAInbound.svc/VehicleVOW"" />
      <add key = ""RPAService.Mortgage"" value = ""http://rpaservices-test.alliedsolutions.net/RPAInbound/RPAInbound.svc/MortgageVOW"" />"
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UTL-OCR\*.config”
$Pattern = "<add key=""AutoLoginPassword"" value=""qGupeajHm68mXlLG27RPBoQoandR0D4n"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UTL-Service\*.config”
$Pattern = "<add key=""AutoLoginPassword"" value=""qGupeajHm68mXlLG27RPBoQoandR0D4n"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessService\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified


$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceBackfeed\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceCycle\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceDist\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceGoodThru\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceProc1\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceProc2\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceProc3\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServiceRPT\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UnitracBusinessServicePRT\*.config”
$Pattern = "    <add key=""UTLRematchApi"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL/GetUTLMatchResults/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UTLMatch\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UTL-ReMatch\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\UTLBusinessService\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "    <add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-staging.alliedsolutions.net/UTL-Service/"" />"
    } 
}
Set-Content $fileName $FileModified



#Select-String -Path '\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\STAGE\*\*.config' -Pattern "BaseUTLAPIURL"