

$Modules = @(
    "$PSScriptRoot\New-Table.psm1"
    "$PSScriptRoot\Remove-Table.psm1"
    "$PSScriptRoot\..\log\verbosely.psm1"
)

Import-Module $Modules

Function Publish-Table {
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

    # Production table Safty net.
    if ($sch -eq 'pro') {
        write-fail -verbosely $true -m 'You can not publish to production table. Please choose a different schema.' 
        return
    }

    $RemParams = @{
        srv = $srv 
        db = $db 
        sch = $sch 
        tb = $tb 
        v = $verbosely   
    }

    Remove-Table @RemParams
    
    $NewParams = @{
        srv = $srv 
        db = $db 
        sch = $sch 
        tb = $tb 
        v = $verbosely   
        dat = $dat
    }

    New-table @NewParams

}























