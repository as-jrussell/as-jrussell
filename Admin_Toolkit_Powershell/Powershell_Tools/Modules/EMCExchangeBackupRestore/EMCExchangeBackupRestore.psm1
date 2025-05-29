# $Id: //NW/dev/appagents_dev/nsr/nmmclient/ExchangeBackupRestoreCmdlet/MountBackup/MountBackupCmdlet.cs#1 $ Copyright (c) 2016-2019 EMC Corporation */

# Copyright (c) 2016-2019 EMC Corporation.
#
# All rights reserved.  This is an UNPUBLISHED work, and
# comprises proprietary and confidential information of EMC.
# Unauthorized use, disclosure, and distribution are strictly
# prohibited.  Use, duplication, or disclosure of the software
# and documentation by the U.S. Government is subject to
# restrictions set forth in a license agreement between the
# Government and EMC or other written agreement specifying
# the Government's rights to use the software and any applicable
# FAR provisions, such as FAR 52.227-19.

# Aliases for the EMC commands.

Function Invoke-RestoreExchangeBackup
{
    <#
    .SYNOPSIS
    Performs necessary database dismount and volume offline operations before invoking Restore-ExchangeBackup -RollbackRestore.

    .DESCRIPTION
    The Invoke-RestoreExchangeBackup will perform the following operations before invoking Restore-ExchangeBackup -RollbackRestore:
     * Verify that all databases have 'overwrite' set.
     * Dismount all databases.

    Following the restore, the databases are mounted.

    .PARAMETER backup
    A backup from Get-ExchangeBackup or Backup-Exchange.

    .PARAMETER serverinfo
    An object containing appropriate option values for Restore-ExchangeBackup.

    .LINK
    Backup-Exchange
    Dismount-ExchangeBackupMount
    Get-ExchangeBackup
    Get-ExchangeBackupMount
    Mount-ExchangeBackup
    Remove-ExchangeBackup
    Restore-ExchangeBackup
    Import-ExchangeBackupConfigFile

    .EXAMPLE
    Invoke-RestoreExchangeBackup $backup $serverinfo

    Restore an Exchange backup previously retrieved by Get-ExchangeBackup.

    .NOTES
    This command will be obsolete in a future release when Restore-ExchangeBackup fully supports multi-database rollback restore.
    #>

    # SupportsShouldProcess=$True enables -WhatIf processing. This is automatic; no explicit coding is needed for it.
    [cmdletbinding(SupportsShouldProcess=$True)]
    Param(
        [Parameter(Mandatory=$True,Position=1)]
        [EMCExchangeBackupRestore.BackupData.ExchangeBackup]$backup,

        [Parameter(Mandatory=$True,Position=2)]
        [PSCustomObject]$serverinfo
    )

    $firstdb = Get-MailboxDatabase -Identity $backup.BackupDatabases[0].Identity
    if ($firstdb -eq $null) {
        throw "Cannot find database " + $backup.BackupDatabases[0].Identity
    }

    # Scan through all the databases in the backup and verify that they have overwrite set.
    foreach ($backupdb in $backup.BackupDatabases) {
        $db = Get-MailboxDatabase -Identity $backupdb.Identity
        if ($db -eq $null) {
            throw "Cannot find database " + $db.Identity
        }

        if (!$db.AllowFileRestore) {
            # fault
            throw "Database " + $backupdb.Identity + " does not have AllowFileRestore (overwrite) set."
        }
    }

    # Now dismount all databases. Do this after the above loop so that a failure
    # doesn't leave some databases dismounted.
    foreach ($backupdb in $backup.BackupDatabases) {
        if ($pscmdlet.ShouldProcess($backupdb.Identity, "Dismount-Database")) {
            Write-Verbose ("Dismounting " + $backupdb.Identity + ".")
            Dismount-Database -Identity $backupdb.Identity -Confirm:$false
        }
    }

    # Perform the restore. Season to taste.
    if ($pscmdlet.ShouldProcess($firstdb.Identity, "Restore-ExchangeBackup -RollbackRestore")) {
        $serverinfo | Restore-ExchangeBackup -RollbackRestore -Backup $backup -Force
    }

    # Now mount the databases. Note
    # that one - the first - will have been already mounted. Mounting it
    # again is not a problem.
    foreach ($backupdb in $backup.BackupDatabases) {
        if ($pscmdlet.ShouldProcess($backupdb.Identity, "Mount-Database")) {
            Write-Verbose ("Mounting " + $backupdb.Identity + ".")
            Mount-Database -Identity $backupdb.Identity -Confirm:$false
        }
    }
}


