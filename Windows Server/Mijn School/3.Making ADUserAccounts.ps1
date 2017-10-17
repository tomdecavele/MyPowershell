$UserNames = Import-Csv ".\UserAccounts.csv" -Delimiter ";"
 
Foreach ($User in $UserNames)
{ 
	$Name = $User.Name
	$SamAccountName = $User.SamAccountName
	$DisplayName = $User.DisplayName
	$GivenName = $User.GivenName
	$SurName = $User.SurName
	$HomeDrive = $User.HomeDrive
    $HomeDirectory = $User.HomeDirectory
    $ScriptPath = $User.ScriptPath
	$Path = $User.Path

	$AccountPassword = ConvertTo-SecureString $User.AccountPassword -AsPlainText -force

	New-ADUser -Name $Name -SamAccountName $SamAccountName -DisplayName $DisplayName -GivenName $GivenName -Surname $SurName -HomeDrive $HomeDrive -HomeDirectory $HomeDirectory -ScriptPath $ScriptPath -Path $Path -AccountPassword $AccountPassword -Enabled:$true
}