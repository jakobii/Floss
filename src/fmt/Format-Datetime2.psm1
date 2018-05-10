


Function Format-DateTime2 {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,

        [switch]
        $DBNull
    )
    if(Test-Falsy $InputObject){ return Pop-Falsy -DBNull:$DBNull }


    $DT = Get-Date -Date $InputObject
    [string]$DateTime2 = $DT.Year.ToString() + '-'
    [string]$DateTime2 += $DT.Month.ToString() + '-'
    [string]$DateTime2 += $DT.Day.ToString() + ' '
    [string]$DateTime2 += $DT.TimeOfDay.ToString()
    [string]$OutputObject = $DateTime2

    return Pop-Falsy $OutputObject -DBNull:$DBNull
}



