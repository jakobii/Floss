
FUNCTION Write-End {
    Param(
        $Message,

        [Nullable[datetime]]
        $StartTime,

        [switch]
        $Verbosely = $true
    )  
    $ParentFunc = Get-Function -CallStack 2
    if ( !$Verbosely -or !$ParentFunc.Parameters.Verbosely ) {return}
    if (!$Message) {[string]$Message = $ParentFunc.FunctionName}

    if ($startTime) {
        $time_span = New-TimeSpan -Start $startTime -End $(get-date)
        Write-Host "Timespan`0: $time_span"  -f Magenta
    }

    Write-Host "`0Ending`0$Message`0`n" -f black -b Gray
}
