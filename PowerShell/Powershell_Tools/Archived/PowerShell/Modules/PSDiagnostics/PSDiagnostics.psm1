<#
  Windows PowerShell Diagnostics Module
  This module contains a set of wrapper scripts that
  enable a user to use ETW tracing in Windows 
  PowerShell.
 #>

$script:Logman="$env:windir\system32\logman.exe"
$script:wsmanlogfile = "$env:windir\system32\wsmtraces.log"
$script:wsmprovfile = "$env:windir\system32\wsmtraceproviders.txt"
$script:wsmsession = "wsmlog"
$script:pssession = "PSTrace"
$script:psprovidername="Microsoft-Windows-PowerShell"
$script:wsmprovidername = "Microsoft-Windows-WinRM"
$script:oplog = "/Operational"
$script:analyticlog="/Analytic"
$script:debuglog="/Debug"
$script:wevtutil="$env:windir\system32\wevtutil.exe"
$script:slparam = "sl"
$script:glparam = "gl"

function Start-Trace
{
    Param(
    [Parameter(Mandatory=$true,
               Position=0)]               
    [string]
    $SessionName,    
    [Parameter(Position=1)]
    [string]
    $OutputFilePath,
    [Parameter(Position=2)]
    [string]
    $ProviderFilePath,
    [Parameter()]
    [Switch]
    $ETS,
    [Parameter()]
    [ValidateSet("bin", "bincirc", "csv", "tsv", "sql")]
    $Format,
    [Parameter()]
    [int]
    $MinBuffers=0,
    [Parameter()]
    [int]
    $MaxBuffers=256,
    [Parameter()]
    [int]
    $BufferSizeInKB = 0,    
    [Parameter()]
    [int]
    $MaxLogFileSizeInMB=0
    )
    
    Process
    {
        $executestring = " start $SessionName"
        
        if ($ETS)
        {
            $executestring += " -ets"
        }
        
        if ($OutputFilePath -ne $null)
        {
            $executestring += " -o $OutputFilePath"
        }
        
        if ($ProviderFilePath -ne $null)
        {
            $executestring += " -pf $ProviderFilePath"
        }
        
        if ($Format -ne $null)
        {
            $executestring += " -f $Format"
        }
        
        if ($MinBuffers -ne 0 -or $MaxBuffers -ne 256)
        {
            $executestring += " -nb $MinBuffers $MaxBuffers"
        }
        
        if ($BufferSizeInKB -ne 0)
        {
            $executestring += " -bs $BufferSizeInKB"
        }
        
        if ($MaxLogFileSizeInMB -ne 0)
        {
            $executestring += " -max $MaxLogFileSizeInMB"
        }
        
        & $script:Logman $executestring.Split(" ")
    }               
}

function Stop-Trace
{
    param(
    [Parameter(Mandatory=$true,               
               Position=0)]
    $SessionName,
    [Parameter()]
    [switch]
    $ETS
    )
    
    Process
    {
        if ($ETS)
        {
            & $script:Logman update $SessionName -ets
            & $script:Logman stop $SessionName -ets
        }
        else        
        {
            & $script:Logman update $SessionName
            & $script:Logman stop $SessionName 
        }
    }    
}

function Enable-WSManTrace
{
    
    # winrm
    "{04c6e16d-b99f-4a3a-9b3e-b8325bbc781e} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii
    
    # winrsmgr
	"{c0a36be8-a515-4cfa-b2b6-2676366efff7} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii -append

	# WinrsExe
	"{f1cab2c0-8beb-4fa2-90e1-8f17e0acdd5d} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii -append

	# WinrsCmd
	"{03992646-3dfe-4477-80e3-85936ace7abb} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii -append

	# IPMIPrv
	"{651d672b-e11f-41b7-add3-c2f6a4023672} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii -append
	
	#IpmiDrv
	"{D5C6A3E9-FA9C-434e-9653-165B4FC869E4} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii -append

    # WSManProvHost
    "{6e1b64d7-d3be-4651-90fb-3583af89d7f1} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii -append

    # Event Forwarding
    "{6FCDF39A-EF67-483D-A661-76D715C6B008} 0xffffffff 0xff" | out-file $script:wsmprovfile -encoding ascii -append

    Start-Trace -SessionName $script:wsmsession -ETS -OutputFilePath $script:wsmanlogfile -Format bincirc -MinBuffers 16 -MaxBuffers 256 -BufferSizeInKb 64 -MaxLogFileSizeInMB 256 -ProviderFilePath $script:wsmprovfile    
}

