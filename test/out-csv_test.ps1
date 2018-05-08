

import-module "$PSScriptRoot\..\inquiry.psm1"

$csv = @{
    blah = 1
    omg  = 2
}


out-csv -Path "C:\temp\blah\omg.csv" -Value $csv -Verbosely

