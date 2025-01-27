<#

_checkErrorLogs.ps1
Description:
Author: Jim Breffni.
This script displays the errorlog entries for all selected servers for the last n days.
The script can take a few minutes to run if the error logs are large and you are looking back over several days.

Requirements:
Module invokesqlquery needs to be installed.
1.  Invokesqlquery can be downloaded from http://powershell4sql.codeplex.com/

#>

cls

import-module D:\POWERSHELL\MODULES\invokesqlquery
 
$today    = (get-date).toString()
$all      = @()
$lookback = ((get-date).adddays(-1)).ToString()  #  look back n days from current time

#  Load up the list of servers to check
#  Use this code if you can get your list of servers from a sql database
#$servers = invoke-sqlquery -query @' 
#select distinct serverName from SQL_SERVERS
#  order by serverName 
#'@  -server IGNITE-SQL  -database SQL_TRACKING

#  remove the comment from the code below if you want to supply the list of servers as an array
$servers = 'allied-pimsdb', 'ds-sqltest-01','WINTRAQSQL','pos-sql-01', 'ds-sqldev-02'  | select-object @{Name = 'serverName'; Expression = {$_}}


foreach ($server in $servers) {

"$((get-date).toString()) - Checking SQL Error Logs on $($server.servername)..."

try {
$all += invoke-sqlquery -query "EXEC master..xp_readerrorlog 0, 1, null, null, '$lookback', '$today' " -server $server.servername | select-object @{Name="Server"; Expression={$server.servername}}, LogDate, ProcessInfo, Text | `
  where-object {$_.Text -match 'error|fail|warn|kill|dead|cannot|could|stop|terminate|bypass|roll|truncate|upgrade|victim|recover'} | `
  where-object {$_.Text -notmatch 'setting database option recovery to'}
}
catch {"Unable to read SQL error log from server $server"}
}  #  foreach ($server in $servers) {

$all | out-gridview -title ("$($all.Count) errors in SQL Server Error Logs. From $lookback to $today")


$all = @()
foreach ($server in $servers) {
"$((get-date).toString()) - Checking Agent Error Logs on $($server.servername)..."
try {
$all += invoke-sqlquery -query "EXEC master..xp_readerrorlog 0, 2, null, null, '$lookback', '$today' " -server $server.servername | select-object @{Name="Server"; Expression={$server.servername}}, LogDate, ProcessInfo, Text | `
  where-object {[datetime]$_.LogDate -ge  $lookback} 
}
catch {"Unable to read SQL Agent error log from server $server"}
}  #  foreach ($server in $servers) {

$all | out-gridview -title ("$($all.Count) errors in SQL Agent Error Logs. From $lookback to $today")

