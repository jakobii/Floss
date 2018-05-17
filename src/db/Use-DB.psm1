

FUNCTION Use-DB {

    [cmdletbinding(DefaultParameterSetName = "Query")]
    param(
    
        # QUERY
        [parameter(ParameterSetName = "Query", Mandatory = $true, ValueFromPipeline = $true)]
        [alias('Query')]
        [string]
        $Sql,

        [parameter(ParameterSetName = "querypath", Mandatory = $true)]
        [System.IO.FileInfo]
        $SqlPath,


        [parameter(ParameterSetName = "Query")]
        [parameter(ParameterSetName = "QueryPath")]
        [System.IO.FileInfo]
        $CsvPath,

        # BULK MANAGE TABLE
        [parameter(ParameterSetName = "Publish", Mandatory = $true)]
        [parameter(ParameterSetName = "WRITE", Mandatory = $true)]
        $InputObject,

        [parameter(ParameterSetName = "Publish", Mandatory = $true)]
        [parameter(ParameterSetName = "READ", Mandatory = $true)]
        [parameter(ParameterSetName = "WRITE")]
        [string]
        $Table,

        [parameter(ParameterSetName = "Publish")]
        [parameter(ParameterSetName = "READ")] 
        [parameter(ParameterSetName = "WRITE")]
        [string]
        $Schema = 'dbo',

        [parameter(ParameterSetName = "WRITE", Mandatory = $true)]
        [switch]
        $Write,

        [parameter(ParameterSetName = "READ", Mandatory = $true)]
        [switch]
        $Read,

        [parameter(ParameterSetName = "Publish", Mandatory = $true)]
        [switch]
        $Publish,

        # OPTIONS
        [switch]
        $verbosely,

        [scriptblock]
        $OnSuccess,

        [scriptblock]
        $OnError,

        [string]
        $ResourceID,

        [string]
        $Server,

        [string]
        $Database,

        [switch]
        $Encryption,

        [string]
        $Username,

        [string]
        $Password

    )


    # GENERAL PARAMS
    [hashtable]$DB = @{}
    if ($ResourceID) {
        $Resource = Get-Resource -ID $ResourceID -CallStack 3
        if ( Test-Falsy $Resource.Server -af ) {
            $DB.Server = $Resource.Server
        }
        if ( Test-Falsy $Resource.Database -af) {
            $DB.Database = $Resource.Database
        }
        if ( Test-Falsy $Resource.Username -af) {
            $DB.Username = $Resource.Username
        }
        if ( Test-Falsy $Resource.Password -af) {
            $DB.Password = $Resource.Password
        }
        $DB.Verbosely = $Verbosely
    }

    if ($Server) {
        $DB.Server = $Server
    }
    if ($Database) {
        $DB.Database = $Database
    }
    if ($Username) {
        $DB.Username = $Username
    }
    if ($Password) {
        $DB.Password = $Password
    }
    $DB.Verbosely = $Verbosely




    # TSQL QUERY
    if ($PSCmdlet.ParameterSetName -eq 'QueryPath') {
        if (Test-Path $SqlPath) {
            $Sql = import-script  $SqlPath
        }
        else {
            write-fail 'Could Not find SqlPath'
        }
    }
    if ($PSCmdlet.ParameterSetName -eq 'Query' -or $PSCmdlet.ParameterSetName -eq 'QueryPath') {
        # Build Params
        $DB.query = $Sql
        if ($Encryption) {$DB.Trusted_Connection = $true}
        $DB.OutputAs = 'datatable'

        if( !$DB.Password -or !$DB.Username ){
            $DB.Integrated_Security = $true
        }

        if ($OnSuccess) { $DB.OnSuccess = $OnSuccess } # [fix] add to publish table functions
        if ($OnError) { $DB.OnError = $OnError } # [fix] add to publish table functions
        $Data = Invoke-TSQL @DB
    }






    # PUBLISH TABLE SMO
    if ($PSCmdlet.ParameterSetName -eq 'Publish') {
        $DB.Schema = $Schema
        $DB.Table = $Table
        $DB.InputObject = $InputObject
        $Data = Publish-Table @DB
    }
    if ($PSCmdlet.ParameterSetName -eq 'write') {
        $DB.Schema = $Schema 
        $DB.Table = $Table 
        $DB.InputObject = $InputObject
        $Data = Write-Table @DB
    }


    # RETURN TYPE
    if ($CsvPath) {
        Out-Csv -Path $CsvPath -Value $Data -Verbosely:$Verbosely
    }
    else {
        return Pop-Falsy $Data 
    }

}
