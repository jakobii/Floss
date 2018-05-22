FUNCTION New-String {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    
    if($InputObject -is [array]){
        $OutputObject = [string]::Concat($InputObject)
    }
    
    if($InputObject -is [hashtable]){
        foreach($key in $InputObject.keys){
            [string]$OutputObject += [convert]::ToString( $($InputObject.$key) )
        }
    }

    if($InputObject -is [Byte]){
        $OutputObject = [System.Text.Encoding]::ASCII.GetString($InputObject)
    }

    return Pop-Falsy $OutputObject
}