

FUNCTION Write-Success {
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
        $write.BackgroundColor = 'green'
    }
    else {
        $write.ForegroundColor = 'green'
    }

    # object
    if ($Message -is [hashtable]) {
        $Write.Object = Format-HashtableAsList  $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }

    # write
    Write-Host @write

}

