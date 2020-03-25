param (
	[Parameter(Mandatory=$true,Position=1)][string]$targetip,
	[Parameter(Mandatory=$true,Position=2)][string]$firstPort,
	[Parameter(Mandatory=$true,Position=3)][string]$lastPort,
	[Parameter(Mandatory=$true,Position=4)][string]$timeout
)

If (!($targetIP) -and ($firstport) -and ($lastport) -and ($time)) {
	Write-Host Usage:
	Write-Host  powershell.exe portscanner.ps1 -targetip <IP address> -firstport <first port in range> -lastport <last port in range> -time <timeout value in ms>
	Write-Host " "
	Write-Host Example:
	Write-Host  powershell.exe portscanner.ps1 -targetip 192.168.1.1 -firstport 1 -lastport 1024 -time 100
	Exit
}

function PortCheck {
	Param([string]$srv,$p=135,$timeout=100)
	
	$tcpclient = new-Object system.Net.Sockets.TcpClient
	$iar = $tcpclient.BeginConnect($srv,$p,$null,$null)
	$wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)
	
	if(!$wait) {
		$tcpclient.Close()
	} else {
		$tcpclient.EndConnect($iar) | out-Null
		$tcpclient.Close()
		Write-Host $srv`:$p is open!
	}
}

ForEach ($number in ($firstPort..$lastPort)) {
	PortCheck -srv $targetip -p $number -timeout $timeout
}
