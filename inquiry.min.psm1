<#
	Module    : Inquiry
	Version   : 1.0.0
	DateTime  : 06/20/2018 13:06:53
	Functions : 65
#>
<# MANIFEST
	Get-KeyChain
	New-Credential
	New-Password
	Test-Admin
	Clear-Table
	Compare-DataSet
	ConvertTo-DataRows
	ConvertTo-DataTable
	Invoke-TSQL
	New-InsertInto
	Import-Path
	Publish-Table
	Remove-Table
	Use-DB
	Write-table
	Format-Char
	Format-Date
	Format-DateTime
	Format-DateTime2
	Format-Decimal
	Format-EmailAddress
	Format-Number
	Format-PhoneNumber
	Format-ProperName
	Format-Suffix
	Format-TitleCase
	Format-HashtableAsList
	Get-FunctionName
	Send-DiscordMessage
	Show-Progress
	Write-Alert
	Write-End
	Write-Fail
	Write-Note
	Write-Start
	Write-Success
	Write-Time
	ConvertFrom-Percentage
	Get-Max
	Get-Sum
	ConvertTo-DirectoryInfoArray
	Import-Config
	Import-Script
	New-Path
	Out-Csv
	Find-Directory
	Get-SftpFile
	Assert-Boolean
	Assert-String
	Assert-type
	Compress-Modules
	ConvertTo-PSCustomObject
	ConvertTo-Type
	Get-Function
	Out-Hash
	Get-ModuleStatistics
	Get-Resource
	Merge-Files
	New-DBNull
	New-String
	Out-Unique
	Pop-Falsy
	Pop-Null
	Protect-Sql
	Test-Falsy
#>




<#	Get-KeyChain.psm1	#>
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

<#	New-Credential.psm1	#>
function New-Credential {
    param(
        [parameter(Mandatory = $true)]
        [alias("u")]
        [string]
        $Username,
        [parameter(Mandatory = $true)]
        [alias("p")]
        [string]  
        $Password
    )
    $SecureString = ConvertTo-SecureString $Password -AsPlainText -Force
    return [System.Management.Automation.PSCredential]::new($Username, $SecureString)
}

<#	New-Password.psm1	#>
Function New-Password ([int]$MinLength = 8 ) {
    DO {
        #GEN PASSWORD
        $Password = [System.Web.Security.Membership]::GeneratePassword( $MinLength, 2)
        # AD PASSWORD REQUIREMENTS
        $LENGTH  = [regex]::new(".{$MinLength,}").Match( $Password )
        $SPECIAL = [regex]::new('[!@#$%<>^&?]').Match( $Password )
        $LOWER   = [regex]::new('[a-z]').Match( $Password )
        $UPPER   = [regex]::new('[A-Z]').Match( $Password )
        $NUMBER  = [regex]::new('[0-9]').Match( $Password )
        # TEST PASSWORD
        $Meets_Complexity = $true
        if (!$LENGTH.Success)  {$Meets_Complexity = $false}
        if (!$SPECIAL.Success) {$Meets_Complexity = $false}
        if (!$LOWER.Success)   {$Meets_Complexity = $false}
        if (!$UPPER.Success)   {$Meets_Complexity = $false}
        if (!$NUMBER.Success)  {$Meets_Complexity = $false}
    }
    Until($Meets_Complexity)
    return $Password
}
<#	Test-Admin.psm1	#>
FUNCTION Test-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    [bool]$PSSHELLADMIN = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    return $PSSHELLADMIN
}

<#	Clear-Table.psm1	#>
function Clear-Table {
    param(
        [parameter(mandatory = $true)]
        [string]$Server, 
        [parameter(mandatory = $true)]
        [string]$Database, 
        [parameter(mandatory = $true)]
        [string]$Schema,
        [parameter(mandatory = $true)]
        [string]$Table,
        [switch]
        $Verbosely,
        [string]
        $Username,
        [string]
        $Password,
        [switch]
        $force
    )
    if (!$force) {
        $Protected_Schemas = @(
            'pro'
        )
    }
    if ($Protected_Schemas -contains $Schema ) {
        Write-Fail "Schema [$Schema] is protected and can not be dropped."
    }
    $StartTime = get-date
    write-start -Verbosely:$Verbosely
    $Params = @{}
    $Params.Query = "if exists ( select top 1 * from [$Schema].[$Table]) begin delete from [$Schema].[$Table] end;"
    $Params.Server = $Server
    $Params.Database = $Database
    $Params.OutNull = $true
    $Params.OnSuccess = {write-success -message 'Table Cleared' -Verbosely:$Verbosely}
    $Params.OnError = {PARAM($SQLCMD, $ERR); write-fail -message $ERR -Verbosely:$Verbosely}
    if ($Username -and $Password) {
        $Params.Username = $Username
        $Params.Password = $Password
    }
    else {
        $Params.Integrated_Security = $True
    }
    write-note -message $Params -Verbosely:$Verbosely
    Invoke-TSQL @Params
    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -Verbosely:$Verbosely
}

<#	Compare-DataSet.psm1	#>
<# compares two peices of data and returns the differnece
    by default it will return a hashtable with the new values that have changed
        mainhash.propertyname 
    if IncludeHistory param is used
        mainhash.propertyname.new
        mainhash.propertyname.old
#>
function Compare-DataSet {
    param(
        $old, 
        $new, #priority
        [switch]
        $Verbosely,
        [switch]
        $IncludeHistory,
        [switch]
        $ExcludeUnchanged
    )
    # [System.Data.DataRow]
    if ($new -is [System.Data.DataRow] -and $old -is [System.Data.DataRow]) {
        [hashtable]$OutputObject = @{}
        [bool]$DataSetChanged = $false # check if anything in the dataset has changed
        [array]$Columns = $new.Table.Columns
        foreach ($Column in $Columns) {
            $ColumnName = $Column.ColumnName
            $NewValue = $new.$ColumnName
            $OldValue = $old.$ColumnName
            [bool]$PropertyChanged = $false
            if ($NewValue -ne $OldValue) {
                [bool]$PropertyChanged = $true
                [bool]$DataSetChanged = $true
                write-alert "$ColumnName : '$NewValue'" -verbosely:$Verbosely
            }
            else{
                write-note "$ColumnName : '$NewValue'" -verbosely:$Verbosely
            }
            if ($IncludeHistory -and $ExcludeUnchanged -and $PropertyChanged) {
                # create a history table.
                [hashtable]$history = @{
                    new = $NewValue
                    old = $OldValue
                }
                # add history table to column name
                $OutputObject.Add( $ColumnName, $history )
            } 
            elseif (!$IncludeHistory -and $ExcludeUnchanged -and $PropertyChanged) {
                # add only the new value.
                $OutputObject.Add( $ColumnName, $NewValue )
            }
            elseif ($IncludeHistory -and !$ExcludeUnchanged) {
                # create a history table.
                [hashtable]$history = @{
                    new = $NewValue
                    old = $OldValue
                }
                # add history table to column name
                $OutputObject.Add( $ColumnName, $history )
            } 
            elseif (!$IncludeHistory -and !$ExcludeUnchanged) {
                # add only the new value.
                $OutputObject.Add( $ColumnName, $NewValue )
            }
        } #end row loop
         # if nothing ever changed just return null
         if (!$DataSetChanged) {return $null}
    }
    # [hashtable]
    if ($new -is [hashtable] -and $old -is [hashtable]) {
    }
    return Pop-falsy $OutputObject
}

