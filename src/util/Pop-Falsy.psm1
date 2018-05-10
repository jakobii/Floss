
# Returns null if the InputObject evaluates to falsy
FUNCTION Pop-Falsy {
    param(
        [parameter(ValueFromPipeline)]
        $InputObject,

        [switch]
        $DBNull
    )

    # Quick Check, reduce Deep checks
    if (!$InputObject) { return Pop-Null -DBNull:$DBNull }
    
    # Deep Check
    [bool]$falsy = test-falsy $InputObject
    if ($falsy) { Pop-Null -DBNull:$DBNull }
    else {return $InputObject}
}




