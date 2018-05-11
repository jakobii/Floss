


FUNCTION New-Path {
    param(

        [System.IO.FileInfo]
        $Path,
        
        [switch]
        $ExcludeFile,

        [switch]
        $Verbosely
    )

    if (Test-Path $Path) { return }
        
    if ($ExcludeFile){
        $NewPath = $path.Directory
    }  
    else{
        $NewPath = $path.FullName
    }

    $path_params = @{
        Path        = $NewPath
        ItemType    = 'Directory'
        Force       = $true
        ErrorAction = 'stop'
    }

    try {
        New-Item @path_params | Out-Null
        write-success $NewPath -Verbosely:$Verbosely
    }
    catch {
        write-fail $psitem -Verbosely:$Verbosely
    }
}



