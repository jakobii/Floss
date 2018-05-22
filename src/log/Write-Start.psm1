FUNCTION Write-Start {
    Param(
        $Message,

        [switch]
        $Verbosely = $true,
        
        [switch]
        $OutTime
    )
    if(!$Verbosely){return}
    if (!$Message) {[string]$Message = Get-FunctionName -callstack 2}
    Write-Host "`n`0Starting`0$Message`0" -f black -b DarkCyan
    
    if($OutTime){
        $StartTime = get-date
        return $StartTime 
    }

}
