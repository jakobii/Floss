

function Compress-Modules {
    
    param(
        [array]
        $Sources,

        [system.io.fileinfo]
        $destination,

        [string]
        $Name,

        [string]
        $Version

    )

    [string]$module_content = ''
    if ($sources -is [array]) {
        foreach ($path in $Sources) {
            [array]$ChildItems += Get-ChildItem -Path $path -Recurse
        }
        foreach ($ChildItem in $ChildItems) {
            $item = get-item $ChildItem.FullName
            if ( $item.Extension -eq '.psm1' ) {
                [array]$content = get-content $item -Delimiter "`r`n"
                if ( $content[0] -like "#beta*" ) {continue}

                [string]$module_content += "<#`t$($item.Name)`t#>`r`n"
                foreach ( $line in $content ) {
                    if ( $line.trim() -eq '' ) {continue}
                    [string]$module_content += $line
                }
                [string]$module_content += "`r`n"
            }
        }
    }


    # Manifest
    $func_SEARCH = [regex]::new('[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]\s+([0-9a-zA-Z]+)-([0-9a-zA-Z]+)(\s+)?(.+)?(\s+)?[{]')
    $match = $func_SEARCH.Match( $module_content )
    while ( $match.Success ) {
        $Verb = $match.groups[1]
        $Noun = $match.groups[2]

        [array]$Verbs += $Verb
        [array]$Nouns += $Noun
        [array]$Funcs += "$Verb-$Noun"
        
        $match = $match.NextMatch()
    }
    [string]$manifest = "<# MANIFEST`r`n"
    foreach( $func in $Funcs ){
        [string]$manifest += "`t$func`r`n"
    }
    [string]$manifest += "#>"


    if ($version) {
        [string]$header = "<#`r`n`tModule    : $($Name)`r`n`tVersion   : $($version)`r`n`tDateTime  : $(get-date)`r`n`tFunctions : $($Funcs.Count)`r`n#>`r`n"
    }

    [string]$everything = $header + $manifest + $("`r`n" * 5) + $module_content
    new-item -Path $destination -Value $everything -Force

}


