






FUNCTION format-hashtable {
    Param(
        [hashtable]
        $Message,

        [switch]
        $verbosely = $true
    )

    # get max length
    [double]$key_Max_length = 0
    foreach( $key in $Message.keys){
        [string]$key_as_string = $key
        [int]$key_length = $key_as_string.Length
        if($key_length -gt $key_Max_length){
            [double]$key_Max_length = $key_length 
        }
    }

    # what is the max number of tabs we need?
    [int]$Max_Number_of_Tabs = ([math]::floor( $($key_Max_length/8) ) + 1)
    [int]$Max_char_with_tabs = $Max_Number_of_Tabs * 8
    $Formated_Hash = @()
    $tab = "`t"

    # format each key value with the correct number of tabs
    foreach( $key in $Message.keys){
        [string]$key_as_string = $key
        [int]$key_length = $key_as_string.Length

        # how many tabs does this one need?
        [double]$key_tab_dif = $Max_char_with_tabs - $key_length 
        [int]$tabs_needed =  ([math]::floor( $($key_tab_dif/8) ) + 1)

        # format
        $Formated_Hash += "$key_as_string$($tab*$tabs_needed):`0$($Message.$key_as_string)"
    }

    return $Formated_Hash 
}


$table = @{ a = 'abc' ; d = 'dfe'}




format-hashtable -Message $table

