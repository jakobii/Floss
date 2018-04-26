


Function Format-DateTime($Value) {
    # Returns Time formated in base 24h
    if ($Value) {
        $DT = Get-Date -Date $Value
        [string]$DateTime = $DT.Year.ToString() + '-'
        [string]$DateTime += $DT.Month.ToString() + '-'
        [string]$DateTime += $DT.Day.ToString() + ' '
        [string]$DateTime += $DT.Hour.ToString() + ':'
        [string]$DateTime += $DT.Minute.ToString() + ':'
        [string]$DateTime += $DT.Second.ToString() 
        return $DateTime -replace "'", "''"
    }
}

