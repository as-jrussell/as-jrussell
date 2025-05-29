#
# Module manifest for module 'AWS.Tools.Installer'
#

@{
    # Script module or binary module file associated with this manifest
    RootModule = 'AWS.Tools.Installer.psm1'

    # Supported PSEditions
    CompatiblePSEditions = @('Core', 'Desktop')

    # Version number of this module.
    ModuleVersion = '1.0.2.4'

    # ID used to uniquely identify this module
    GUID = '450031c1-9177-4fc1-9518-93166b1a926b'

    # Author of this module
    Author = 'Amazon.com, Inc'

    # Company or vendor of this module
    CompanyName = 'Amazon.com, Inc'

    # Copyright statement for this module
    Copyright = 'Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.'

    # Description of the functionality provided by this module
    Description = 'The AWS.Tools.Installer module makes it easier to install, update and uninstall other AWS.Tools modules (see https://www.powershellgallery.com/packages/AWS.Tools.Common/).
You can use a single command like ''Install-AWSToolsModule EC2,S3'' to install multiple modules.
You can also update all your installed AWS.Tools modules and remove old versions by running `Update-AWSToolsModule -CleanUp`.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the PowerShell host required by this module
    PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    PowerShellHostVersion = ''

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = '4.7.2'

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = ''

    # Processor architecture (None, X86, Amd64, IA64) required by this module
    ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(
        @{
            ModuleName = 'PowerShellGet';
            ModuleVersion = '2.2.1' }
    )

    # Assemblies that must be loaded prior to importing this module.
    RequiredAssemblies = @( )

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess = @( )

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @( )

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @( )

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules = @( )

    # Functions to export from this module
    FunctionsToExport = @(
        'Uninstall-AWSToolsModule', 
        'Install-AWSToolsModule', 
        'Update-AWSToolsModule' )

    # Cmdlets to export from this module
    CmdletsToExport = @( )

    # Variables to export from this module
    VariablesToExport = @( )

    # Aliases to export from this module
    AliasesToExport = @( )

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @( )

    # Private data to pass to the module specified in ModuleToProcess
    PrivateData = @{

        PSData = @{
            Tags = @('AWS', 'cloud', 'Windows', 'PSEdition_Desktop', 'PSEdition_Core', 'Linux', 'MacOS', 'Mac')
            LicenseUri = 'https://aws.amazon.com/apache-2-0/'
            ProjectUri = 'https://github.com/aws/aws-tools-for-powershell'
            IconUri = 'https://sdk-for-net.amazonwebservices.com/images/AWSLogo128x128.png'
            ReleaseNotes = 'https://github.com/aws/aws-tools-for-powershell/blob/master/CHANGELOG.md'
        }
    }
}

