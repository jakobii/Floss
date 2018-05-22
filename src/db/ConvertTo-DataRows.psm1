







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
        if (test-falsy $Rows[$i]) { 
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








