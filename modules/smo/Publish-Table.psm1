

$Modules = @(
    "$PSScriptRoot\New-Table.psm1"
    "$PSScriptRoot\Remove-Table.psm1"
    "$PSScriptRoot\..\log\verbosely.psm1"
)

Import-Module $Modules

Function Publish-Table {
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

    # Production table Safty net.
    if ($Schema -eq 'pro') {
        write-fail -verbosely $true -m 'You can not publish to production table. Please choose a different Schema.' 
        return
    }

    $RemParams = @{
        Server = $Server 
        Database = $Database 
        Schema = $Schema 
        Table = $Table 
        verbosely = $verbosely   
    }

    Remove-Table @RemParams
    
    $NewParams = @{
        Server = $Server 
        Database = $Database 
        Schema = $Schema 
        Table = $Table 
        verbosely = $verbosely   
        InputObject = $InputObject
    }

    New-table @NewParams

}























