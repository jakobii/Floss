
function ConvertTo-Decimal {
    param(
        [double]$Percentage
    )

    if ($Percentage) {
        $Decimal = $Percentage / 100
        return $Decimal
    }

    # maybe some string convertion here as well.
}

