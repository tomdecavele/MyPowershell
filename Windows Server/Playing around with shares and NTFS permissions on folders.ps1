#
# making a share and set NTFS permissions remotely 
#

#
# making a share remotely
# - name : homedirs
# - share perms : everyone - full control
# - NTFS perms : Administrators - full control and Authenticated Users - ReadAndExecute on this folder only 
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

#
# making a share remotely
# - name : profiles
# - share perms : everyone - full control
# - NTFS perms : Administrators - full control and Authenticated Users - Modify
#
New-Item -Path \\team10-ms\C$\Profiles -type directory -Force 
New-SmbShare -CimSession team10-ms –Name Profiles –Path c:\Profiles -FullAccess Everyone

$acl = Get-Acl \\team10-ms\c$\Profiles
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl \\team10-ms\c$\Profiles $acl

#
# making a share remotely
# - name : public
# - share perms : everyone - full control
# - NTFS perms : Administrators - full control and Authenticated Users - ReadAndExecute
#
New-Item -Path \\team10-ms\C$\Public -type directory -Force 
New-SmbShare -CimSession team10-ms –Name Public –Path c:\Public -FullAccess Everyone

$acl = Get-Acl \\team10-ms\c$\Public
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","ReadandExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl \\team10-ms\c$\Public $acl