<#	ConvertTo-DataRows.psm1	#>
FUNCTION  ConvertTo-DataRows {
    param(
        [string]
        $TableName,
        [System.Collections.Specialized.OrderedDictionary]
        $Columns,
        # array of rows
        # each row is a hashtables
        [system.array] 
        $Rows,
        [switch]
        $verbosely,
        [switch]
        $AsTable
    )
    # Make A Table
    $DATATABLE = [System.Data.Datatable]::new()
    if ($TableName) {
        $DATATABLE.TableName = $TableName
    }
    # Add Columns & Types
    FOREACH ( $ColumnName in $Columns.keys ) {
        [string]$DataType = $Columns.$ColumnName
        # attemp to add the Column
        try {
            [void]$DATATABLE.Columns.Add($ColumnName, $DataType)
        }
        catch {
            write-fail "Could not add Column. $PSItem" -Verbosely:$Verbosely
        }
    }
    # Add Rows
    [int]$TotalRows = $Rows.Length
    [int]$I = 0
    for ( $i = 0 ; $i -lt $TotalRows; $i++) {
        #check if row is null before adding
        if (test-falsy $Rows[$i] -fast) { 
            continue 
        }
        $RowObject = $Rows[$i]
        $NewRow = $DATATABLE.NewRow()
        # add each value the row column
        FOREACH ( $ColumnName in $Columns.keys ) {
            $RowValue = $RowObject.$ColumnName
            # convert to datatype 
            $dayatype = $Columns.$ColumnName
            $Converted_Row_Value = ConvertTo-Type -Type $dayatype -InputObject $RowValue -DBNull
            # attemp to add the value to the row
            try {$NewRow.$ColumnName = $Converted_Row_Value}
            catch {
                write-fail "Could not add value to row. $PSItem" -Verbosely:$Verbosely
            }
        }
        # Percentage Completed
        Show-Progress -Goal $TotalRows -step $($I + 1) -Tag 'Convert Rows to type [DataRows]' -id 52
        # mass Add rows to Table
        [void]$DATATABLE.Rows.Add($NewRow)
    }
    if ($AsTable) {
        RETURN $DATATABLE[0].table
    }
    else {
        RETURN $DATATABLE
    }
}

<#	ConvertTo-DataTable.psm1	#>
FUNCTION  ConvertTo-DataTable {
    param(
        [string]
        $TableName,
        [hashtable]
        $Columns,
        # array of rows
        # each row is a hashtables
        [array] 
        $Rows,
        [switch]
        $verbosely  
    )
    # Make A Table
    $DATATABLE = [System.Data.Datatable]::new()
    if ($TableName) {
        $DATATABLE.TableName = $TableName
    }
    # Add Columns & Types
    FOREACH ( $ColumnName in $Columns.keys ) {
        [string]$DataType = $Columns.$ColumnName
        # attemp to add the Column
        try {
            [void]$DATATABLE.Columns.Add($ColumnName, $DataType)
        }
        catch {
            write-fail "Could not add Column. $PSItem" -Verbosely:$Verbosely
        }
    }
    # Add Rows
    FOREACH ($Row in $Rows) {
        $NewRow = $DATATABLE.NewRow()
        # add each value the row column
        FOREACH ($key in $Row.keys) {
            $RowValue = $Row.$key
            # attemp to add the value to the row
            try {$NewRow.$key = $RowValue}
            catch {
                write-fail "Could not add value to row. $PSItem" -Verbosely:$Verbosely
            }
        }
        # Add Table to row
        [void]$DATATABLE.Rows.Add($NewRow)
    }
    RETURN $DATATABLE
}

