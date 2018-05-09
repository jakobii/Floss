
# Returns null if the InputObject evaluates to falsy
FUNCTION Pop-Falsy {
    param(
        $InputObject
    )

    [bool]$falsy = test-falsy $InputObject

    if($falsy){
        return $null
    }
    else{
        return $InputObject
    }
}




