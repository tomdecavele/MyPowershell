#
# preparing VMs for exams, lessons
#
# TDC3 vof - September,2017
#
# $erroractionpreference = "Stop"
# set-psdebug -strict

$debug=0

$deploy=1
$correct_LAN=0
$delete=0

$Min=1
$Max=1

$vCenter="xxx.xxx.xxx.xxx"
$User="xxx@vsphere.local"
$Password="xxx"

$TEMPLATE_pfSense="TEMPLATE_pfSense"
$TEMPLATE_Windows="TEMPLATE_W10 (RDP)"
$TEMPLATE_Windows_Server="TEMPLATE_W2016"

$ResourcePool=""
$NetworkName=""

$VM_Name=""
$Template=""
$DataStore=""
$NetworkAdapter=""

function Deploy-VM
{
    if ($debug) {
		write-host "VM_Name:",$VM_Name,"; Template:",$Template
		}

	New-VM -Name $VM_Name -ResourcePool $ResourcePool -Datastore $DataStore -Template $Template -DiskStorageFormat Thin -RunAsync:$true -Confirm:$false
}

function correct-LAN
{
   if ($debug) {
       write-host "Correcting LAN on",$VM_Name,"..."
       }
	   
   Get-NetworkAdapter -VM $VM_Name | where {$_.Name -eq $NetworkAdapter} | Set-NetworkAdapter -NetworkName $NetworkName -RunAsync:$true -Confirm:$false
}

function Delete-VM
{
   if ($debug) {
       write-host "Removing",$VM_Name,"..."
       }
	   
   Remove-VM $VM_Name -DeletePermanently -Confirm:$false
}

# 
# Start of Script
#

Connect-VIServer $vCenter -user $User -Password $Password

for ($i=$Min; $i -le $Max; $i++)
{
	$ResourcePool="Team"+$i.ToString("00")
	$NetworkName="LAN "+$ResourcePool
	
	if ($debug) {
		write-host "ResourcePool:",$ResourcePool,"; NetworkName:",$NetworkName
		write-host }
	  
	if ($deploy)
	{
		$VM_Name=$ResourcePool+"_pfSense"
		$Template=$TEMPLATE_pfSense
		$DataStore="SAN001-1"
#		Deploy-VM
	   
		$VM_Name=$ResourcePool+"_W10"
		$Template=$TEMPLATE_Windows
		$DataStore="SAN001-1"
#	   	Deploy-VM
		
		$VM_Name=$ResourcePool+"_DC1"
		$Template=$TEMPLATE_Windows_Server
		$DataStore="SAN002-1"
    	Deploy-VM

		$VM_Name=$ResourcePool+"_MS"
		$Template=$TEMPLATE_Windows_Server
		$DataStore="SAN002-1"
#	   	Deploy-VM
	}

	if ($correct_LAN)
	{
		$VM_Name=$ResourcePool+"_pfSense"
		$NetworkAdapter="Network adapter 2"
#		correct-LAN
		
		$VM_Name=$ResourcePool+"_W10"
		$NetworkAdapter="Network adapter 1"
#		correct-LAN

		$VM_Name=$ResourcePool+"_DC1"
		$NetworkAdapter="Network adapter 1"
		correct-LAN

		$VM_Name=$ResourcePool+"_MS"
		$NetworkAdapter="Network adapter 1"
#	   	correct-LAN
    }
	 
	if ($delete)
	{
		$VM_Name=$ResourcePool+"_pfSense"
		Delete-VM

		$VM_Name=$ResourcePool+"_W10"
		Delete-VM

		$VM_Name=$ResourcePool+"_DC1"
#		Delete-VM

		$VM_Name=$ResourcePool+"_MS"
#		Delete-VM				
	}
}

Disconnect-VIServer -Server $vCenter -confirm:$false

#
# End of script
#