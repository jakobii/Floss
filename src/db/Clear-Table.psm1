

function Clear-Table {
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
        $Password,

        [switch]
        $force

    )

    if (!$force) {
        $Protected_Schemas = @(
            'pro'
        )
    }


    if ($Protected_Schemas -contains $Schema ) {
        Write-Fail "Schema [$Schema] is protected and can not be dropped."
    }
    
    $StartTime = get-date
    write-start -Verbosely:$Verbosely
    $Params = @{}
    $Params.Query = "if exists ( select top 1 * from [$Schema].[$Table]) begin delete from [$Schema].[$Table] end;"

    $Params.Server = $Server
    $Params.Database = $Database
    $Params.OutNull = $true
    $Params.OnSuccess = {write-success -message 'Table Cleared' -Verbosely:$Verbosely}
    $Params.OnError = {PARAM($SQLCMD, $ERR); write-fail -message $ERR -Verbosely:$Verbosely}
    
    if ($Username -and $Password) {
        $Params.Username = $Username
        $Params.Password = $Password
    }
    else {
        $Params.Integrated_Security = $True
    }

    write-note -message $Params -Verbosely:$Verbosely


    Invoke-TSQL @Params

    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -Verbosely:$Verbosely
}








