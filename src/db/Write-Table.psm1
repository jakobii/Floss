

function Write-table {
    param(
        [string]$Server, 
        [string]$Database, 
        [string]$Schema,
        [string]$Table,
        $InputObject,
        
        [switch]
        $verbosely,

        [switch]
        $force,

        [string]
        $Username,

        [string]
        $Password
    )
    $StartTime = get-date
    write-start -verbosely:$verbosely
    $Params = @{}
    $Params.DatabaseName = $Database
    $Params.SchemaName = $Schema
    $Params.TableName = $Table
    $Params.ServerInstance = $Server
    $Params.force = $force
    $Params.ErrorAction = 'stop'

    if($Username -and $Password){
        $Params.Credential = New-Credential -Username $Username -Password $Password
    }

    write-note -message $Params -verbosely:$verbosely
    
    $Params.InputData = $InputObject
    try {
        Write-SqlTableData @Params 
        write-success -message 'Table Created' -verbosely:$verbosely
    }
    catch { write-fail -message $PSItem -verbosely:$verbosely}
    write-time -start $StartTime -verbosely:$verbosely
    write-end -verbosely:$verbosely
}






