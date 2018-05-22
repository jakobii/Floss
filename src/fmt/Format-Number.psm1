



function Format-Number {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    [string]$int = ''
    foreach ($char in $InputObject.ToCharArray()) {
        [string]$str = $char
        if ($str -match '^\d$') {
            [string]$int += $str
        }
    }

    return Pop-Falsy $int
}












