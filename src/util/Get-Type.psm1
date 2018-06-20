


Function Get-type {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    $InputObject.GetType()
}