Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\Inquiry.src.psm1"



$TSQL = @{
    Server              = ''
    Database            = ''
    Query               = ''
    Trusted_Connection  = $true 
    Integrated_Security = $true 
}

$data = Invoke-TSQL @TSQL


$pt = @{
    Server      = '' 
    Database    = '' 
    Schema      = ''
    Table       = ''
    InputObject = $data
    Verbosely   = $true
}
publish-table @pt


