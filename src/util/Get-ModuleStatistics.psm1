
FUNCTION Get-ModuleStatistics {
    param(
        $path
    )
    [array]$items = Get-ChildItem $path -Recurse
    foreach ( $item in $items) {

        # filter the modules
        if ($item.Extension -eq '.psm1') {
            [array]$lines = Get-Content -ReadCount 1 -Path $item.FullName
            
            if ($lines -eq $null ) {
                [array]$Empty += $item.name
                [int]$Empty_Count++ | out-null
            }
            if ($lines[0].Trim() -eq '#beta') {

                [array]$Beta += $item.name
                [int]$Beta_count++ | out-null
            }
            if ($lines[0].Trim() -ne '#beta') {
            
                [array]$Production += $item.name
                [int]$Production_Count++ | out-null
            }
        }

    }

    write-alert " Total Production modules $Production_Count " -bouble
    write-output $Production


    write-alert " Total Beta modules $Beta_count " -bouble
    write-output $Beta


    write-alert " Total emplty modules $Empty_Count " -bouble
    write-output $Empty
}