<#	Invoke-TSQL.psm1	#>
FUNCTION Invoke-TSQL {
    Param(
        [parameter(mandatory = $true)]
        [string]
        $Server,
        [parameter(mandatory = $true)]
        [string]
        $Database,
        [parameter(ParameterSetName = "Password", mandatory = $true)]
        [string]
        $Username,
        [parameter(ParameterSetName = "Password", mandatory = $true)]
        [string]
        $Password,
        [parameter(ParameterSetName = "Integrated")]
        [switch]
        $Integrated_Security = $true,
        [parameter(mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $Query,
        [switch]
        $Trusted_Connection,     
        # Optionals
        [switch]
        $OutNull,
        [switch]
        $Verbosely,
        [scriptblock]
        $OnError,
        [scriptblock]
        $OnSuccess,
        [string]
        $OutputAs
    )
    Write-start -verbosely:$Verbosely
    [hashtable]$state = [ordered]@{}
    [string]$Conn = "Server=$Server;Database=$Database;"
    if ($Trusted_Connection) { 
        [string]$Conn += "Trusted_Connection=Yes;"
    }
    if ($Username) {
        [string]$Conn += "User Id=$Username;"
    }
    if ($Password) {
        [string]$Conn += "Password=$Password;"
    }
    if ($Integrated_Security.IsPresent -and (!$Password -and !$Username) ) {
        [string]$Conn += "Integrated Security=SSPI;"
    }
    $SQLCMD = @{}
    $SQLCMD.ConnectionString = $Conn
    $SQLCMD.Query = $Query 
    $SQLCMD.ErrorAction = 'Stop'
    if ($OutputAs) {$SQLCMD.OutputAs = $OutputAs}
    Write-Note -message $SQLCMD -verbosely:$verbosely
    $Query_Start_Time = Get-Date
    # EXECUTE THE QUERY
    try {
        $TSQL_RESULTS = Invoke-Sqlcmd @SQLCMD
        $state.Success = $true
    }
    catch {
        $state.Success = $False
        $state.Error = $PSItem
    }
    # when successfull
    if ($state.Success -eq $true) {
         # Return Type Information
        if ($TSQL_RESULTS) {
            if ($TSQL_RESULTS -is [System.Data.DataSet]) {
                $state.Result_Type = '[System.Data.DataSet]'
                $state.Table_Count = $TSQL_RESULTS.Tables.Count
            }
            elseif ($TSQL_RESULTS -is [System.Data.DataTable]) {
                $state.Result_Type = '[System.Data.DataTable]'
                $state.Row_Count = $TSQL_RESULTS.Rows.Count
                $state.Column_Count = $TSQL_RESULTS.Columns.Count
            }
            elseif ($TSQL_RESULTS -is [array]) {
                $state.Result_Type = '[System.Array]'
                $state.Row_Count = $TSQL_RESULTS.Count
            }
            elseif ($TSQL_RESULTS -is [System.Data.DataRow]) {
                $state.Result_Type = '[System.Data.DataRow]'
                $state.Column_Count = $TSQL_RESULTS.table.columns.Count
            }
        }
        else{$state.Results = 'Null'}
        Write-Success -Message $state -verbosely:$verbosely
        Write-time -Start $Query_Start_Time -verbosely:$Verbosely
        # Invoke External cmd
        if ($OnSuccess) { $OnSuccess.Invoke($SQLCMD, $TSQL_RESULTS) }
    }
    # when not so successful
    elseif($state.Success -eq $false){
        Write-fail -Message $state -verbosely:$verbosely
        # Invoke External cmd
        if ($OnError) { $OnError.Invoke($SQLCMD, $PSItem) }
    }
    write-end -verbosely:$Verbosely
    # Return Value to Pipe
    if ($TSQL_RESULTS -and $state.Success -and ($OutNull -eq $False) ) {
        RETURN $TSQL_RESULTS
    }
}

<#	New-InsertInto.psm1	#>
Function New-InsertInto {
    Param(
        [string]
        $Schema = 'dbo',
        [string]
        $table,
        [array]
        $Rows
    )
    # Declare Elements 
    [string]$BEGIN_STATEMENT = "INSERT INTO [$($schema)].[$($table)] ( `n"
    [string]$MIDDLE_STATEMENT += "`n)`nVALUES (`n"
    [string]$ENDING_STATEMENT += "`n);`nGO"
    [string]$COLUMN_NAME_ARRAY = ''
    [string]$VALUE_FUNC_ARRAY = ''
    # Concat Elms as Strings
    [int]$COUNTER = 0
    Foreach ($SqlObj in $SqlElms) {
        if ($COUNTER -ne 0) {$COLUMN_NAME_ARRAY += ", `n"}
        if ($COUNTER -ne 0) {$VALUE_FUNC_ARRAY += ", `n"}
        $COLUMN_NAME_ARRAY += $SqlObj.Column
        $VALUE_FUNC_ARRAY += $SqlObj.Expression
        $COUNTER++
    }
    # Build Statement
    [string]$INSERT_STATEMENT += $BEGIN_STATEMENT
    [string]$INSERT_STATEMENT += $COLUMN_NAME_ARRAY
    [string]$INSERT_STATEMENT += $MIDDLE_STATEMENT
    [string]$INSERT_STATEMENT += $VALUE_FUNC_ARRAY
    [string]$INSERT_STATEMENT += $ENDING_STATEMENT
    return $INSERT_STATEMENT
}

<#	Publish-Files.psm1	#>
Function Import-Path($DB, [string]$Path, [boolean]$verbosely) {
    if ($verbosely) {Write-Start -message "Auto import" }
    #check if path exists
    if ($(Test-Path -Path $Path) -eq $false) { 
        if ($verbosely) {
            Write-Warning -Message "$Path could not be Found."
            Write-End "Auto import"
        }
        return 
    }
    #check if its file or folder
    $item = Get-Item -Path $Path
    if ($item.Attributes -eq 'Directory') {
        if ($verbosely) {Write-Note "Searching $Path for files to auto import" }
        $ImportFiles = Get-ChildItem -Path $Path -Recurse
        [boolean]$isDirectory = $true
    }
    if ($item.Attributes -eq 'Archive') {
        if ($verbosely) {Write-Note " Testing Path $Path" }
        [array]$ImportFiles = @($item)
        [boolean]$isDirectory = $False
    }
    #foreach
    [boolean]$ImportBoolean = $False
    foreach ($File in $ImportFiles) {
        #Get Item in more detail
        $item = Get-Item $File.PSPath
        #skip ignorefile
        if ($item.Name -eq '.ignore') {Continue}
        #check against ingnore file
        if ($verbosely) {Write-Note "checking file $($item.FullName) " }
        if ( $(search-IngnoreFile -value $item.Name -Folder $Folder) -and ($isDirectory -eq $true) ) {
            if ($verbosely) {
                Write-Note "$($item.Name) matches criteria in the '.ignore' file and will not be auto imported" 
            }
            continue
        }
        # default ignore list
        if ( search-DefaultIgnoreList -value $item.Name ) {
            if ($verbosely) {
                Write-Note "$($item.Name) matches criteria in the Default Ignore List and will not be auto imported" 
            }
            continue
        }
        #if csv
        if ( ($item.Extension).ToLower() -match ".csv") {
            $Data = import-csv -Path $item.FullName
            if (test-null $Data -AsFalse ) {[boolean]$ImportBoolean = $true}
            else {Write-Warning -Message " '$item' was not imported because it is an Empty file."}
        }
        #if txt
        if ( ($item.Extension).ToLower() -match ".txt") {
            $Data = import-csv -Path $item.FullName -Delimiter "`t"
            if (test-null $Data -AsFalse ) {[boolean]$ImportBoolean = $true}
            else {Write-Warning -Message " '$item' was not imported because it is an Empty file."}
        }
        #check if ok to import
        if ($ImportBoolean) {
            try {
                $TableName = $item.BaseName
                Remove-Table -TableName $TableName -DB $DB -verbosely $verbosely
                Import-Table -TableName $TableName -Value $Data -DB $DB -verbosely $verbosely
                if ($verbosely) {Write-Success -M  "$($item.FullName) was autoimported"}
            }
            catch { 
                throw $PSItem
            }
        }
    }
    if ($verbosely) {
        if ($ImportBoolean -eq $false) {
            Write-warning -Message "No Valid files where found for auto imported process" 
        }
        Write-End "Auto import"
    }
}
<#	Publish-Table.psm1	#>
Function Publish-Table {
    param(
        [parameter(Mandatory = $true)]
        [string]
        $Server, 
        [parameter(Mandatory = $true)]
        [string]
        $Database, 
        [string]
        $Schema = 'dbo',
        [parameter(Mandatory = $true)]
        [string]
        $Table,
        [parameter(Mandatory = $true)]
        $InputObject,
        [switch]
        $Verbosely,
        [string]
        $Username,
        [string]
        $Password
    )
    # Production table Safty net.
    if ($Schema -eq 'pro') {
        write-fail -Verbosely $true -m 'You can not publish to production table. Please choose a different Schema.' 
        return
    }
    $Params = @{}
    if ($Server) {$Params.Server = $Server }
    if ($Database) {$Params.Database = $Database}
    if ($Schema) {$Params.Schema = $Schema}
    if ($Table) {$Params.Table = $Table}
    if ($Verbosely) {$Params.Verbosely = $Verbosely}
    if ($Username) {$Params.Username = $Username}
    if ($Password) {$Params.Password = $Password}
    Remove-Table @Params | Out-Null
    if ($InputObject) {$Params.InputObject = $InputObject}
    $Params.force = $true
    Write-table @Params | Out-Null
}

<#	Remove-Table.psm1	#>
function Remove-Table {
    param(
        [parameter(mandatory = $true)]
        [string]$Server, 
        [parameter(mandatory = $true)]
        [string]$Database, 
        [parameter(mandatory = $true)]
        [string]$Schema,
        [parameter(mandatory = $true)]
        [string]$Table,
        [switch]
        $Verbosely,
        [string]
        $Username,
        [string]
        $Password,
        [switch]
        $force
    )
    if (!$force) {
        $Protected_Schemas = @(
            'pro'
        )
    }
    if ($Protected_Schemas -contains $Schema ) {
        Write-Fail "Schema [$Schema] is protected and can not be dropped."
    }
    $StartTime = get-date
    write-start -message 'Remove-table' -Verbosely:$Verbosely
    $Params = @{}
    $Params.Query = "DROP TABLE IF EXISTS [$Schema].[$Table]"
    $Params.Server = $Server
    $Params.Database = $Database
    $Params.OutNull = $true
    $Params.OnSuccess = {write-success -message 'Table Dropped' -Verbosely:$Verbosely}
    $Params.OnError = {PARAM($SQLCMD, $ERR); write-fail -message $ERR -Verbosely:$Verbosely}
    if ($Username -and $Password) {
        $Params.Username = $Username
        $Params.Password = $Password
    }
    else {
        $Params.Integrated_Security = $True
    }
    write-note -message $Params -Verbosely:$Verbosely
    Invoke-TSQL @Params
    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -message 'Remove-table'  -Verbosely:$Verbosely
}

<#	Use-DB.psm1	#>
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

<#	Write-Table.psm1	#>
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

<#	Format-Char.psm1	#>
<# Returns only a single character.
 # if more than one character is provided
 # it should return the first character that 
 # is not a space.
 # will return null for empty strings.
 # returns a single character string
 #>
FUNCTION Format-Char {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    [string]$str = $InputObject
    [array]$char_array = $str.ToCharArray()
    FOREACH ($Char in $char_array) {
        if ( test-falsy $Char -af ) { 
            [string]$OutputObject = $Char
            Break
        }
    }
    return Pop-Falsy $OutputObject
}

<#	Format-Date.psm1	#>
# Returns Time formated in base 24h
Function Format-Date {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    [string]$OutputObject = $(Get-Date -Date $InputObject).ToShortDateString()
    return Pop-Falsy $OutputObject
}

<#	Format-Datetime.psm1	#>
# Returns Time formated in base 24h
Function Format-DateTime {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    $DT = Get-Date -Date $InputObject
    [string]$DateTime = $DT.Year.ToString() + '-'
    [string]$DateTime += $DT.Month.ToString() + '-'
    [string]$DateTime += $DT.Day.ToString() + ' '
    [string]$DateTime += $DT.Hour.ToString() + ':'
    [string]$DateTime += $DT.Minute.ToString() + ':'
    [string]$DateTime += $DT.Second.ToString() 
    $DateTime = Protect-Sql $DateTime
    return Pop-Falsy $DateTime
}

<#	Format-Datetime2.psm1	#>
Function Format-DateTime2 {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    $DT = Get-Date -Date $InputObject
    [string]$DateTime2 = $DT.Year.ToString() + '-'
    [string]$DateTime2 += $DT.Month.ToString() + '-'
    [string]$DateTime2 += $DT.Day.ToString() + ' '
    [string]$DateTime2 += $DT.TimeOfDay.ToString()
    [string]$OutputObject = $DateTime2
    return Pop-Falsy $OutputObject
}

<#	Format-Decimal.psm1	#>
function Format-Decimal {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    [string]$decimal = ''
    $decimalPointNotUsed = $true
    foreach ($char in $InputObject.ToCharArray()) {
        [string]$str = $char
        if ($str -match '^\d$') {
            [string]$decimal += $str
        }
        if ($str -match '^[.]$' -and $decimalPointNotUsed ) {
            [string]$decimal += $str
            $decimalPointNotUsed = $false
        }
    }
    return Pop-Falsy $decimal
}

<#	Format-EmailAddress.psm1	#>
FUNCTION Format-EmailAddress {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    $Match = [regex]::new('([0-9a-zA-Z._-]+@[0-9a-zA-Z._-]+[.][0-9a-zA-Z._-]+)').Match($InputObject)
    $Email = $Match.Groups[1].Value.ToLower().Trim()
    return Pop-Falsy $Email
}
<#	Format-Number.psm1	#>
function Format-Number {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    [string]$int = ''
    foreach ($char in $InputObject.ToCharArray()) {
        [string]$str = $char
        if ($str -match '^\d$') {
            [string]$int += $str
        }
    }
    return Pop-Falsy $int
}

<#	Format-PhoneNumber.psm1	#>
FUNCTION Format-PhoneNumber {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    # Check if the Value has numbers in it
    # if it does not contain numbers return null
    [bool]$Contains_Int = $InputObject -match '.*\d.*'
    if (!$Contains_Int) {return $null}
    # safely convert to string else null
    try {[string]$PhoneNumber_Orginal = $InputObject}
    catch {Return $null}
    #[array]$CharArray = $PhoneNumber_Orginal.ToCharArray()
    foreach ($char in $PhoneNumber_Orginal.ToCharArray() ) {
        if ($char -match '\d') {
            #[string]$str = $char
            [string]$PhoneNumber_Int_Only += $char
        }
    }
    # Format Numbers According to digit count in regex
    Switch -Regex ($PhoneNumber_Int_Only) {
        # Short Formatted PhoneNumber : ddd-dddd
        '^(\d{3})(\d{4})$' {
            $Regex = [regex]::new('^(\d{3})(\d{4})$')
            $Match = $Regex.Match($PhoneNumber_Int_Only)
            [string]$g1 = $Match.Groups[1].Value
            [string]$g2 = $Match.Groups[2].Value
            [string]$OutputObject = "$g1-$g2"
            break
        }
        # Formatted PhoneNumber with Area code : (ddd) ddd-dddd
        '^(\d{3})(\d{3})(\d{4})$' {
            $Regex = [regex]::new('^(\d{3})(\d{3})(\d{4})$')
            $Match = $Regex.Match($PhoneNumber_Int_Only)
            [string]$g1 = $Match.Groups[1].Value
            [string]$g2 = $Match.Groups[2].Value
            [string]$g3 = $Match.Groups[3].Value
            [string]$OutputObject = "($g1) $g2-$g3"
            break
        }
        # Formatted PhoneNumber with 1-3 digit Country code : +ddd (ddd) ddd-dddd
        '^(\d{1,3})(\d{3})(\d{3})(\d{4})$' {
            $Regex = [regex]::new('^(\d{1,3})(\d{3})(\d{3})(\d{4})$')
            $Match = $Regex.Match($PhoneNumber_Int_Only)
            [string]$g1 = $Match.Groups[1].Value
            [string]$g2 = $Match.Groups[2].Value
            [string]$g3 = $Match.Groups[3].Value
            [string]$g4 = $Match.Groups[4].Value
            [string]$OutputObject = "+$g1 ($g2) $g3-$g4"
            break
        }
        # Non-formatted PhoneNumber
        # Digit Length did not meet any standard
        default {
            [string]$OutputObject = $PhoneNumber_Int_Only.trim()
            break
        }
    }
    return Pop-Falsy $OutputObject
}

<#	Format-ProperName.psm1	#>
function Format-ProperName {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    $eng = [System.Globalization.CultureInfo]::new('en-US')
    $Name = $eng.TextInfo.ToTitleCase($InputObject.tolower().trim())
    switch -Regex ($Name) {
        # Scrub !@#$%^&*()[ ]
        "[^a-zA-Z,. '-]+" {
            $regx = [regex]::new("[^a-zA-Z,. '-]+")
            $Name = $regx.Replace($Name, '')
        }
        # Remove Extra Middle whitespace
        "\b[\s]+\b" {
            $regx = [regex]::new("\b[\s]+\b")
            $Name = $regx.Replace($Name, ' ')
        }
        # [important!] Remove Suffix I-VII
        "\b([,. ]?[,. ])\b[IiVv]{1,3}$" {
            $regx = [regex]::new("\b([,. ]?[,. ])\b[IiVv]{1,3}$")
            $Name = $regx.Replace($Name, '')
            $name = $eng.TextInfo.ToTitleCase($Name.tolower())
        }
        # [important!] Remove Suffix John Jr, Martin Sr
        ".*\b[,.]?([ ]|[,\.])\b[JjSs][Rr]\b[,\.]?" {
            $regx = [regex]::new("\b[,\.]?([ ]|[,\.])\b[JjSs][Rr]\b[,\.]?")
            $Name = $regx.Replace($Name, '')
            $name = $eng.TextInfo.ToTitleCase($Name.tolower())
        }
        # O'Brian
        "^[Oo][\'][a-zA-Z-]+" {
            $regx = [regex]::new("^[Oo]\b[\']\b")
            $Name = $regx.Replace($Name, '')
            $Name = $eng.TextInfo.ToTitleCase($Name.tolower().trim())
            $Name = "O'" + $Name
        }
        # McDonald
        "^[Mm][Cc]\w+" {
            $regx = [regex]::new("^[Mm][Cc]")
            $Name = $regx.Replace($Name, '')
            $Name = $eng.TextInfo.ToTitleCase($Name.tolower().trim())
            $Name = "Mc" + $Name
        }
    }
    return Pop-Falsy $Name
}

<#	Format-Suffix.psm1	#>
FUNCTION Format-Suffix {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [string]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    $eng = [System.Globalization.CultureInfo]::new('en-US')
    switch -Regex ($InputObject) {
        # Sr | JR
        '\b[JjSs][Rr]\b' {
            $regx = [regex]::new("\b([JjSs][Rr])\b")
            $match = $regx.match($InputObject)
            [STRING]$Suffix = $match.Groups[1].Value.ToLower()
            break
        }
        # Roman Numerals 1-13
        "\b(I{1,3}|I{0,3}XI{0,3}|I{0,3}VI{0,3})\b" {
            $regx = [regex]::new("\b(I{1,3}|I{0,3}XI{0,3}|I{0,3}VI{0,3})\b") 
            $match = $regx.match($InputObject)
            [STRING]$Suffix = $match.Groups[1].Value
            break
        }
    }
    if ($Suffix) {
        [string]$OutputObject = $eng.TextInfo.ToTitleCase( $Suffix )
        return $OutputObject
    }
}

<#	Format-TitleCase.psm1	#>
FUNCTION Format-TitleCase  {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }
    [string]$string = $InputObject
    [string]$lowered = $string.tolower()
    [string]$trimmed = $lowered.Trim()
    $eng = [System.Globalization.CultureInfo]::new('en-US')
    [string]$OutputObject = $eng.TextInfo.ToTitleCase($trimmed)
    return Pop-Falsy $OutputObject 
}
<#	Format-Hashtable.psm1	#>
FUNCTION Format-HashtableAsList {
    Param(
        [hashtable]
        $Hashtable,
        $tab
    )
    # get max length
    [double]$key_Max_length = 0
    foreach ( $key in $Hashtable.keys) {
        [string]$key_as_string = $key
        [int]$key_length = $key_as_string.Length
        if ($key_length -gt $key_Max_length) {
            [double]$key_Max_length = $key_length 
        }
    }
    $Formated_Hash = @()
    if ($tab) {
        # what is the max number of tabs we need?
        [int]$Max_Number_of_Tabs = ([math]::floor( $($key_Max_length / 8) ) + 1)
        [int]$Max_char_with_tabs = $Max_Number_of_Tabs * 8
        $tab = "`t"
        # format each key value with the correct number of tabs
        foreach ( $key in $Hashtable.keys) {
            [string]$key_as_string = $key
            [int]$key_length = $key_as_string.Length
            # how many tabs does this one need?
            [double]$key_tab_dif = $Max_char_with_tabs - $key_length 
            [int]$tabs_needed = ([math]::floor( $($key_tab_dif / 8) ) + 1)
            if ( $($key_tab_dif % 8) -eq 0 ) {
                [int]$tabs_needed = [math]::floor( $($key_tab_dif / 8) )
            }
            else {
                [int]$tabs_needed = ([math]::floor( $($key_tab_dif / 8) ) + 1)
            }
            # format
            $Formated_Hash += "$key_as_string$($tab*$tabs_needed):`0$($Hashtable.$key_as_string)"
        }
    } #end tab
    # just use spaces
    else {
        $space = ' '
        $Max_spaces = $key_Max_length + 1
        foreach ( $key in $Hashtable.keys) {
            [string]$key_as_string = $key
            [int]$key_length = $key_as_string.Length
            $Spaces_needed = $Max_spaces - $key_length
            $Formated_Hash += "$key_as_string$($space*$Spaces_needed):`0$($Hashtable.$key_as_string)"
        }
    }
    return $Formated_Hash 
}

<#	Get-FunctionName.psm1	#>
function Get-FunctionName ([int]$CallStack = 1) {
    [string]$FunctionName = $(Get-PSCallStack)[$CallStack].FunctionName
    return $FunctionName
}

<#	Send-DiscordMessage.psm1	#>
FUNCTION Send-DiscordMessage {
    param(
        $Message,
        $URL,
        [scriptblock]
        $OnSuccess,
        [scriptblock]
        $OnError,
        [switch]
        $Verbosely
    )
    if ($url) {
        $restParam = @{
            Method      = 'POST'
            Uri         = $URL
            Body        = @{content = $Message}
            ErrorAction = 'stop'
        }
        try {
            Invoke-RestMethod @restParam
            if($OnSuccess){$OnSuccess.Invoke($restParam)}
        }
        catch {
            if($OnSuccess){$OnSuccess.Invoke($restParam,$PSItem)}
            if($Verbosely){Write-Host $PSItem -f red }
        }
    }
}     

<#	Show-Progress.psm1	#>
Function Show-Progress {
    Param(
        [double]    
        $Goal,
        [double]
        $Step,
        [string]
        $Tag,
        $ID = 50
    )
    $Progress_double = ($Step / $Goal) * 100
    Write-Progress -Activity $Tag -Status "Complete: $Progress_double%" -PercentComplete $Progress_double -Id $ID
}

<#	Write-Alert.psm1	#>
FUNCTION Write-Alert {
    Param(
        $Message,
        [switch]
        $verbosely = $true,
        [switch]
        $bouble
    )
    if(!$verbosely){return}
    $write = @{}
    # color
    if ($bouble) {
        $write.ForegroundColor = 'black'
        $write.BackgroundColor = 'yellow'
    }
    else {
        $write.ForegroundColor = 'yellow'
    }
    # object
    if ($Message -is [hashtable]) {
        $Write.Object = Format-HashtableAsList  $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }
    # write
    Write-Host @write
}

<#	Write-End.psm1	#>
FUNCTION Write-End {
    Param(
        $Message,
        [Nullable[datetime]]
        $StartTime,
        [switch]
        $Verbosely = $true
    )  
    $ParentFunc = Get-Function -CallStack 2
    if ( !$Verbosely -or !$ParentFunc.Parameters.Verbosely ) {return}
    if (!$Message) {[string]$Message = $ParentFunc.FunctionName}
    if ($startTime) {
        $time_span = New-TimeSpan -Start $startTime -End $(get-date)
        Write-Host "Timespan`0: $time_span"  -f Magenta
    }
    Write-Host "`0Ending`0$Message`0`n" -f black -b Gray
}

<#	Write-Fail.psm1	#>
FUNCTION Write-Fail {
    Param(
        $Message,
        [switch]
        $bouble,
        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    $write = @{}
    # color
    if ($bouble) {
        $write.ForegroundColor = 'black'
        $write.BackgroundColor = 'red'
    }
    else {
        $write.ForegroundColor = 'red'
    }
    # object
    if ($Message -is [hashtable]) {
        $Write.Object = Format-HashtableAsList $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }
    # write
    Write-Host @write
}
<#	Write-Note.psm1	#>
FUNCTION Write-Note {
    Param(
        $Message,
        [switch]
        $verbosely = $true,
        [switch]
        $bouble
    )
    $ParentFunc = Get-Function -CallStack 2
    if ( !$Verbosely -or !$ParentFunc.Parameters.Verbosely ) {return}
    $write = @{}
    # color
    if ($bouble) {
        $write.ForegroundColor = 'black'
        $write.BackgroundColor = 'white'
    }
    else {
        $write.ForegroundColor = 'white'
    }
    # object
    if ($Message -is [hashtable]) {
        $Write.Object = Format-HashtableAsList  $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }
    # write
    Write-Host @write
}

<#	Write-Start.psm1	#>
FUNCTION Write-Start {
    Param(
        $Message,
        [switch]
        $Verbosely = $true,
        [switch]
        $OutTime
    )
    $ParentFunc = Get-Function -CallStack 2
    if ( !$Verbosely -or !$ParentFunc.Parameters.Verbosely ) {return}
    if (!$Message) {[string]$Message = $ParentFunc.FunctionName}
    Write-Host "`n`0Starting`0$Message`0" -f black -b DarkCyan
    if ($OutTime) {
        $StartTime = get-date
        return $StartTime 
    }
}

<#	Write-Success.psm1	#>
FUNCTION Write-Success {
    Param(
        $Message,
        [switch]
        $bouble,
        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    $write = @{}
    # color
    if ($bouble) {
        $write.ForegroundColor = 'black'
        $write.BackgroundColor = 'green'
    }
    else {
        $write.ForegroundColor = 'green'
    }
    # object
    if ($Message -is [hashtable]) {
        $Write.Object = Format-HashtableAsList  $Message
        $Write.Separator = "`n"
    }
    else {
        $Write.Object = $Message
    }
    # write
    Write-Host @write
}

<#	Write-Time.psm1	#>
FUNCTION Write-Time {
    Param(
        $Start,
        $End = $(get-date),
        [switch]
        $verbosely = $true
    )
    if(!$verbosely){return}
    $time_span = New-TimeSpan -Start $Start -End $End 
    Write-Host "Timespan`0: $time_span"  -f Magenta
}

<#	ConvertFrom-Percentage.psm1	#>
function ConvertFrom-Percentage {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [string]
        $InputObject
    )
    [double]$Percentage = Format-Decimal $InputObject
    if ($Percentage) {
        $Decimal = $Percentage / 100
        return $Decimal
    }
    # maybe some string convertion here as well.
}

<#	Get-Max.psm1	#>
Function Get-Max ($InputObject) {
    foreach($item in $InputObject){
        if($item -gt $max){
            $max = $item
        }
    }
    return pop-falsy $max
}

<#	Get-Sum.psm1	#>
function Get-Sum {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if ($InputObject -is [array]) {
        [double]$sum = 0
        foreach ($item in $InputObject) {
            $sum = $sum + $item
        }
    }
    return $sum
}
<#	ConvertTo-DirectoryInfoArray.psm1	#>
# returns an array of [System.IO.DirectoryInfo] objects
# index 0 is the startin Directory 
FUNCTION ConvertTo-DirectoryInfoArray {
    Param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [System.IO.DirectoryInfo]
        $Path
    )
    [array]$PathArray = @()
    [array]$PathArray += $Path
    $I = 0
    While($true){
        [System.IO.DirectoryInfo]$parent = $PathArray[$i].Parent
        [array]$PathArray += $parent
        $I++
        # Test Parent
        if($PathArray[$i].FullName -eq $Path.Root.FullName){
            break
        }
    }
    return $PathArray 
}
<#	Import-Config.psm1	#>
FUNCTION Import-Config {
    param(
        [string]
        $Path,
        [string]
        $Format = 'json'
    )
    # Resolve Path
    if ($Path -and $(Test-Path $Path) ) {
        [string]$Content = Get-Content -Path $Path
    }
    else{
        return $null
    }
    # Resolve Format and Import
    if ( $Format -eq 'json' ) {
        $Config = ConvertFrom-Json $Content
    }
    $Config
}

<#	Import-Script.psm1	#>
FUNCTION Import-Script ($path) {
    [string]$Script = Get-Content -Path $path -Delimiter "`n`r"
    return $Script
}

<#	New-Path.psm1	#>
FUNCTION New-Path {
    param(
        [System.IO.FileInfo]
        $Path,
        [switch]
        $ExcludeFile,
        [switch]
        $Verbosely
    )
    if (Test-Path $Path) { return }
    if ($ExcludeFile){
        $NewPath = $path.Directory
    }  
    else{
        $NewPath = $path.FullName
    }
    $path_params = @{
        Path        = $NewPath
        ItemType    = 'Directory'
        Force       = $true
        ErrorAction = 'stop'
    }
    try {
        New-Item @path_params | Out-Null
        write-success $NewPath -Verbosely:$Verbosely
    }
    catch {
        write-fail $psitem -Verbosely:$Verbosely
    }
}

<#	Out-Csv.psm1	#>
FUNCTION Out-Csv {
    Param(
        [string]
        $Path,
        $Value,
        [switch]
        $Verbosely
    )
    # Log
    Write-Start -verbosely:$Verbosely
    $start_time = get-date
    [hashtable]$state = [ordered]@{}
    # Magic Path
    New-Path $Path -ExcludeFile
    # Export
    try {
        $Value | Export-Csv -Path $Path -Force -NoTypeInformation -ErrorAction 'Stop'
        $state.Success = $true
        $state.Csv = $Path
        Write-Success -Message $state -verbosely:$Verbosely
    }
    catch {
        $state.Success = $false
        $state.Error = $PSItem
        $state.Csv = $Path
        Write-fail -Message $state -verbosely:$Verbosely
    }
    # Log
    write-time -start $start_time -verbosely:$Verbosely
    write-end -verbosely:$Verbosely
}

<#	Search-Path.psm1	#>
# return the closest path that matches
FUNCTION Find-Directory {
    param(
        [string]
        $DirectoryName,
        [System.IO.DirectoryInfo]
        $StartIn ,
        [ValidateSet("Child", "Parent")]
        [string]
        $type = 'Parent'
    )
    # Starting Directory
    if ($StartIn -eq $null) {
        $stack = $(Get-PSCallStack)[1]
        [System.IO.FileInfo]$Function = $stack.Position.File
        $StartIn = $Function.Directory
    }
    if ($type -eq 'Child') {}
    # Parent Directory
    if ($type -eq 'Parent') {
        $DirectoryInfoArray = ConvertTo-DirectoryInfoArray $StartIn
        Foreach ( $Directory in $DirectoryInfoArray ) {
            If ($Directory.Name -eq $DirectoryName) {
                Return $Directory
            }
        } 
    }
}

<#	Get-SftpFile.psm1	#>
function Get-SftpFile {
    param(
        [string]
        $Server,
        [string]
        $UserName,
        [string]
        $Password,
        [string]
        $SshFingerprint,
        [string]
        $UnixPath,
        [string]
        $UnixFile,
        [string]
        $Path,
        [string]
        $DllPath,
        [switch]
        $force,
        [switch]
        $verbosely
    )
    write-start -Verbosely:$Verbosely
    $StartTime = get-date
    [hashtable]$log = @{}
    $log.DllPath = $DllPath
    # Load WinSCP .NET assembly 
    try {  
        [System.Reflection.Assembly]::UnsafeLoadFrom($DllPath) | Out-Null
        $log.Dll_Load_Success = $true
    }
    catch {
        $log.DllLoadSuccess = $false
        write-fail "could not load the winscpnet.dll. $PSItem"
    }
    # magic path
    New-Path -Path $Path 
    # Remove File
    if ($Force) {
        try {
            Remove-Item -Path "$Path\$UnixFile" -Force -ErrorAction 'stop'
            $log.File_Removed = "$Path\$UnixFile"
        }
        catch {}
    }
    # Set up session options
    $WinSCP_Properties = @{ 
        Protocol              = [WinSCP.Protocol]::Sftp        
        HostName              = $Server                        
        UserName              = $UserName                      
        Password              = $Password                      
        SshHostKeyFingerprint = $SshFingerprint   
    }
    $Auth = New-Object WinSCP.SessionOptions -Property $WinSCP_Properties
    $Session = New-Object WinSCP.Session
    [hashtable]$log = $log + $WinSCP_Properties
    try {
        $Session.Open($Auth)
        $Session.GetFiles("$UnixPath/$UnixFile", "$("$Path")\*").Check()
        $log.Success = $true
        write-success $log  -Verbosely:$Verbosely
    }
    catch {
        $log.Error = $PSItem
        $log.Success = $False
        write-fail $log -Verbosely:$Verbosely
        $Session.Dispose() 
    }
    write-time -start $StartTime -Verbosely:$Verbosely
    write-end -Verbosely:$Verbosely
}

<#	Assert-Boolean.psm1	#>
FUNCTION Assert-Boolean {
    param( 
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject, 
        [bool]$Expect, 
        [string]$Tag
    )
    Write-Start
    Write-Alert $Tag
    $log = @{}
    # success
    if ($Expect -eq $InputObject) {
        $Success = $true
    }
    else {
        $Success = $false
    }
    #type 
    if ($InputObject -eq $null ) {
        $log.Datatype = 'null'
    }
    else {
        $log.DataType = $InputObject.GetType()
        $log.TypeBase = $($InputObject.GetType()).BaseType.Name
    }
    $log.Success = $Success
    $log.Expected = $Expect
    $log.InputObject = $InputObject
    if ($Success) {
        Write-Success $log 
    }
    else {
        Write-Fail $log
    }
    Write-End
}
<#	Assert-String.psm1	#>
<# this function check if the InputObject param matches the expect param
 # the InputObject param is left duck typed on purpose. this allows for
 # the type provided to be out in a log. and prevents the type from 
 # being converted to a string and giving a false positive.
 #>
FUNCTION Assert-String {
    PARAM(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        $InputObject, 
        [AllowNull()]
        $Expect, 
        [string]
        $Tag,
        [switch]
        $CaseInSensitive
    )
    Write-Start
    Write-Alert $Tag
    $log = @{}
    # Success 
    if ( (!$CaseInSensitive -and $InputObject -ceq $Expect) -or ($CaseInSensitive -and $InputObject -eq $Expect) ){
        $Success = $true
    }
    else {
        $Success = $false
    }
    # Length
    try {
        $log.length = $InputObject.length
    }
    catch {
        $log.length = 'N/A' 
    }
    #type 
    if ($InputObject -eq $null ) {
        $log.Datatype = 'null'
    }
    else {
        $log.DataType = $InputObject.GetType()
        $log.TypeBase = $($InputObject.GetType()).BaseType.Name
    }
    $log.Success = $Success
    $log.Expected = $Expect
    $log.InputObeject = $InputObject
    if ($Success) {
        Write-Success $log 
    }
    else {
        Write-Fail $log
    }
    Write-End
}

<#	Assert-Type.psm1	#>
FUNCTION Assert-type {
    PARAM(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        $InputObject, 
        [AllowNull()]
        $Expect, 
        [string]
        $Tag
    )
    Write-Start
    Write-Alert $Tag
    $log = @{}
    # Success 
    [string]$type = $InputObject.GetType()
    if ( $type -eq $Expect ){
        $Success = $true
    }
    else {
        $Success = $false
    }
    #type 
    if ($InputObject -eq $null ) {
        $log.Datatype = 'null'
    }
    else {
        $log.DataType = $InputObject.GetType()
        $log.TypeBase = $($InputObject.GetType()).BaseType.Name
    }
    $log.Success = $Success
    $log.Expected = $Expect
    $log.InputObeject = $InputObject
    if ($Success) {
        Write-Success $log 
    }
    else {
        Write-Fail $log
    }
    Write-End
}

<#	Compress-Modules.psm1	#>
function Compress-Modules {
    param(
        [array]
        $Sources,
        [system.io.fileinfo]
        $destination,
        [string]
        $Name,
        [string]
        $Version
    )
    [string]$module_content = ''
    if ($sources -is [array]) {
        foreach ($path in $Sources) {
            [array]$ChildItems += Get-ChildItem -Path $path -Recurse
        }
        foreach ($ChildItem in $ChildItems) {
            $item = get-item $ChildItem.FullName
            if ( $item.Extension -eq '.psm1' ) {
                [array]$content = get-content $item -Delimiter "`r`n"
                if ( $content[0] -like "#beta*" ) {continue}
                [string]$module_content += "<#`t$($item.Name)`t#>`r`n"
                foreach ( $line in $content ) {
                    if ( $line.trim() -eq '' ) {continue}
                    [string]$module_content += $line
                }
                [string]$module_content += "`r`n"
            }
        }
    }
    # Manifest
    $func_SEARCH = [regex]::new('[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]\s+([0-9a-zA-Z]+)-([0-9a-zA-Z]+)(\s+)?(.+)?(\s+)?[{]')
    $match = $func_SEARCH.Match( $module_content )
    while ( $match.Success ) {
        $Verb = $match.groups[1]
        $Noun = $match.groups[2]
        [array]$Verbs += $Verb
        [array]$Nouns += $Noun
        [array]$Funcs += "$Verb-$Noun"
        $match = $match.NextMatch()
    }
    [string]$manifest = "<# MANIFEST`r`n"
    foreach( $func in $Funcs ){
        [string]$manifest += "`t$func`r`n"
    }
    [string]$manifest += "#>"
    if ($version) {
        [string]$header = "<#`r`n`tModule    : $($Name)`r`n`tVersion   : $($version)`r`n`tDateTime  : $(get-date)`r`n`tFunctions : $($Funcs.Count)`r`n#>`r`n"
    }
    [string]$everything = $header + $manifest + $("`r`n" * 5) + $module_content
    new-item -Path $destination -Value $everything -Force
}

<#	ConvertTo-PSCustomObject.psm1	#>
FUNCTION ConvertTo-PSCustomObject {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $Inputobject
    )
    $psobject = New-Object -TypeName 'PSCustomObject'
    if ($Inputobject -is [hashtable] -or $Inputobject -is [System.Collections.Specialized.OrderedDictionary]) {
        foreach ($key in $Inputobject.keys) {
            $psobject | Add-Member -MemberType 'NoteProperty' -Name $key -Value $Inputobject.$key 
        }
    }
    return $psobject
}

