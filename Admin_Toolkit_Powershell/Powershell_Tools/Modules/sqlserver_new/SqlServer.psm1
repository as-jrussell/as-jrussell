#
# Script module for module 'SqlServer'
#
Set-StrictMode -Version Latest

# Set up some helper variables to make it easier to work with the module
$PSModule = $ExecutionContext.SessionState.Module
$PSModuleRoot = $PSModule.ModuleBase

# Import the appropriate nested binary module based on the current PowerShell version
$binaryModuleRoot = $PSModuleRoot

# Set FormatData and TypeData. This is being done explicitly because those attributes are not supported to be set in the manifest .psd1 file on linux/mac.
$formatFile = Join-Path -Path $PSModuleRoot -ChildPath "SqlProvider.Format.ps1xml"
Update-FormatData -AppendPath $formatFile
$typeFile = Join-Path -Path $PSModuleRoot -ChildPath "SqlProvider.Types.ps1xml"
Update-TypeData -PrependPath $typeFile
$assessmentFormatFile = Join-Path -Path $PSModuleRoot -ChildPath "Microsoft.SqlServer.Assessment.format.ps1xml"
Update-FormatData -PrependPath $assessmentFormatFile

if (($PSVersionTable.Keys -contains "PSEdition") -and ($PSVersionTable.PSEdition -ne 'Desktop')) {
    # .Net Core DLLs are under the 'coreclr' folder
    if ([version]$PSVersionTable.PSVersion -ge "7.2.1") {
        $binaryModuleRoot = Join-Path -Path $PSModuleRoot -ChildPath 'coreclr'
    } else {
        # Emit an error and remind user to upgrade...
        Write-Error "This module requires PowerShell 7.2.1+. Please, upgrade your PowerShell version by checking https://aka.ms/pscore6."
        Exit 1
    }
}

$moduleDLLs = @('Microsoft.SqlServer.Management.PSProvider.dll',
                'Microsoft.SqlServer.Management.PSProvider.Ext.dll',
                'Microsoft.SqlServer.Management.PSSnapins.dll',
                'Microsoft.AnalysisServices.PowerShell.Cmdlets.dll',
                'Microsoft.SqlServer.Assessment.Cmdlets.dll',
                'SqlServerPostScript.ps1')

$extraDLLS = @( 'Microsoft.SqlServer.Smo.dll',
                'Microsoft.SqlServer.Dmf.dll',
                'Microsoft.SqlServer.SqlWmiManagement.dll',
                'Microsoft.SqlServer.ConnectionInfo.dll',
                'Microsoft.SqlServer.SmoExtended.dll',
                'Microsoft.SqlServer.Management.RegisteredServers.dll',
                'Microsoft.SqlServer.Management.Sdk.Sfc.dll',
                'Microsoft.SqlServer.SqlEnum.dll',
                'Microsoft.SqlServer.RegSvrEnum.dll',
                'Microsoft.SqlServer.WmiEnum.dll',
                'Microsoft.SqlServer.ServiceBrokerEnum.dll',
                'Microsoft.SqlServer.Management.Collector.dll',
                'Microsoft.SqlServer.Management.CollectorEnum.dll',
                'Microsoft.SqlServer.Management.Utility.dll',
                'Microsoft.SqlServer.Management.UtilityEnum.dll',
                'Microsoft.SqlServer.Management.HadrDMF.dll' )

$importedModules = @()

$moduleDLLs | ForEach-Object {
    $binaryModulePath = Join-Path -Path $binaryModuleRoot -ChildPath "$_"
    if (Test-Path -Path $binaryModulePath) {
        $binaryModule = Import-Module -Name $binaryModulePath -PassThru
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification="This is a false positive. PSA cannot inspect downstream usage")]
        $importedModules += $binaryModule
    }
}

# Load misc assemblies (from the local folder)
$extraDLLS | ForEach-Object {
    $binaryPath = Join-Path -Path $binaryModuleRoot -ChildPath "$_"

    if (Test-Path -Path $binaryPath) {
        Add-Type -Path $binaryPath
    }
}

