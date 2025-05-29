#let's get our list of servers. For this, create a .txt files with all the server names you want to check.
$sqlservers = "UTPROD-DIST-01"

#  Load up the list of servers to check

#let's set up the email stuff
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("10.11.1.147")
$msg.Body = “Replication Job is not executing."

$Results=SELECT  sj.name
         FROM msdb.dbo.sysjobhistory sjh
         JOIN  msdb.dbo.sysjobs sj ON (sjh.job_id = sj.job_id)
         WHERE sjh.status=
         
 
 If ($msg.Body.Length -gt 33)
    {

    #who is this coming from
    $msg.From = “AlliedIgnite@alliedsolutions.net”
    #and going to
    $msg.To.Add(”leroy.brown@alliedsolutions.net")
    #and a nice pretty title
    $msg.Subject = “ALERT: Replication Job is stopped.”
    #and BOOM! send that bastard!
    $smtp.Send($msg)
    }
