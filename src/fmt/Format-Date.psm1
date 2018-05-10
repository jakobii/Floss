

# Returns Time formated in base 24h

Function Format-Date {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,

        [switch]
        $DBNull
    )

    if(Test-Falsy $InputObject){ return Pop-Falsy -DBNull:$DBNull }

    [string]$OutputObject = $(Get-Date -Date $InputObject).ToShortDateString()

    return Pop-Falsy $OutputObject -DBNull:$DBNull
}






