$Script:PSModuleRoot = $PSScriptRoot
# Importing from [C:\projects\snowsql\SnowSQL\Public]
# .\SnowSQL\Public\Add-SnowSqlRoleMember.ps1
function Add-SnowSqlRoleMember
{
    <#
    .SYNOPSIS
    Add users to role

    .DESCRIPTION
    Add users to role

    .EXAMPLE
    Add-SnowSqlRoleMember -Role TEST_ROLE -Name TEST_USER

    .NOTES

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Name of Role to update
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Role,

        # User to add to Role
        [Alias('Member')]
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,

        # Return the command instead of the results
        [switch]
        $DSL
    )
    begin
    {
        $template = 'GRANT ROLE {0} TO USER {1};'
    }
    process
    {
        $Query = $template -f $Role, $Name

        if ($DSL)
        {
            return $Query
        }

        Invoke-SnowSql -Query $Query
    }
}

# .\SnowSQL\Public\Disable-SnowSqlUser.ps1
function Disable-SnowSqlUser
{
    <#
    .SYNOPSIS
    Disable user account

    .DESCRIPTION
    Disable user account

    .EXAMPLE
    Disable-SnowSqlUser -Name TEST_USER

    .NOTES

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Name of user to disable
        [Alias('SamAccountName')]
        [parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,

        # Return the command instead of the results
        [switch]
        $DSL
    )

    begin
    {
        $template = 'ALTER USER {0} SET DISABLED=TRUE;'
    }

    process
    {
        $Query = $template -f $Name

        if ($DSL)
        {
            return $Query
        }

        Invoke-SnowSql -Query $Query
    }
}

# .\SnowSQL\Public\Enable-SnowSqlUser.ps1
function Enable-SnowSqlUser
{
    <#
    .SYNOPSIS
    Enable user account

    .DESCRIPTION
    Enable user account

    .EXAMPLE
    Enable-SnowSqlUser -Name TEST_USER

    .NOTES

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Name of user to Enable
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,

        # Return the command instead of the results
        [switch]
        $DSL
    )

    begin
    {
        $template = 'ALTER USER {0} SET DISABLED=FALSE;'
    }

    process
    {
        $Query = $template -f $Name

        if ($DSL)
        {
            return $Query
        }

        Invoke-SnowSql -Query $Query
    }
}

# .\SnowSQL\Public\Get-SnowSqlConnection.ps1
function Get-SnowSqlConnection
{
    <#
    .SYNOPSIS
    Gets the current Snowflake connection

    .DESCRIPTION
    Gets the current Snowflake connection

    .EXAMPLE
    Get-SnowSqlConnection

Endpoint                    Credential
--------                    ----------
contoso.east-us-2.azure     System.Management.Automation.PSCredential

    .NOTES

    #>

    [OutputType('SnowSql.Connection')]
    [CmdletBinding()]
    param()

    end
    {
        if ($Script:SnowSqlConnection)
        {
            return $Script:SnowSqlConnection
        }
        else
        {
            Write-Error "Unable to find a SnowSql session. Run Open-SnowSqlConnection to create one." -ErrorAction Stop
        }

    }
}

# .\SnowSQL\Public\Get-SnowSqlRole.ps1
function Get-SnowSqlRole
{
    <#
    .SYNOPSIS
    Get list of Snowflake roles

    .DESCRIPTION
    Get list of Snowflake roles

    .EXAMPLE
    Get-SnowSqlRole

created_on                    name                         is_default is_current is_inherited assigned_to_users granted_to_roles granted_role                                                                                                                        s
----------                    ----                         ---------- ---------- ------------ ----------------- ---------------- ------------
2020-02-01 12:31:05.000 -0800 ACTADMIN                     N          N          N            0                 0                0
2020-02-01 12:31:05.000 -0800 PUB                          N          N          Y            0                 0                0
2020-02-01 12:31:05.000 -0800 SECURITY                     Y          Y          N            0                 0                0
2020-02-01 12:31:05.000 -0800 ADMIN                        N          N          N            0                 0                0

    .NOTES

    #>

    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Role to return
        [Alias('Role')]
        [SupportsWildcards()]
        [parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name='*',

        # Return the command instead of the results
        [switch]
        $DSL
    )
    begin
    {
        $Query = 'SHOW ROLES;'

        if ($DSL)
        {
            return $Query
        }

        $results = Invoke-SnowSql -Query $Query
    }

    process
    {
        if (-Not $DSL)
        {
            $results | Where-Object Name -Like $Name
        }
    }
}

