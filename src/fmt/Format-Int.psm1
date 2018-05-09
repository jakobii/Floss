



function Format-Int {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    [string]$int = ''
    foreach ($char in $InputObject.ToCharArray()) {
        [string]$str = $char
        if ($str -match '^\d$') {
            [string]$int += $str
        }
    }

    if ($int) {
        return $int
    }
}












