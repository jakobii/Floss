
FUNCTION Write-End {
    Param(
        $Message,

        [datetime]
        $StartTime,

        [switch]
        $Verbosely = $true
    )  
    if (!$Verbosely) {return}


    if ($startTime) {
        $time_span = New-TimeSpan -Start $startTime -End $(get-date)
        Write-Host "Timespan`0: $time_span"  -f Magenta
    }

    if (!$Message) {[string]$Message = $(Get-PSCallStack)[1].FunctionName}
    Write-Host "`0Ending`0$Message`0`n" -f black -b Gray
}
