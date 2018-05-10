



function Format-Int {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,

        [switch]
        $DBNull
    )
    if(Test-Falsy $InputObject){ return Pop-Falsy -DBNull:$DBNull }

    [string]$int = ''
    foreach ($char in $InputObject.ToCharArray()) {
        [string]$str = $char
        if ($str -match '^\d$') {
            [string]$int += $str
        }
    }

    return Pop-Falsy $int -DBNull:$DBNull
}












