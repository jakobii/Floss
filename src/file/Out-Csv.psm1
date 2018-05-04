

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










