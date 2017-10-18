#
# making a share and set NTFS permissions remotely 
#

#
# making a share remotely
# - name : homedirs
# - share perms : everyone - full control
# - NTFS perms : Administrators - full control and Authenticated Users - ReadAndExecute on this folder only 
#
$FileServer="team10-ms"
$Share="C$"
$Drive="C:"
$Dir="Homedirs"
$LocalPath=$Drive+"\"+$Dir
$Path="\\"+$FileServer+"\"+$Share+"\"+$Dir

New-Item -Path $Path -type directory -Force
New-SmbShare -CimSession $FileServer –Name $Dir –Path $LocalPath -FullAccess Everyone

$acl = Get-Acl $Path
$acl.SetAccessRuleProtection($True, $False)
#
# SetAccessRuleProtection (isProtected As Boolean,preserveInheritance As Boolean)
# - isProtected: true to protect the access rules from inheritance (=disable inheritance).
# - preserveInheritanceType: false to remove inherited access rules. This parameter is ignored if isProtected is false.
#
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","ReadAndExecute", "None", "NoPropagateInherit", "Allow")
$acl.AddAccessRule($rule)

Set-Acl $Path $acl

#
# making a share remotely
# - name : profiles
# - share perms : everyone - full control
# - NTFS perms : Administrators - full control and Authenticated Users - Modify
#
$FileServer="team10-ms"
$Share="C$"
$Drive="C:"
$Dir="Profiles"
$LocalPath=$Drive+"\"+$Dir
$Path="\\"+$FileServer+"\"+$Share+"\"+$Dir

New-Item -Path $Path -type directory -Force 
New-SmbShare -CimSession $FileServer –Name $Dir –Path $LocalPath -FullAccess Everyone

$acl = Get-Acl $Path
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl $Path $acl

#
# making a share remotely
# - name : public
# - share perms : everyone - full control
# - NTFS perms : Administrators - full control and Authenticated Users - ReadAndExecute
#
$FileServer="team10-ms"
$Share="C$"
$Drive="C:"
$Dir="Public"
$LocalPath=$Drive+"\"+$Dir
$Path="\\"+$FileServer+"\"+$Share+"\"+$Dir

New-Item -Path $Path -type directory -Force 
New-SmbShare -CimSession $FileServer –Name $Dir –Path $LocalPath -FullAccess Everyone

$acl = Get-Acl $Path
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl $Path $acl
