#
# Preparing VMHostAccounts
#
# TDC3 vof - September,2017
#
# $erroractionpreference = "Stop"
# set-psdebug -strict

$debug=1

$create=1
$delete=0

$MinAccount=30
$MaxAccount=30

$vCenter="xxx.xxx.xxx.xxx"
$User="xxx@vsphere.local"
$Password="xxx"

$VMHost="xxx.xxx.xxx.xxx"
$VMHostAccount=""
$AssignGroups="winos"

# 
# Start of Script
#

Connect-VIServer $vCenter -user $User -Password $Password

for ($i=$MinAccount; $i -le $MaxAccount; $i++)
{
	$VMHostAccount="Team"+$i.ToString("00")
	
	if ($debug) {
		write-host "VMHostAccount:",$VMHostAccount
		write-host }
	  
	if ($create)
	{
		New-VMHostAccount -Id $VMHostAccount -Password P@ssw0rd -UserAccount:$true -AssignGroups $AssignGroups -Server $vCenter -Confirm:$false
	}

	if ($delete)
	{
		Remove-VMHostAccount $VMHostAccount -Confirm:$false
	}
}

Disconnect-VIServer -Server $vCenter -confirm:$false

#
# End of script
#