# .\SnowSQL\Public\Get-SnowSqlRoleMember.ps1
function Get-SnowSqlRoleMember
{
    <#
    .SYNOPSIS
    Gets the members of the Snowflake role

    .DESCRIPTION
    Gets the members of the Snowflake role

    .EXAMPLE
    Get-SnowSqlRoleMember

    .NOTES

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Name of Role to update
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Role,

        # Return the command instead of the results
        [switch]
        $DSL
    )
    begin
    {
        $template = 'SHOW GRANTS OF ROLE {0};'
    }
    process
    {
        $Query = $template -f $Role

        if ($DSL)
        {
            return $Query
        }

        Invoke-SnowSql -Query $Query
    }
}

# .\SnowSQL\Public\Get-SnowSqlUser.ps1
function Get-SnowSqlUser
{
    <#
    .SYNOPSIS
    Get list of Snowflake users

    .DESCRIPTION
    Get list of Snowflake users

    .EXAMPLE
    Get-SnowSqlUser

    .NOTES

    #>

    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # User to return
        [Alias('User')]
        [SupportsWildcards()]
        [parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name='*',

        # Return the command instead of the results
        [switch]
        $DSL
    )

    begin
    {
        $Query = 'SHOW USERS;'

        if ($DSL)
        {
            return $Query
        }

        $results = Invoke-SnowSql -Query $Query
    }

    process
    {
        if (-Not $DSL)
        {
            $results | Where-Object Name -Like $Name
        }
    }
}

# .\SnowSQL\Public\Invoke-SnowSql.ps1
function Invoke-SnowSql
{
    <#
    .SYNOPSIS
    Invokes a Snowflake SQL statement

    .DESCRIPTION
    Invokes a Snowflake SQL statement

    .EXAMPLE
    Open-SnowSqlConnection
    Invoke-SnowSql -Query '!help'

    .NOTES
    Error handling does not exist at the moment
    #>

    [cmdletbinding(
        DefaultParameterSetName = 'QueryConnection',
        SupportsShouldProcess
    )]
    param(
        # Snowflake endpoint (ex: contoso.east-us-2.azure)
        [Parameter(ParameterSetName = 'QueryCred', Mandatory)]
        [Parameter(ParameterSetName = 'PathCred', Mandatory)]
        [string]
        $Endpoint,

        # Credential for snowflake endpoint
        [Parameter(ParameterSetName = 'QueryCred', Mandatory)]
        [Parameter(ParameterSetName = 'PathCred', Mandatory)]
        [PSCredential]
        $Credential,

        # An existing connection made with Open-SnowSqlConnection
        [Parameter(ParameterSetName = 'QueryConnection')]
        [Parameter(ParameterSetName = 'PathConnection')]
        [PSTypeName('SnowSql.Connection')]
        $Connection,

        # Query to invoke
        [Parameter(ParameterSetName = 'QueryCred')]
        [Parameter(ParameterSetName = 'QueryConnection')]
        [string[]]
        $Query = '!help',

        # SnowSql script file to execute
        [Parameter(ParameterSetName = 'PathCred')]
        [Parameter(ParameterSetName = 'PathConnection')]
        [string]
        $Path
    )

    begin
    {
        try
        {
            $snowSql = Get-Command snowsql -ErrorAction Stop |
                Select-Object -First 1 -ExpandProperty Source
        }
        catch
        {
            Write-Error "Could not find [snowsql.exe] on local system. Install snowsql.exe and make it available in the %path%. Install instructions can be found here [https://docs.snowflake.net/manuals/user-guide/snowsql-install-config.html]" -ErrorAction Stop
        }

        if($PSCmdlet.ParameterSetName -match 'Connection$')
        {
            if( -not $Connection )
            {
                $Connection = Get-SnowSqlConnection
            }
            $Credential = $Connection.Credential
            $Endpoint = $Connection.Endpoint
        }
    }

    process
    {
        $singleLineQuery = $Query -join [environment]::NewLine

        # make sure the query is not too long for the commandline
        $maxCommandLength = 500
        if ($singleLineQuery.Length -ge $maxCommandLength)
        {
            $Path = New-TemporaryFile
            Write-Verbose "Saving query to file [$Path]"

            #Setting to UTF8 without BOM as snowsql commands for files with BOM fail
            [System.IO.File]::WriteAllLines($Path, $Query)
        }

        $snowSqlParam = @(
            '--accountname', $Endpoint
            '--username', $Credential.UserName
            '--option', 'exit_on_error=true'
            '--option', 'output_format=csv'
            '--option', 'friendly=false'
            '--option', 'timing=false'
            if ($Debug)
            {
                '--option', 'log_level=DEBUG'
            }
            if ($Path)
            {
                '--filename', $Path
            }
            else
            {
                '--query', $singleLineQuery
            }
        )

        Write-Debug ("Executing [& '$snowsql' $snowSqlParam]" -f $snowsql)
        if ($PSCmdlet.ShouldProcess("Execute SnowSql on [$Endpoint] as [$($Credential.UserName)]. Use -Debug to see full command"))
        {
            $env:SNOWSQL_PWD = $Credential.GetNetworkCredential().password
            $results = & $snowsql @snowSqlParam | ConvertFrom-Csv
            $env:SNOWSQL_PWD = ""
            Write-Verbose "LastExitCode[$LastExitCode]"
        }

        $results
    }
}

