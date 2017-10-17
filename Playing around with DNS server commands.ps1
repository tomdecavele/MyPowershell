#
# nslookup alternative in Powershell
#
Resolve-DnsName -Name tdc3.local -Type A
#
# Adding a primary reverse lookup zone in the domain
#
Add-DnsServerPrimaryZone -NetworkID "192.168.2.0/24" -ReplicationScope Domain
#
# Force DC to register itself in the newly created reverse lookup zone
#
ipconfig /registerdns
#
# Manually adding the PTR resource record for your DC 
#
Add-DnsServerResourceRecordPtr -Name "2" -ZoneName "1.168.192.in-addr.arpa" -PtrDomainName "team10-dc1.team10.local"

Add-DnsServerResourceRecord -PTR -Name "2" -ZoneName "1.168.192.in-addr.arpa" -PtrDomainName "team10-dc1.team10.local"

Remove-DnsServerResourceRecord -ZoneName "1.168.192.in-addr.arpa" -RRType "PTR" -Name "5" -force:$true
#
# Adding & Removing resource records ... examples
#
Add-DnsServerResourceRecordCName -Name "ftp" -HostNameAlias "dc1.tdc3.local" -ZoneName "tdc3.local"
or
Add-DnsServerResourceRecord -CName -Name "ftp" -HostNameAlias "dc1.tdc3.local" -ZoneName "tdc3.local"

Remove-DnsServerResourceRecord -ZoneName "tdc3.local" -RRType "CNAME" -Name "ftp.tdc3.local." -force:$true



Add-DnsServerResourceRecordA -Name "ftp" -ZoneName "tdc3.local" -IPv4Address "192.168.1.5" -CreatePTR
or
Add-DnsServerResourceRecord -A -ZoneName "tdc3.local" -Name "ftp" -IPv4Address "192.168.1.5" -CreatePTR

Remove-DnsServerResourceRecord -ZoneName "tdc3.local" -RRType "A" -Name "ftp.tdc3.local." -force:$true



Add-DnsServerResourceRecordAAAA -Name "ftp" -ZoneName "tdc3.local" -IPv6Address "3ffe::1"
or
Add-DnsServerResourceRecord -AAAA -Name "ftp" -ZoneName "tdc3.local" -IPv6Address "3ffe::1"

Remove-DnsServerResourceRecord -ZoneName "tdc3.local" -RRType "AAAA" -Name "ftp.tdc3.local." -force:$true



Add-DnsServerResourceRecordMX -Preference 10  -Name "." -MailExchange "mail.tdc3.local" -ZoneName "tdc3.local"
or
Add-DnsServerResourceRecord -MX -Name "." -ZoneName "tdc3.local" -MailExchange "mail.tdc3.local" -Preference 10

Get-DnsServerResourceRecord -ZoneName tdc3.local -Name "." -RRType "MX" |
    Where-Object {$_.RecordData.Preference -eq 10 -and $_.RecordData.MailExchange -eq "mail.tdc3.local."} |
    Remove-DnsServerResourceRecord -ZoneName "tdc3.local" -force:$true

	
	
Add-DnsServerResourceRecord -NS -ZoneName "tdc3.local" -name "." -nameserver "ns1.tdc3.local"

Get-DnsServerResourceRecord -ZoneName tdc3.local -Name "." -RRType "NS" |
    Where-Object {$_.RecordData.NameServer -eq "ns1.tdc3.local.3"} |
    Remove-DnsServerResourceRecord -ZoneName "tdc3.local" -force:$true
	

	
Add-DnsServerResourceRecord -TXT -ZoneName "tdc3.local" -name "." -DescriptiveText "testje" 

Get-DnsServerResourceRecord -ZoneName tdc3.local -Name "." -RRType "TXT" | 
    Where-Object {$_.RecordData.DescriptiveText -eq "testje"} |
	Remove-DnsServerResourceRecord -ZoneName "tdc3.local" -force:$true
	
#
# Show DNS Forwarders
#
Get-DnsServerForwarder
#
# Manage DNS Forwarders
#
Remove-DnsServerForwarder -IPAddress 192.168.1.1
Add-DnsServerForwarder -IPAddress 172.20.0.2
Add-DnsServerForwarder -IPAddress 172.20.0.3
Add-DnsServerForwarder -IPAddress 172.20.0.8
Get-DnsServerForwarder
#
# Disable the use of root hints
#
Set-DnsServerForwarder -UseRootHint:$false
Get-DnsServerForwarder
#
# Testing your nameserver
#

Test-DnsServer -IPAddress 192.168.1.2

Test-DnsServer -IPAddress 192.168.1.2 -Context Forwarder

#
# Adding a secundary nameserver & configuring zone transfer and notify to all known nameservers
#
Add-DnsServerResourceRecord -NS -ZoneName "tdc3.local" -name "." -nameserver "ns1.tdc3.local"
Set-DnsServerPrimaryZone -name "tdc3.local" -SecureSecondaries TransferToZoneNameServer -Notify Notify

Add-DnsServerResourceRecord -NS -ZoneName "1.168.192.in-addr.arpa" -name "." -nameserver "ns1.tdc3.local"
Set-DnsServerPrimaryZone -name "1.168.192.in-addr.arpa" -SecureSecondaries TransferToZoneNameServer -Notify Notify

#
# Creating secondary zones on secondary name server
#
Add-DnsServerSecondaryZone -Name "tdc3.local" -ZoneFile "tdc3.local.dns" -MasterServers 192.168.1.2
Add-DnsServerSecondaryZone -NetworkID "192.168.1.0/24" -ZoneFile "1.168.192.in-addr.arpa" -MasterServers 192.168.1.2

#
# Start zone transfer
#
Start-DnsServerZoneTransfer -Name "tdc3.local"
#
# Enable scavanging for a zone
#
Get-DnsServerScavenging
Set-DnsServerScavenging -ScavengingState:$true -ApplyOnAllZones:$true
