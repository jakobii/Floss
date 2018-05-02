
Import-Module "$PSScriptRoot\..\log\verbosely.psm1"


function New-table {
    param(
        [string]$Server, 
        [string]$Database, 
        [string]$Schema,
        [string]$Table,
        $InputObject,
        
        [alias('v')]   
        [switch]
        $verbosely
    )
    $StartTime = get-date
    write-start -verbosely:$verbosely
    $Params = @{}
    $Params.DatabaseName = $Database
    $Params.SchemaName = $Schema
    $Params.TableName = $Table
    $Params.ServerInstance = $Server
    $Params.force = $true
    $Params.ErrorAction = 'stop'
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






