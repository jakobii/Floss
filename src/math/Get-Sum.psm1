

function Get-Sum {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    if ($InputObject -is [array]) {
        [double]$sum = 0
        foreach ($item in $InputObject) {
            $sum = $sum + $item
        }
    }
    return $sum
}