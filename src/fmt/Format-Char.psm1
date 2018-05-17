
<# Returns only a single character.
 # if more than one character is provided
 # it should return the first character that 
 # is not a space.
 # will return null for empty strings.
 # returns a single character string
 #>

FUNCTION Format-Char {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    [string]$str = $InputObject
    [array]$char_array = $str.ToCharArray()
    
    FOREACH ($Char in $char_array) {
        if ( test-falsy $Char -af ) { 
            [string]$OutputObject = $Char
            Break
        }
    }

    return Pop-Falsy $OutputObject
}


