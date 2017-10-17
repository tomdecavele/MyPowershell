#
# Setting Permissions on ResourcePools
#
# TDC3 vof - September,2017
#
# $erroractionpreference = "Stop"
# set-psdebug -strict

$debug=0

$set=0
$remove=0

$Min=1
$Max=30

$vCenter="xxx.xxx.xxx.xxx"
$User="xxx@vsphere.local"
$Password="xxx"

$ResourcePool=""
$Principal=""
$Role="Resource pool administrator (WinOS)"

# 
# Start of Script
#

Connect-VIServer $vCenter -user $User -Password $Password

for ($i=$Min; $i -le $Max; $i++)
{
	$ResourcePool="Team"+$i.ToString("00")
	$Principal="team"+$i.ToString("00")
	
	if ($debug) {
		write-host "ResourcePool:",$ResourcePool,"Principal:",$Principal
		write-host }
	  
	if ($set)
	{
		Get-ResourcePool -Name $ResourcePool | New-VIPermission -Principal $Principal -Role $Role -Confirm:$false
	}

	if ($remove)
	{
		Get-VIPermission -Entity $ResourcePool -Principal $Principal | Remove-VIPermission -Confirm:$false
	}
}

Disconnect-VIServer -Server $vCenter -confirm:$false

#
# End of script
#
