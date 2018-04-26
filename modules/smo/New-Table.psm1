
Import-Module "$PSScriptRoot\..\log\verbosely.psm1"


function New-table {
    param(
        [string]$srv, 
        [string]$db, 
        [string]$sch,
        [string]$tb,
        $dat,
        
        [alias('v')]   
        [switch]
        $verbosely
    )
    $StartTime = get-date
    write-start -message 'New-table' -verbosely:$verbosely
    $Params = @{}
    $Params.DatabaseName = $db
    $Params.SchemaName = $sch
    $Params.TableName = $tb
    $Params.ServerInstance = $srv
    $Params.force = $true
    $Params.ErrorAction = 'stop'
    write-note -message $Params -verbosely:$verbosely
    
    $Params.InputData = $dat
    try {
        Write-SqlTableData @Params
        write-success -message 'Table Created' -verbosely:$verbosely
    }
    catch { write-fail -message $PSItem -verbosely:$verbosely}
    write-time -start $StartTime -verbosely:$verbosely
    write-end -message 'New-table' -verbosely:$verbosely
}