<#	ConvertTo-Type.psm1	#>
function ConvertTo-Type {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        $InputObject,
        [parameter(Mandatory = $true)]
        [ValidateSet("int", "int32", "int64", "string", "char", "long", "double", "datetime", "bool", "boolean", "guid")]
        [string]
        $Type = 'string',
        [switch]
        $DBNull
    )
    if (Test-Falsy $InputObject) { return Pop-Null -DBNull:$DBNull }
    try {
        switch ($Type) {
            {($_ -eq "int") -or ($_ -eq "int32")} {
                try {
                    $Outputobject = [Convert]::ToInt32($InputObject)
                }
                catch {
                    $Outputobject = Pop-Null -DBNull:$DBNull
                }
                RETURN $Outputobject
            }
            "int64" {
                try {
                    $Outputobject = [Convert]::ToInt64($InputObject)
                }
                catch {
                    $Outputobject = Pop-Null -DBNull:$DBNull
                }
                RETURN $Outputobject
            }
            "string" {
                $Outputobject = [Convert]::ToString($InputObject)
                RETURN $Outputobject
            }
            "char" {
                $Outputobject = [Convert]::ToChar($InputObject)
                RETURN $Outputobject
            }
            "long" {
                [long]$Outputobject = [Convert]::ToInt64($InputObject)
                RETURN $Outputobject
            }
            "double" {
                [double]$Outputobject = [Convert]::ToDouble($InputObject)
                RETURN $Outputobject
            }
            "datetime" {
                try {
                    $Outputobject = [Convert]::ToDateTime($InputObject)
                }
                catch {
                    $Outputobject = Pop-Null -DBNull:$DBNull
                }
                RETURN $Outputobject
            }
            {($_ -eq "bool") -or ($_ -eq "boolean")} {
                [boolean]$Outputobject = [Convert]::ToBoolean($InputObject)
                RETURN $Outputobject
            }
            "guid" {
                [guid]$Outputobject = $InputObject
                RETURN $Outputobject
            }
        }
    }
    catch {
        Write-Fail $PSItem
        return Pop-Null -DBNull:$DBNull
    }
}
<#	Get-Function.psm1	#>
function Get-Function {
    param(
        [int]
        $CallStack = 1
    )
    $Function = $(Get-PSCallStack)[$CallStack]
    $Item = get-item $Function.Position.File
    [hashtable]$FunctionInfo = @{
        FunctionName  = $Function.FunctionName
        ScriptBlock   = $Function.InvocationInfo.MyCommand.ScriptBlock
        FullName      = $Item.FullName
        FileName      = $Item.Name
        Directory     = $Item.Directory
        DirectoryName = $Item.DirectoryName
        Parameters    = [hashtable]$Function.InvocationInfo.BoundParameters
    }
    return $FunctionInfo
}

