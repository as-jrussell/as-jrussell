## To be commented out when in ZARGA 
## NORMAL RUN
#deploy-githubFile 'https://github.exacttarget.com/api/v3' 'dbauto' 'UtilityDB' 'StandardJobs' 'StandardJobScript_UltimateEdition.sql' 'master' 'ATL1Q51CB016I02#I02' 'hbrotherton' 'cbaa10d037e8ea421dc2a62f2f7f4cbbe24d0d3b' 0

function Get-BasicAuthCreds {
    param([string]$Username,[string]$Password)
    $AuthString = "{0}:{1}" -f $Username,$Password
    $AuthBytes  = [System.Text.Encoding]::Ascii.GetBytes($AuthString)
    return [Convert]::ToBase64String($AuthBytes)
}

function Get-GitHubFile{
    param(  [string] $GHRoot = "https://github.com/api/v3", # do not change
            [string] $Org = "DBA", # do not change
            [string] $searchRepo = 'DBA',
            [string] $searchFolder = 'StandardJobs',
            [string] $searchFile = 'StandardJobScript.sql',
            [string] $searchBranch ='', ## If null will go to master
            [string] $targetInstance = '',
            [string] $user, [string] $token,
            [boolean] $debug = 1
        )

    $BasicCreds = Get-BasicAuthCreds -Username $user -Password $token
    $targetInstance = $targetInstance -replace '#',".$env:USERDNSDOMAIN\"
   
    IF( $searchRepo -eq '' )
        {
            $RawRepos = Invoke-RestMethod -Uri "$GHRoot/orgs/$Org/repos" -Headers @{"Authorization"="Basic $BasicCreds"}
        }
    ELSE
        {
            $rawRepos = Invoke-RestMethod -Uri "$GHRoot/orgs/$Org/repos" -Headers @{"Authorization"="Basic $BasicCreds"} | %{($_ | ?{$_.name -eq "$searchRepo"})}
        }

    IF( $debug -eq 1 )
        {
            #cls
            WRITE-HOST "[DryRun] GHroot: $GHRoot "
            WRITE-HOST "[DryRun] GHorg: $Org  "
            WRITE-HOST "[DryRun] GHrepo: $searchRepo "
            WRITE-HOST "[DryRun] GHpath:$searchFolder"
            WRITE-HOST "[DryRun] GHfolder: $searchFile "
            WRITE-HOST "[DryRun] GHrepo: $searchBranch "
            WRITE-HOST "[DryRun] targetInstance: $targetInstance "
            WRITE-HOST "[DryRun] User: $user "
            WRITE-HOST "[DryRun] Token: $token "
            WRITE-HOST "[DryRun] DryRun: $dryRun "
            WRITE-HOST "[DryRun] Verbose: $verbose "

            WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $targetInstance -Database UTILITY -DisableVariables -ErrorAction Stop -Query <SOMETHING>"
        }

    foreach ($RawRepo in $RawRepos) ## left it like this incase we allow array input later.  Seems like a bad idea though......
        {
            IF( $searchBranch -eq '' ) #pull from master
                {
                    $rawFile = Invoke-RestMethod -Uri "$GHRoot/repos/$Org/$searchRepo/contents/$searchFolder/$searchFile" -Headers @{"Authorization"="Basic $BasicCreds"}
                }
            ELSE
                {
                    $rawFile = Invoke-RestMethod -Uri "$GHRoot/repos/$Org/$searchRepo/contents/$searchFolder/$searchFile`?ref=$searchBranch" -Headers @{"Authorization"="Basic $BasicCreds"}
                }
    
    
            $cleanFile = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RawFile.Content))
            #$cleanFile
            WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $targetInstance -Database UTILITY -DisableVariables -ErrorAction Stop -Query $cleanFile"
            IF( $debug -eq 0 )
                {                       
                       # Invoke-Sqlcmd -ServerInstance $targetInstance -Database UTILITY -DisableVariables -ErrorAction Stop -Query  
                }
        }

}

