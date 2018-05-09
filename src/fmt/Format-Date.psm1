

# Returns Time formated in base 24h

Function Format-Date {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    if ($InputObject) {
        [string]$DateTime_string = $(Get-Date -Date $InputObject).ToShortDateString()

    }

    return Pop-Falsy $DateTime_string
}