<#	Out-Hash.psm1	#>
function Out-Hash {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,
        [ValidateSet("byte", "hex", "string")]
        [string]
        $OutputAs = 'hex',
        [ValidateSet("MD5", "SHA256", "SHA512")]
        [string]
        $Algorithm = 'MD5'
    )
    switch ($Algorithm) {
        'MD5' {$Cryptography = new-object System.Security.Cryptography.MD5CryptoServiceProvider} 
        'SHA256' {$Cryptography = new-object System.Security.Cryptography.SHA256Managed} 
        'SHA512' {$Cryptography = new-object System.Security.Cryptography.SHA512Managed} 
    }
    # Sql Server returns utf8 hashes
    $Bytes = [System.Text.Encoding]::utf8.GetBytes($InputObject)
    $ByteArray = $Cryptography.ComputeHash($Bytes)
    switch ($OutputAs) {
        'byte' {
            $OutputObject = $ByteArray 
        }
        'hex' {
            [string]$OutputObject = [String]::Join("", ($ByteArray | ForEach-Object { "{0:X2}" -f $_}))
        }
        'string' {
            foreach ($byte in $ByteArray) {
                [string]$OutputObject += $byte.ToString()
            }
        }
    }
    return $OutputObject
}

<#	Get-ModuleStatistics.psm1	#>
FUNCTION Get-ModuleStatistics {
    param(
        $path
    )
    [array]$items = Get-ChildItem $path -Recurse
    foreach ( $item in $items) {
        # filter the modules
        if ($item.Extension -eq '.psm1') {
            [array]$lines = Get-Content -ReadCount 1 -Path $item.FullName
            if ($lines -eq $null) {
                [array]$Empty += $item.name
                [int]$Empty_Count++ | out-null
            }
            if ($lines -is [array]) {
                [string]$all_lines = $lines[0..$($lines.Count - 1)]
                if (test-falsy $all_lines) {
                    [array]$Empty += $item.name
                    [int]$Empty_Count++ | out-null
                }
                if ($lines[0].Trim() -eq '#beta') {
                    [array]$Beta += $item.name
                    [int]$Beta_count++ | out-null
                }
                if ($lines[0].Trim() -ne '#beta') {
                    [array]$Production += $item.name
                    [int]$Production_Count++ | out-null
                }
            }
        }
    }
    write-alert " Total Production modules $Production_Count " -bouble
    write-output $Production
    write-alert " Total Beta modules $Beta_count " -bouble
    write-output $Beta
    write-alert " Total emplty modules $Empty_Count " -bouble
    write-output $Empty
}
<#	Get-Resource.psm1	#>
FUNCTION Get-Resource {
    Param(
        [parameter(ParameterSetName = "ID", Mandatory = $true)]
        [string]
        $ID,
        [parameter(ParameterSetName = "Group", Mandatory = $true)]
        [string]
        $Group,
        [System.io.fileinfo]
        $Path,
        [int]
        $CallStack = 2,
        [switch]
        $Verbosely
    )
    $starttime = write-start -Verbosely:$Verbosely -OutTime
    # RESOLVE PATH
    if ($Path) {
        $JSON_PATH = $Path
    }
    elseif (!$Path) {
        $ParentFunction = Get-Function -CallStack $CallStack
        $ParentFunctionDirectory = $($ParentFunction.Directory)
        #Check the current directory and the move out
        if (Test-Path  "$ParentFunctionDirectory\resources.json") {
            $JSON_PATH = "$ParentFunctionDirectory\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\conf\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\conf\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\..\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\..\conf\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\conf\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\..\..\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\..\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\..\..\conf\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\..\conf\resources.json"
        }
        # last ditch effort. check a child directory.
        else {
            try {
                $ChildItem = Get-ChildItem -Name 'resources.json' -Recurse -Depth 1 -ErrorAction 'stop'
            }
            catch {}
            if ($ChildItem) {
                $JSON_PATH = $ChildItem.FullName
            }
            else {
                Write-Fail "Could Not Find resources.json"
                Return
            }
        }
    }
    # Import Json Content
    try {
        # get dependancies
        $content_params = @{
            Raw         = $true
            ErrorAction = 'stop'
            Path        = $JSON_PATH  # [fix] hard coded paths suck
        }
        $Content = Get-Content @content_params
    }
    catch {
        Write-Fail "$JSON_PATH Could Not be imported. $psitem"
        Return
    }
    # Convert Json
    try {
        $Resources = ConvertFrom-Json -InputObject $Content -ErrorAction 'stop'
    }
    catch {
        Write-Fail "Could not convert Json to psobject. $JSON_PATH , $psitem"
        Return
    }
    # Select Object
    if ($PSCmdlet.ParameterSetName -eq 'ID') {
        foreach ($Resource in $Resources) {
            if ( $Resource.ID -eq $ID ) {
                $OutputObject = $Resource
                Write-Success @{path = $JSON_PATH; id = $ID;}
                break
            }
        }
    }
    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        [array]$OutputObject = @()
        foreach ($Resource in $Resources) {
            if ( $Resource.Group -like $Group ) {
                [array]$OutputObject += $Resource
            }
        }
    }
    Write-End -StartTime $starttime
    Return Pop-Falsy $OutputObject
}

