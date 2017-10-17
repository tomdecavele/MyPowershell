#
# making a share and set NTFS permissions remotely 
#

New-Item -Path \\team10-ms\C$\Homedirs -type directory -Force
New-SmbShare -CimSession team10-ms –Name Homedirs –Path c:\Homedirs -FullAccess Everyone

$acl = Get-Acl \\team10-ms\c$\Homedirs
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","ReadAndExecute", "None", "NoPropagateInherit", "Allow")
$acl.AddAccessRule($rule)

Set-Acl \\team10-ms\c$\Homedirs $acl



New-Item -Path \\team10-ms\C$\Profiles -type directory -Force 
New-SmbShare -CimSession team10-ms –Name Profiles –Path c:\Profiles -FullAccess Everyone

$acl = Get-Acl \\team10-ms\c$\Profiles
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl \\team10-ms\c$\Profiles $acl



New-Item -Path \\team10-ms\C$\Public -type directory -Force 
New-SmbShare -CimSession team10-ms –Name Public –Path c:\Public -FullAccess Everyone

$acl = Get-Acl \\team10-ms\c$\Public
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","ReadandExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl \\team10-ms\c$\Public $acl
