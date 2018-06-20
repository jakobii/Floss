#unit

import-module "$PSScriptRoot\..\Inquiry.src.psm1"


[string]$String = '2018-5-17' 

$String | ConvertTo-Type -type 'datetime' | Assert-String -Expect '05/17/2018 00:00:00' -Tag 'conevrt to datetime'
