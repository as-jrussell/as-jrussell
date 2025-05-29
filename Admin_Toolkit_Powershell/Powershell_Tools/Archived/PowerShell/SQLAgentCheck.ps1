#let's get our list of servers. For this, create a .txt files with all the server names you want to check.
$sqlservers = Get-Content "D:\Powershell\SQLServer.txt";

#  Load up the list of servers to check

#let's set up the email stuff
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("10.11.1.147")
$msg.Body = “Here is a list of SQL Agents that have stopped.”


#here, we will begin with a foreach loop. We'll be checking all servers in the .txt referenced above.
foreach($sqlserver in $sqlservers)

{
# go to each server and return the name and state of services 
# that are like "SQLAgent" and where their state is stopped
# return the output as a string
$Servers=get-wmiobject win32_service -computername $sqlserver | 
  select name,state | 
  where {($_.name -like "SQLAGENT*" -or $_.name -like "SQL*AGENT") `
    -and $_.state -match "Stopped"} | 
  Out-String
           
      
    if ($Servers.Length -gt 0)
        {
        $msg.body   = $msg.body + "`n $sqlserver"
        }
 }
 
 If ($msg.Body.Length -gt 47)
    {

    #who is this coming from
    $msg.From = “AlliedIgnite@alliedsolutions.net”
    #and going to
    $msg.To.Add(”leroy.brown@alliedsolutions.net")
    #and a nice pretty title
    $msg.Subject = “ALERT: SQL Agents are stopped.”
    #and BOOM! send that bastard!
    $smtp.Send($msg)
    }
