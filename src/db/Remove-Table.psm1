

function Remove-Table {
    param(
        [parameter(mandatory = $true)]
        [string]$Server, 

        [parameter(mandatory = $true)]
        [string]$Database, 

        [parameter(mandatory = $true)]
        [string]$Schema,

        [parameter(mandatory = $true)]
        [string]$Table,
        
        [switch]
        $Verbosely,

        [string]
        $Username,

        [string]
        $Password
    )

    $Protected_Schemas = @(
        'pro'
    )

    if($Protected_Schemas -contains $Schema ) {
        Write-Fail "Schema [$Schema] is protected and can not be dropped."
    }
    
    $StartTime = get-date
    write-start -message 'Remove-table' -Verbosely:$Verbosely
    $Params = @{}
    $Params.Query = "DROP TABLE IF EXISTS [$Schema].[$Table]"

    $Params.Server = $Server
    $Params.Database = $Database
    $Params.OutNull = $true
    $Params.OnSuccess = {write-success -message 'Table Dropped' -Verbosely:$Verbosely}
    $Params.OnError = {PARAM($SQLCMD, $ERR); write-fail -message $ERR -Verbosely:$Verbosely}
    if ($Username) {$Params.Username = $Username}
    if ($Password) {$Params.Password = $Password}
    
    write-note -message $Params -Verbosely:$Verbosely


    Invoke-TSQL @Params

    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -message 'Remove-table'  -Verbosely:$Verbosely
}








