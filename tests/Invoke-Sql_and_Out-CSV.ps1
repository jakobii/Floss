Import-Module "$PSScriptRoot\..\modules\tsql\Invoke-TSQL.psm1"
Import-Module "$PSScriptRoot\..\modules\exporting\Out-Csv.psm1"

$TSQL = @{
    Server              = 'some_server' 
    Database            = 'some_database' 
    Username            = 'some_user'
    Password            = 'some_pass'
    Query               = 'some_query'
    OutputAs            = 'DataRows'
    #Integrated_Security = $true 
    #Trusted_Connection  = $true 
    Verbosely           = $true 
    #OnError             = {param($p, $e) write-host $P.ConnectionString -f yel}
}

$Res = Invoke-TSQL @TSQL 
Out-Csv -Verbosely -Value $Res -Path 'C:\temp\blah.csv'

