#unit

import-module "$PSScriptRoot\..\inquiry.psm1"


[string]$String = '2018-5-17' 

 $String | ConvertTo-Type -type 'datetime' 
