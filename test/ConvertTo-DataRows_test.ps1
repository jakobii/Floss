#unit

import-module "$PSScriptRoot\..\Inquiry.src.psm1"
 


$DataTable_Parameters = @{

    TableName = 'employees'

    # define column names thier datatypes
    Columns   =  [ordered]@{id = 'int'; fn = 'string' ; hd = 'datetime'}
    
    # A simple array of hashtables
    Rows      = @(
        @{ id = 123 ; fn = 'rick'  ; hd = $(get-date)  }
        @{ id = 456 ; fn = 'steve' ; hd = '2014-07-08' }
        @{ id = 789 ; fn = 'beth'  ; hd = '2018-12-09' }
    )
}
$DataRows = ConvertTo-DataRows @DataTable_Parameters


$DataRows[0].fn | Assert-String -Expect 'rick'
$DataRows[2].id | Assert-String -Expect '789'
