#
# Preparing vSwitches
#
# TDC3 vof - September,2017
#
# $erroractionpreference = "Stop"
# set-psdebug -strict

$debug=1

$create=0
$delete=0

$Min=0
$Max=0

$vCenter="xxx.xxx.xxx.xxx"
$User="xxx@vsphere.local"
$Password="xxx"

$VMHost="xxx.xxx.xxx.xxx"
$New_vSwitch=""
$vSwitch=""
$New_vPortGroup=""
$vPortGroup=""
$VIRole="Resource pool administrator (WinOS)"

# 
# Start of Script
#

Connect-VIServer $vCenter -user $User -Password $Password

for ($i=$Min; $i -le $Max; $i++)
{
	$New_vSwitch="vSwitch Team"+$i.ToString("00")
	$New_vPortGroup="LAN Team"+$i.ToString("00")
	
	if ($debug) {
		write-host "New vSwitch:",$New_vSwitch,"; vPortGroup:",$New_vPortGroup
		write-host }
	  
	if ($create)
	{
		$vSwitch=New-VirtualSwitch -VMHost $VMHost -Name $New_vSwitch -NumPorts 60 -Confirm:$false
		New-VirtualPortGroup -VirtualSwitch $vSwitch  -Name $New_vPortGroup -Confirm:$false

        #
        # setting permission for the "Resource pool administrator (WinOS)"
        #
        $role = Get-VIRole -Name $VIRole
        $pg = Get-VirtualPortGroup -Name $New_vPortGroup | Select -First 1
        $net = Get-View (Get-View $pg.VMHostId).Network | where {$_.Name -eq $New_vPortGroup}    
        $authMgr = Get-View AuthorizationManager
        $perm = New-Object VMware.Vim.Permission
        $perm.Principal = "winos"
        $perm.RoleId = $role.Id
        $perm.Propagate = $true
        $perm.Group = $true
        $authMgr.SetEntityPermissions($net.moref,$perm)
	}

	if ($delete)
	{
        $vPortGroup=Get-VirtualPortgroup -Name $New_vPortGroup
		Remove-VirtualPortGroup -VirtualPortGroup $vPortGroup -Confirm:$false
		
		$vSwitch=Get-VirtualSwitch -VMHost $VMHost -Name $New_vSwitch
		Remove-VirtualSwitch -VirtualSwitch $vSwitch -Confirm:$false
	}
}

Disconnect-VIServer -Server $vCenter -confirm:$false

#
# End of script
#
