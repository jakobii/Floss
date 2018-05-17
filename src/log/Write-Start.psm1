FUNCTION Write-Start {
    Param(
        $Message,

        [switch]
        $Verbosely = $true
    )
    if(!$Verbosely){return}
    if (!$Message) {[string]$Message = $(Get-PSCallStack)[1].FunctionName}
    Write-Host "`n`0Starting`0$Message`0" -f black -b DarkCyan
}
