

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
    [hashtable]$log = @{}
    $log.DllPath = $DllPath
    # Load WinSCP .NET assembly 
    try {  
        [System.Reflection.Assembly]::UnsafeLoadFrom($DllPath) | Out-Null
        $log.Dll_Load_Success = $true
    }
    catch {
        $log.DllLoadSuccess = $false
        write-fail "could not load the winscpnet.dll. $PSItem"
    }

    # magic path
    New-Path -Path $Path 

    # Remove File
    if ($Force) {
        try {
            Remove-Item -Path "$Path\$UnixFile" -Force -ErrorAction 'stop'
            $log.File_Removed = "$Path\$UnixFile"
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
    [hashtable]$log = $log + $WinSCP_Properties

    try {
        $Session.Open($Auth)
        $Session.GetFiles("$UnixPath/$UnixFile", "$("$Path")\*").Check()
        $log.Success = $true
        write-success $log  -Verbosely:$Verbosely
    }
    catch {
        
        $log.Error = $PSItem
        $log.Success = $False
        write-fail $log -Verbosely:$Verbosely

        $Session.Dispose() 
    }

    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -Verbosely:$Verbosely
}



