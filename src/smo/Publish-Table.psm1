





Function Publish-Table {
    param(
        [string]$Server, 
        [string]$Database, 
        [string]$Schema,
        [string]$Table,
        $InputObject,
         
        [switch]
        $Verbosely
    )

    # Production table Safty net.
    if ($Schema -eq 'pro') {
        write-fail -Verbosely $true -m 'You can not publish to production table. Please choose a different Schema.' 
        return
    }

    $RemParams = @{
        Server = $Server 
        Database = $Database 
        Schema = $Schema 
        Table = $Table 
        Verbosely = $Verbosely   
    }

    Remove-Table @RemParams | Out-Null
    
    $NewParams = @{
        Server = $Server 
        Database = $Database 
        Schema = $Schema 
        Table = $Table 
        Verbosely = $Verbosely   
        InputObject = $InputObject
    }

    New-table @NewParams | Out-Null

}



























