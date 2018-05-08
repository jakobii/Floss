

function Get-SftpFile {
    param(
        
        [string]
        $Server,
        
        [string]
        $UserName,
        
        [string]
        $Password,
        
        [string]
        $SshFingerprint,
        
        [string]
        $UnixPath,
        
        [string]
        $UnixFile,
        
        [string]
        $Path,
        
        [string]
        $DllPath,

        [boolean]
        $verbosely
    )
    # Load WinSCP .NET assembly 
    try {  
        [System.Reflection.Assembly]::UnsafeLoadFrom($DllPath) | Out-Null
    }
    catch {
        write-fail "could not load the winscpnet.dll. $PSItem"
    }

    # Set up session options
    $WinSCP_Properties = @{ 
        Protocol              = [WinSCP.Protocol]::Sftp        
        HostName              = $Server                        
        UserName              = $UserName                      
        Password              = $Password                      
        SshHostKeyFingerprint = $SshFingerprint   
    }
    
    $Auth = New-Object WinSCP.SessionOptions -Property $WinSCP_Properties
    $Session = New-Object WinSCP.Session
    
    try {
        $Session.Open($Auth)
        $Session.GetFiles("$UnixPath/$UnixFile", "$("$Path")\*").Check()
        if ($verbosely) {Write-Success -M "$UnixFile was downloaded from $Server"}
    }
    catch {
        if ($verbosely) {throw $PSItem }
        $Session.Dispose() 
    }
}



