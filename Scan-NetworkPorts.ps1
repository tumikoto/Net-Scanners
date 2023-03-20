param (
	[Parameter(Mandatory=$true,Position=1)][string]$targetip,
	[Parameter(Mandatory=$true,Position=2)][string]$firstPort,
	[Parameter(Mandatory=$true,Position=3)][string]$lastPort,
	[Parameter(Mandatory=$true,Position=4)][string]$timeout
)

If (!($targetIP) -and ($firstport) -and ($lastport) -and ($time)) {
	Write-Host "Usage:"
	Write-Host  "`tpowershell.exe Scan-NetworkPorts.ps1 -targetip <ip_address> -firstport <first_port> -lastport <last_port> -timeout <timeout_ms>"
	Write-Host " "
	Write-Host "Example:"
	Write-Host "`tpowershell.exe Scan-NetworkPorts.ps1 -targetip 192.168.1.1 -firstport 1 -lastport 1024 -timeout 2000"
	Exit
}

function PortCheck {
	Param([string]$srv,$p=445,$timeout=2000)
	try {
		$tcpclient = new-Object system.Net.Sockets.TcpClient
		$iar = $tcpclient.BeginConnect($srv,$p,$null,$null)
		$wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)
		
		if(!$wait) {
			$tcpclient.Close()
		} else {
			Write-Host $srv`:$p is open!
			$tcpclient.EndConnect($iar) | out-Null
			$tcpclient.Close()
		}
	}
	catch {
		return
	}
}

ForEach ($number in ($firstPort..$lastPort)) {
	PortCheck -srv $targetip -p $number -timeout $timeout
}
