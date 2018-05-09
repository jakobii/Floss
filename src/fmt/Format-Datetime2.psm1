


Function Format-DateTime2 {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    if ($InputObject) {
        $DT = Get-Date -Date $InputObject
        [string]$DateTime2 = $DT.Year.ToString() + '-'
        [string]$DateTime2 += $DT.Month.ToString() + '-'
        [string]$DateTime2 += $DT.Day.ToString() + ' '
        [string]$DateTime2 += $DT.TimeOfDay.ToString()
        return $DateTime2 -replace "'", "''"
    }
}