<#	Merge-Files.psm1	#>
<#
this function merges text files into a single array. each line is an index.
#>
FUNCTION Merge-Files {
    param( 
        [System.IO.DirectoryInfo]
        $Path,
        [string]
        $Extension,
        [int]
        $depth
    )
    # validate path
    if ( !$(Test-Path $Path) ) {
        write-fail "$(Get-FunctionName): Could Not Find Path"
        Return 
    }
    # Get all the items recursively
    $GetChildItem = @{}
    $GetChildItem.Path = $Path 
    $GetChildItem.Recurse = $true
    if ($depth) {$GetChildItem.depth = $depth}
    $ChildItems = Get-ChildItem @GetChildItem
    # only keep files
    [array]$items = @()
    foreach ($ChildItem in $ChildItems) {
        if ( !$($ChildItem -is [System.IO.DirectoryInfo]) ) {
            [array]$items += $ChildItem
        }
    }
    [array]$LINE_ARRAY = @()
    [array]$FILES = @()
    # choose files
    FOREACH ($item in $items) {
        # filter by extension
        if ($Extention -and $item.Extension -eq $Extension) {
            [array]$FILES += $item.fullname
            CONTINUE
        }
        # catch all
        if (!$Extention) {
            [array]$FILES += $item.fullname
            CONTINUE
        }
    }
    # Add file data to line array
    FOREACH ($FILE in $FILES) {
        [array]$FILE_ARRAY = Get-Content -Path $FILE
        #kinda funy logic here but we are just combining two arrays
        [array]$LINE_ARRAY += [array]$FILE_ARRAY 
    }
    RETURN $LINE_ARRAY
}
<#	New-DBNull.psm1	#>
function New-DBNull {
    $DBNull = $([System.DBNull]::Value)
    return $DBNull 
}

