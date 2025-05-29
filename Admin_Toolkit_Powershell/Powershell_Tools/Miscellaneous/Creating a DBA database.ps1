<# 

cd ..
cd .\DBA\PowerShell\DBA_Tools\DBA_Tools
#>

#.\deployDB.ps1 -targetDB "DBA"  -targetHost "PROPHIX-DB-01" -repoFolder "AUTO" -configure 1  -dryRun 0 -notify 0 -force 1 -verbose


#set-location C:\GitHub\DBA-PowerShell\DBA-Tools\DBA_Tools

.\deployDB.ps1 -targetDB DBA -cmsgroup ADMIN -targetHost SQLSPRDAWEC09.colo.as.local -configure 1 -dryRun 0 -notify 1 -force 1

#Set-DbaAgentJobOwner -SqlInstance pingfed-db-01 -ExcludeJob syspolicy_purge_history -Login SA


