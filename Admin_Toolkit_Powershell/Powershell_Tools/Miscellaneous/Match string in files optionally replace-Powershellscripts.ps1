



#find matchString in the files from a specified filePath. optionally, if it exists, replace it with the newString value.




  $filePath = "\\CP-WEBSVCQA-03\E`$\inetpub\"
  
   # set doReplace to yes if intended, set to anything else if just want to search with no changes
  $doReplace = 'no'


   # everything within the single quotes is literal (regex).   Whatever is matched will be replaced by the newString (if set to yes)
   # all regex operators are available but test your action somewhere harmless before getting too fancy
  $matchString =    '*IVOS*'

  


   # only used if doReplace is set to yes
  $newString =  '*E:\logs\*'



   # this uses the filenamePattern to match / limit the search by file names. It has nothing to do with the content of the files. You can get as specific as 
   # an actual filename or it does use wildcards (asterisks) if desired
  $filenamePattern = "web.config"
  



  $files = get-childitem $filePath  -File -Recurse -Filter $filenamePattern  | select-Object FullName, Name
   

  foreach ($file in $files)   {

   $FileContent = Get-Content -path $file.FullName

   if ( $FileContent | Select-String -pattern $matchString  ){
     write-host ("`n"+$file.FullName)
      # get each line in the file that has the matching string
     $lineMatch = $FileContent | Select-String -pattern $matchString  -AllMatches


      #comment out the write-host if you only want to see the filenames that contain the pattern and not the actual lines within the files
     write-host ("matched lines in the file containing the pattern: `n" +$lineMatch )
    

      #replace the matched line if doReplace is yes
     if ( $doReplace -eq "yes"){
         #the matching string will be replaced with the new string anywhere it exists in the file
        $FileContent | ForEach-Object { $_ -replace $matchString, "$newString"  } | Set-Content $file.FullName 
        write-host ("`nmatched strings replaced")
        }
        
     }
 
 

  } #end foreach file


  