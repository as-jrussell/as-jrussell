$ComputerName = Get-Content "C:\Downloads\S.txt"


$Key = "SOFTWARE\Microsoft\NET Framework Setup\NDP"

ForEach ($Computer in $ComputerName)
{
    $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("LocalMachine",$Computer) 
    $RegKey = $Reg.OpenSubKey($Key,$true)
    $SubKeys = $RegKey.GetSubKeyNames() | Where { $_ -match '^(?!S)\p{L}' } |Where { $_  -notmatch 'CDF'}|Where { $_  -notmatch 'v2.0.50727'}|Where { $_  -notmatch 'v3.0'}|Where { $_  -notmatch 'v3.5'}|Where { $_  -notmatch 'v4.0'}
    ForEach ($SubKey in $SubKeys)
    {
        
        $RegSubKey = $RegKey.OpenSubKey($SubKey)
        $SubKeys2 = $RegSubKey.GetSubKeyNames() | Where { $_ -match "client|full" } 
        If ($SubKeys2.Count -gt 0)
        {
            ForEach ($SubKey2 in $SubKeys2)
            {
                $RegSubKey2 = $RegSubKey.OpenSubKey($SubKey2) 
                $Release = $RegSubKey2.GetValue("Release") 
                [PSCustomObject]@{
                    ComputerName = $Computer
                    Client = $SubKey2
                    Version = $RegSubKey2.GetValue("Version")
                    Release = $Release
                    Product = Switch -regex ($Release) {
                        "528040" { [Version]"4.8" } 
                    }
               }
            }
        }
        Else
        {
          "Lower than 4.0.0.0"
            }
        }
    }
