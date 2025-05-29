function get-dnsrecords {
param(
[string]$Computername
)
Import-Module Activedirectory

$dns1 = resolve-dnsname -name $Computername

$dnsas = Resolve-dnsname -name as.local
$dnscol = Resolve-dnsname -name colo.as.local
$dnshos = Resolve-dnsname -name hosted.as.local
$dnsext = Resolve-dnsname -name ext.local
$dnsazr = Resolve-dnsname -name azure.as.local
$dnsrd = Resolve-dnsname -name rd.as.local

$as = Get-DnsServerResourceRecord -Computername as-dc02 -zonename as.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
#$as = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnsas[0].IPaddress).Namehost) -zonename as.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
$colo = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnscol[0].IPaddress).Namehost) -zonename colo.as.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
$hosted = Get-DnsServerResourceRecord -Computername hosted-dc02 -zonename hosted.as.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
#$hosted = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnshos[0].IPaddress).Namehost) -zonename hosted.as.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
$asl = Get-DnsServerResourceRecord -Computername as-dc02 -zonename alliedsolutions.net -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
#$ext = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnsext[0].IPaddress).Namehost) -zonename ext.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
$ext = Get-DnsServerResourceRecord -Computername ADEXT2.ext.local -zonename ext.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
$azr = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnsazr[0].IPaddress).Namehost) -zonename azure.as.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
$rd  = Get-DnsServerResourceRecord -Computername rd-dc01 -zonename rd.as.local -rrtype "A" | Where-Object {$_.RecordData.IPv4Address -eq $dns1.IPaddress} 
#come back and fix R

$asc = Get-DnsServerResourceRecord -Computername as-dc02 -zonename as.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
#$asc = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnsas[0].IPaddress).Namehost) -zonename as.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
$coloc = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnscol[0].IPaddress).Namehost) -zonename colo.as.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
$hostedc = Get-DnsServerResourceRecord -Computername hosted-dc02 -zonename hosted.as.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
#$hostedc = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnshos[0].IPaddress).Namehost) -zonename hosted.as.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
$aslc = Get-DnsServerResourceRecord -Computername as-dc02 -zonename alliedsolutions.net -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
$extc = Get-DnsServerResourceRecord -Computername ADEXT2.ext.local -zonename ext.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
$azrc = Get-DnsServerResourceRecord -Computername ((Resolve-dnsname $dnsazr[0].IPaddress).Namehost) -zonename azure.as.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 
$rdc  = Get-DnsServerResourceRecord -Computername rd-dc01 -zonename rd.as.local -rrtype "cname" | Where-Object {$_.RecordData.HostNameAlias -match $dns1.Name} 

#Initialize Main Array
$b=@()

#Iterate through each array of Forward Zones for A Records

Foreach($line in $as){
$a=@()
$a=""|Select Name,Zone,IPAddress
$a.Name = $line.HostName
$a.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
$a.Zone = "AS.LOCAL"
$b = $b+$a
}

Foreach($line in $colo){
$a=@()
$a=""|Select Name,Zone,IPAddress
$a.Name = $line.HostName
$a.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
$a.Zone = "COLO.AS.LOCAL"
$b = $b+$a
}

Foreach($line in $hosted){
$a=@()
$a=""|Select Name,Zone,IPAddress
$a.Name = $line.HostName
$a.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
$a.Zone = "HOSTED.AS.LOCAL"
$b = $b+$a
}

Foreach($line in $asl){
$a=@()
$a=""|Select Name,Zone,IPAddress
$a.Name = $line.HostName
$a.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
$a.Zone = "Alliedsolutions.net"
$b = $b+$a
}

Foreach($line in $ext){
$a=@()
$a=""|Select Name,Zone,IPAddress
$a.Name = $line.HostName
$a.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
$a.Zone = "EXT.LOCAL"
$b = $b+$a
}

Foreach($line in $azr){
$a=@()
$a=""|Select Name,Zone,IPAddress
$a.Name = $line.HostName
$a.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
$a.Zone = "Azure.AS.LOCAL"
$b = $b+$a
}

Foreach($line in $rd){
$a=@()
$a=""|Select Name,Zone,IPAddress
$a.Name = $line.HostName
$a.IPaddress = $line.RecordData.IPv4Address.IPAddressToString
$a.Zone = "RD.AS.LOCAL"
$b = $b+$a
}

#Iterate through forward Zones for Cnames
$c = @()

Foreach($line in $asc){
$a=@()
$a=""|Select Name,Zone,Alias
$a.Name = $line.HostName
$a.Alias = $line.RecordData.HostNameAlias
$a.Zone = "AS.LOCAL"
$c = $c+$a
}

Foreach($line in $coloc){
$a=@()
$a=""|Select Name,Zone,Alias
$a.Name = $line.HostName
$a.Alias = $line.RecordData.HostNameAlias
$a.Zone = "COLO.AS.LOCAL"
$c = $c+$a
}

Foreach($line in $hostedc){
$a=@()
$a=""|Select Name,Zone,Alias
$a.Name = $line.HostName
$a.Alias = $line.RecordData.HostNameAlias
$a.Zone = "HOSTED.AS.LOCAL"
$c = $c+$a
}

Foreach($line in $aslc){
$a=@()
$a=""|Select Name,Zone,Alias
$a.Name = $line.HostName
$a.Alias = $line.RecordData.HostNameAlias
$a.Zone = "Alliedsolutions.net"
$c = $c+$a
}

Foreach($line in $extc){
$a=@()
$a=""|Select Name,Zone,Alias
$a.Name = $line.HostName
$a.Alias = $line.RecordData.HostNameAlias
$a.Zone = "EXT.LOCAL"
$c = $c+$a
}

Foreach($line in $azrc){
$a=@()
$a=""|Select Name,Zone,Alias
$a.Name = $line.HostName
$a.Alias = $line.RecordData.HostNameAlias
$a.Zone = "Azure.AS.LOCAL"
$c = $c+$a
}

Foreach($line in $rdc){
$a=@()
$a=""|Select Name,Zone,Alias
$a.Name = $line.HostName
$a.Alias = $line.RecordData.HostNameAlias
$a.Zone = "RD.AS.LOCAL"
$c = $c+$a
}

Echo "------- A Records -------"
$b
Echo ""
Echo "------- Cname Rec -------"
$c

}