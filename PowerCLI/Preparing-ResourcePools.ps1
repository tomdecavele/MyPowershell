#
# Preparing ResourcePools
#
# TDC3 vof - September,2017
#
# $erroractionpreference = "Stop"
# set-psdebug -strict

$debug=1

$create=1
$delete=0

$Min=30
$Max=30

$vCenter="xxx.xxx.xxx.xxx"
$User="xxx@vsphere.local"
$Password="xxx"

$VMHost="xxx.xxx.xxx.xxx.xxx"
$ResourcePool=""
$NewResourcePool=""
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
		write-host "ResourcePool:",$ResourcePool
		write-host }
	  
	if ($create)
	{
		$NewResourcePool=New-ResourcePool -Location $VMHost -Name $ResourcePool -Confirm:$false
#		Get-ResourcePool -Name $ResourcePool | New-VIPermission -Principal $Principal -Role $Role -Confirm:$false
		New-VIPermission -Entity $NewResourcePool -Principal $Principal -Role $Role -Confirm:$false
	}

	if ($delete)
	{
		Remove-ResourcePool $ResourcePool -Confirm:$false
	}
}

Disconnect-VIServer -Server $vCenter -confirm:$false

#
# End of script
#