function Disable-WSManTrace
{
    Stop-Trace $script:wsmsession -ets
}

function Enable-PSWSManCombinedTrace
{
	param (
		[switch] $DoNotOverwriteExistingTrace
	)
	
    $provfile = [io.path]::GetTempFilename()
    
	$traceFileName = [string][Guid]::NewGuid()
	if ($DoNotOverwriteExistingTrace) {
		$fileName = [string][guid]::newguid()
		$logfile = $pshome + "\\Traces\\PSTrace_$fileName.etl" 
	} else {
		$logfile = $pshome + "\\Traces\\PSTrace.etl" 
	}
    
    "Microsoft-Windows-PowerShell 0 5" | out-file $provfile -encoding ascii
    "Microsoft-Windows-WinRM 0 5" | out-file $provfile -encoding ascii -append
    
    if (!(Test-Path $pshome\Traces))
    {
        mkdir -Force $pshome\Traces | out-null
    }
    
    if (Test-Path $logfile)
    {
        Remove-Item -Force $logfile | out-null
    }
    
    Start-Trace -SessionName $script:pssession -OutputFilePath $logfile -ProviderFilePath $provfile -ets 
	
	remove-item $provfile -Force -ea 0
}

function Disable-PSWSManCombinedTrace
{
    Stop-Trace -SessionName $script:pssession -ets
}

function Set-LogProperties
{
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [Microsoft.PowerShell.Diagnostics.LogDetails]
        $LogDetails,
		[switch] $Force
     )

    Process
    {
        if ($LogDetails.AutoBackup -and !$LogDetails.Retention)
        {
            throw (New-Object System.InvalidOperationException)
        }    
        
        $enabled = $LogDetails.Enabled.ToString()
        $retention = $LogDetails.Retention.ToString()
        $autobackup = $LogDetails.AutoBackup.ToString()
        $maxLogSize = $LogDetails.MaxLogSize.ToString()
	$buildNumber = Get-CimInstance Win32_OperatingSystem | select -ExpandProperty BuildNumber
        
        if (($LogDetails.Type -eq "Analytic") -or ($LogDetails.Type -eq "Debug"))
        {           
            if ($LogDetails.Enabled)
            {
		if($buildNumber -lt 7600)
		{
		     & $script:wevtutil $script:slparam $LogDetails.Name -e:$Enabled
		}
		else
		{
		     & $script:wevtutil /q:$Force $script:slparam $LogDetails.Name -e:$Enabled
		}
            }
            else
            {
		if($buildNumber -lt 7600)
		{
	            & $script:wevtutil $script:slparam $LogDetails.Name -e:$Enabled -rt:$Retention -ms:$MaxLogSize
		}
		else
		{
	            & $script:wevtutil /q:$Force $script:slparam $LogDetails.Name -e:$Enabled -rt:$Retention -ms:$MaxLogSize
		}

            }
        }
        else
        {
	    if($buildNumber -lt 7600)
	    {
                & $script:wevtutil $script:slparam $LogDetails.Name -e:$Enabled -rt:$Retention -ab:$AutoBackup -ms:$MaxLogSize
	    }
	    else
	    {
                & $script:wevtutil /q:$Force $script:slparam $LogDetails.Name -e:$Enabled -rt:$Retention -ab:$AutoBackup -ms:$MaxLogSize
	    }
        }
    }            
}

function ConvertTo-Bool([string]$value)
{
    if ($value -ieq "true")
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Get-LogProperties
{
    param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)] $Name
    )
    
    Process
    {
        $details = & $script:wevtutil $script:glparam $Name
        $indexes = @(1,2,8,9,10)
        $value = @()
        foreach($index in $indexes)
        { 
            $value += @(($details[$index].SubString($details[$index].IndexOf(":")+1)).Trim())
        }
        
        $enabled = ConvertTo-Bool $value[0]
        $retention = ConvertTo-Bool $value[2]
        $autobackup = ConvertTo-Bool $value[3]        
        
        New-Object Microsoft.PowerShell.Diagnostics.LogDetails $Name, $enabled, $value[1], $retention, $autobackup, $value[4]
    }
}

