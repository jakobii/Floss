



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


        [parameter(mandatory = $true)]
        [string]
        $Server,

        [parameter(mandatory = $true)]
        [string]
        $Database,

        
        [switch]
        $Verbosely
    )

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
    $tsql_params.Server = $Server
    $tsql_params.Database = $Database
    $tsql_params.Trusted_Connection = $true
    $tsql_params.Integrated_Security = $true
    

    Invoke-TSQL @tsql_params 

}

