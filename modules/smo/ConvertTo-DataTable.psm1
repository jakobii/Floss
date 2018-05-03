







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








