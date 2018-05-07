


Function Invoke-AsAdmin {

    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$command
        ,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$credential
        ,
        [Parameter(Mandatory = $false)]
        [ValidateSet("Restricted", "AllSigned", "RemoteSigned", "Unrestricted", "Bypass")]
        [String]$executionPolicy = "Bypass"
    )

    
    Write-Verbose "EXECUTING COMMAND WITH ELEVATED PRIVILEGES: $command"
    $result = @{'result' = $false; 'output' = $false; 'error' = $false};
    $psi = New-object System.Diagnostics.ProcessStartInfo
    #$psi.CreateNoWindow = $true 
    $psi.UseShellExecute = $false 
    $psi.RedirectStandardOutput = $true 
    $psi.RedirectStandardError = $true 
    $psi.FileName = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' 
    $psi.Arguments = @"
-ExecutionPolicy $executionPolicy $command
"@
    $psi.UserName = $credential.GetNetworkCredential().UserName
    $psi.Domain = $credential.GetNetworkCredential().Domain
    $psi.Password = $credential.Password
    $psi.Verb = "runas"
    $process = New-Object System.Diagnostics.Process 
    $process.StartInfo = $psi
    try {
        $result['result'] = $process.Start()
        $result['output'] = $process.StandardOutput.ReadToEnd()   
        $result['error'] = $process.StandardError.ReadToEnd()
    }
    catch {
        $result['result'] = $false
        $result['error'] = Write-Error $_.Exception.Message
    }
	
    if ($result['error'] -ne '') {
        Write-Verbose $result['error']
    }
    $result
}