# When the module is unloaded, remove the nested binary module that was loaded with it
$PSModule.OnRemove = {
    Remove-Module -ModuleInfo $importedModules
}
# SIG # Begin signature block
# MIInvgYJKoZIhvcNAQcCoIInrzCCJ6sCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCS4I+aR5ZmcPbp
# rkIjkzULAoIayRvGfXsNE0209expxaCCDXYwggX0MIID3KADAgECAhMzAAACy7d1
# OfsCcUI2AAAAAALLMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjIwNTEyMjA0NTU5WhcNMjMwNTExMjA0NTU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC3sN0WcdGpGXPZIb5iNfFB0xZ8rnJvYnxD6Uf2BHXglpbTEfoe+mO//oLWkRxA
# wppditsSVOD0oglKbtnh9Wp2DARLcxbGaW4YanOWSB1LyLRpHnnQ5POlh2U5trg4
# 3gQjvlNZlQB3lL+zrPtbNvMA7E0Wkmo+Z6YFnsf7aek+KGzaGboAeFO4uKZjQXY5
# RmMzE70Bwaz7hvA05jDURdRKH0i/1yK96TDuP7JyRFLOvA3UXNWz00R9w7ppMDcN
# lXtrmbPigv3xE9FfpfmJRtiOZQKd73K72Wujmj6/Su3+DBTpOq7NgdntW2lJfX3X
# a6oe4F9Pk9xRhkwHsk7Ju9E/AgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUrg/nt/gj+BBLd1jZWYhok7v5/w4w
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzQ3MDUyODAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAJL5t6pVjIRlQ8j4dAFJ
# ZnMke3rRHeQDOPFxswM47HRvgQa2E1jea2aYiMk1WmdqWnYw1bal4IzRlSVf4czf
# zx2vjOIOiaGllW2ByHkfKApngOzJmAQ8F15xSHPRvNMmvpC3PFLvKMf3y5SyPJxh
# 922TTq0q5epJv1SgZDWlUlHL/Ex1nX8kzBRhHvc6D6F5la+oAO4A3o/ZC05OOgm4
# EJxZP9MqUi5iid2dw4Jg/HvtDpCcLj1GLIhCDaebKegajCJlMhhxnDXrGFLJfX8j
# 7k7LUvrZDsQniJZ3D66K+3SZTLhvwK7dMGVFuUUJUfDifrlCTjKG9mxsPDllfyck
# 4zGnRZv8Jw9RgE1zAghnU14L0vVUNOzi/4bE7wIsiRyIcCcVoXRneBA3n/frLXvd
# jDsbb2lpGu78+s1zbO5N0bhHWq4j5WMutrspBxEhqG2PSBjC5Ypi+jhtfu3+x76N
# mBvsyKuxx9+Hm/ALnlzKxr4KyMR3/z4IRMzA1QyppNk65Ui+jB14g+w4vole33M1
# pVqVckrmSebUkmjnCshCiH12IFgHZF7gRwE4YZrJ7QjxZeoZqHaKsQLRMp653beB
# fHfeva9zJPhBSdVcCW7x9q0c2HVPLJHX9YCUU714I+qtLpDGrdbZxD9mikPqL/To
# /1lDZ0ch8FtePhME7houuoPcMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGZ4wghmaAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAALLt3U5+wJxQjYAAAAAAsswDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIFhBDxvzuZhvh18ZpJJ2QKW0
# S5FKEEJCurW6QSKLNcZDMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEApbAb72tMlITxH1sLHrbkWNF0V/1CcAjbAbSerWjKLf8GVD4xGFS3rF9k
# 6cMeTB/cIjn6jRqEUSB83l4fsnq4pJjhjs1iw2zF+rLA0tfs6pZYnZ77PvarPF26
# XMNQ58by4cNoRUxak3d88sLBMmhznyzRkpjEhaYthbmEKWRcEWMqColy7Gebtk3h
# 78PpSUzDhUEkPX0mBEstR930HEW16LovEcujwN9Nz0e2dlKon5Fj1OM6AQS2B/DU
# 807LLWDr9zxjhDdIL4mSd6z6BgXf15cartxNLjg3bZnX6FIqkj+P/UnnXvv3wS1P
# kWUdUPFxKLjWJFYN65jUfOGM8ZDinKGCFygwghckBgorBgEEAYI3AwMBMYIXFDCC
# FxAGCSqGSIb3DQEHAqCCFwEwghb9AgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFYBgsq
# hkiG9w0BCRABBKCCAUcEggFDMIIBPwIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCDkZlJFLtAi9NOb6kQApyKznJfLrqM321xWTZnYm9J1dgIGZBsIw1vQ
# GBIyMDIzMDQwMzAyMzMxNC42NFowBIACAfSggdikgdUwgdIxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVs
# YW5kIE9wZXJhdGlvbnMgTGltaXRlZDEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046
# M0JENC00QjgwLTY5QzMxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNl
# cnZpY2WgghF4MIIHJzCCBQ+gAwIBAgITMwAAAbT7gAhEBdIt+gABAAABtDANBgkq
# hkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMjA5
# MjAyMDIyMDlaFw0yMzEyMTQyMDIyMDlaMIHSMQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVy
# YXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjNCRDQtNEI4
# MC02OUMzMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtEemnmUHMkIfvOiu27K86Zbw
# WhksGwV72Dl1uGdqr2pKm+mfzoT+Yngkq9aLEf+XDtADyA+2KIZU0iO8WG79eJjz
# z29flZpBKbKg8xl2P3O9drleuQw3TnNfNN4+QIgjMXpE3txPF7M7IRLKZMiOt3Ff
# kFWVmiXJAA7E3OIwJgphg09th3Tvzp8MT8+HOtG3bdrRd/y2u8VrQsQTLZiVwTZ6
# qDYKNT8PQZl7xFrSSO3QzXa91LipZnYOl3siGJDCee1Ba7X1i13dQFHxKl5Ff4Jz
# DduOBZ85e2VrpyFy1a3ayGUzBrIw59jhMbjIw9YVcQt9kUWntyCmNk15WybCS+hX
# pEDDLVj1X5W9snmoW1qu03+unprQjWQaVuO7BfcvQdNVdyKSqAeKy1eT2Hcc5n1a
# AVeXFm6sbVJmZzPQEQR3Jr7W8YcTjkqC5hT2qrYuIcYGOf3Pj4OqdXm1Qqhuwtsk
# xviv7yy3Z+PxJpxKx+2e6zGRaoQmIlLfg/a42XNVHTf6Wzr5k7Q1w7v0uA/sFsgy
# KmI7HzKHX08xDDSmJooXA5btD6B0lx/Lqs6Qb4KthnA7N2IEdJ5sjMIhyHZwBr7f
# zDskU/+Sgp2UnfqrN1Vda/gb+pmlbJwi8MphvElYzjT7PZK2Dm4eorcjx7T2QVe3
# EIelLuGbxzybblZoRTkCAwEAAaOCAUkwggFFMB0GA1UdDgQWBBTLRIXl8ZS4Opy7
# Eii3Tt44zDLZfjAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNV
# HR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Ny
# bC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYI
# KwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAy
# MDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEAEtEPBYwpt4JioSq0
# joGzwqYX6SoNH7YbqpgArdlnrdt6u3ukKREluKEVqS2XajXxx0UkXGc4Xi9dp2bS
# xpuyQnTkq+IQwkg7p1dKrwAa2vdmaNzz3mrSaeUEu40yCThHwquQkweoG4eqRRZe
# 19OtVSmDDNC3ZQ6Ig0qz79vivXgy5dFWk4npxA5LxSGR4wBaXaIuVhoEa06vd/9/
# 2YsQ99bCiR7SxJRt1XrQ5kJGHUi0Fhgz158qvXgfmq7qNqfqfTSmsQRrtbe4Zv/X
# +qPo/l6ae+SrLkcjRfr0ONV0vFVuNKx6Cb90D5LgNpc9x8V/qIHEr+JXbWXW6mAR
# VVqNQCmXlVHjTBjhcXwSmadR1OotcN/sKp2EOM9JPYr86O9Y/JAZC9zug9qljKTr
# oZTfYA7LIdcmPr69u1FSD/6ivL6HRHZd/k2EL7FtZwzNcRRdFF/VgpkOxHIfqvjX
# ambwoMoT+vtGTtqgoruhhSk0bM1F/pBpi/nPZtVNLGTNaK8Wt6kscbC9G6f09gz/
# wBBJOBmvTLPOOT/3taCGSoJoDABWnK+De5pie4KX8BxxKQbJvxz7vRsVJ5R6mGx+
# Bvav5AjsxvZZw6eQmkI0vPRckxL9TCVCfWS0uyIKmyo6TdosnbBO/osre7r0jS9A
# H8spEqVlhFcpQNfOg/CvdS2xNVMwggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZ
# AAAAAAAVMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVa
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEF
# AAOCAg8AMIICCgKCAgEA5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1
# V/YBf2xK4OK9uT4XYDP/XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9
# alKDRLemjkZrBxTzxXb1hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmv
# Haus9ja+NSZk2pg7uhp7M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928
# jaTjkY+yOSxRnOlwaQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3t
# pK56KTesy+uDRedGbsoy1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEe
# HT39IM9zfUGaRnXNxF803RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26o
# ElHovwUDo9Fzpk03dJQcNIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4C
# vEJoLhDqhFFG4tG9ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ug
# poMhXV8wdJGUlNi5UPkLiWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXps
# xREdcu+N+VLEhReTwDwV2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0C
# AwEAAaOCAd0wggHZMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYE
# FCqnUv5kxJq+gpE8RjUpzxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtT
# NRnpcjBcBgNVHSAEVTBTMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNo
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5o
# dG0wEwYDVR0lBAwwCgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBD
# AEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZW
# y4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5t
# aWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAt
# MDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0y
# My5jcnQwDQYJKoZIhvcNAQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pc
# FLY+TkdkeLEGk5c9MTO1OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpT
# Td2YurYeeNg2LpypglYAA7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0j
# VOR4U3UkV7ndn/OOPcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3
# +SmJw7wXsFSFQrP8DJ6LGYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmR
# sqlb30mjdAy87JGA0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSw
# ethQ/gpY3UA8x1RtnWN0SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5b
# RAGOWhmRaw2fpCjcZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmx
# aQFEfnyhYWxz/gq77EFmPWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsX
# HRWJjXD+57XQKBqJC4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0
# W2rRnj7tfqAxM328y+l7vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0
# HVUzWLOhcGbyoYIC1DCCAj0CAQEwggEAoYHYpIHVMIHSMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFu
# ZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjNC
# RDQtNEI4MC02OUMzMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2
# aWNloiMKAQEwBwYFKw4DAhoDFQBlnNiQ85uX9nN4KRJt/gHkJx4JCKCBgzCBgKR+
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBBQUAAgUA
# 59SvrzAiGA8yMDIzMDQwMzA5NTE0M1oYDzIwMjMwNDA0MDk1MTQzWjB0MDoGCisG
# AQQBhFkKBAExLDAqMAoCBQDn1K+vAgEAMAcCAQACAiV+MAcCAQACAhFgMAoCBQDn
# 1gEvAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMH
# oSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQADgYEAZ9xS1JG3TLdO4stA3btM
# FEuVoQM05V8FtogrbsCB4kbQkawGFIiIoj4naSEfqolsR0m1vTy1fGkg4rFm94Rh
# NHdcyHSxrg0EoNij+97Xe/B3fJjkUEFXtSMYCPjcIcnaUyLYMeEZH9m2sZ0kbg3X
# ksvcWKYwA4oOrvhz5kN/vLIxggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
# dGFtcCBQQ0EgMjAxMAITMwAAAbT7gAhEBdIt+gABAAABtDANBglghkgBZQMEAgEF
# AKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEi
# BCDMqqqM1I0OelJ49CLRtbvGnZ6ffh5TKsbAzd3XU5bYUTCB+gYLKoZIhvcNAQkQ
# Ai8xgeowgecwgeQwgb0EINPI93vmozBwBlFxvfr/rElreFPR4ux7vXKx2ni3AfcG
# MIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEm
# MCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAG0+4AI
# RAXSLfoAAQAAAbQwIgQg/3qRw1ejdxShYkLFYsRZNlpleoWiplfUPFCd9oEkc+8w
# DQYJKoZIhvcNAQELBQAEggIAA/eiABoFOPEI9r9G4M/rfbiGCXiL6GR837/CbyoM
# 10oSXHHyhQsS73OMbK6daHmc418UJuFrCakafHQADEIQAq8kiJaW7Oq3RuTuusKz
# bcvug3FVVJC6ejqvbAGDoFau3h6G8xCBz+r1H476oshtBR6QtRohkZY3JyYCa/45
# RtVBdQdtfUPI8+aX9oCqReXEOy++rkB7wYP5CsXLmMdu0Kdmivv7aWQJZbDy+J3Y
# zYdajNzZEZneM76XCrhLJ2v3ndLPIqaP+8LhepLcFFrwdDSjhPT0HzMjN9/QjMln
# OCp30bN/3eigx8cGcQu+sD5T+a6MF4PmgbD8y9VD2QwGH4YZhED/l21ve3xa6WmU
# 0HJMQqFZ+fzF+pEFkGypHya6pxE9mT0w3QL7EoYy8QQVDQ0hlXvHDd9LsUPIW8A3
# CzDgZbdQ33Y57FjIT9uTUpcNRyfvy1ls0lKQwwKY/pTV02pPBngweMh+RCBQvNxh
# Su7RLm0W/lnCgUBo3+Yl80xD51eeccF9cepvgVtbYPa+dDKZVQkn/hrFehwFDAJB
# KN2Wweifd+2bkXo2j4p/eXonnbGryE0ORBCi/lmBs6ttcvvFwVxiI325eL4V6CGu
# 3Smq/yX83QTDW5rvpJVdeGlbMa8DjlQ90Z1SfCnzHBkBLi3hJOJwBuUQ/RR8pFgj
# ySY=
# SIG # End signature block
