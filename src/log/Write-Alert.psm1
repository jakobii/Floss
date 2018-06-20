
FUNCTION Write-Alert {
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
        $write.BackgroundColor = 'yellow'
    }
    else {
        $write.ForegroundColor = 'yellow'
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

