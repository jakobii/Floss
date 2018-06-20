#unit

import-module "$PSScriptRoot\..\inquiry.psm1"
 
$DataTable_Parameters = @{

    TableName = 'employees'

    # define column names thier datatypes
    Columns   = [ordered] @{ id = 'int'; fn = 'string' ; hd = 'datetime'}
    
    # A simple array of hashtables
    Rows      = @(
        @{ id = 123 ; fn = Format-ProperName 'rick'    ; hd = $(get-date)  }
        @{ id = 456 ; fn = Format-ProperName 'steve'   ; hd = '2014-07-08' }
        @{ id = 789 ; fn = Format-ProperName 'beth'    ; hd = '2018-12-09' }
        @{ id = 789 ; fn = Format-ProperName 'bethany' ; hd = '2018-12-09' }
    )
}

$Rows = ConvertTo-DataRows @DataTable_Parameters
$hist = Compare-DataSet -old $Rows[2] -new $Rows[3] -IncludeHistory

$hist.fn.new | Assert-String -Expect 'Bethany' -Tag 'new column value'
$hist.fn.old | Assert-String -Expect 'Beth' -Tag 'old column value'







