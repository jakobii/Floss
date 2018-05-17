FUNCTION New-String {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    
    if($InputObject -is [array]){
        $OutputObject = [string]::Concat($InputObject)
    }

    if($InputObject -is [Byte]){
        $OutputObject = [System.Text.Encoding]::ASCII.GetString($InputObject)
    }

    return Pop-Falsy $OutputObject
}