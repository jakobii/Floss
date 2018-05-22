
FUNCTION Import-Script ($path) {
    [string]$Script = Get-Content -Path $path -Delimiter "`n`r"
    return $Script
}



