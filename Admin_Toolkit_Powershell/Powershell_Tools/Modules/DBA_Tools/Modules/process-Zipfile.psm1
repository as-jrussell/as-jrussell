## This is just a place holder of an old function in a previous script....
function process-Zipfile ( [string] $FileName, [string] $f_targetHost, [string] $f_targetDB , [string] $f_folder, [string] $f_repoVersion , [int] $f_dryRun ){
    IF( $f_folder -eq "COPY" )
        {
            $databaseFolder = $f_targetDB +"\*"
        }
    ELSE
        {
            $databaseFolder = $f_targetDB +"\"+ $f_folder +"*"
        }
#    IF(Test-Path $FileName) 
#        {
            $ObjArray = @() 
            $RawFiles = [IO.Compression.ZipFile]::OpenRead($FileName).Entries            
            #$RawFiles = [IO.Compression.ZipFile]::OpenRead($zipFile).Entries.contains("StoredProcedure")
            #$targetRawFiles = $rawFiles.FullName.contains("SQLmonitor\StoredProcedure\") 
            #$rawFiles | Format-Table -AutoSize
            #$FileName
            ForEach( $RawFile in $RawFiles )
            { 
                IF($rawFile.FullName -like "$databaseFolder" )
                    { 
                        $total++ #; Write-Host "HERE" 
                        $object = New-Object -TypeName PSObject            
                        $Object | Add-Member -MemberType NoteProperty -Name FileName -Value $RawFile.Name         
                        $Object | Add-Member -MemberType NoteProperty -Name FullPath -Value $RawFile.FullName            
                        #$Object | Add-Member -MemberType NoteProperty -Name CompressedLengthInKB -Value ($RawFile.CompressedLength/1KB).Tostring("00")            
                        #$Object | Add-Member -MemberType NoteProperty -Name UnCompressedLengthInKB -Value ($RawFile.Length/1KB).Tostring("00")            
                        #$Object | Add-Member -MemberType NoteProperty -Name FileExtn -Value ([System.IO.Path]::GetExtension($RawFile.FullName))            
                        $Object | Add-Member -MemberType NoteProperty -Name ZipFileName -Value $zipfile     
                        #$object | Add-Member -MemberType NoteProperty -Name scriptContent -Value        
                        $ObjArray += $Object  
                    }               
            }
#        }
#    ELSE
#        {
#            WRITE-WARNING "$FileName File path not found" 
#            EXIT
#        }

    IF($total -eq 0 -AND ($f_dryRun -eq 1 -OR $Verbose) )
        {
            Write-Host `t"Source Location: $f_targetDB\$f_folder"
            Write-Host `t"Files to process: $total"
            Write-Host `t"[WARNING] Nothing to Process"
            Write-Host " "
            $WarningMessage = "[WARNING] Nothing to Process in: $f_sqlSourcePath"
            #[void]$ResultsTable.Rows.Add("2", $WarningMessage)
            [void]$ResultsTable.Rows.Add("2", $f_targetHost, $f_targetDB, $WarningMessage)
        }
    ELSE
        {
            IF($total -ne 0 -or $verbose )
            {
                Write-Host `t"Source Location: $f_targetDB\$f_folder"
                Write-Host `t"Files to process: $total"
                #Write-Host " "
            }
            $failureCounter = 0

            $process = "Started"
            WHILE( $process -ne "Succesful" -AND $failureCounter -lt $total ) # AND attempts less than file count
            {
                $process = "Started"
                #Write-Host "[$process] Attempt "
                #$count++

                foreach($object in $objArray) 
                {            
                    $currentFile = $object.FileName
                    IF($f_dryRun -eq 1 -OR $Verbose){ Write-Host `t`t"File: $currentFile" }

                    #$fullPath = $object.ZipFileName +"\"+ $object.FullPath
                    #$fullPath = $object.FullPath
                    #Write-Host "Full Path: $fullPath "

                    $zip = [IO.Compression.ZipFile]::OpenRead($FileName)
                    $file = $zip.Entries | where-object { $_.Name -eq $currentFile }
                    #Write-Host "FILE: $file "

                    $stream = $file.Open()
                    $reader = New-Object IO.StreamReader($stream)
                    $text = $reader.ReadToEnd()
                    #$text

                    IF($f_dryRun -eq 0)
                        {
                            TRY
                                {
                                    WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $f_targetHost -Database $f_targetDB  -ErrorAction Stop -Query $text "
	                                Invoke-Sqlcmd -ServerInstance $f_targetHost -Database $f_targetDB  -ErrorAction Stop -Query "$text" 
                                    IF($process -ne "FAILED"){ $Process = "Succesful" }
                                }
                            CATCH
                                {
                                    $displayCounter = $failureCounter + 1
                                    Write-Host `t"[ALERT] !!! Something broke !!!  Attempt $displayCounter of $total "
                                    $process = "FAILED"
                                }
                        }
                    ELSE
                        {
                            WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $f_targetHost -Database $f_targetDB  -ErrorAction Stop -Query $text "
                            IF($process -ne "FAILED"){ $Process = "Succesful" }
                        }

                    $reader.Close()
                    $stream.Close()        
                 
                }   #forEach

                #$ObjArray | Format-Table -AutoSize 
                  
                Write-Host " "
                $failureCounter ++
            } #end WHILE

            If( $process -eq "FAILED" )
                {
                    Write-Host "[ALERT] Failure $failureCounter Total $total"
                    IF($failureCounter -eq $total ) { Write-Host($error) }
                    
                    $ExceptionMessage = "[FAILED] Invoke-Sqlcmd -ServerInstance $f_targetHost -Database $f_targetDB  -ErrorAction Stop -InputFile $f_sqlSourcePath\$currentFile "
                    [void]$ResultsTable.Rows.Add("3", $f_targetHost, $f_targetDB, $ExceptionMessage)
                }
            ELSEIF( $f_dryRun -eq 0 -AND $total -ne 0)
                {
                    Write-Host "[OK] Process was Successful "
                    $SuccessfulMessage = "[Success] Processed: $f_sqlSourcePath"
                    [void]$ResultsTable.Rows.Add("1", $f_targetHost, $f_targetDB, $SuccessfulMessage)
                    #Capture Relase info in systemConfig.

                    Write-Host "[] Recording Value"
                    $execSQL = "EXECUTE [dbo].[SetConfig] 'Release."+ $f_targetDB +"', '"+ $f_repoVersion +"'"

                    WRITE-VERBOSE `t"Invoke-Sqlcmd -ServerInstance $f_targetHost -Database UTILITY  -ErrorAction Stop -Query $execSQL"
                    Invoke-Sqlcmd -ServerInstance $f_targetHost -Database UTILITY  -ErrorAction Stop -Query $execSQL
                }
            $total = 0 
        }
}