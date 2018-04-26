

Import-Module "$PSScriptRoot\Format-Hashtable.psm1"






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
        $Write.Object = format-hashtable $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }

    # write
    Write-Host @write

}


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

FUNCTION Write-alter {
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
        $Write.Object = format-hashtable $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }

    # write
    Write-Host @write
}

FUNCTION Write-End {
    Param(
        $Message,

        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    if (!$Message) {[string]$Message = $(Get-PSCallStack)[1].FunctionName}
    Write-Host "`0Ending`0$Message`0`n" -f black -b Gray
}


FUNCTION Write-Start {
    Param(
        $Message,

        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    if (!$Message) {[string]$Message = $(Get-PSCallStack)[1].FunctionName}
    Write-Host "`n`0Starting`0$Message`0" -f black -b DarkCyan
}


FUNCTION Write-time {
    Param(
        $Start,

        $End = $(get-date),

        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    $time_span = New-TimeSpan -Start $Start -End $End 

    Write-Host "Timespan`0: $time_span"  -f Magenta
}





function write-log {

    Param(
        $Message,

        [switch]
        $verbosely = $true,
        
        [string]
        $type,
        
        [switch]
        $bouble
    )
    if(!$verbosely){return}
    
    $write = @{}

    switch ( $type ) {

        'start' { 
 
            $write.ForegroundColor = 'black'
            $write.BackgroundColor = 'DarkCyan'
            $Write.Object = "`n`0Starting`0$Message`0"
            break
        }
        'end' { 
   
            $write.ForegroundColor = 'black'
            $write.BackgroundColor = 'gray'
            $Write.Object = "`0Ending`0$Message`0`n"
            break
        }
        'time' { 
            if ($bouble) {
                $write.ForegroundColor = 'white'
                $write.BackgroundColor = 'magenta'
            }
            else {
                $write.ForegroundColor = 'magenta'
            }
            break
        }
        'success' { 
            if ($bouble) {
                $write.ForegroundColor = 'black'
                $write.BackgroundColor = 'green'
            }
            else {
                $write.ForegroundColor = 'green'
            }
            break
        } 
        'fail' { 
            if ($bouble) {
                $write.ForegroundColor = 'black'
                $write.BackgroundColor = 'red'
            }
            else {
                $write.ForegroundColor = 'red'
            }
            break
        }
        'note' { 
            if ($bouble) {
                $write.ForegroundColor = 'black'
                $write.BackgroundColor = 'white'
            }
            else {
                $write.ForegroundColor = 'white'
            }
            break
        }
        'alert' { 
            if ($bouble) {
                $write.ForegroundColor = 'black'
                $write.BackgroundColor = 'yellow'
            }
            else {
                $write.ForegroundColor = 'yellow'
            }
            break
        }
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








