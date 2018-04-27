


Function Format-Date($Value) {
    # Returns Time formated in base 24h
    if ($Value) {
        [string]$DateTime = $(Get-Date -Date $Value).ToShortDateString()
        return $DateTime -replace "'", "''"
    }
}






