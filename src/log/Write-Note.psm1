FUNCTION Write-Note {
    Param(
        $Message,

        [switch]
        $verbosely = $true,
        
        [switch]
        $bouble
    )
    if(!$verbosely){return}
    $write = @{}
    
    # color
    if ($bouble) {
        $write.ForegroundColor = 'black'
        $write.BackgroundColor = 'white'
    }
    else {
        $write.ForegroundColor = 'white'
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


