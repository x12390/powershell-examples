$header = @"
<style>
@import 'https://fonts.googleapis.com/css?family=Montserrat:300,400,700';
body { font-family: Montserrat, sans-serif;}
table { border-collapse: collapse;}
th {  background: #ccc;}
th, td {border: 1px solid #ccc; padding: 8px;}
tr:nth-child(even) {background: #efefef;}
tr:hover {background: #d1d1d1;}
</style>
"@

#Install Web Server (IIS)
Install-WindowsFeature -name Web-Server

#Get instance metadata from Azure Instance Metadata service
$metadata = Invoke-RestMethod -Headers @{"Metadata"="true"} -URI http://169.254.169.254/metadata/instance?api-version=2017-08-01 -Method get

#create data object with some instance metadata
$body = New-Object System.Collections.ArrayList
$body.Add([pscustomobject] @{"Name" = "Server Name"; "Value" = $metadata.compute.name}) | Out-Null
$body.Add([pscustomobject] @{"Name" = "Azure Location"; "Value" = $metadata.compute.location}) | Out-Null
$body.Add([pscustomobject] @{"Name" = "Resource Group"; "Value" = $metadata.compute.resourceGroupName}) | Out-Null
$body.Add([pscustomobject] @{"Name" = "Private IP"; "Value" = $metadata.network.interface.ipv4.ipAddress.privateIpAddress}) | Out-Null

#Convert data object to HTML and overwrite existing index
$HTML = $body | ConvertTo-Html -Title "WebServer Details"-Head $header
$HTML | Out-File -FilePath "C:\inetpub\wwwroot\index.html" -Force 
