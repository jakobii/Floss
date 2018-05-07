
FUNCTION Import-Script ($path) {
    return [string]$Script = Get-Content -Path $path -Delimiter "`n`r"
}



