$ComputerName =  Get-Content "C:\Downloads\S.txt"


$Key = "SOFTWARE\Microsoft\NET Framework Setup\NDP"

ForEach ($Computer in $ComputerName)
{
    $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("LocalMachine",$Computer) 
    $RegKey = $Reg.OpenSubKey($Key,$true)
    $SubKeys = $RegKey.GetSubKeyNames() | Where { $_ -match '^(?!S)\p{L}' }
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
                        "378389" { [Version]"4.5" }
                        "378675|378758" { [Version]"4.5.1" }
                        "379893" { [Version]"4.5.2" }
                        "393295|393297" { [Version]"4.6" }
                        "394254|394271" { [Version]"4.6.1" }
                        "394802|394806" { [Version]"4.6.2" }
                        "460798" { [Version]"4.7" }
                        "461308" { [Version]"4.7.1" }
                        "461808" { [Version]"4.7.2" }
                        "528040" { [Version]"4.8" }
                        {$_ -gt 528040} { [Version]"Undocumented 4.6.2 or higher, please update script" }
                    }
                }
            }
        }
        Else
        {
            [PSCustomObject]@{
                ComputerName = $Computer
                Client = $null
                Version = $SubKey
                Release = $null
                Product = $null
            }
        }
    }
}