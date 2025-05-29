set-location C:\Downloads\Datafiles

$isodate=Get-Date -format s 
$isodate=$isodate -replace(":","")
$basepath=(Get-Location -PSProvider FileSystem).ProviderPath


$instancepath=$basepath + "\Prod.txt"
$outputfile="\logs\sql_server_db_sizes_" + $isodate + ".html"
$outputfilefull = $basepath + $outputfile


$filePath = ""

$dt = new-object "System.Data.DataTable"
foreach ($instance in get-content $instancepath)
{
$instance
$cn = new-object System.Data.SqlClient.SqlConnection "server=$instance;database=msdb;Integrated Security=sspi"
$cn.Open()
$sql = $cn.CreateCommand()
$sql.CommandText = "



SELECT 
	 @@servername as ServerName
    ,[TYPE] = A.TYPE_DESC
	,[Database_Name] = D.name
    ,[AutoGrow] = 'By ' + CASE is_percent_growth WHEN 0 THEN CAST(growth/128 AS VARCHAR(10)) + ' MB -' 
        WHEN 1 THEN CAST(growth AS VARCHAR(10)) + '% -' ELSE '' END 
        + CASE max_size WHEN 0 THEN 'DISABLED' WHEN -1 THEN ' Unrestricted' 
            ELSE ' Restricted to ' + CAST(max_size/(128*1024) AS VARCHAR(10)) + ' GB' END 
        + CASE is_percent_growth WHEN 1 THEN ' [autogrowth by percent, BAD setting!]' ELSE '' END
		, [Remaining Space GB ] =  CASE CAST(max_size/(128)  AS VARCHAR(10)) WHEN 0 THEN NULL 
		ELSE
		((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) 
		END
		,[FILESIZE_GB] = (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1024)
	, [Remaining Space %] =cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6))
FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
join sys.databases D on D.database_id = A.database_id
where (D.database_id >=5) --AND  D.name = 'PRL_DATAHUB_PROD')
and A.TYPE_DESC != 'FILESTREAM' and max_size != '-1'
and cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) <='.15'
order by cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) ASC, A.TYPE asc, A.NAME;


"
    $rdr = $sql.ExecuteReader()
    $dt.Load($rdr)
    $cn.Close()
 
}

$dt | select * -ExcludeProperty RowError, RowState, HasErrors, Name, Table, ItemArray | ConvertTo-Html -head $reportstyle -body "SQL Server Database Sizes" | Set-Content $outputfilefull  

$filepath = $outputfilefull  



set-location C:\Downloads\Datafiles

$isodate=Get-Date -format s 
$isodate=$isodate -replace(":","")
$basepath= 'C:\Downloads\Datafiles'


$instancepath=$basepath + "\NonProd.txt"
$outputfile="\logs\sql_server_db_sizes_" + $isodate + ".html"
$outputfilefull = $basepath + $outputfile


$filePath = ""

$dt = new-object "System.Data.DataTable"
foreach ($instance in get-content $instancepath)
{
$instance
$cn = new-object System.Data.SqlClient.SqlConnection "server=$instance;database=msdb;Integrated Security=sspi"
$cn.Open()
$sql = $cn.CreateCommand()
$sql.CommandText = "



SELECT 
	 @@servername as ServerName
    ,[TYPE] = A.TYPE_DESC
	,[Database_Name] = D.name
    ,[AutoGrow] = 'By ' + CASE is_percent_growth WHEN 0 THEN CAST(growth/128 AS VARCHAR(10)) + ' MB -' 
        WHEN 1 THEN CAST(growth AS VARCHAR(10)) + '% -' ELSE '' END 
        + CASE max_size WHEN 0 THEN 'DISABLED' WHEN -1 THEN ' Unrestricted' 
            ELSE ' Restricted to ' + CAST(max_size/(128*1024) AS VARCHAR(10)) + ' GB' END 
        + CASE is_percent_growth WHEN 1 THEN ' [autogrowth by percent, BAD setting!]' ELSE '' END
		, [Remaining Space GB ] =  CASE CAST(max_size/(128)  AS VARCHAR(10)) WHEN 0 THEN NULL 
		ELSE
		((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) 
		END
		,[FILESIZE_GB] = (CONVERT(DECIMAL(10,2),A.SIZE/128.0)/1024)
	, [Remaining Space %] =cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6))
FROM sys.master_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
join sys.databases D on D.database_id = A.database_id
where (D.database_id >=5) --AND  D.name = 'PRL_DATAHUB_PROD')
and A.TYPE_DESC != 'FILESTREAM' and max_size != '-1'
and cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) <='.15'
order by cast(round((((CAST(max_size/(128)  AS VARCHAR(10)) - CONVERT(DECIMAL(10,2),A.SIZE/128))/1024) /(CAST(max_size/(128*1024) AS VARCHAR(10)))),6,0) as decimal(10,6)) ASC, A.TYPE asc, A.NAME;


"
    $rdr = $sql.ExecuteReader()
    $dt.Load($rdr)
    $cn.Close()
 
}

$dt | select * -ExcludeProperty RowError, RowState, HasErrors, Name, Table, ItemArray | ConvertTo-Html -head $reportstyle -body "SQL Server Database Sizes" | Set-Content $outputfilefull  

$filepath = $outputfilefull  