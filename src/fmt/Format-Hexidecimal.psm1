#beta


Function Format-Hexidecimal {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    
    if ($InputObject -is [byte]) {
        [string]$OutputObject = [String]::Join("", ($InputObject | ForEach-Object { "{0:X2}" -f $_}))
    }
    else{

        [string]$InputObject =  "{0:X2}"  -f $InputObject 
    }

    return $OutputObject 
}