
<# Returns only a single character.
 # if more than one character is provided
 # it should return the first character that 
 # is not a space.
 # will return null for empty strings.
 #>

FUNCTION Format-Char {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )

    [string]$str = $InputObject
    [array]$char_array = $str.ToCharArray()
    
    FOREACH ($item in $char_array) {
        if ($item -ne ' ') { 
            [char]$OutputObject = $item
            Break
        }
    }


    return Pop-Falsy $OutputObject
}


