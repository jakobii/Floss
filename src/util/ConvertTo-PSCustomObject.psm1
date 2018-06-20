


FUNCTION ConvertTo-PSCustomObject {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $Inputobject
    )
    
    $psobject = New-Object -TypeName 'PSCustomObject'

    if ($Inputobject -is [hashtable] -or $Inputobject -is [System.Collections.Specialized.OrderedDictionary]) {
        foreach ($key in $Inputobject.keys) {
            $psobject | Add-Member -MemberType 'NoteProperty' -Name $key -Value $Inputobject.$key 
        }
    }

    return $psobject
}