<#	New-String.psm1	#>
FUNCTION New-String {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if($InputObject -is [array]){
        $OutputObject = [string]::Concat($InputObject)
    }
    if($InputObject -is [hashtable]){
        foreach($key in $InputObject.keys){
            [string]$OutputObject += [convert]::ToString( $($InputObject.$key) )
        }
    }
    if($InputObject -is [Byte]){
        $OutputObject = [System.Text.Encoding]::ASCII.GetString($InputObject)
    }
    return Pop-Falsy $OutputObject
}
<#	Out-Unique.psm1	#>
FUNCTION Out-Unique {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [array]
        $InputObject,
        [switch]
        $Verbosely,
        [switch]
        $CaseSensitive
    )
    $start = Write-Start -OutTime
    [array]$UniqueObjects = @()
    if (!$CaseSensitive) {
        foreach ($index in $InputObject) {
            if ($UniqueObjects -notcontains $index) {
                [array]$UniqueObjects += $index
            }
        }
    }
    if ($CaseSensitive) {
        foreach ($index in $InputObject) {
            if ($UniqueObjects -cnotcontains $index) {
                [array]$UniqueObjects += $index
            }
        }
    }
    $log = @{}
    $log.Recieved_Objects = $InputObject.Count
    $log.Unique_Objects = $UniqueObjects.Count
    Write-Note $log
    write-end -StartTime $start
    return $UniqueObjects 
}