function Enable-PSTrace
{
    param(
        [switch] $Force,
		[switch] $AnalyticOnly
     )

    $Properties = Get-LogProperties ($script:psprovidername + $script:analyticlog)
	
	if (!$Properties.Enabled) {
		$Properties.Enabled = $true
		if ($Force) {
			Set-LogProperties $Properties -Force 
		} else {
			Set-LogProperties $Properties
		}
	}

	if (!$AnalyticOnly) {
		$Properties = Get-LogProperties ($script:psprovidername + $script:debuglog)
		if (!$Properties.Enabled) {
			$Properties.Enabled = $true
			if ($Force) {
				Set-LogProperties $Properties -Force 
			} else {
				Set-LogProperties $Properties
			}
		}
	}
}

function Disable-PSTrace
{
    param(
		[switch] $AnalyticOnly
     )
    $Properties = Get-LogProperties ($script:psprovidername + $script:analyticlog)
	if ($Properties.Enabled) {
		$Properties.Enabled = $false
		Set-LogProperties $Properties
	}
	
	if (!$AnalyticOnly) {
		$Properties = Get-LogProperties ($script:psprovidername + $script:debuglog)
		if ($Properties.Enabled) {
			$Properties.Enabled = $false
			Set-LogProperties $Properties
		}
	}
}
add-type @"
using System;

namespace Microsoft.PowerShell.Diagnostics
{
    public class LogDetails
    {
        public string Name
        {
            get
            {
                return name;
            }
        }
        private string name;

        public bool Enabled
        {
            get
            {
                return enabled;
            }
            set
            {
                enabled = value;
            }
        }
        private bool enabled;

        public string Type
        {
            get
            {
                return type;
            }
        }
        private string type;

        public bool Retention
        {
            get
            {
                return retention;
            }
            set
            {
                retention = value;
            }
        }
        private bool retention;

        public bool AutoBackup
        {
            get
            {
                return autoBackup;
            }
            set
            {
                autoBackup = value;
            }
        }
        private bool autoBackup;

        public int MaxLogSize
        {
            get
            {
                return maxLogSize;
            }
            set
            {
                maxLogSize = value;
            }
        }
        private int maxLogSize;

        public LogDetails(string name, bool enabled, string type, bool retention, bool autoBackup, int maxLogSize)
        {
            this.name = name;
            this.enabled = enabled;
            this.type = type;
            this.retention = retention;
            this.autoBackup = autoBackup;
            this.maxLogSize = maxLogSize;
        }
    }
}
"@

