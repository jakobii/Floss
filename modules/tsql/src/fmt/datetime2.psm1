


Function Format-DateTime2($Value) {
    if ($Value) {
        $DT = Get-Date -Date $Value
        [string]$DateTime2 = $DT.Year.ToString() + '-'
        [string]$DateTime2 += $DT.Month.ToString() + '-'
        [string]$DateTime2 += $DT.Day.ToString() + ' '
        [string]$DateTime2 += $DT.TimeOfDay.ToString()
        return $DateTime2 -replace "'", "''"
    }
}



