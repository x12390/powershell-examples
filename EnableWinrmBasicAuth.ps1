<#Winrm for Machine without AD. Enables Basic Authentication over http #>

$enable = $true
Enable-PSRemoting -Force
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $enable
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $enable

new-netfirewallrule -name WinRM-BA -displayname WinRM-BA -localport 5985 -profile any -action allow -protocol tcp
