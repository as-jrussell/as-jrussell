Function Copy-myFiles ( [string] $sourcePath,  [string] $TargetPath , [string] $TargetHost, [string] $filter, [bool] $DryRun )
{
    #IF($total -eq 0 -AND ($f_dryRun -eq 1 -OR $Verbose) )
    #    {
    #        Write-Host `t"Source Location: $f_targetDB\$f_folder"
    #        Write-Host `t"Files to process: $total"
    #        Write-Host `t"[WARNING] Nothing to Process"
    #        Write-Host " "
    #        $WarningMessage = "[WARNING] Nothing to Process in: $f_sqlSourcePath"
    #        #[void]$ResultsTable.Rows.Add("2", $WarningMessage)
    #        [void]$ResultsTable.Rows.Add("2", $f_targetHost, $f_targetDB, $WarningMessage)
    #    }
    #ELSE
    #    {
    #        IF($total -ne 0 -or $verbose )
    #        {
    #            Write-Host `t"Source Location: $f_sqlSourcePath"
    #            Write-Host `t"Files to process: $total"
    #        }
    #    }
    ## Alter targetPath for UNC if required
    if( $TargetHost -like ".\*" ){
        write-verbose `t" ] No changes to local path"
    }
    else{
        write-verbose `t" ] Change path to UNC"
        $targetPath = "\\"+ $TargetHost.substring(0,$TargetHost.IndexOf('\')) +"\"+ $TargetPath.REPLACE(":","$") 
    }

    ## Does source path exist
    Write-Host " ] Test Source Path: $($sourcePath)"
    Write-Host `t"Test-Path -Path $sourcePath -IsValid"
    IF ( Test-Path -Path $sourcePath -IsValid ){
        get-childitem -recurse -path $sourcePath -filter $filter -exclude *.tmp | % {
            $file = $_
            $total ++
        }

        Write-verbose `t"Source path exists - Files $($total)"
        ## Does target path exist
        Write-Host " ] Test Target Path: $($targetPath)"
        Write-Host `t"Test-Path -Path $targetPath -IsValid"
        IF ( Test-Path -Path $targetPath -IsValid ){
            Write-verbose `t"Target path exists"
        }
        else{
            Write-Host "[WARNING] Creating target Path"
            #confirm it happened...
        }
        $copyCMD = "robocopy $sourcePath $targetPath /MIR /ETA"
        ## move files
        If( $DryRun ){
            Write-Host " ] Copying $($total) files"
            Write-Host `t"[DryRun] $($copyCMD)"
        }
        else{
            Write-Host `t"$($copyCMD)"
            invoke-expression $copyCMD
        }

        ## confirm files exist  ?  Should....

    }

    else{
        Write-Host "[ALERT] Source does not exist"
    }
}

## what is public
Export-ModuleMember -Function Copy-myFiles

#Function Process-PassINIT ( [string] $sourcePath,  [string] $TargetPath , [string] $TargetHost, [string] $filter, [bool] $DryRun )
#{
#    ## SET all rows Enabled = 0 during deploy


#    ## $sourcePath Expected as c:\Github\pass-adminsupport\init
#    $sourcePath = $sourcePath +'\Scripts\'
#    ## $filter expected .sql

#    ## Take scripts\implemetation load it into variable

#    ## take scripts\backout

#    ## take scripts\Sanity

#    ## Perform Merge
#}

### what is public
#Export-ModuleMember -Function Process-PassINIT