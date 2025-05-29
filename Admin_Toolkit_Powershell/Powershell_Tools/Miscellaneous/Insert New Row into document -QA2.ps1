
$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessService\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />" 
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServiceDist\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServiceDist\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServiceLetterGen\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServiceProc1\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServiceProc2\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified








$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServiceProc3\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServicePRT\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UnitracBusinessServiceRPT\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTLBusinessService\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified







$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTLMatch\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\UTLReMatch\*.config”
$Pattern = "<add key=""Process.Password"" value=""OOo2uY6cqEVRVagK2TRCCg=="" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
         $FileModified +=       "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"
        
    } 
}
Set-Content $fileName $FileModified




Select-String -Path '\\as.local\shared\InfoTech\UniTrac_Master_Configs\Test\QA2\*\*.config' -Pattern "BaseUTLAPIURL"