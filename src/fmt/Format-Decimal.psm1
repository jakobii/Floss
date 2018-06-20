




function Format-Decimal {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    [string]$decimal = ''
    $decimalPointNotUsed = $true
    foreach ($char in $InputObject.ToCharArray()) {
        [string]$str = $char
        
        if ($str -match '^\d$') {
            [string]$decimal += $str
        }

        if ($str -match '^[.]$' -and $decimalPointNotUsed ) {
            [string]$decimal += $str
            $decimalPointNotUsed = $false
        }

    }

    return Pop-Falsy $decimal
}





