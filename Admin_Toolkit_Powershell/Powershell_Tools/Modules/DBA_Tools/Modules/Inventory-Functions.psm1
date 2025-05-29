function Merge-HarvestInfo( [Object[]]$f_HarvestInfo ){
    $execMerge="EXEC info.HarvestHistoryMerge 
            @HarvestID = $(if($f_HarvestInfo.HarvestID -eq $null){ 'null' }ELSE{$f_HarvestInfo.HarvestID}),
            @TargetCMS ='$($f_HarvestInfo.TargetCMS)', 
            @CMSGroup ='$($f_HarvestInfo.CMSGroup)', 
            @TargetInvServer ='$($f_HarvestInfo.TargetInvServer)',
            @TargetInvDB ='$($f_HarvestInfo.TargetInvDB)', 
            @ProcessInfo = '$($f_HarvestInfo.ProcessInfo)', 
            @DryRun = '$($f_HarvestInfo.DryRun)', 
            --@Comments,
            @StartDateTime = '$($f_HarvestInfo.StartDateTime)', 
            @EndDateTime = $(if($f_HarvestInfo.HarvestID -eq $null){ 'null' }ELSE{$("'"+ $f_HarvestInfo.EndDateTime +"'")}), 
            @StartedBy ='$($env:USERNAME)'; "

    TRY{
        Write-Verbose "
        $($execMerge)"
        Invoke-Sqlcmd -ServerInstance $f_HarvestInfo.TargetInvServer -Database $f_HarvestInfo.TargetInvDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    Catch{
        Write-Host "[ALERT] FAILED TO MERGE HARVEST!!!!!" -ForegroundColor Red 
        $failedOBJ = [ordered]@{
            Host = $($f_HarvestInfo.TargetInvServer)
            Function = "Merge-HarvestInfo"
            Command = "Merge-HarvestInfo `$HarvestInfo $($f_HarvestInfo.DryRun)"
            Message = 'NA'
        }
        record-Failure $f_HarvestInfo $failedOBJ $f_HarvestInfo.DryRun
    }
}
Export-ModuleMember -Function Merge-HarvestInfo

# WARNING THIS FUNCTION DOES NOT MATCH THAT INT HE HARVEST SCRIPT
function merge-InstInfo( [Object[]]$InstanceInfo, [Object[]]$ProcessInfo ){
    $execMerge="EXEC inv.InstanceMerge @SQLServerName ='$($InstanceInfo.SQLServerName)', 
                @MachineName ='$($InstanceInfo.MachineName)', 
                @InstanceName ='$($InstanceInfo.InstanceName)',
                @DomainName ='$($InstanceInfo.DomainName)', 
                @local_net_address = '$($InstanceInfo.local_net_address)', 
                @Port = $($InstanceInfo.Port), 
                @DACPort = $($InstanceInfo.DACPort), 
                @ProductName = '$($InstanceInfo.ProductName)', 
                @ProductVersion = '$($f_currentInfo.ProductVersion)', 
                @ProductLevel = '$($InstanceInfo.ProductLevel)', 
                @ProductUpdateLevel = '$($InstanceInfo.ProductUpdateLevel)',
                @Edition = '$($InstanceInfo.Edition)', 
                @EngineEdition = '$($InstanceInfo.EngineEdition)', 
                @min_size_server_memory_mb = '$($InstanceInfo.min_size_server_memory_mb)', 
                @max_size_server_memory_mb = '$($InstanceInfo.max_size_server_memory_mb)', 
                @CTFP = $($InstanceInfo.CTFP), 
                @MDOP = $($InstanceInfo.MDOP),
                @IsAdHocEnabled = $($($InstanceInfo.IsAdHocEnabled)),
                @IsDBMailEnabled = $($($InstanceInfo.IsDBMailEnabled)),
                @IsAgentXPsEnabled = $($($InstanceInfo.IsAgentXPsEnabled)),
                @IsHadrEnabled = $($InstanceInfo.IsHadrEnabled),
                @HadrManagerStatus = '$($InstanceInfo.HadrManagerStatus)',
                @InSingleUser = $($InstanceInfo.InSingleUser),
                @IsClustered = $($InstanceInfo.IsClustered),
                @ServerEnvironment = '$($InstanceInfo.ServerEnvironment)',
                @ServerStatus = '$(if($InstanceInfo.Description -like 'DCOM*'){'DECOMMED'}ELSE{'UP'})',
                @HarvestDate = '$(Get-Date)',
                --@Comments = '$($InstanceInfo.Description)',
                --@CREATE_DT,
                --@UPDATE_DT,
                @UPDATE_USER ='$($env:USERNAME)';"

    If( $ProcessInfo.DryRun ) {
        Write-Host "[DryRun] - Not Performing MERGE
        $($execMerge)"
    }
    ELSE{
        TRY{
            Write-verbose "
            $($execMerge)"
            Invoke-Sqlcmd -ServerInstance $ProcessInfo.TargetInvServer -Database $ProcessInfo.TargetInvDB -Query $execMerge -QueryTimeout 65535 -ErrorAction 'Stop' 
        }
        CATCH{
            Write-Host `t"[ALERT] FAILED TO MERGE $($InstanceInfo.SQLServerName)" -ForegroundColor Red 
            Write-Host `t"$($execMerge)"
            ### record information or raise alert?
            Write-Host `t"error: $_" -ForegroundColor Red 

            $failedOBJ = [ordered]@{
                Host = $($InstanceInfo.SQLServerName)
                Function = "merge-InstInfo"
                Command = "$($selectSQL)"
                Message = $($_)
            }
            record-Failure $ProcessInfo $failedOBJ $ProcessInfo.DryRun
        }
    }

    ### Does not pass Harvest Info as object becuase it is in a shared module...
    # get-InstanceID $ProcessInfo.TargetInvServer $ProcessInfo.TargetInvDB $($InstanceInfo.SQLServerName) $ProcessInfo.DryRun
}
Export-ModuleMember -Function merge-InstInfo


