




FUNCTION Import-Config {

    param(
        [string]
        $Path,

        [string]
        $Format = 'json'
    )


    # Resolve Path
    if ($Path -and $(Test-Path $Path) ) {
        [string]$Content = Get-Content -Path $Path
    }
    else{
        return $null
    }

    # Resolve Format and Import
    if ( $Format -eq 'json' ) {
        $Config = ConvertFrom-Json $Content
    }


    $Config
}



