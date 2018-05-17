

# Returns Time formated in base 24h

Function Format-DateTime {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    $DT = Get-Date -Date $InputObject
    [string]$DateTime = $DT.Year.ToString() + '-'
    [string]$DateTime += $DT.Month.ToString() + '-'
    [string]$DateTime += $DT.Day.ToString() + ' '
    [string]$DateTime += $DT.Hour.ToString() + ':'
    [string]$DateTime += $DT.Minute.ToString() + ':'
    [string]$DateTime += $DT.Second.ToString() 
    $DateTime = Protect-Sql $DateTime

    return Pop-Falsy $DateTime
}