Export-ModuleMember Start-Trace, Stop-Trace, Enable-WSManTrace, Disable-WSManTrace, Enable-PSTrace, Disable-PSTrace, Enable-PSWSManCombinedTrace, Disable-PSWSManCombinedTrace, Get-LogProperties, Set-LogProperties
# SIG # Begin signature block
# MIIXXAYJKoZIhvcNAQcCoIIXTTCCF0kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUa2zyoX1cn6yo3i5RULuWP3bn
# FBSgghIxMIIEYDCCA0ygAwIBAgIKLqsR3FD/XJ3LwDAJBgUrDgMCHQUAMHAxKzAp
# BgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3NvZnQgQ29ycC4xHjAcBgNV
# BAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJv
# b3QgQXV0aG9yaXR5MB4XDTA3MDgyMjIyMzEwMloXDTEyMDgyNTA3MDAwMFoweTEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEjMCEGA1UEAxMaTWlj
# cm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
# ggEKAoIBAQC3eX3WXbNFOag0rDHa+SU1SXfA+x+ex0Vx79FG6NSMw2tMUmL0mQLD
# TdhJbC8kPmW/ziO3C0i3f3XdRb2qjw5QxSUr8qDnDSMf0UEk+mKZzxlFpZNKH5nN
# sy8iw0otfG/ZFR47jDkQOd29KfRmOy0BMv/+J0imtWwBh5z7urJjf4L5XKCBhIWO
# sPK4lKPPOKZQhRcnh07dMPYAPfTG+T2BvobtbDmnLjT2tC6vCn1ikXhmnJhzDYav
# 8sTzILlPEo1jyyzZMkUZ7rtKljtQUxjOZlF5qq2HyFY+n4JQiG4FsTXBeyS9UmY9
# mU7MK34zboRHBtGe0EqGAm6GAKTAh99TAgMBAAGjgfowgfcwEwYDVR0lBAwwCgYI
# KwYBBQUHAwMwgaIGA1UdAQSBmjCBl4AQW9Bw72lyniNRfhSyTY7/y6FyMHAxKzAp
# BgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3NvZnQgQ29ycC4xHjAcBgNV
# BAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJv
# b3QgQXV0aG9yaXR5gg8AwQCLPDyIEdE+9mPs30AwDwYDVR0TAQH/BAUwAwEB/zAd
# BgNVHQ4EFgQUzB3OdgBwW6/x2sROmlFELqNEY/AwCwYDVR0PBAQDAgGGMAkGBSsO
# AwIdBQADggEBAHurrn5KJvLOvE50olgndCp1s4b9q0yUeABN6crrGNxpxQ6ifPMC
# Q8bKh8z4U8zCn71Wb/BjRKlEAO6WyJrVHLgLnxkNlNfaHq0pfe/tpnOsj945jj2Y
# arw4bdKIryP93+nWaQmRiL3+4QC7NPP3fPkQEi4F6ymWk0JrKHG3OI/gBw3JXWjN
# vYBBa2aou7e7jjTK8gMQfHr10uBC33v+4eGs/vbf1Q2zcNaS40+2OKJ8LdQ92zQL
# YjcCn4FqI4n2XGOPsFq7OddgjFWEGjP1O5igggyiX4uzLLehpcur2iC2vzAZhSAU
# DSq8UvRB4F4w45IoaYfBcOLzp6vOgEJydg4wggR6MIIDYqADAgECAgphAbKbAAAA
# AAAVMA0GCSqGSIb3DQEBBQUAMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBMB4X
# DTExMDIyMTIwNTMxMloXDTEyMDUyMTIwNTMxMlowgYMxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxHjAcBgNVBAMTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
# ggEBAKVxdBjL25wv+vFjGYCjjv/IcIMMoUcq+vpasM5ND7072iHNBdV9fD+1mXYl
# OtygTyDlctNDceb/bBT5n4SyJYe9FLVdvjeJLsWrhWBxhYEnuTMD+a3WkwLutlUR
# AsuDhfbBhWNhGaAUnJ2fnEZjN9gRPFfHSCBTFvfMWP72wBrKtkZsDeg6Bc6mHOOI
# 8N2qwnCDW9Hy8j+42aSdowBuqoHN7joErcBKkiwT4OlBdgmAAWxnILQxsD5r0kAI
# g9VwMI0w576M0C/u1IY/GlqlwGiF6Il8kQNKbllDIEiciP7JRbfoTAQBC2LOouwc
# kyX90LEOxvi2JBp7+3zWXE7RZ+kCAwEAAaOB+DCB9TATBgNVHSUEDDAKBggrBgEF
# BQcDAzAdBgNVHQ4EFgQU2XLUywxiX92jdJ9fDphBqFsTQyYwDgYDVR0PAQH/BAQD
# AgeAMB8GA1UdIwQYMBaAFMwdznYAcFuv8drETppRRC6jRGPwMEQGA1UdHwQ9MDsw
# OaA3oDWGM2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3Rz
# L0NTUENBLmNybDBIBggrBgEFBQcBAQQ8MDowOAYIKwYBBQUHMAKGLGh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvQ1NQQ0EuY3J0MA0GCSqGSIb3DQEB
# BQUAA4IBAQBgYCfYfDBJEkdBNzxedbTkogA2EUiwLFibmHztoxKhmO4Ys5f2bY7Y
# MBocrSFjQUaT168aKEuXNn1AVGDMYrzp/GmnX3/Fh6aGDHyp4ll924jVd3gFpiTK
# ZPhOUbdEKI4aLFQIKHLFHxg9LM8AJ28T0aVh8tZiOr0ATgUvmWd95WNDPzsMvosH
# euF4QL/feM6HIKIZobxg8J+sUlx2FP0beAXXY3Vrgf2HRq2tWVK/e7+vGaSSsvIL
# LH4wENsxS76EWn/3mxJ46d5+YKsNxjEe9nKaPmfPOO44zjkbc9s72TTfg9KczeGL
# 3hr+ZAhfr/YuuDIldmkl89WNNSPD2yVEMIIEnTCCA4WgAwIBAgIQaguZT8AAJasR
# 20UfWHpnojANBgkqhkiG9w0BAQUFADBwMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMp
# IDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYDVQQLExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xITAfBgNVBAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eTAeFw0wNjA5
# MTYwMTA0NDdaFw0xOTA5MTUwNzAwMDBaMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBUaW1lc3RhbXBpbmcg
# UENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3Ddu+6/IQkpxGMjO
# SD5TwPqrFLosMrsST1LIg+0+M9lJMZIotpFk4B9QhLrCS9F/Bfjvdb6Lx6jVrmlw
# ZngnZui2t++Fuc3uqv0SpAtZIikvz0DZVgQbdrVtZG1KVNvd8d6/n4PHgN9/TAI3
# lPXAnghWHmhHzdnAdlwvfbYlBLRWW2ocY/+AfDzu1QQlTTl3dAddwlzYhjcsdckO
# 6h45CXx2/p1sbnrg7D6Pl55xDl8qTxhiYDKe0oNOKyJcaEWL3i+EEFCy+bUajWzu
# JZsT+MsQ14UO9IJ2czbGlXqizGAG7AWwhjO3+JRbhEGEWIWUbrAfLEjMb5xD4Gro
# fyaOawIDAQABo4IBKDCCASQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwgaIGA1UdAQSB
# mjCBl4AQW9Bw72lyniNRfhSyTY7/y6FyMHAxKzApBgNVBAsTIkNvcHlyaWdodCAo
# YykgMTk5NyBNaWNyb3NvZnQgQ29ycC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJvb3QgQXV0aG9yaXR5gg8AwQCL
# PDyIEdE+9mPs30AwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFG/oTj+XuTSr
# S4aPvJzqrDtBQ8bQMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQE
# AwIBhjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQCUTRExwnxQ
# uxGOoWEHAQ6McEWN73NUvT8JBS3/uFFThRztOZG3o1YL3oy2OxvR+6ynybexUSEb
# bwhpfmsDoiJG7Wy0bXwiuEbThPOND74HijbB637pcF1Fn5LSzM7djsDhvyrNfOzJ
# rjLVh7nLY8Q20Rghv3beO5qzG3OeIYjYtLQSVIz0nMJlSpooJpxgig87xxNleEi7
# z62DOk+wYljeMOnpOR3jifLaOYH5EyGMZIBjBgSW8poCQy97Roi6/wLZZflK3toD
# dJOzBW4MzJ3cKGF8SPEXnBEhOAIch6wGxZYyuOVAxlM9vamJ3uhmN430IpaczLB3
# VFE61nJEsiP2MIIEqjCCA5KgAwIBAgIKYQWiMAAAAAAACDANBgkqhkiG9w0BAQUF
# ADB5MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQD
# ExpNaWNyb3NvZnQgVGltZXN0YW1waW5nIFBDQTAeFw0wODA3MjUxOTAxMTVaFw0x
# MzA3MjUxOTExMTVaMIGzMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMQ0wCwYDVQQLEwRNT1BSMScwJQYDVQQLEx5uQ2lwaGVyIERTRSBFU046ODVE
# My0zMDVDLTVCQ0YxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZp
# Y2UwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDwBC2ylsAagWclsSZi
# sxNLzjC6wBI4/IFlNAfENrIkaPYHBMAHl/S38XseYixG2UukUTS302ztWju0g6FH
# PREILjVrRebCPIwCZgKpGGnrSu0nLO48d1uk1HCZS1eEENCvLfiJHebqKbTnz54G
# YqdyVMI7xs8/uOGwWBBs5aXXw8J1N730heGB6CjYG/HyrvGCo9bXA6KfFYT7Pfqr
# 4bYyyKACZPPm/xomcQhTihUC8oMndkmCcafvrTJ4xtdsFk8iZZdiTUYv/yOvheym
# cL0Dy9rYMgXFK5BAtp7VLIZst8sTMn2Nxn6uFy8y/Ga7HbBFVfit+i1ng2cpk4TS
# WqEjAgMBAAGjgfgwgfUwHQYDVR0OBBYEFOiX9vfvjPHmaeNZaE73mIp63ZsuMB8G
# A1UdIwQYMBaAFG/oTj+XuTSrS4aPvJzqrDtBQ8bQMEQGA1UdHwQ9MDswOaA3oDWG
# M2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL3RzcGNh
# LmNybDBIBggrBgEFBQcBAQQ8MDowOAYIKwYBBQUHMAKGLGh0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2kvY2VydHMvdHNwY2EuY3J0MBMGA1UdJQQMMAoGCCsGAQUF
# BwMIMA4GA1UdDwEB/wQEAwIGwDANBgkqhkiG9w0BAQUFAAOCAQEADT93X5E8vqU1
# pNsFBYQfVvLvmabHCI0vs80/cdWGfHcf3esXsr184/mZ8gpFSK0Uu2ks8j5nYlTy
# 7n8nEZI57M7Zh06I92BHI3snFUAIn78NMQSC2DW2DJwA04uqeGHFtYhBnT423Fik
# J5s62r0GXRSmsg9MwY48i/Jimfhm7dXzHCiwMtvKMQm8+yJoRkz603Mi5ymOIgD7
# Vr8GroGgFbo0+SiOH0piBaGJ9YFH6Q2RCNdYO48eawlpqcBIfFWCP18AOEOcBsw/
# 2C+/T3MJPf26XvTH7DfCZGGgTdQ9cMxbsBOBwdSjMRq9ZNaW0no/KltGUwk8zQP5
# P1kAzIlTYTGCBJUwggSRAgEBMIGHMHkxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
# YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENB
# AgphAbKbAAAAAAAVMAkGBSsOAwIaBQCggcAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkE
# MRYEFAQKeeK0QTkp3IDPAi2+RktllgioMGAGCisGAQQBgjcCAQwxUjBQoCaAJABX
# AGkAbgBkAG8AdwBzACAAUABvAHcAZQByAFMAaABlAGwAbKEmgCRodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcG93ZXJzaGVsbCAwDQYJKoZIhvcNAQEBBQAEggEAOj38
# ev/2tVgkNWkt9TAAQyaIa8bp6tvHC7he7plMbKedGmdSZ+FXGmPrZGlw3OWQzgxD
# 0JvKarv/NEzc07i+gGpHYRKsGhKnMnD4rzpVFwex8t07ypSZ7KPm/AbMUhyhWgLe
# ycCKG/3CFFYf405BDrcwstOfv/pFW8ka+x2SLoUJxvQ0WTOryHDDxtjDYnb8Vvqu
# Byv06vkHJkjYhm5i2I0+SaoVwQrjmLvqTUetK03jDHG3zcsqRFGZpaZihgiUOE37
# SUHNqCvMdkUwpJpedcPYWSjGXha7EYIJ/POmfpngV8HuWs5Irjtx+3iOC9K1UhuE
# g+LsKY8n/BEMZhjRGaGCAh8wggIbBgkqhkiG9w0BCQYxggIMMIICCAIBATCBhzB5
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpN
# aWNyb3NvZnQgVGltZXN0YW1waW5nIFBDQQIKYQWiMAAAAAAACDAHBgUrDgMCGqBd
# MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTExMDUx
# MTE5NTEyNFowIwYJKoZIhvcNAQkEMRYEFNsMOynveNyLMJHNDRF/gtfodtffMA0G
# CSqGSIb3DQEBBQUABIIBAJw5tWSPqQAE+cm2bofDQM/pttLXWL68Mcemtqnvc+mw
# IipcrxoRPph7VLph/F/oUXT1SUM40JHSpdDRhOJ3AtWbdD+5FTaxpFFsN4QLCN75
# dd3XKwM/n/RDW4s6/IcCXCCQeysTxicphsU1N8J1ecqZMl/bHZVu13lO26VefHSM
# 9r35KVfV73BuLQmkjfFMc4tI909LkUxbKzhijzeJu6yFBeA5YaR6GOmpXGkKsEnJ
# 5Kj1OpC4upROdksuk/PGdjMCzVNwtfXBZtK8f56Ip7tPVbTtIMA0fKxlE1+5tVyJ
# DM4o9BGa0/vz+AqGd1aWxQ8UECNyXaEwT1qObZI3yuk=
# SIG # End signature block
