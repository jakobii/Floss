
Import-Module "$PSScriptRoot\..\log\verbosely.psm1"



function Remove-Table {
    param(
        [string]$Server, 
        [string]$Database, 
        [string]$Schema,
        [string]$Table,
        
        [alias('v')]   
        [switch]
        $verbosely
    )
    
    $StartTime = get-date
    write-start -message 'Remove-table' -verbosely:$verbosely
    $Params = @{}
    $Params.Query = "DROP TABLE IF EXISTS [$Schema].[$Table]"
    $Params.ConnectionString = "Server=$Server; Database=$Database; Trusted_Connection=Yes; Integrated Security=SSPI;"
    $Params.ErrorAction = 'stop'

    write-note -message $Params -verbosely:$verbosely
    try {
        Invoke-Sqlcmd @Params
        write-success -message 'Table Dropped' -verbosely:$verbosely
    }
    catch { write-fail -message $PSItem -verbosely:$verbosely}
    write-time -start $StartTime -verbosely:$verbosely
    write-end -message 'Remove-table'  -verbosely:$verbosely
}








