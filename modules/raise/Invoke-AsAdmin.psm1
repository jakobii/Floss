





Function Invoke-AsAdmin($Command,[switch]$Exit) {
    # $myinvocation.MyCommand.Definition

    Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f $Command )
    
    if ($Exit) {
        exit $LASTEXITCODE
    }
}




