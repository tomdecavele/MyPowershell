$OUNames = Import-Csv ".\OUs.csv" -Delimiter ";"
 
Foreach ($OU in $OUNames)
{ 
	$Name = $OU.Name
	$DisplayName = $OU.DisplayName
	$Description = $OU.Description
	$Path = "OU=" + $Name + "," + $OU.Path

	set-ADOrganizationalUnit -Identity $Path -ProtectedFromAccidentalDeletion:$false
} 
