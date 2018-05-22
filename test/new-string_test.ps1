


import-module "$PSScriptRoot\..\inquiry.psm1"

$Hash = @{
    hrId = 'blah'
    fn   = 'omG'
}

[array]$array += $Hash.Values
$Hash | new-String | Get-Hash


