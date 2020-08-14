# Config Basic Auth with HTTP for WinRM (used for Win 2016 Datacenter)

#create ansible user
$USERNAME = "Ansible"
$Password = Read-Host -AsSecureString -Prompt 'Input password for User $AnsibleUser '

#does user exist
Try {
    Write-Verbose "Searching for $($USERNAME) in LocalUser DataBase"
    $ObjLocalUser = Get-LocalUser $USERNAME
    Write-Verbose "User $($USERNAME) was found"
}

Catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    "User $($USERNAME) was not found" | Write-Warning
}

Catch {
    "An unspecifed error occured" | Write-Error
    Exit # Stop Powershell! 
}

#Create the user if it was not found
If (!$ObjLocalUser) {
  New-LocalUser $USERNAME -Password $Password -FullName "Ansible User" -Description ""
  #add user to administrator group
  Add-LocalGroupMember -Group "Administrators" -Member $USERNAME
}

#enable basic auth
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true

#enable unencrypted connection
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true

#display winrm config
winrm get winrm/config/service

#open ansible port
New-NetFirewallRule -DisplayName "Ansible-Port" -Direction Inbound -Action Allow -EdgeTraversalPolicy Allow -Protocol TCP -LocalPort 5985,5986