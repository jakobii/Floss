
function ConvertFrom-Percentage {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [string]
        $InputObject
    )

    [double]$Percentage = Format-Decimal $InputObject

    if ($Percentage) {
        $Decimal = $Percentage / 100
        return $Decimal
    }

    # maybe some string convertion here as well.
}