# SIG # Begin signature block
# MIIfKgYJKoZIhvcNAQcCoIIfGzCCHxcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCD9ZQoNNSo/yoJn
# 07EgHUJql1QltXgSyvbNzhKvF8AxKaCCDlkwggawMIIEmKADAgECAhAIrUCyYNKc
# TJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0z
# NjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0
# JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJr
# Q5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhF
# LqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+F
# LEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh
# 3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJ
# wZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQay
# g9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbI
# YViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchAp
# QfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRro
# OBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IB
# WTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+
# YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAC
# hjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAED
# MAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql
# +Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFF
# UP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1h
# mYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3Ryw
# YFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5Ubdld
# AhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw
# 8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnP
# LqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatE
# QOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bn
# KD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQji
# WQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbq
# yK+p/pQd52MbOoZWeE4wggehMIIFiaADAgECAhALyko14sGCglkXWPsT8gmbMA0G
# CSqGSIb3DQEBCwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjExMjI4MDAwMDAwWhcNMjMwMTAz
# MjM1OTU5WjCB9jEdMBsGA1UEDwwUUHJpdmF0ZSBPcmdhbml6YXRpb24xEzARBgsr
# BgEEAYI3PAIBAxMCVVMxGTAXBgsrBgEEAYI3PAIBAhMIRGVsYXdhcmUxEDAOBgNV
# BAUTBzQxNTI5NTQxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdTZWF0dGxlMSIwIAYDVQQKExlBbWF6b24gV2ViIFNlcnZpY2VzLCBJ
# bmMuMRcwFQYDVQQLEw5TREtzIGFuZCBUb29sczEiMCAGA1UEAxMZQW1hem9uIFdl
# YiBTZXJ2aWNlcywgSW5jLjCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGB
# AKHRLdQSyJ6AfhQ8U7Gi6le7gshUhu34xQ7jaTCfpKaKQRGu+oNfAYDRSSfh498e
# K+jFnGHU/TMzVHEgBb4TUrc1e2f5LHhXAtYTJK0uis9OJ5n3MjHwOJt/uGSSMUAI
# IIselvbSF2mOE0lIz0CNMIlUiXI9O+y9+FJP7Vsg/NU/zAVsQ4Ok0GLd+Yp566nR
# uj9aNU+L+TxRhSHA7KKjJ9oE0mVblUGQaeNrOd1Ql9djJy0pg6oT2s9Peh8lqB3t
# UsMaoQ/FMV0P/e1S6V3yFg/I1OvQdtm29ryJTdg9ZvIV/FGnIYdW5s5T8t//nf+7
# LToQVhpML/ZWEhFRAa6We80Y8zs9glIPDZyYmi6OPbpY7kVHa4dr8S49tPwrVMjC
# 3hk9v9S6poDx/hR9kytwVt1Lo4LjAlpmKLeHVmOnn5uenpXqFOJMbTMYmciwHz8y
# WJwZYMKKLJPCGa79xaAkZj9HCop5yPUPccqjyz2i0v/Pt8yFH77s8q86e99O2a+/
# oQIDAQABo4ICNTCCAjEwHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIw
# HQYDVR0OBBYEFGmlIp+0bnVEmnOvWcJjnCup9DbsMC4GA1UdEQQnMCWgIwYIKwYB
# BQUHCAOgFzAVDBNVUy1ERUxBV0FSRS00MTUyOTU0MA4GA1UdDwEB/wQEAwIHgDAT
# BgNVHSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8v
# Y3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JT
# QTQwOTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0
# MjAyMUNBMS5jcmwwPQYDVR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIBFhto
# dHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGEMCQG
# CCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUHMAKG
# UGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENv
# ZGVTaWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3J0MAwGA1UdEwEB/wQCMAAw
# DQYJKoZIhvcNAQELBQADggIBALlYa6PSDPPulVJbqEi7XGz23lFZwYa1PiXk+PkJ
# O2HDXv2zep26LZriwBHT2yA/KbDvbwZpf4VOBKn5lQC9R+DsgwW/xZbNq7y3cWf9
# Ad1AQ9Do/FXfBqVO1if+GpqFbqUme5wOjn8/8dc4nFR4erbDgkM4ICn/astBigYn
# fM5wTO+J8ex+7fE2D1kFAwfZAuiRNdDreVMDlYXpJMQ4CtTKVLHYentLR747zzRj
# O4PqgL1exvbvpOMZlSDLWhaDjtKwUDb645ziHDA3DXe8K51+hIFuadKTinJa8Pfs
# bgg2W7aTfBdi2gTyXkeVJ836631Ks4KD3cXui9Jx2PWRAVxKIEvXuebZ09Mph2ji
# BH75urqS57i1mpS7OA5lIj7a7NIYsVl26PVpJUEr3LRKV8GO3tRC7KP0zE7sB7k2
# VQKwBXbsifq/vpcmeyy4OeQbZ1i8GwZLPHuygP9exTWK2o2wWByJs62Wdk6JmSRE
# vr9Wr59BVNbQfRSRaF9q058bBK68hGZtDBpJ9gJX4V12DI2UpSbcGf10+afL1J4z
# FDv98GIGkgmfLQJUpJeC/FnNrEXJbINndCsOb6gdLvLX1grMdUPmPkpRZyvG3HEy
# EMCV5ODMItTx7K6TDyeZDIXXP5oBnBMK9EjtRD3XkEb9dDfuzCrdlTpEoTElt2mG
# uEE7MYIQJzCCECMCAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNl
# cnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWdu
# aW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhALyko14sGCglkXWPsT8gmbMA0G
# CWCGSAFlAwQCAQUAoHwwEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwG
# CisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZI
# hvcNAQkEMSIEIAlrM2MCCbhcvmPwUejifVN2f7fdZtUJuUyioThHSrDmMA0GCSqG
# SIb3DQEBAQUABIIBgImVEW8L2rSRPqVtcT1iSZLXjCAKze9sZptmyD9TdvVwUClk
# 6KOnfmdVwOvT0WeoLM3nEjk5XiL0zKU39uiSKXQ0wmf9z6AfzqAbSfTre+lDEUJZ
# yneOvXUrjSq9oALs/6wKNmBP9lF19mGc/bY/qDJf7Nll0Synrr6nvEBiOX52nq2H
# rxEbO7eEH07PS6tmS4fN/Y4SvszgnQGT0a2gmK+cx7BokICSvPBm1QUzPkoDPVgI
# Yef2owCsRYyxdK6VAVKxCewXN2YU9uaJwoB/WGUpXzx+zqkb0nk/C/liC+8/zGRA
# FJg9QRQJNIfJGbnMP3dYQ+kIm0Swo+jWYsmbPHX28T8n5Jr3RZvt/ioaqH76Hais
# G+Qjx8XwsGxVoClV07v1eNSr5i1rf5PfgCgPaqHvZh8JPOLabcQcyhIEO+0eITpd
# 3+BiNybuBMP7si2UbFkH2eWcE9QVQZWYw1p9qjzAkKLoKmIzkfAhtemXAn39pZZo
# AeR7W7Pp4VG/MHXylqGCDX0wgg15BgorBgEEAYI3AwMBMYINaTCCDWUGCSqGSIb3
# DQEHAqCCDVYwgg1SAgEDMQ8wDQYJYIZIAWUDBAIBBQAwdwYLKoZIhvcNAQkQAQSg
# aARmMGQCAQEGCWCGSAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCAzOXIdVvTFUjJL
# dy7Q5JIFKaW8cDwJJdgjaQYOks4dJAIQOCvERrsga5v/djRphjfgdRgPMjAyMjAy
# MjgyMjE2MTNaoIIKNzCCBP4wggPmoAMCAQICEA1CSuC+Ooj/YEAhzhQA8N0wDQYJ
# KoZIhvcNAQELBQAwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IElu
# YzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQg
# U0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQTAeFw0yMTAxMDEwMDAwMDBa
# Fw0zMTAxMDYwMDAwMDBaMEgxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2Vy
# dCwgSW5jLjEgMB4GA1UEAxMXRGlnaUNlcnQgVGltZXN0YW1wIDIwMjEwggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDC5mGEZ8WK9Q0IpEXKY2tR1zoRQr0K
# dXVNlLQMULUmEP4dyG+RawyW5xpcSO9E5b+bYc0VkWJauP9nC5xj/TZqgfop+N0r
# cIXeAhjzeG28ffnHbQk9vmp2h+mKvfiEXR52yeTGdnY6U9HR01o2j8aj4S8bOrdh
# 1nPsTm0zinxdRS1LsVDmQTo3VobckyON91Al6GTm3dOPL1e1hyDrDo4s1SPa9E14
# RuMDgzEpSlwMMYpKjIjF9zBa+RSvFV9sQ0kJ/SYjU/aNY+gaq1uxHTDCm2mCtNv8
# VlS8H6GHq756WwogL0sJyZWnjbL61mOLTqVyHO6fegFz+BnW/g1JhL0BAgMBAAGj
# ggG4MIIBtDAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8E
# DDAKBggrBgEFBQcDCDBBBgNVHSAEOjA4MDYGCWCGSAGG/WwHATApMCcGCCsGAQUF
# BwIBFhtodHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwHwYDVR0jBBgwFoAU9Lbh
# IB3+Ka7S5GGlsqIlssgXNW4wHQYDVR0OBBYEFDZEho6kurBmvrwoLR1ENt3janq8
# MHEGA1UdHwRqMGgwMqAwoC6GLGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEy
# LWFzc3VyZWQtdHMuY3JsMDKgMKAuhixodHRwOi8vY3JsNC5kaWdpY2VydC5jb20v
# c2hhMi1hc3N1cmVkLXRzLmNybDCBhQYIKwYBBQUHAQEEeTB3MCQGCCsGAQUFBzAB
# hhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wTwYIKwYBBQUHMAKGQ2h0dHA6Ly9j
# YWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFNIQTJBc3N1cmVkSURUaW1lc3Rh
# bXBpbmdDQS5jcnQwDQYJKoZIhvcNAQELBQADggEBAEgc3LXpmiO85xrnIA6OZ0b9
# QnJRdAojR6OrktIlxHBZvhSg5SeBpU0UFRkHefDRBMOG2Tu9/kQCZk3taaQP9rhw
# z2Lo9VFKeHk2eie38+dSn5On7UOee+e03UEiifuHokYDTvz0/rdkd2NfI1Jpg4L6
# GlPtkMyNoRdzDfTzZTlwS/Oc1np72gy8PTLQG8v1Yfx1CAB2vIEO+MDhXM/EEXLn
# G2RJ2CKadRVC9S0yOIHa9GCiurRS+1zgYSQlT7LfySmoc0NR2r1j1h9bm/cuG08T
# HfdKDXF+l7f0P4TrweOjSaH6zqe/Vs+6WXZhiV9+p7SOZ3j5NpjhyyjaW4emii8w
# ggUxMIIEGaADAgECAhAKoSXW1jIbfkHkBdo2l8IVMA0GCSqGSIb3DQEBCwUAMGUx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9v
# dCBDQTAeFw0xNjAxMDcxMjAwMDBaFw0zMTAxMDcxMjAwMDBaMHIxCzAJBgNVBAYT
# AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2Vy
# dC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3Rh
# bXBpbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC90DLuS82P
# f92puoKZxTlUKFe2I0rEDgdFM1EQfdD5fU1ofue2oPSNs4jkl79jIZCYvxO8V9PD
# 4X4I1moUADj3Lh477sym9jJZ/l9lP+Cb6+NGRwYaVX4LJ37AovWg4N4iPw7/fpX7
# 86O6Ij4YrBHk8JkDbTuFfAnT7l3ImgtU46gJcWvgzyIQD3XPcXJOCq3fQDpct1Hh
# oXkUxk0kIzBdvOw8YGqsLwfM/fDqR9mIUF79Zm5WYScpiYRR5oLnRlD9lCosp+R1
# PrqYD4R/nzEU1q3V8mTLex4F0IQZchfxFwbvPc3WTe8GQv2iUypPhR3EHTyvz9qs
# EPXdrKzpVv+TAgMBAAGjggHOMIIByjAdBgNVHQ4EFgQU9LbhIB3+Ka7S5GGlsqIl
# ssgXNW4wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wEgYDVR0TAQH/
# BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwgw
# eQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2Vy
# dC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9E
# aWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0
# dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5j
# cmwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3Vy
# ZWRJRFJvb3RDQS5jcmwwUAYDVR0gBEkwRzA4BgpghkgBhv1sAAIEMCowKAYIKwYB
# BQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCwYJYIZIAYb9bAcB
# MA0GCSqGSIb3DQEBCwUAA4IBAQBxlRLpUYdWac3v3dp8qmN6s3jPBjdAhO9LhL/K
# zwMC/cWnww4gQiyvd/MrHwwhWiq3BTQdaq6Z+CeiZr8JqmDfdqQ6kw/4stHYfBli
# 6F6CJR7Euhx7LCHi1lssFDVDBGiy23UC4HLHmNY8ZOUfSBAYX4k4YU1iRiSHY4yR
# UiyvKYnleB/WCxSlgNcSR3CzddWThZN+tpJn+1Nhiaj1a5bA9FhpDXzIAbG5KHW3
# mWOFIoxhynmUfln8jA/jb7UBJrZspe6HUSHkWGCbugwtK22ixH67xCUrRwIIfEmu
# E7bhfEJCKMYYVs9BNLZmXbZ0e/VWMyIvIjayS6JKldj1po5SMYIChjCCAoICAQEw
# gYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UE
# CxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1
# cmVkIElEIFRpbWVzdGFtcGluZyBDQQIQDUJK4L46iP9gQCHOFADw3TANBglghkgB
# ZQMEAgEFAKCB0TAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcN
# AQkFMQ8XDTIyMDIyODIyMTYxM1owKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQU4deC
# qOGRvu9ryhaRtaq0lKYkm/MwLwYJKoZIhvcNAQkEMSIEIHTAz/4w8fg/hDNP8SgI
# WMG+UBYFFklT1b2UvMv00EkuMDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEILMQkAa8
# CtmDB5FXKeBEA0Fcg+MpK2FPJpZMjTVx7PWpMA0GCSqGSIb3DQEBAQUABIIBALze
# DQxCs9qQ9H9sYDM181aEzfn0tRmW9c+cE6z8hJClhZAE6/7v/m3TvwIfHvNYD5uW
# //yCVoYxvjQzJdtyPWyNCGpGhqIjamflH6XLlbGGR5QClThlO5uAlWWXn0irZizW
# rJIW3MHTf6SuNIm4Ex7ujCCD20yoNaVsa/1ffpIxOXa6Z+8442j87wEHBF4pIUnk
# 0XxGIWp4r5gflqEVvwtdjyUPtDts4rGb3J2UzecfONbKknGOW+5GjBU3hSGzw6ls
# T+usj1/Zsmi1juZhrU6yLD2ZwJSN3zscoC+TG7Wr2iXRuTFKp8T8x3Uci1aCVwKT
# wHbgh4/75jAENymM9D8=
# SIG # End signature block
