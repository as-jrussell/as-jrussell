#
# Module manifest for module 'AWS.Tools.RDS'
#

@{
    # Script module or binary module file associated with this manifest
    RootModule = 'AWS.Tools.RDS.dll'

    # Supported PSEditions
    CompatiblePSEditions = @('Core', 'Desktop')

    # Version number of this module.
    ModuleVersion = '4.1.326'

    # ID used to uniquely identify this module
    GUID = 'c444a7d7-a916-407d-b56f-43e38c2b1365'

    # Author of this module
    Author = 'Amazon.com, Inc'

    # Company or vendor of this module
    CompanyName = 'Amazon.com, Inc'

    # Copyright statement for this module
    Copyright = 'Copyright 2012-2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.'

    # Description of the functionality provided by this module
    Description = 'The RDS module of AWS Tools for PowerShell lets developers and administrators manage Amazon Relational Database Service from the PowerShell scripting environment. In order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows PowerShell, .NET Framework 4.7.2 or newer is required. Alternative modules AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a single module and also support older versions of Windows PowerShell and .NET Framework.'

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
            ModuleName = 'AWS.Tools.Common';
            RequiredVersion = '4.1.326';
            Guid = 'e5b05bf3-9eee-47b2-81f2-41ddc0501b86' }
    )

    # Assemblies that must be loaded prior to importing this module.
    RequiredAssemblies = @(
        'AWSSDK.RDS.dll'
    )

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess = @(

    )

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @(

    )

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @(
        'AWS.Tools.RDS.Format.ps1xml'
    )

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules = @(
        'AWS.Tools.RDS.Completers.psm1',
        'AWS.Tools.RDS.Aliases.psm1'
    )

    # Functions to export from this module
    FunctionsToExport = ''

    # Cmdlets to export from this module
    CmdletsToExport = @(
        'Add-RDSRoleToDBCluster', 
        'Add-RDSRoleToDBInstance', 
        'Add-RDSSourceIdentifierToSubscription', 
        'Add-RDSTagsToResource', 
        'Convert-RDSReadReplicaDBCluster', 
        'Convert-RDSReadReplicaToNewPrimary', 
        'Convert-RDSReadReplicaToStandalone', 
        'Copy-RDSDBClusterParameterGroup', 
        'Copy-RDSDBClusterSnapshot', 
        'Copy-RDSDBParameterGroup', 
        'Copy-RDSDBSnapshot', 
        'Copy-RDSOptionGroup', 
        'Edit-RDSActivityStream', 
        'Edit-RDSCertificate', 
        'Edit-RDSCurrentDBClusterCapacity', 
        'Edit-RDSCustomDBEngineVersion', 
        'Edit-RDSDBCluster', 
        'Edit-RDSDBClusterEndpoint', 
        'Edit-RDSDBClusterParameterGroup', 
        'Edit-RDSDBClusterSnapshotAttribute', 
        'Edit-RDSDBInstance', 
        'Edit-RDSDBParameterGroup', 
        'Edit-RDSDBProxy', 
        'Edit-RDSDBProxyEndpoint', 
        'Edit-RDSDBProxyTargetGroup', 
        'Edit-RDSDBSnapshot', 
        'Edit-RDSDBSnapshotAttribute', 
        'Edit-RDSDBSubnetGroup', 
        'Edit-RDSEventSubscription', 
        'Edit-RDSGlobalCluster', 
        'Edit-RDSOptionGroup', 
        'Enable-RDSDBSecurityGroupIngress', 
        'Get-RDSAccountAttribute', 
        'Get-RDSBlueGreenDeployment', 
        'Get-RDSCertificate', 
        'Get-RDSDBCluster', 
        'Get-RDSDBClusterBacktrackList', 
        'Get-RDSDBClusterEndpoint', 
        'Get-RDSDBClusterParameter', 
        'Get-RDSDBClusterParameterGroup', 
        'Get-RDSDBClusterSnapshot', 
        'Get-RDSDBClusterSnapshotAttribute', 
        'Get-RDSDBEngineVersion', 
        'Get-RDSDBInstance', 
        'Get-RDSDBInstanceAutomatedBackup', 
        'Get-RDSDBLogFile', 
        'Get-RDSDBLogFilePortion', 
        'Get-RDSDBParameter', 
        'Get-RDSDBParameterGroup', 
        'Get-RDSDBProxy', 
        'Get-RDSDBProxyEndpoint', 
        'Get-RDSDBProxyTarget', 
        'Get-RDSDBProxyTargetGroup', 
        'Get-RDSDBSecurityGroup', 
        'Get-RDSDBSnapshot', 
        'Get-RDSDBSnapshotAttribute', 
        'Get-RDSDBSubnetGroup', 
        'Get-RDSEngineDefaultClusterParameter', 
        'Get-RDSEngineDefaultParameter', 
        'Get-RDSEvent', 
        'Get-RDSEventCategory', 
        'Get-RDSEventSubscription', 
        'Get-RDSExportTask', 
        'Get-RDSGlobalCluster', 
        'Get-RDSOptionGroup', 
        'Get-RDSOptionGroupOption', 
        'Get-RDSOrderableDBInstanceOption', 
        'Get-RDSPendingMaintenanceAction', 
        'Get-RDSReservedDBInstance', 
        'Get-RDSReservedDBInstancesOfferingList', 
        'Get-RDSSourceRegion', 
        'Get-RDSTagForResource', 
        'Get-RDSValidDBInstanceModification', 
        'New-RDSBlueGreenDeployment', 
        'New-RDSCustomDBEngineVersion', 
        'New-RDSDBCluster', 
        'New-RDSDBClusterEndpoint', 
        'New-RDSDBClusterParameterGroup', 
        'New-RDSDBClusterSnapshot', 
        'New-RDSDBInstance', 
        'New-RDSDBInstanceReadReplica', 
        'New-RDSDBParameterGroup', 
        'New-RDSDBProxy', 
        'New-RDSDBProxyEndpoint', 
        'New-RDSDBSecurityGroup', 
        'New-RDSDBSnapshot', 
        'New-RDSDBSubnetGroup', 
        'New-RDSEventSubscription', 
        'New-RDSGlobalCluster', 
        'New-RDSOptionGroup', 
        'New-RDSReservedDBInstancesOfferingPurchase', 
        'Register-RDSDBProxyTarget', 
        'Remove-RDSBlueGreenDeployment', 
        'Remove-RDSCustomDBEngineVersion', 
        'Remove-RDSDBCluster', 
        'Remove-RDSDBClusterEndpoint', 
        'Remove-RDSDBClusterParameterGroup', 
        'Remove-RDSDBClusterSnapshot', 
        'Remove-RDSDBInstance', 
        'Remove-RDSDBInstanceAutomatedBackup', 
        'Remove-RDSDBParameterGroup', 
        'Remove-RDSDBProxy', 
        'Remove-RDSDBProxyEndpoint', 
        'Remove-RDSDBSecurityGroup', 
        'Remove-RDSDBSnapshot', 
        'Remove-RDSDBSubnetGroup', 
        'Remove-RDSEventSubscription', 
        'Remove-RDSFromGlobalCluster', 
        'Remove-RDSGlobalCluster', 
        'Remove-RDSOptionGroup', 
        'Remove-RDSRoleFromDBCluster', 
        'Remove-RDSRoleFromDBInstance', 
        'Remove-RDSSourceIdentifierFromSubscription', 
        'Remove-RDSTagFromResource', 
        'Reset-RDSDBCluster', 
        'Reset-RDSDBClusterParameterGroup', 
        'Reset-RDSDBParameterGroup', 
        'Restart-RDSDBCluster', 
        'Restart-RDSDBInstance', 
        'Restore-RDSDBClusterFromS3', 
        'Restore-RDSDBClusterFromSnapshot', 
        'Restore-RDSDBClusterToPointInTime', 
        'Restore-RDSDBInstanceFromDBSnapshot', 
        'Restore-RDSDBInstanceFromS3', 
        'Restore-RDSDBInstanceToPointInTime', 
        'Revoke-RDSDBSecurityGroupIngress', 
        'Start-RDSActivityStream', 
        'Start-RDSDBCluster', 
        'Start-RDSDBClusterFailover', 
        'Start-RDSDBInstance', 
        'Start-RDSDBInstanceAutomatedBackupsReplication', 
        'Start-RDSExportTask', 
        'Start-RDSFailoverGlobalCluster', 
        'Stop-RDSActivityStream', 
        'Stop-RDSDBCluster', 
        'Stop-RDSDBInstance', 
        'Stop-RDSDBInstanceAutomatedBackupsReplication', 
        'Stop-RDSExportTask', 
        'Submit-RDSPendingMaintenanceAction', 
        'Switch-RDSBlueGreenDeployment', 
        'Unregister-RDSDBProxyTarget')

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport = @(
        'Get-RDSAccountAttributes', 
        'Get-RDSCertificates', 
        'Get-RDSDBLogFiles', 
        'Get-RDSDBSnapshotAttributes', 
        'Get-RDSEventCategories', 
        'Get-RDSEventSubscriptions', 
        'Get-RDSPendingMaintenanceActions', 
        'Get-RDSReservedDBInstancesOfferings', 
        'Get-RDSReservedDBInstancesOffering')

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @(
        'AWS.Tools.RDS.dll-Help.xml'
    )

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
# MIIurwYJKoZIhvcNAQcCoIIuoDCCLpwCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCACXS2qxRH9Gz+Y
# PUdvrWxlNkdG40OYjn5Be4A0k9ag0aCCFB0wggXAMIIEqKADAgECAhAP0bvKeWvX
# +N1MguEKmpYxMA0GCSqGSIb3DQEBCwUAMGwxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xKzApBgNV
# BAMTIkRpZ2lDZXJ0IEhpZ2ggQXNzdXJhbmNlIEVWIFJvb3QgQ0EwHhcNMjIwMTEz
# MDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
# RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQD
# ExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aa
# za57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllV
# cq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT
# +CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd
# 463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+
# EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92k
# J7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5j
# rubU75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7
# f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJU
# KSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYiCd98THU/Y+wh
# X8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQAB
# o4IBZjCCAWIwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5n
# P+e6mK4cD08wHwYDVR0jBBgwFoAUsT7DaQP4v0cB1JgmGggC72NkK8MwDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMH8GCCsGAQUFBwEBBHMwcTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEkGCCsGAQUFBzAC
# hj1odHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRIaWdoQXNzdXJh
# bmNlRVZSb290Q0EuY3J0MEsGA1UdHwREMEIwQKA+oDyGOmh0dHA6Ly9jcmwzLmRp
# Z2ljZXJ0LmNvbS9EaWdpQ2VydEhpZ2hBc3N1cmFuY2VFVlJvb3RDQS5jcmwwHAYD
# VR0gBBUwEzAHBgVngQwBAzAIBgZngQwBBAEwDQYJKoZIhvcNAQELBQADggEBAEHx
# qRH0DxNHecllao3A7pgEpMbjDPKisedfYk/ak1k2zfIe4R7sD+EbP5HU5A/C5pg0
# /xkPZigfT2IxpCrhKhO61z7H0ZL+q93fqpgzRh9Onr3g7QdG64AupP2uU7SkwaT1
# IY1rzAGt9Rnu15ClMlIr28xzDxj4+87eg3Gn77tRWwR2L62t0+od/P1Tk+WMieNg
# GbngLyOOLFxJy34riDkruQZhiPOuAnZ2dMFkkbiJUZflhX0901emWG4f7vtpYeJa
# 3Cgh6GO6Ps9W7Zrk9wXqyvPsEt84zdp7PiuTUy9cUQBY3pBIowrHC/Q7bVUx8ALM
# R3eWUaNetbxcyEMRoacwggawMIIEmKADAgECAhAIrUCyYNKcTJ9ezam9k67ZMA0G
# CSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0zNjA0MjgyMzU5NTla
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDVtC9C
# 0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0JAfhS0/TeEP0F9ce
# 2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJrQ5qZ8sU7H/Lvy0da
# E6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhFLqGfLOEYwhrMxe6T
# SXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+FLEikVoQ11vkunKoA
# FdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh3K3kGKDYwSNHR7Oh
# D26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJwZPt4bRc4G/rJvmM
# 1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQayg9Rc9hUZTO1i4F4z
# 8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbIYViY9XwCFjyDKK05
# huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchApQfDVxW0mdmgRQRNY
# mtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRroOBl8ZhzNeDhFMJlP
# /2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IBWTCCAVUwEgYDVR0T
# AQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHwYD
# VR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNV
# HR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRU
# cnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAEDMAgGBmeBDAEEATAN
# BgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql+Eg08yy25nRm95Ry
# sQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFFUP2cvbaF4HZ+N3HL
# IvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1hmYFW9snjdufE5Btf
# Q/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3RywYFzzDaju4ImhvTnh
# OE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5UbdldAhQfQDN8A+KVssIh
# dXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw8MzK7/0pNVwfiThV
# 9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnPLqR0kq3bPKSchh/j
# wVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatEQOON8BUozu3xGFYH
# Ki8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bnKD+sEq6lLyJsQfmC
# XBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQjiWQ1tygVQK+pKHJ6l
# /aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbqyK+p/pQd52MbOoZW
# eE4wggehMIIFiaADAgECAhAFSBlU0HcFPwxIHXZupwTGMA0GCSqGSIb3DQEBCwUA
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwHhcNMjIxMTA1MDAwMDAwWhcNMjMxMTA4MjM1OTU5WjCB9jET
# MBEGCysGAQQBgjc8AgEDEwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEd
# MBsGA1UEDwwUUHJpdmF0ZSBPcmdhbml6YXRpb24xEDAOBgNVBAUTBzQxNTI5NTQx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdTZWF0
# dGxlMSIwIAYDVQQKExlBbWF6b24gV2ViIFNlcnZpY2VzLCBJbmMuMRcwFQYDVQQL
# Ew5TREtzIGFuZCBUb29sczEiMCAGA1UEAxMZQW1hem9uIFdlYiBTZXJ2aWNlcywg
# SW5jLjCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAK9vDmDGSnY2lXZ9
# nlp41y3ArsYpOy2oaM0TjFdorTVku7toW9HYNr41iEQIS5edE5DJ4mjCE9PSiinq
# eJArM66qMPhQJyl5NrumlY3jVy3EZSSlKt9H9+aCnF/7ku1CjHZ7d8+B6Pqw4RfB
# S8PZ7dH85hih3VIPzpd8r/5pIBO2mw+MaPLhOFycmloGX4l/6RO41FYYFVV4klpc
# bmU+5meN/7mhGtdBPGte7G+4IVF2v8ZxRiCIP+MvSC8LCJYXUNWt4LQ2nXPmbA4U
# lb0MlJA1IxkXZ2uY6Hi62MOf4JQvnEjFO5YKS/ie6fRZ/hnjGCyfHA/2cLDJaJv9
# JleODk1W/0D2pOOx9yQyvv1UM6C9I/tvqEc98xzWQALRviag5ic1DPJtXzbOXX3K
# zhOsUInCj0xgVM+nBPXy83GyPx/p8tbcFQMryG2dJ7sKNWheNwB96dMAumysQhcH
# Gk8dGH6WUHTR2JcqpueGAU+tQo4ZWJCcsvV3GlZe9kDjs1dTuQIDAQABo4ICNTCC
# AjEwHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHQYDVR0OBBYEFFvU
# mCXQMox/7R+rB702j2AeTZleMC4GA1UdEQQnMCWgIwYIKwYBBQUHCAOgFzAVDBNV
# Uy1ERUxBV0FSRS00MTUyOTU0MA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr
# BgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8vY3JsMy5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEzODQy
# MDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmww
# PQYDVR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIBFhtodHRwOi8vd3d3LmRp
# Z2ljZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGEMCQGCCsGAQUFBzABhhho
# dHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUHMAKGUGh0dHA6Ly9jYWNl
# cnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVTaWduaW5nUlNB
# NDA5NlNIQTM4NDIwMjFDQTEuY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEL
# BQADggIBAA7jihh1yfeO45MthV2/e0v5qB8DrSM4knVgPLryRTp6fQuPxjNAbD6t
# k++ZW3zUzIQIak7S4pMOkRqucyooSxNhbVdKsWzCEHYtv1Yt0g/E6n+8ghZhW4b8
# m9kMmK/K9thjKZ6EQBaPLY2a5VV7dH8EYcu4Y8THocdpFlAgyu06oUmAnq7Ue/Q+
# mQls5A4mDS5w1NO9gmVz9DtytAnhY8Tjk4cpfSP86ZSckWutesy3WpTwVG6e0BOZ
# tRFmC14mT7cb02ZGBuz8lIbK/KHCNptEVA18OJxGrRat/k4GHxmynfioKN5Ji+xd
# H+nMkpbeLJBnm1Nx9OztEtnEX9zrv2pzu6axZwRYOo8EBYZs4sG/MQk+tg1ST4or
# 5LBNTMVG3L2o5R1b4VjybSASS3DSnOdQbOcjtCZS73ShQHffObCqqlJVB3nvgknK
# 0aq64XVQElgbTbZBu1aL83VtKkBKAlu1e1euPrJISYgJhKDBlvGT/Fs9WoDUWOzP
# R2FDxa8KyXsfnrkRXEiDxOTHa5rNtKwjPcn2Hgm8bWEBzlPuegGqpHfE36elwEJC
# 9aIA9m5XGvfuKshHs54jNuVU4OPhQJIk0Hux5zJWnezYdM+q0AhkH2wHqt0ogeD4
# U+sHoe1KClFclVFNKrpdlO2BSIxlQiInW0UL06RqqwcpLHGtFqnxMYIZ6DCCGeQC
# AQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/
# BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWduaW5nIFJTQTQwOTYg
# U0hBMzg0IDIwMjEgQ0ExAhAFSBlU0HcFPwxIHXZupwTGMA0GCWCGSAFlAwQCAQUA
# oHwwEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIDOW
# zv5cRnCrAEd8lPd1JDbSp2m4z18mRtuNWL0Liv35MA0GCSqGSIb3DQEBAQUABIIB
# gEFucs4Yu0GSOxyYe2KT8Se7nshGSPT/kUZXQuGpqQLPJat8JQ6eAanWJxJh3Q/x
# 6XzhBGGgtbAuvrIt/wP31pRsvNQHdu5yAOV0+1gaU+nhqSGeg/jlTieiIKhtBCAH
# 0dLY7J1zSGkaLDgsZrIVjAZ+P5lGeutFujS8UBNzYygasqvaE5Vtkb15MjpeYglU
# ViiKrr/UsSCkbNku4l41RpvazyN0a8OKotP6YSSSWyKyqVpSEM8bnlSrPmdNGjQ8
# O+Tb7+HZUg8zAtltIkky88k9yoexeCrjyLdOFvWGannNk8tcfde1OMji1YzxaID2
# WfYz0MjrR/Mnt0XVJHjnpYr35d9OfSIwB/LsZ+d0qh6i2Nh88n9kCZxtPcL19WsJ
# 0GXjVjWYEyR8HLoMmvV2mZmuvQD3VUp6z5QctZNgoV+yBM+/C9Ppv24nOadprL/v
# mRBea8Pbselhh3Q1n2GP50XVobB4pFdZCDVFoeBjSvqf6/i3sDhRnPak1xHo1zW9
# 2KGCFz4wghc6BgorBgEEAYI3AwMBMYIXKjCCFyYGCSqGSIb3DQEHAqCCFxcwghcT
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAweAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCAt0infG5fVLxTLyLuRRE5ZYNKHpnAT
# 1+0hsz3CXAGpGgIRAI6nr9JcjWC6Gwzy8ig297oYDzIwMjMwNTAzMjE0NzE0WqCC
# EwcwggbAMIIEqKADAgECAhAMTWlyS5T6PCpKPSkHgD1aMA0GCSqGSIb3DQEBCwUA
# MGMxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UE
# AxMyRGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBp
# bmcgQ0EwHhcNMjIwOTIxMDAwMDAwWhcNMzMxMTIxMjM1OTU5WjBGMQswCQYDVQQG
# EwJVUzERMA8GA1UEChMIRGlnaUNlcnQxJDAiBgNVBAMTG0RpZ2lDZXJ0IFRpbWVz
# dGFtcCAyMDIyIC0gMjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAM/s
# pSY6xqnya7uNwQ2a26HoFIV0MxomrNAcVR4eNm28klUMYfSdCXc9FZYIL2tkpP0G
# gxbXkZI4HDEClvtysZc6Va8z7GGK6aYo25BjXL2JU+A6LYyHQq4mpOS7eHi5ehbh
# VsbAumRTuyoW51BIu4hpDIjG8b7gL307scpTjUCDHufLckkoHkyAHoVW54Xt8mG8
# qjoHffarbuVm3eJc9S/tjdRNlYRo44DLannR0hCRRinrPibytIzNTLlmyLuqUDgN
# 5YyUXRlav/V7QG5vFqianJVHhoV5PgxeZowaCiS+nKrSnLb3T254xCg/oxwPUAY3
# ugjZNaa1Htp4WB056PhMkRCWfk3h3cKtpX74LRsf7CtGGKMZ9jn39cFPcS6JAxGi
# S7uYv/pP5Hs27wZE5FX/NurlfDHn88JSxOYWe1p+pSVz28BqmSEtY+VZ9U0vkB8n
# t9KrFOU4ZodRCGv7U0M50GT6Vs/g9ArmFG1keLuY/ZTDcyHzL8IuINeBrNPxB9Th
# vdldS24xlCmL5kGkZZTAWOXlLimQprdhZPrZIGwYUWC6poEPCSVT8b876asHDmoH
# OWIZydaFfxPZjXnPYsXs4Xu5zGcTB5rBeO3GiMiwbjJ5xwtZg43G7vUsfHuOy2SJ
# 8bHEuOdTXl9V0n0ZKVkDTvpd6kVzHIR+187i1Dp3AgMBAAGjggGLMIIBhzAOBgNV
# HQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwHwYDVR0jBBgwFoAU
# uhbZbU2FL3MpdpovdYxqII+eyG8wHQYDVR0OBBYEFGKK3tBh/I8xFO2XC809KpQU
# 31KcMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9E
# aWdpQ2VydFRydXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdDQS5jcmww
# gZAGCCsGAQUFBwEBBIGDMIGAMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wWAYIKwYBBQUHMAKGTGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydFRydXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdDQS5j
# cnQwDQYJKoZIhvcNAQELBQADggIBAFWqKhrzRvN4Vzcw/HXjT9aFI/H8+ZU5myXm
# 93KKmMN31GT8Ffs2wklRLHiIY1UJRjkA/GnUypsp+6M/wMkAmxMdsJiJ3HjyzXyF
# zVOdr2LiYWajFCpFh0qYQitQ/Bu1nggwCfrkLdcJiXn5CeaIzn0buGqim8FTYAno
# o7id160fHLjsmEHw9g6A++T/350Qp+sAul9Kjxo6UrTqvwlJFTU2WZoPVNKyG39+
# XgmtdlSKdG3K0gVnK3br/5iyJpU4GYhEFOUKWaJr5yI+RCHSPxzAm+18SLLYkgyR
# TzxmlK9dAlPrnuKe5NMfhgFknADC6Vp0dQ094XmIvxwBl8kZI4DXNlpflhaxYwzG
# RkA7zl011Fk+Q5oYrsPJy8P7mxNfarXH4PMFw1nfJ2Ir3kHJU7n/NBBn9iYymHv+
# XEKUgZSCnawKi8ZLFUrTmJBFYDOA4CPe+AOk9kVH5c64A0JH6EE2cXet/aLol3RO
# LtoeHYxayB6a1cLwxiKoT5u92ByaUcQvmvZfpyeXupYuhVfAYOd4Vn9q78KVmksR
# AsiCnMkaBXy6cbVOepls9Oie1FqYyJ+/jbsYXEP10Cro4mLueATbvdH7WwqocH7w
# l4R44wgDXUcsY6glOJcB0j862uXl9uab3H4szP8XTE0AotjWAQ64i+7m4HJViSwn
# GWH2dwGMMIIGrjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzANBgkqhkiG9w0B
# AQsFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVk
# IFJvb3QgRzQwHhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5WjBjMQswCQYD
# VQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lD
# ZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1ySVFVxyUDxPKR
# N6mXUaHW0oPRnkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50fng8zH1ATCyZz
# lm34V6gCff1DtITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW1Oco
# LevTsbV15x8GZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12sy+iEZLRS8nZH
# 92GDGd1ftFQLIWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYNXNXmG6jBZHRA
# p8ByxbpOH7G1WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCYJn+g
# GkcgQ+NDY4B7dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucfWmyU
# 8lKVEStYdEAoq3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLcGEh/
# FDTP0kyr75s9/g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixXNXkrqPNFYLwj
# jVj33GHek/45wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtbiiKowSYI+RQQ
# EgN9XyO7ZONj4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O6V3IXjASvUae
# tdN2udIOa5kM0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAw
# HQYDVR0OBBYEFLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX44LS
# cV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEF
# BQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRp
# Z2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYy
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5j
# cmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEB
# CwUAA4ICAQB9WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJLKftw
# ig2qKWn8acHPHQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExiHQwIgqgWvalW
# zxVzjQEiJc6VaT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2MvGQm
# h2ySvZ180HAKfO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj+sAngkSumScb
# qyQeJsG33irr9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJxLaf
# zYeHJLtPo0m5d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZJyw9P2un8WbD
# Qc1PtkCbISFA0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SVe+0K
# XzM5h0F4ejjpnOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228Vex4Ziza4k9Tm
# 8heZWcpw8De/mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJDwq9
# gdkT/r+k0fNX2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr5n8a
# pIUP/JiW9lVUKx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8/DCCBY0wggR1
# oAMCAQICEA6bGI750C3n79tQ4ghAGFowDQYJKoZIhvcNAQEMBQAwZTELMAkGA1UE
# BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2lj
# ZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4X
# DTIyMDgwMTAwMDAwMFoXDTMxMTEwOTIzNTk1OVowYjELMAkGA1UEBhMCVVMxFTAT
# BgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEh
# MB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0MIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAv+aQc2jeu+RdSjwwIjBpM+zCpyUuySE98orYWcLh
# Kac9WKt2ms2uexuEDcQwH/MbpDgW61bGl20dq7J58soR0uRf1gU8Ug9SH8aeFaV+
# vp+pVxZZVXKvaJNwwrK6dZlqczKU0RBEEC7fgvMHhOZ0O21x4i0MG+4g1ckgHWMp
# Lc7sXk7Ik/ghYZs06wXGXuxbGrzryc/NrDRAX7F6Zu53yEioZldXn1RYjgwrt0+n
# MNlW7sp7XeOtyU9e5TXnMcvak17cjo+A2raRmECQecN4x7axxLVqGDgDEI3Y1Dek
# LgV9iPWCPhCRcKtVgkEy19sEcypukQF8IUzUvK4bA3VdeGbZOjFEmjNAvwjXWkmk
# wuapoGfdpCe8oU85tRFYF/ckXEaPZPfBaYh2mHY9WV1CdoeJl2l6SPDgohIbZpp0
# yt5LHucOY67m1O+SkjqePdwA5EUlibaaRBkrfsCUtNJhbesz2cXfSwQAzH0clcOP
# 9yGyshG3u3/y1YxwLEFgqrFjGESVGnZifvaAsPvoZKYz0YkH4b235kOkGLimdwHh
# D5QMIR2yVCkliWzlDlJRR3S+Jqy2QXXeeqxfjT/JvNNBERJb5RBQ6zHFynIWIgnf
# fEx1P2PsIV/EIFFrb7GrhotPwtZFX50g/KEexcCPorF+CiaZ9eRpL5gdLfXZqbId
# 5RsCAwEAAaOCATowggE2MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFOzX44LS
# cV1kTN8uZz/nupiuHA9PMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgP
# MA4GA1UdDwEB/wQEAwIBhjB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0
# dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2Vy
# dHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDBFBgNV
# HR8EPjA8MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRB
# c3N1cmVkSURSb290Q0EuY3JsMBEGA1UdIAQKMAgwBgYEVR0gADANBgkqhkiG9w0B
# AQwFAAOCAQEAcKC/Q1xV5zhfoKN0Gz22Ftf3v1cHvZqsoYcs7IVeqRq7IviHGmlU
# Iu2kiHdtvRoU9BNKei8ttzjv9P+Aufih9/Jy3iS8UgPITtAq3votVs/59PesMHqa
# i7Je1M/RQ0SbQyHrlnKhSLSZy51PpwYDE3cnRNTnf+hZqPC/Lwum6fI0POz3A8eH
# qNJMQBk1RmppVLC4oVaO7KTVPeix3P0c2PR3WlxUjG/voVA9/HYJaISfb8rbII01
# YBwCA8sgsKxYoA5AY8WYIsGyWfVVa88nq2x2zm8jLfR+cWojayL/ErhULSd+2DrZ
# 8LaHlv1b0VysGMNNn3O3AamfV6peKOK5lDGCA3YwggNyAgEBMHcwYzELMAkGA1UE
# BhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2Vy
# dCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQQIQDE1p
# ckuU+jwqSj0pB4A9WjANBglghkgBZQMEAgEFAKCB0TAaBgkqhkiG9w0BCQMxDQYL
# KoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIzMDUwMzIxNDcxNFowKwYLKoZI
# hvcNAQkQAgwxHDAaMBgwFgQU84ciTYYzgpI1qZS8vY+W6f4cfHMwLwYJKoZIhvcN
# AQkEMSIEIHkVzSo1cwXL8s0sLHExn4b7x8sIculPA2030P8j2NMJMDcGCyqGSIb3
# DQEJEAIvMSgwJjAkMCIEIMf04b4yKIkgq+ImOr4axPxP5ngcLWTQTIB1V6Ajtbb6
# MA0GCSqGSIb3DQEBAQUABIICAG/FUeSC8KHEZU9U7bEIqmyanJFNFGmMdvS1gfUs
# goLsi057sPVbp+pqQItaQhK6fNXO8gaxJ/vRwPuIBPjV/2bM8kLmo75h7egz7jjv
# PTT6dZv/ckpCbN1DNgU9hhtqeUr/JYy4w5eros3+hffk12koILakafJanDlPqUvH
# THeEaLBqsX+GdK4UO0/avJJTgiPYP2cP87kymH9cC56HQHR2pkqnSIR5X7tPWkTE
# aiTp7oDyO3vH82JZe9r4K6RDkboCCat2J3NzGXBLG/r7unoYePSzh/n8kDNHwO8c
# 3wnQkxQT+jrFTZAa3iHMFUtLMsOYIOukoeMEm9DB0hQ+E2kENMPn0Hrmsq8ShREK
# liRJfJX/975srXkCwdnCR7Eo5ZQoT6siymkLszeE24+v7A9u1sBscaog9h/U6FpL
# B1mjw8XpOAK3WjXxboAeO5n1P1Fg9MvqlepObvMMW1a1d8Xe2WDbK0L+m8RfCJ22
# IYjSIGIfOalErfcRVhHALbaPhZVPZ2HiDTEUw4iuXY3DDTANVf/1K0J5qe4hWSXL
# 4BQ1s2kqdfM5riBuuLwyc7xG/mfy+Y1k6Zz/n2MSepHv8VAosMCJ2p8LtY2fSIvv
# ON83g+fU2up/4ZVVG3UwMdL+ONelYO2pnAFBKV1CG3R3C7Fg2p2yEqyt1R/cIwkG
# 5nvn
# SIG # End signature block
