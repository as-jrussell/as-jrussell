function Get-DatabaseData {
    [CmdletBinding()]
    param (
        [string]$connectionString,
        [string]$query,
        [switch]$isSQLServer
    )
    if ($isSQLServer) {
        Write-Verbose 'in SQL Server mode'
        $connection = New-Object System.Data.SqlClient.SqlConnection
    } else {
        Write-Verbose 'in OleDB mode'
        $connection = New-Object System.Data.OleDb.OleDbConnection
    }
    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    if ($isSQLServer) {
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    } else {
        $adapter = New-Object System.Data.OleDb.OleDbDataAdapter $command
    }
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataset)
    $dataset.Tables[0]
}
function Invoke-DatabaseQuery {
    [CmdletBinding()]
    param (
        [string]$connectionString,
        [string]$query,
        [switch]$isSQLServer
    )
    if ($isSQLServer) {
        Write-Verbose 'in SQL Server mode'
        $connection = New-Object System.Data.SqlClient.SqlConnection
    } else {
        Write-Verbose 'in OleDB mode'
        $connection = New-Object System.Data.OleDb.OleDbConnection
    }
    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $connection.Open()
    $command.ExecuteNonQuery()
    $connection.close()
}
