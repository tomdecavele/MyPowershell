$Members = Import-Csv ".\GroupMembers.csv" -Delimiter ";"
 
Foreach ($Member in $Members)
{ 
	$Identity = $Member.Identity
	$Members = $Member.Member

	Add-ADGroupMember -Identity $Identity -Members $Members
}