function Import-ExchangeBackupConfigFile
{
    <#
    .SYNOPSIS
    Imports a configuration file into an object suitable for piping into other backup and restore commands.

    .DESCRIPTION
    The Import-ExchangeBackupConfigFile will import a configuration file as used by the msagentadmin -z parameter into an object suitable for use by other PowerShell commands.


    .PARAMETER file 
    A configuration file.

    .LINK
    Backup-Exchange
    Dismount-ExchangeBackupMount
    Get-ExchangeBackup
    Get-ExchangeBackupMount
    Mount-ExchangeBackup
    Remove-ExchangeBackup
    Restore-ExchangeBackup
    Invoke-RestoreExchangeBackup

    .EXAMPLE
    $serverinfo = Import-ExchangeBackupConfigFile E:\configuration.txt

    Import a configuration file and store it in $serverinfo.

    Configuration file:

     # Configuration file for my ProtectPoint backup/restore configuration.
     DDBOOST_USER=my_dd_user
     DEVICE_HOST=ddhost.myorg.com
     DEVICE_PATH=/mypath
     LOCKBOX_PATH="C:\Program Files\DPSAPPS\common\lockbox"
     RP_MGMT_HOST=rphost.myorg.com
     RP_USER=my_rp_user
     RESTORE_DEVICE_GROUP=DG_restore_group
     RESTORE_DEVICE_POOL=myhost_restore_pool
     CLIENT=myhost.myorg.com
     DEBUG_LEVEL=9
     BACKUP_TYPE=RecoverPoint
     BACKUP_PREFERENCE=preferred
     SERVER_ORDER_LIST=server_order_list
     INCLUDE_STANDALONE_DATABASES=true
     DEVICE_FC_SERVICE=fibrehost
     DDBOOST_FC=TRUE
     DELETE_DEBUG_LOGS_DAYS=7

    $serverinfo will contain:

     ClientName                 : myhost.myorg.com
     DataDomainHost             : {ddhost.myorg.com}
     DataDomainUser             : {my_dd_user}
     RestoreDeviceGroup         : DG_restore_group
     LockBoxPath                : C:\Program Files\DPSAPPS\common\lockbox
     RestoreDevicePool          : myhost_restore_pool
     DataDomainHostPath         : {/mypath}
     DebugLevel                 : 9
     BackupViaRecoverPoint      : False
     BackupPreferred            : True
     ServerOrderList            : server_order_list
     IncludeStandaloneDatabases : True
     DataDomainFibreChannelHost : fibrehost
     DeleteDebugLogsInDays      : 7

    .EXAMPLE
    $serverinfo = Import-ExchangeBackupConfigFile E:\configuration.txt

    Import a configuration file and store it in $serverinfo.

    Configuration file:

     # Configuration file for my Exchange BBB backup/restore configuration.
     DDBOOST_USER=my_dd_user
     DEVICE_HOST=ddhost.myorg.com
     DEVICE_PATH=/mypath
     LOCKBOX_PATH="C:\Program Files\DPSAPPS\common\lockbox"
     CLIENT=myhost.myorg.com
     DEBUG_LEVEL=9
     BACKUP_PREFERENCE=preferred
     SERVER_ORDER_LIST=server_order_list
     INCLUDE_STANDALONE_DATABASES=true
     DEVICE_FC_SERVICE=fibrehost
     DDBOOST_FC=TRUE
     DELETE_DEBUG_LOGS_DAYS=7

    $serverinfo will contain:

     ClientName                 : myhost.myorg.com
     DataDomainHost             : {ddhost.myorg.com}
     DataDomainUser             : {my_dd_user}
     LockBoxPath                : C:\Program Files\DPSAPPS\common\lockbox
     DataDomainHostPath         : {/mypath}
     DebugLevel                 : 9
     BackupPreferred            : True
     ServerOrderList            : server_order_list
     IncludeStandaloneDatabases : True
     DataDomainFibreChannelHost : fibrehost
     DeleteDebugLogsInDays      : 7

    .EXAMPLE
    $serverinfo = Import-ExchangeBackupConfigFile E:\configuration.txt

    Import a configuration file and store it in $serverinfo.

    Configuration file:

     # Configuration file for my ProtectPoint VMAX backup/restore configuration.
     DDBOOST_USER=my_dd_user
     DEVICE_HOST=ddhost.myorg.com
     DEVICE_PATH=/mypath
     LOCKBOX_PATH="C:\Program Files\DPSAPPS\common\lockbox"
     RESTORE_DEVICE_GROUP=DG_restore_group
     RESTORE_DEVICE_POOL=myhost_restore_pool
     CLIENT=myhost.myorg.com
     DEBUG_LEVEL=9
     BACKUP_TYPE=VMAX
     DEVICE_FC_SERVICE=fibrehost
     DDBOOST_FC=TRUE
     DELETE_DEBUG_LOGS_DAYS=7

    $serverinfo will contain:

     ClientName                 : myhost.myorg.com
     DataDomainHost             : {ddhost.myorg.com}
     DataDomainUser             : {my_dd_user}
     RestoreDeviceGroup         : DG_restore_group
     LockBoxPath                : C:\Program Files\DPSAPPS\common\lockbox
     RestoreDevicePool          : myhost_restore_pool
     DataDomainHostPath         : {/mypath}
     DebugLevel                 : 9
     BackupViaVMAX              : False
     DataDomainFibreChannelHost : fibrehost
     DeleteDebugLogsInDays      : 7

    .NOTES
    The configuration file contains key/value pairs separated by '=' characters.

    Blank lines and lines starting with the '#' character are ignored.

    The following key translations are performed:
     * CLIENT               ClientName
     * DDBOOST_USER         DataDomainUser
     * DDVDISK_USER         DataDomainVDiskUser
     * DEVICE_HOST          DataDomainHost
     * DEVICE_PATH          DataDomainHostPath
     * LOCKBOX_PATH         LockBoxPath
     * RESTORE_DEVICE_GROUP RestoreDeviceGroup
     * RESTORE_DEVICE_POOL  RestoreDevicePool
     * DEBUG_LEVEL          DebugLevel
     * SERVER_ORDER_LIST    ServerOrderList
     * DEVICE_FC_SERVICE    DataDomainFibreChannelHost
     * DM_HOST              EcdmHost
     * DM_USER              EcdmUser
     * DM_TENANT            EcdmTenant
     * DM_PORT              EcdmPort
     * DM_MOUNT_TIMEOUT     EcdmMountTimeout
     * DM_LOG_LEVEL         EcdmLogLevel
     * DM_LOG_TAG           EcdmLogTag
     * DELETE_DEBUG_LOGS_DAYS DeleteDebugLogsInDays
     If BACKUP_TYPE=BBB/BlockBasedBackup
     * BlockBasedBackup     True
     If BACKUP_TYPE=RP/RecoverPoint
     * RecoverPoint         True
     If BACKUP_TYPE=VMAX
     * VMAX                 True
     If BACKUP_PREFERENCE=preferred
     * BackupPreferred     True
     If BACKUP_PREFERENCE=passive
     * BackupPassive       True
     If BACKUP_PREFERENCE=active
     * BackupActive        True
     If INCLUDE_STANDALONE_DATABASES=true
     * IncludeStandaloneDatabases True

     DataDomainUser, DataDomainVDiskUser, DataDomainHost and DataDomainHostPath can appear multiple times
     in the file, and can contain comma-separated lists. Each occurrence is combined into a single
     list, split by commas. Note that this disallows user names, hosts, and paths containing commas
     and spaces as part of the identifier. Quoted strings for these items are also not supported.

     If the DDBOOST_FC is key is present and is not the string "true" (ignoring case), the DataDomainFibreChannelHost key will be removed from the output.

     If the CLIENT or ClientName key is not present, a key with the local host name will be added automatically.

    The output object is created with properties corresponding to the key names after translation, if any.
    #>

    Param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$file
    )

    # Translations for entries in the file. Note that these will be case-insensitive.
    $replace = @{
        "DDBOOST_USER" = "DataDomainUser";
        "DDVDISK_USER" = "DataDomainVDiskUser";
        "DEVICE_HOST"  = "DataDomainHost";
        "DEVICE_PATH"  = "DataDomainHostPath";
        "LOCKBOX_PATH" = "LockBoxPath";
        "CLIENT"       = "ClientName";
        "RESTORE_DEVICE_GROUP" = "RestoreDeviceGroup";
        "RESTORE_DEVICE_POOL" = "RestoreDevicePool";
        "DEBUG_LEVEL"  = "DebugLevel";
        "SERVER_ORDER_LIST"  = "ServerOrderList";
        "DEVICE_FC_SERVICE"  = "DataDomainFibreChannelHost";
        "DM_HOST" = "EcdmHost";
        "DM_USER" = "EcdmUser";
        "DM_TENANT" = "EcdmTenant";
        "DM_PORT" = "EcdmPort";
        "DM_MOUNT_TIMEOUT" = "EcdmMountTimeout";
        "DM_LOG_LEVEL" = "EcdmLogLevel";
        "DM_LOG_TAG" = "EcdmLogTag";
        "DELETE_DEBUG_LOGS_DAYS" = "DeleteDebugLogsInDays";
    }

    $hash = @{}

    # Read the file as an array of text lines;
    # exclude blank lines and lines that start with # (can have whitespace before the '#')
    # convert from CSV with a delimiter of '=' (splits into key/value pairs);
    # for each converted line, translate the key if required and store in the hash.

    # The four Data Domain parameters are arrays. This needs to be handled specially;
    # this code will accept both multiple occurrences of the entry in the file
    # and comma-separated lists. It does not, currently, handle situations where
    # the identifier, such as the user name, contains a comma or whitespace.

    (Get-Content -Path $file) -NotMatch '^\s*$' -NotMatch '^\s*#' |
         ConvertFrom-Csv -Header key,value -Delimiter '=' |
          %{
                if($_.value -ne $NULL)
                {
                    $_.key = $_.key.Trim()
                    $_.value = $_.value.Trim()
                    if ($replace.ContainsKey($_.key)) { $_.key = $replace.Get_Item($_.key) };
                    # Based on the value of BACKUP_TYPE key, store value in the hash
                    # e.g When in Config file   "BACKUP_TYPE=BBB", store the hash value "BBB: True"
                    # Based on the value of BACKUP_PREFERENCE key, store value in the hash
                    # e.g When in Config file "BACKUP_PREFERENCE=preferred", store the hash value "BackupPreferred: True"
                    if ($_.key -eq "BACKUP_TYPE" )
                    {
                        switch ($_.value)
                        {
                            {($_ -eq "BBB") -or ($_ -eq "BlockBasedBackup")}  { $hash["BackupViaBlockBasedBackup"] = $True }
                        }
                    }
                    elseif ($_.key -eq "BACKUP_PREFERENCE")
                    {
                        switch ($_.value)
                        {
                            {($_ -eq "preferred")}  { $hash["BackupPreferred"] = $True }
                            {($_ -eq "passive")}    { $hash["BackupPassive"] = $True }
                            {($_ -eq "active")}     { $hash["BackupActive"] = $True }
                        }
                    }
                    elseif ($_.key -eq "RESTORE_FROM_DD_ONLY")
                    {
                        if ($_.value -eq "true")
                        {
                            $hash["RestoreFromDataDomain"] = $True
                        }
                    }
                    elseif ($_.key -eq "INCLUDE_STANDALONE_DATABASES")
                    {
                        if ($_.value -eq "true")
                        {
                            $hash["IncludeStandaloneDatabases"] = $True
                        }
                    }
                    elseif ($_.key -eq "SERVER_ORDER_LIST")
                    {
                        $hash[$_.key] = $_.value.Split(",").Trim();
                    }
                    elseif ($_.key -eq "DataDomainHost" -or $_.key -eq "DataDomainHostPath" -or
                      $_.key -eq "DataDomainUser" -or $_.key -eq "DataDomainVDiskUser")
                    {
                        if ($hash[$_.key] -eq $null)
                        {
                            $hash[$_.key] = @()
                        }
                        # PowerShell v2 or older does not support string[].trim().
                        $hash[$_.key] += $_.value.Split(",") | % {$_.Trim()};
                    }
                    else
                    {
                        $hash[$_.key] = $_.value
                    }
                }
           }

    # Add ClientName using the local host name if not provided.
    if (!$hash.ContainsKey("ClientName")) { $hash["ClientName"] = ([System.Net.DNS]::GetHostByName('').HostName) }

    # Support for DDBOOST_FC=TRUE. Anything other than "true" (case insensitive) results in the fibre channel host being removed.
    if ($hash.ContainsKey("DDBOOST_FC") -and $hash["DDBOOST_FC"] -ne "true") { $hash.Remove("DataDomainFibreChannelHost") }
    $hash.Remove("DDBOOST_FC")

    # Convert the hash into a PSObject suitable for piping to commands.
    return New-Object PSObject -Property $hash
}

Set-Alias Restore-Exchange Restore-ExchangeBackup
Set-Alias Rollback-Exchange Invoke-RestoreExchangeBackup
Set-Alias Invoke-ExchangeRollback Invoke-RestoreExchangeBackup

Export-ModuleMember -Alias * -Function * -Cmdlet *
