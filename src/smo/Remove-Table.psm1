

function Remove-Table {
    param(
        [string]$Server, 
        [string]$Database, 
        [string]$Schema,
        [string]$Table,
        
        [alias('v')]   
        [switch]
        $Verbosely
    )
    
    $StartTime = get-date
    write-start -message 'Remove-table' -Verbosely:$Verbosely
    $Params = @{}
    $Params.Query = "DROP TABLE IF EXISTS [$Schema].[$Table]"
    $Params.ConnectionString = "Server=$Server; Database=$Database; Trusted_Connection=Yes; Integrated Security=SSPI;"
    $Params.ErrorAction = 'stop'

    write-note -message $Params -Verbosely:$Verbosely
    try {
        Invoke-Sqlcmd @Params
        write-success -message 'Table Dropped' -Verbosely:$Verbosely
    }
    catch { write-fail -message $PSItem -Verbosely:$Verbosely}
    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -message 'Remove-table'  -Verbosely:$Verbosely
}








