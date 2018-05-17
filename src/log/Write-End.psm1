
FUNCTION Write-End {
    Param(
        $Message,

        [switch]
        $Verbosely = $true
    )
    if(!$Verbosely){return}
    if (!$Message) {[string]$Message = $(Get-PSCallStack)[1].FunctionName}
    Write-Host "`0Ending`0$Message`0`n" -f black -b Gray
}
