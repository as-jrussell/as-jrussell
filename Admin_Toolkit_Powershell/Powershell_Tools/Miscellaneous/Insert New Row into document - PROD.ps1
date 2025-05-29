
$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessService\*.config”
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




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceBill\*.config”
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






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceCycle\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceCycle2\*.config”
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






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceCycle3\*.config”
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




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceCycle4\*.config”
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




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceCycleSANT\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceCycleSANT2\*.config”
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






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceDist\*.config”
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






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceFax\*.config”
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






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceFee\*.config”
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







$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceProc1\*.config”
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



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceProc2\*.config”
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



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceProc3\*.config”
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



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceProc4\*.config”
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



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceProc5\*.config”
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



$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceProc6\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceProc7\*.config”
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






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServicePRT\*.config”
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




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceRPT\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLMatch\*.config”
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






$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLMatch2\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLRematchAdhoc\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLRematchDefault\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLRematchDefaultSantander\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLRematchDefaultWellsFargo\*.config”
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




$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLRematchDefaultMidsizeLenders\*.config”
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





$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UTLRematchDefaultRepoPlus\*.config”
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


