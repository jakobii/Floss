#beta

FUNCTION Format-Percent {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    return Pop-Falsy $InputObject
}