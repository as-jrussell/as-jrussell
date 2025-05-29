
# Original text
$FileName1 = “\\as.local\shared\InfoTech\UniTrac_Master_Configs\Prod"
$servers = Get-Content "C:\temp\files.txt"
$FileName4 =  "OspreyWorkflowService.exe.config2"
$FileName5 =  "OspreyWorkflowService.exe.config"

Foreach ($FileName2 in $servers){

$inputFile1 =  "$FileName1\$FileName2\$FileName3"
# Text to be inserted
$inputFile2 = "
        <add key = ""RPAService.ProcessTool"" value = ""RPA"" />
            <add key = ""RPAService.Vehicle"" value = ""http://rpaservices-test.alliedsolutions.net/RPAInbound/RPAInbound.svc/VehicleVOW"" />
      <add key = ""RPAService.Mortgage"" value = ""http://rpaservices-test.alliedsolutions.net/RPAInbound/RPAInbound.svc/MortgageVOW"" />"
# Output file
$outputFile = "$FileName1\$FileName2\$FileName4"
# Find where the last </location> tag is
if ((Select-String -Pattern "<add key=""BaseUTLAPIURL"" value=""http://unitrac-utlapi-prod.alliedsolutions.net/UTL-Service/"" />"  -Path $inputFile1 |
    select -last 1) -match ":(\d+):")
{
    $insertPoint = $Matches[1]
    # Build up the output from the various parts
    Get-Content -Path $inputFile1 | select -First $insertPoint | Out-File $outputFile
    $inputFile2 | Out-File $outputFile -Append
    Get-Content -Path $inputFile1 | select -Skip $insertPoint | Out-File $outputFile -Append
}


Remove-Item "$FileName1\$FileName2\$FileName5"


Rename-Item -path "$FileName1\$FileName2\$FileName4" "$FileName1\$FileName2\$FileName5" -Force}