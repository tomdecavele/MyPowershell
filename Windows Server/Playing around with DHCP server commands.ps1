#
# Remotely install/uninstall the DHCP service
#
Enable-PSRemoting -Force #First run this command locally on the machine, you want to install roles/features on remotely !!!

Get-WindowsFeature 

Install-WindowsFeature -ComputerName team01-ms.tdc3.local -Name DHCP –IncludeManagementTools
UnInstall-WindowsFeature -ComputerName team01-ms.tdc3.local -Name DHCP –IncludeManagementTools
#
# Authorizing/Deautorizing DHCP server in AD
#
Add-DhcpServerInDC -DnsName team10-dc1.tdc3.local -IPAddress 192.168.1.2
Remove-DhcpServerInDC -DnsName team10-dc1.tdc3.local -IPAddress 192.168.1.2
#
# Creating/remove address scope
#
Add-DHCPServerv4Scope -ComputerName "team10-dc1.tdc3.local" -Name "LAN1" -StartRange 192.168.1.1 -EndRange 192.168.1.254 -SubnetMask 255.255.255.0 -State Active
Remove-DHCPServerv4Scope -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0

Add-Dhcpserverv4ExclusionRange -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0 -StartRange 192.168.1.1 -EndRange 192.168.1.10
Remove-Dhcpserverv4ExclusionRange -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0
#
# Set Scope Options : Default Gateway (only!)
#
Set-DHCPServerv4OptionValue -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0 -Router 192.168.1.1
#
# Set DHCP Server Options : DNS Server(s) & Domain Name
#
Set-DHCPServerv4OptionValue -ComputerName "team10-dc1.tdc3.local" -DnsServer 192.168.1.2 -DnsDomain tdc3.local

Set-DHCPServerv4OptionValue -ComputerName "team10-dc1.tdc3.local" -DnsServer 192.168.1.2,192.168.1.3 -DnsDomain tdc3.local -force

Get-DHCPServerv4OptionValue
Remove-DHCPServerv4OptionValue -OptionId 6
Remove-DHCPServerv4OptionValue -OptionId 15
#
# Making a DHCP reservation from a csv-file or manualy
#
Import-Csv –Path .\DHCPReservations.csv -Delimiter ";" | Add-DhcpServerv4Reservation -ComputerName "team10-dc1.tdc3.local"

Add-DhcpServerv4Reservation -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0 -Name "Win10.tdc3.local" -IPAddress 192.168.1.200 -ClientId "F0-DE-F1-7A-00-5E" -Description "Windows 10"
#
# Activating/Disactivating a scope
#
Set-DhcpServerv4Scope -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0 -State Active
Set-DhcpServerv4Scope -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0 -State InActive
#
# Remove a scope
#
Remove-DHCPServerv4Scope -ComputerName "team10-dc1.tdc3.local" -ScopeId 192.168.1.0 -Force
#
# Add/Remove a DHCP failover server 
#
Add-DhcpServerv4Failover -ComputerName team10-dc1.tdc3.local -Name DC-MS-Failover -PartnerServer team10-ms.tdc3.local -ScopeId 192.168.1.0 -SharedSecret "sEcReT"
Remove-DhcpServerv4Failover -ComputerName team10-dc1.tdc3.local -Name DC-MS-Failover
#
# Add/Remove a DHCP failover scope 
#
Add-DhcpServerv4FailoverScope -ComputerName team10-dc1.tdc3.local -Name DC-MS-Failover -ScopeId 192.168.2.0
Remove-DhcpServerv4FailoverScope -ComputerName team10-dc1.tdc3.local -Name DC-MS-Failover -ScopeId 192.168.2.0
#
# Force a failover for all scopes
#
Invoke-DhcpServerv4FailoverReplication -ComputerName team10-dc1.tdc3.local -Name DC-MS-Failover
#
# Force a failover for one scope
#
Invoke-DhcpServerv4FailoverReplication -ComputerName team10-dc1.tdc3.local -Name DC-MS-Failover -ScopeId 192.168.1.0
#
# Export & Import a DHCP configuration
#
Export-DHCPServer -ComputerName "team10-dc1.tdc3.local" -File .\dhcp.xml
Import-DHCPServer -ComputerName "team10-dc1.tdc3.local" -File .\dhcp.xml -BackupPath .\dhcpbackup\
