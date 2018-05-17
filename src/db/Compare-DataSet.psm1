

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