<#	Pop-Falsy.psm1	#>
# Returns null if the InputObject evaluates to falsy
FUNCTION Pop-Falsy {
    param(
        [parameter(ValueFromPipeline)]
        $InputObject,
        [switch]
        $DBNull
    )
    # Quick Check, reduce Deep checks
    if (!$InputObject) { return Pop-Null -DBNull:$DBNull }
    # Deep Check
    [bool]$falsy = test-falsy $InputObject
    if ($falsy) { Pop-Null -DBNull:$DBNull }
    else {return $InputObject}
}

<#	Pop-Null.psm1	#>
Function Pop-Null {
    Param(
        [switch]
        $DBNull
    )
    if($DBNull){
        return New-DBNull
    }
    else{
        return $null
    }
}

<#	Protect-Sql.psm1	#>
function Protect-Sql($InputObject) {
    # array
    if ($InputObject -is [Array]) {
        [array]$OutputObject = @()
        foreach ($row in $InputObject) {
            $Escaped_Sql = Protect-Sql $row # [recurse] :D!
            [array]$OutputObject += $Escaped_Sql
        }
        return $OutputObject
    }
    # char
    if ($InputObject -is [char]) {
        if ($InputObject -eq "'") {
            return $null
        }
        return $InputObject
    }
    # String
    if ($InputObject -is [string])  {
        $Escaped_Sql = $InputObject -replace "'", "''"
        [string]$OutputObject = $Escaped_Sql
        return $OutputObject
    }
}

<#	Test-Falsy.psm1	#>
Function Test-Falsy {
    param(
        # the value you would like to check for null
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [alias("o")]    
        $InputObject, 
        # Causes this function to return false if $InputObject -eq <Some Null>
        [alias("af")]
        [switch]
        $asFalse, 
        [alias("v")]
        [switch]
        $Verbosely,
        # assumes you intend to do a thorough check of complex
        # objects unless explicitly stated otherwise
        [switch]
        $fast 
    ) 
    write-start -verbosely:$Verbosely
    [hashtable]$log = @{}
    $log.InputObject = $InputObject
    # false until proven true
    [boolean]$Falsy = $False
    # Null
    if ($InputObject -eq $null) {
        [boolean]$Falsy = $True
        $log.DataType = 'null'
    }
    else {
        $log.DataType = $InputObject.GetType()
    }
    # DBNull
    if ($InputObject -is [DBNull]) {
        [boolean]$Falsy = $True 
    }
    # int
    elseif ($InputObject -is [int]) {
        if ($InputObject -eq 0) {
            [boolean]$Falsy = $True
        }
    }
    # Float
    elseif ($InputObject -is [float]) {
        if ($InputObject -eq 0) {
            [boolean]$Falsy = $True
        }
    }
    # String
    elseif ($InputObject -is [String]) {
        $log.CharCount = $InputObject.count
        if ($InputObject.Trim() -eq '') {
            [boolean]$Falsy = $True
        }
    }
    # char
    elseif ($InputObject -is [char]) {
        if ($InputObject -eq ' ') {
            [boolean]$Falsy = $True
        }
    }
    # Standard powershell falsy catching
    elseif (!$InputObject) {
        [boolean]$Falsy = $True
    } 
    # Arrays
    elseif ($InputObject -is [array]) {
        try {
            # try to can stringify the array. 
            # faster then iterating and falsy's objects that are empty.
            [string]$ConcatArray = $InputObject[0..$($InputObject.Count - 1)]
            [boolean]$Falsy = test-falsy $ConcatArray
        }
        catch { 
            # dont error out
        }
        # Deep checking. this could take a while.....
        if (!$fast -and !$Falsy) {
            [boolean]$Falsy = $true # until proven false
            foreach ($index in $InputObject) {
                if (test-falsy $index -af) {
                    [boolean]$Falsy = $false
                    break # stop check at first non-falsy value
                }
            }
        }
    }
    # hashtables & OrderedDictionary
    elseif ($InputObject -is [hashtable] -or $InputObject -is [System.Collections.Specialized.OrderedDictionary]) {
        try {
            # try to can stringify the array. 
            # faster then iterating and falsy's objects that are empty.
            [string]$ConcatArray = $InputObject.values
            [boolean]$Falsy = test-falsy $ConcatArray
        }
        catch { 
            # dont error out
        }
        if (!$fast -and !$Falsy) {
            [boolean]$Falsy = $true # until proven false
            foreach($key in $InputObject.keys){
                $value = $InputObject.$key 
                if(test-falsy $value -af){
                    [boolean]$Falsy = $false
                    break # stop check at first non-falsy value
                }
            }
        }
    }
    $log.Flasy = $Falsy
    Write-Note $log -Verbosely:$Verbosely
    write-end -verbosely:$Verbosely
    if ($AsFalse -eq $true) {
        Return !$Falsy
    }
    if ($AsFalse -eq $false) {
        Return $Falsy
    }
}

