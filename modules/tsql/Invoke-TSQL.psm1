

Import-Module "$PSScriptRoot\..\log\verbosely.psm1"








FUNCTION Invoke-TSQL {

    Param(

        [parameter(mandatory = $true)]
        [string]
        $Server,

        [parameter(mandatory = $true)]
        [string]
        $Database,
        
        [parameter(ParameterSetName = "Password", mandatory = $true)]
        [string]
        $Username,

        [parameter(ParameterSetName = "Password", mandatory = $true)]
        [string]
        $Password,

        [parameter(ParameterSetName = "Integrated", mandatory = $true)]
        [switch]
        $Integrated_Security,

        [parameter(mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $Query,

        [switch]
        $Trusted_Connection,     

        # Optionals
        [switch]
        $OutNull,

        [switch]
        $Verbosely,

        [scriptblock]
        $OnError,

        [scriptblock]
        $OnSuccess,

        [string]
        $OutputAs
    )

    Write-start -verbosely:$Verbosely
    [hashtable]$state = [ordered]@{}


    [string]$Conn = "Server=$Server;Database=$Database;"
    if ($Trusted_Connection) { 
        [string]$Conn += "Trusted_Connection=Yes;"
    }
    if ($Username) {
        [string]$Conn += "User Id=$Username;"
    }
    if ($Password) {
        [string]$Conn += "Password=$Password;"
    }
    if ($Integrated_Security) {
        [string]$Conn += "Integrated Security=SSPI;"
    }

    $SQLCMD = @{}
    $SQLCMD.ConnectionString = $Conn
    $SQLCMD.Query = $Query 
    $SQLCMD.ErrorAction = 'Stop'
    if ($OutputAs) {$SQLCMD.OutputAs = $OutputAs}
    Write-Note -message $SQLCMD -verbosely:$verbosely
    $Query_Start_Time = Get-Date
    
    
    # EXECUTE THE QUERY
    try {
        $TSQL_RESULTS = Invoke-Sqlcmd @SQLCMD
        $state.Success = $true
    }
    catch {
        $state.Success = $False
        $state.Error = $PSItem
    }

    
    # when successfull
    if ($state.Success -eq $true) {
         # Return Type Information
        if ($TSQL_RESULTS) {
            if ($TSQL_RESULTS -is [System.Data.DataSet]) {
                $state.Result_Type = '[System.Data.DataSet]'
                $state.Table_Count = $TSQL_RESULTS.Tables.Count
            }
            elseif ($TSQL_RESULTS -is [System.Data.DataTable]) {
                $state.Result_Type = '[System.Data.DataTable]'
                $state.Row_Count = $TSQL_RESULTS.Rows.Count
                $state.Column_Count = $TSQL_RESULTS.Columns.Count
            }
            elseif ($TSQL_RESULTS -is [array]) {
                $state.Result_Type = '[System.Array]'
                $state.Row_Count = $TSQL_RESULTS.Count
            }
            elseif ($TSQL_RESULTS -is [System.Data.DataRow]) {
                $state.Result_Type = '[System.Data.DataRow]'
                $state.Column_Count = $TSQL_RESULTS.table.columns.Count
            }
        }
        else{$state.Results = 'Null'}
        Write-Success -Message $state -verbosely:$verbosely
        Write-time -Start $Query_Start_Time -verbosely:$Verbosely
        
        # Invoke External cmd
        if ($OnSuccess) { $OnSuccess.Invoke($SQLCMD, $TSQL_RESULTS) }
    }

    # when not so successful
    elseif($state.Success -eq $false){
        Write-fail -Message $state -verbosely:$verbosely
        
        # Invoke External cmd
        if ($OnError) { $OnError.Invoke($SQLCMD, $PSItem) }
    }


    write-end -verbosely:$Verbosely

    # Return Value to Pipe
    if ($TSQL_RESULTS -and $state.Success -and ($OutNull -eq $False) ) {
        RETURN $TSQL_RESULTS
    }
}


























