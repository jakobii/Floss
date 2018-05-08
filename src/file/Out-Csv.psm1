

Import-Module "$PSScriptRoot\..\log\verbosely.psm1"


FUNCTION Out-Csv {

    Param(

        [string]
        $Path,

        $Value,

        [switch]
        $Verbosely
    )

    # Log
    Write-Start -verbosely:$Verbosely
    $start_time = get-date
    [hashtable]$state = [ordered]@{}


    # Magic Path
    $path_bool = Test-Path $Path
    if (!$path_bool) {
        try {
            [System.IO.FileInfo]$path_obj = $Path
            New-Item $path_obj.Directory -ItemType 'Directory' -Force | out-null
            $state.Directory = $path_obj.Directory 
        }
        catch{
            $state.Directory = $path_obj.Directory 
        }
    }

    
    # Export
    try {
        $Value | Export-Csv -Path $Path -Force -NoTypeInformation -ErrorAction 'Stop'
        
        $state.Success = $true
        $state.Csv = $Path

        Write-Success -Message $state -verbosely:$Verbosely
    }
    catch {
        $state.Success = $false
        $state.Error = $PSItem
        $state.Csv = $Path
        Write-fail -Message $state -verbosely:$Verbosely
    }

    # Log
    write-time -start $start_time -verbosely:$Verbosely
    write-end -verbosely:$Verbosely
}