# .\SnowSQL\Public\New-SnowSqlRole.ps1
function New-SnowSqlRole
{
    <#
    .SYNOPSIS
    Create a new Snowflake role

    .DESCRIPTION
     Create a new Snowflake role

    .EXAMPLE
    New-SnowSqlRole -Role TEST_ROLE

    .NOTES

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Name of Role to create
        [Alias('Name')]
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Role,

        # Return the command instead of the results
        [switch]
        $DSL
    )
    begin
    {
        $template = 'CREATE ROLE {0};'
    }
    process
    {
        $Query = $template -f $Role

        if ($DSL)
        {
            return $Query
        }

        Invoke-SnowSql -Query $Query
    }
}

# .\SnowSQL\Public\New-SnowSqlUser.ps1
function New-SnowSqlUser
{
    <#
    .SYNOPSIS
    Create a new Snowflake user account

    .DESCRIPTION
    Create a new Snowflake user account

    .EXAMPLE
    New-SnowSqlUser -Name TESTUSER -LoginName TESTUSER@CONTOSO.COM -Description 'AD Account'

    .NOTES
    Current use case is for creating AD users in Snowflake. Local accounts may need different options.
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Name of the Snowflake user
        [Alias('SamAccountName')]
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,

        # Login or Active Directory account name
        [Alias('UserPrincipalName')]
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $LoginName,

        # Description of the user account
        [Alias('Comment')]
        [parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Description,

        # Return the command instead of the results
        [switch]
        $DSL
    )

    begin
    {
        $template = "CREATE USER {0} LOGIN_NAME='{1}' MUST_CHANGE_PASSWORD=FALSE COMMENT='{2}';"
    }

    process
    {
        $Query = $template -f $Name, $LoginName, $Description

        if ($DSL)
        {
            $Query
        }
        else
        {
            Invoke-SnowSql -Query $Query
        }

        Enable-SnowSqlUser -Name $Name -DSL:$DSL
    }
}

# .\SnowSQL\Public\Open-SnowSqlConnection.ps1
function Open-SnowSqlConnection
{
    <#
    .SYNOPSIS
    Opens a connection to Snowflake

    .DESCRIPTION
    Establishes a few important environment values for connecting to snowflake

    .EXAMPLE
    Open-SnowSqlConnection -Endpoint contoso.east-us-2.azure -Credential (Get-Credential)

    .NOTES
    Will also execute a '!help' statement to verify connectivity
    #>

    [OutputType('SnowSql.Connection')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Snowflake endpoint (ex: contoso.east-us-2.azure)
        [Parameter(Mandatory)]
        [string]
        $Endpoint,

        # Credential for snowflake endpoint
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential
    )

    end
    {
        $SnowSqlConnection = [PSCustomObject]@{
            PSTypeName = 'SnowSql.Connection'
            Endpoint   = $Endpoint
            Credential = $Credential
        }

        # Do basic connection test
        $invokeSnowSqlSplat = @{
            Query       = '!help'
            ErrorAction = 'Stop'
            Connection  = $SnowSqlConnection
        }
        $null = Invoke-SnowSql @invokeSnowSqlSplat
        $Script:SnowSqlConnection = $SnowSqlConnection

        return $Script:SnowSqlConnection
    }
}

# .\SnowSQL\Public\Remove-SnowSqlRoleMember.ps1
function Remove-SnowSqlRoleMember
{
    <#
    .SYNOPSIS
    Remove Snowflake user from role

    .DESCRIPTION
    Remove Snowflake user from role

    .EXAMPLE
    Remove-SnowSqlRoleMember -Role TEST_ROLE -Name TEST_USER

    .NOTES

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Implemented in Invoke-SnowSql")]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # Name of Role to update
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Role,

        # User to remove from role
        [Alias('Member')]
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,

        # Return the command instead of the results
        [switch]
        $DSL
    )

    begin
    {
        $template = 'REVOKE ROLE {0} FROM USER {1};'
    }

    process
    {
        $Query = $template -f $Role, $Name

        if ($DSL)
        {
            return $Query
        }

        Invoke-SnowSql -Query $Query
    }
}


