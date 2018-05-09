Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


$TSQL = @{
    Server              = '' 
    Database            = '' 
    #Username            = ''
    #Password            = ''
    Query               = ''
    OutputAs            = 'datatable'
    Integrated_Security = $true 
    Trusted_Connection  = $true 
    Verbosely           = $true #$true 
    #OnError             = {param($p, $e) write-host $P.ConnectionString -f yel}
}

$Res = Invoke-TSQL @TSQL 
Out-Csv -Verbosely:$true -Value $Res -Path 'C:\temp\blah.csv'

