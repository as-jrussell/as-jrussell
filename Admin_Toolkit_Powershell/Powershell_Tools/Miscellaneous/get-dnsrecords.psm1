function get-dnsrecords {
param(

[Parameter(Mandatory=$true,
ParameterSetName="Computer",
ValueFromPipeline=$true,
Position=0)]
[string]
$Computername,

[Parameter(Mandatory=$false,
ParameterSetName="Domains",
Position=2)]
[Array[]]
$DomainList

)

$DefaultDomainList = @("alliedsolutions.net",
"as.local",
"Azure.as.local",
"caas.local",
"colo.as.local",
"ext.local",
"hosted.as.local",
"miinformaciondeseguro.com",
"myalliedsolutions.net",
"rd.as.local",
"root.mds",
"selectprotect.net",
"visualunitrac.com",
"weareallied.net"
)

$FallbackDNSServer = "as-dc02.as.local"


Import-Module Activedirectory

Try { 

    $CompDNS = resolve-dnsname -name $Computername -ErrorAction STOP
    
    }
Catch [System.ComponentModel.Win32Exception]{

    Write-Host "This machine doesn't seem to have any records"
    return
}

if($DomainList -ne $null){

    $Domains = $DomainList

} else {

    $Domains = $DefaultDomainList

}




$a=@()
$cname=@()
$ptr=@()

Try{

$dnsserv = (Resolve-dnsname -name (Get-CimInstance win32_computersystem | % {$_.Domain }))[0]

}
Catch
{

$dnsserv = $FallbackDNSServer

}


foreach($Domain in $Domains){

    Write-Host ("Checking against domain "+$Domain) -ForegroundColor Blue -BackgroundColor White
    
    $Arec = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnsserv[0].IPaddress).Namehost) -zonename $Domain -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $CompDNS.IPaddress}

    $Crec = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnsserv[0].IPaddress).Namehost) -zonename $Domain -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -like ($Computername+'*')} 


    Foreach($line in $Arec){
        $x=@()
        $x=""|Select Name,Zone,IPAddress
        $x.Name = $line.HostName
        $x.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
        $x.Zone = $Domain
        $a = $a+$x
    }

    Foreach($line in $Crec){
        $y=@()
        $y=""|Select Name,Zone,Alias
        $y.Name = $line.HostName
        $y.Alias = $line.RecordData.HostNameAlias
        $y.Zone = $Domain
        $cname = $cname+$y
    }


}

$IPAddress = $CompDNS.IPAddress
    $IPAddressArray = $IPAddress.Split(".")
    $IPAddressFormatted = ($IPAddressArray[2]+"."+$IPAddressArray[1]+"."+$IPAddressArray[0])
    $ReverseZoneName = ($IPAddressFormatted+".in-addr.arpa")
    Write-Host ("Checking against reverse zone "+ $ReverseZoneName) -ForegroundColor Blue -BackgroundColor White
    $Prec = Get-DnsServerResourceRecord -ZoneName $ReverseZoneName -ComputerName ((Resolve-dnsname $dnsserv[0].IPaddress).Namehost) -RRType Ptr | Where {$_.HostName -eq $IPAddressArray[3]}


Foreach($line in $Prec){
$z=@()
$z=""|Select "4th Octect",Zone,Alias
$z.'4th Octect' = $line.HostName
$z.Alias = $line.RecordData.PtrDomainName
$z.Zone = $ReverseZoneName
$ptr = $ptr+$z
}

Write-Output ""
Write-Output ""
Write-Output "------- A Records -------"
$a | Format-Table -AutoSize
Write-Output ""
Write-Output "------- Cname Rec -------"
$cname | Format-Table -AutoSize
Write-Output ""
Write-Output "------- PTR Rec -------"
$ptr | Format-Table -AutoSize

}