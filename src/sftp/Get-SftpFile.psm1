

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

        [switch]
        $force,

        [switch]
        $verbosely
    )

    

    write-start -Verbosely:$Verbosely
    $StartTime = get-date
    $LOG = @{}
    $LOG.DllPath = $DllPath
    # Load WinSCP .NET assembly 
    try {  
        [System.Reflection.Assembly]::UnsafeLoadFrom($DllPath) | Out-Null
    }
    catch {
        write-fail "could not load the winscpnet.dll. $PSItem"
    }

    # magic path
    New-Path -Path $Path 

    # Remove File
    if ($Force) {
        try {
            Remove-Item -Path "$Path\$UnixFile" -Force -ErrorAction 'stop'
            $LOG.Removed = "$Path\$UnixFile"
        }
        catch {}
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
    $LOG += $WinSCP_Properties

    try {
        $Session.Open($Auth)
        $Session.GetFiles("$UnixPath/$UnixFile", "$("$Path")\*").Check()
        $LOG.Success = $true
        write-success $LOG  -Verbosely:$Verbosely
    }
    catch {
        
        $LOG.Error = $PSItem
        $LOG.Success = $False
        write-fail $LOG -Verbosely:$Verbosely

        $Session.Dispose() 
    }

    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -Verbosely:$Verbosely
}



