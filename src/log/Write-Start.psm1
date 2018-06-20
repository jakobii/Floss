FUNCTION Write-Start {
    Param(
        $Message,

        [switch]
        $Verbosely = $true,
        
        [switch]
        $OutTime
    )

    $ParentFunc = Get-Function -CallStack 2
    if ( !$Verbosely -or !$ParentFunc.Parameters.Verbosely ) {return}
    if (!$Message) {[string]$Message = $ParentFunc.FunctionName}

        
    Write-Host "`n`0Starting`0$Message`0" -f black -b DarkCyan

    if ($OutTime) {
        $StartTime = get-date
        return $StartTime 
    }

}




