

# Returns Time formated in base 24h

Function Format-Date {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    if (Test-Falsy $InputObject) { return $null }

    [string]$OutputObject = $(Get-Date -Date $InputObject).ToShortDateString()

    return Pop-Falsy $OutputObject
}






