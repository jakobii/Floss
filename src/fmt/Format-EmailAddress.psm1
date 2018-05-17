
FUNCTION Format-EmailAddress {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    $Match = [regex]::new('([0-9a-zA-Z._-]+@[0-9a-zA-Z._-]+[.][0-9a-zA-Z._-]+)').Match($InputObject)
    $Email = $Match.Groups[1].Value.ToLower().Trim()
    return Pop-Falsy $Email
}