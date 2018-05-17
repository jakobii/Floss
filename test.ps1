# Get all the things
[array]$items = Get-ChildItem "$PSScriptRoot\test" -Recurse
foreach ( $item in $items) {
    # filter the modules
    if ($item.Extension -eq '.ps1') {
        [array]$lines = Get-Content -ReadCount 1 -Path $item.FullName
         
        # skip empty files
        if ($lines -eq $null ) {continue} 

        if ($lines[0].Trim() -eq '#unit') {
            # import!
            Write-alert $item.FullName -bouble
            . $item.FullName
        }
    }
}
 