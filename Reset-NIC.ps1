#This script reboots the NIC and reconnects to WiFi
#Reboot NIC
Disable-NetAdapter -InterfaceDescription "Intel(R) Dual Band Wireless-AC 8260"
Write-Output "-----------------------------`r`n- NIC Successfully Disabled -`r`n-----------------------------"
for($timer = 3; $timer -gt 0; $timer--)
{
	Start-Sleep 1
	Write-Output "- Attempting Reboot: $timer"
}
Enable-NetAdapter -InterfaceDescription "Intel(R) Dual Band Wireless-AC 8260"
Write-Output "----------------------------`r`n- NIC Successfully Enabled -`r`n----------------------------"
for($timer = 3; $timer -gt 0; $timer--)
{
	Start-Sleep 1
	Write-Output "- Attempting Connection: $timer"
}

#Find known WiFi network
try{$SSID.clear()}
catch{}
$profiles = (netsh wlan show profiles) -Match '^\s+All User Profile' -Replace '^\s+All User Profile\s+:\s+',''
$networks = (netsh wlan show networks)
ForEach($line0 in $profiles)
{
	ForEach($line1 in $networks)
	{
		if($line1 -like '^SSID')
		{
			$SSID = ($line) -Replace '^SSID\s+[0-9]+\s+:\s+',''
			if($line0 -eq $SSID){break}
		}
	}
	if($SSID){break}
}

#Get WiFi credentials and connect to WiFi
$key = (netsh wlan show profile name=$SSID key = clear) -Match '^\s+Key Content\s+' -Replace '^\s+Key Content\s+:\s+',''
Write-Output "-------------------------"
netsh wlan connect name=$SSID
Write-Output "-------------------------"

#Test Connection
for($timer = 3; $timer -gt 0; $timer--)
{
	Start-Sleep 1
	Write-Output "- Testing Connection: $timer"
}
$error.clear()
try{ Test-Connection google.com -Count 3 >> $null}
catch{ Write-Output "---------------------`r`n- Connection Failed -`r`n---------------------`r`n" }
if(!$error){ Write-Output "-------------------------`r`n- Connection Successful -`r`n-------------------------`r`n" }

#Clear Variables
try{$timer.clear()}catch{}
try{$SSID.clear()}catch{}
try{$line0.clear()}catch{}
try{$line1.clear()}catch{}
try{$profiles.clear()}catch{}
try{$networks.clear()}catch{}
try{$key.clear()}catch{}