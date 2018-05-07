



FUNCTION Get-KeyChain {
    Param(

        [parameter(ParameterSetName = "ID", mandatory = $true)]
        [string]
        $ID,

        [parameter(ParameterSetName = "Group", mandatory = $true)]
        [string]
        $Group,

        [parameter(ParameterSetName = "Group", mandatory = $true)]
        [string]
        $Member,

        [string]
        $ConfigPath,

        [switch]
        $Verbosely
    )

    # Resolve Config Path
    if ( $ConfigPath ) {
        $Config = Import-Config -path $ConfigPath
    }
    elseif( Test-Path "$PSScriptRoot\..\..\conf\keychain.json" ){
        $Config = Import-Config -path "$PSScriptRoot\..\..\conf\keychain.json" 
    }
    elseif( Test-Path "$pwd\keychain.json" ){
        $Config = Import-Config -path "$pwd\keychain.json" 
    }
    else{
        Write-Fail 'Could Not find keychain.json file'
    }

    # Resolve Query
    if ($PSCmdlet.ParameterSetName -eq 'ID') {
        $Query = "SELECT * FROM [pro].[keychain] WHERE [id] = '$ID'"
    }
    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        $Query = "SELECT * FROM [pro].[keychain] WHERE [group] = '$Group' AND [member] = '$Member'"
    }



    # build tsql params
    $tsql_params = @{}
    $tsql_params.Query = $Query
    $tsql_params.Verbosely = $Verbosely
    $tsql_params.Server = $Config.Server
    $tsql_params.Database = $Config.Database
    $tsql_params.Trusted_Connection = $Config.Trusted_Connection

    if ($Config.Username -and $Config.Password ) {
        $tsql_params.Username = $Config.Username 
        $tsql_params.Password = $Config.Password
    }
    else {
        $tsql_params.Integrated_Security = $Config.Integrated_Security
    }
    
    Invoke-TSQL @tsql_params 

}

