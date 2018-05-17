FUNCTION Write-Time {
    Param(
        $Start,

        $End = $(get-date),

        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    $time_span = New-TimeSpan -Start $Start -End $End 

    Write-Host "Timespan`0: $time_span"  -f Magenta
}
