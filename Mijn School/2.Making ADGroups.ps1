$GroupNames = Import-Csv ".\Groups.csv" -Delimiter ";"
 
Foreach ($Group in $GroupNames)
{ 
	$Name = $Group.Name
	$DisplayName = $Group.DisplayName
	$Path = $Group.Path
	$GroupCategory = $Group.GroupCategory
	$GroupScope = $Group.GroupScope


	New-ADGroup -Name $Name -SamAccountName $Name -GroupCategory $GroupCategory -GroupScope $GroupScope -DisplayName $DisplayName -Path $Path
}