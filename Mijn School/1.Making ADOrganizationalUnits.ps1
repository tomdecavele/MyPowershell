$OUNames = Import-Csv ".\OUs.csv" -Delimiter ";"
 
Foreach ($OU in $OUNames)
{ 
	$Name = $OU.Name
	$DisplayName = $OU.DisplayName
	$Description = $OU.Description
	$Path = $OU.Path

	New-ADOrganizationalUnit -Name $Name -DisplayName $DisplayName  -Description $Description -Path $Path
} 
