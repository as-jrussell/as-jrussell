
$FileName = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessServiceMatchOut\*.config”
$Pattern = "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"  
$FileOriginal = Get-Content $FileName

[String[]] $FileModified = @() 
Foreach ($Line in $FileOriginal)
{   
    $FileModified += $Line
    if ($Line -match $pattern) 
    {
        #Add Lines after the selected pattern 
        $FileModified += "<add key = ""RPAService.ProcessTool"" value = ""RPA"" />
<add key = ""RPAService.WriteUrl"" value = ""http://rpaservices.alliedsolutions.net/RPAInboundTest/RPAInbound.svc/Write"" />"  
        
    } 
}
Set-Content $fileName $FileModified






Select-String -Path '\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod\UnitracBusinessService*\*.config' -Pattern "RPAService.WriteUrl"