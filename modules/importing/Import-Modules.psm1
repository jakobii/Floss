

FUNCTION Import-Modules ([array]$modules, [switch]$Verbosely, [scriptblock]$OnError) {


    foreach ($module in $modules) {
        # Check Path
        if ( Test-Path $module) {
            try {Import-Module -Name $module}
            catch {
                if($Verbosely){Write-Host " Failed To import the Module File." -f Yellow}
            }
        }

        # Check Installed Modules
        elseif ( !$(get-module $module) ) {
            try {
                Import-Module -Name $module -Force
            }
            catch {
                if ($Verbosely) {Write-Host "Module can not be found. Lets try installing it." -f Yellow}
                # try installing
                try {
                    $install_module = @{
                        Name         = $module
                        AllowClobber = $true 
                        Confirm      = $false
                        Force        = $true
                    }
                    Install-Module @install_module
                }
                catch {
                    if ($Verbosely) {Write-Host "Module Could not be installed" -f Yellow}
                    $OnError.Invoke()
                }
            }
            #fail msg
        }
    }

    # Export all modules to parent scripts
    Export-ModuleMember -Function *

}




