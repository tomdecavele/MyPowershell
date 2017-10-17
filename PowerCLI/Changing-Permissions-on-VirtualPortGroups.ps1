#
# Changing Permissions on VirtualPortGroups
#
# TDC3 vof - September,2017
#
# $erroractionpreference = "Stop"
# set-psdebug -strict

$debug=1

$set=0
$remove=1

$Min=30
$Max=30

$vCenter="xxx.xxx.xxx.xxx"
$User="xxx@vsphere.local"
$Password="xxx"

$VirtualPortGroup=""
$VIRole="Resource pool administrator (WinOS)"
$Principal="winos"

# 
# Start of Script
#

Connect-VIServer $vCenter -user $User -Password $Password

for ($i=$Min; $i -le $Max; $i++)
{
	$VirtualPortGroup="LAN Team"+$i.ToString("00")
	
	if ($debug) {
		write-host "VirtualPortGroup:",$VirtualPortGroup
		write-host }
	  
	if ($set)
	{
        #
        # setting permission for the "Resource pool administrator (WinOS)"
        #
        $role = Get-VIRole -Name $VIRole
        $pg = Get-VirtualPortGroup -Name $VirtualPortGroup | Select -First 1
        $net = Get-View (Get-View $pg.VMHostId).Network | where {$_.Name -eq $VirtualPortGroup}    
        $authMgr = Get-View AuthorizationManager
        $perm = New-Object VMware.Vim.Permission
        $perm.Principal = $Principal
        $perm.RoleId = $role.Id
        $perm.Propagate = $true
        $perm.Group = $true
        $authMgr.SetEntityPermissions($net.moref,$perm)
	}

	if ($remove)
	{
	    $role = Get-VIRole -Name $VIRole
        $pg = Get-VirtualPortGroup -Name $VirtualPortGroup | Select -First 1
        $net = Get-View (Get-View $pg.VMHostId).Network | where {$_.Name -eq $VirtualPortGroup}    
        $authMgr = Get-View AuthorizationManager
        $perm = New-Object VMware.Vim.Permission
        $perm.Principal = $Principal
        $perm.RoleId = $role.Id
        $perm.Propagate = $true
        $perm.Group = $true
        $authMgr.RemoveEntityPermissions($net.moref,$perm)
    }
}

Disconnect-VIServer -Server $vCenter -confirm:$false

#
# End of script
#
