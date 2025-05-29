sqlcmd -S Unitrac-DB01 -U solarwinds_sql -P S0l@rw1nds -i "\\slrwinds.as.local\e$\ExternalActions\AutoTrakk\AutoTrakk.sql"  -o \\slrwinds.as.local\e$\ExternalActions\AutoTrakk\Logs\AutoTrakk.txt 
if(Test-Path "\\slrwinds.as.local\e$\ExternalActions\AutoTrakk\Logs\AutoTrakk.txt"){
$destination = "\\slrwinds.as.local\e$\ExternalActions\AutoTrakk\Logs\AutoTrakk"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path "\\slrwinds.as.local\e$\ExternalActions\AutoTrakk\Logs\AutoTrakk.txt" -Destination $destination
}


Remove-Item -Path "\\slrwinds.as.local\e$\ExternalActions\AutoTrakk\Logs\AutoTrakk.txt"




