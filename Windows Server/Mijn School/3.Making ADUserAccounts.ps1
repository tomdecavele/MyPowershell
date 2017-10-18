$UserNames = Import-Csv ".\UserAccounts.csv" -Delimiter ";"

$HomeServer="\\team10-ms"
$HomeShare="Homedirs" 
 
Foreach ($User in $UserNames)
{ 
	$Name = $User.Name
	$SamAccountName = $User.SamAccountName
	$DisplayName = $User.DisplayName
	$GivenName = $User.GivenName
	$SurName = $User.SurName
	$HomeDrive = $User.HomeDrive
    $HomeDirectory = $HomeServer+"\"+$HomeShare+"\"+$User.Name
    $ScriptPath = $User.ScriptPath
	$Path = $User.Path

	$AccountPassword = ConvertTo-SecureString $User.AccountPassword -AsPlainText -force

	New-ADUser -Name $Name -SamAccountName $SamAccountName -DisplayName $DisplayName -GivenName $GivenName -Surname $SurName -HomeDrive $HomeDrive -HomeDirectory $HomeDirectory -ScriptPath $ScriptPath -Path $Path -AccountPassword $AccountPassword -Enabled:$true
	New-Item -Path $HomeDirectory -type directory -Force
	$acl = Get-Acl $HomeDirectory
	$acl.SetAccessRuleProtection($False, $False)
	$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($User.name,"Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
	$acl.AddAccessRule($rule)
	Set-Acl $HomeDirectory $acl
}