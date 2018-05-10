

# Returns Time formated in base 24h

Function Format-DateTime {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,

        [switch]
        $DBNull
    )
    if(Test-Falsy $InputObject){ return Pop-Falsy -DBNull:$DBNull }

    $DT = Get-Date -Date $InputObject
    [string]$DateTime = $DT.Year.ToString() + '-'
    [string]$DateTime += $DT.Month.ToString() + '-'
    [string]$DateTime += $DT.Day.ToString() + ' '
    [string]$DateTime += $DT.Hour.ToString() + ':'
    [string]$DateTime += $DT.Minute.ToString() + ':'
    [string]$DateTime += $DT.Second.ToString() 
    $DateTime = Protect-Sql $DateTime

    return Pop-Falsy $DateTime -DBNull:$DBNull
}

