FUNCTION Write-Note {
    Param(
        $Message,

        [switch]
        $verbosely = $true,
        
        [switch]
        $bouble
    )
    $ParentFunc = Get-Function -CallStack 2
    if ( !$Verbosely -or !$ParentFunc.Parameters.Verbosely ) {return}

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
        $Write.Object = Format-HashtableAsList  $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }

    # write
    Write-Host @write
}


