# Config Basic Auth with HTTP for WinRM (used for Win 2016 Datacenter)

#create ansible user
$AnsibleUser = "Ansible"
$Password = Read-Host -AsSecureString -Prompt 'Input password for user $AnsibleUser'
New-LocalUser $AnsibleUser -Password $Password -FullName "Ansible User" -Description ""

#add user to administrator group
Add-LocalGroupMember -Group "Administrators" -Member $AnsibleUser

#enable basic auth
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true

#enable unencrypted connection
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true

#display winrm config
winrm get winrm/config/service

#open ansible port
New-NetFirewallRule -DisplayName "Ansible-Port" -Direction Inbound -Action Allow -EdgeTraversalPolicy Allow -Protocol TCP -LocalPort 5985,5986
