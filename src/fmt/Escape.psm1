function Out-SqlEscape($Value){
    # [fix] use regex
    return $Value -replace "'", "''"
}
