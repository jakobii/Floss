
FUNCTION  ConvertTo-DataTable {
    param(

        [string]
        $TableName,

        [hashtable]
        $Columns,
    
        # array of rows
        # each row is a hashtables
        [array] 
        $Rows
    )

    # Make A Table
    $DATATABLE = [System.Data.Datatable]::new()
    $DATATABLE.TableName = $TableName

    # Add Columns & Types
    FOREACH ( $ColumnName in $Columns.keys ) {
        [string]$DataType = $Columns.$ColumnName
        [void]$DATATABLE.Columns.Add($ColumnName, $DataType)
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
                write-host "could not add value to row"
                write-host $PSItem -f red
            }
        }
        
        # Add Table to row
        [void]$DATATABLE.Rows.Add($NewRow)
    }

    RETURN $DATATABLE
}
