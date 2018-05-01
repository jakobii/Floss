Import-Module @(
    "$PSScriptRoot\..\modules\smo\publish-table.psm1"
    "$PSScriptRoot\..\modules\tsql\Invoke-TSQL.psm1"
)

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


