

FUNCTION Write-Fail {
    Param(
        $Message,

        [switch]
        $bouble,

        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    
    $write = @{}

    # color
    if ($bouble) {
        $write.ForegroundColor = 'black'
        $write.BackgroundColor = 'red'
    }
    else {
        $write.ForegroundColor = 'red'
    }

    # object
    if ($Message -is [hashtable]) {
        $Write.Object = format-hashtable $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }

    # write
    Write-Host @write

}