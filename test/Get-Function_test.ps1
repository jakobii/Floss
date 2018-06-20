#unit

import-module "$PSScriptRoot\..\Inquiry.src.psm1"


function get-bar ([int]$omg, [array]$rar, [string]$lala){ 
    $func = Get-Function
    return $func
}


$FuncInfo = get-bar 
$FuncInfo.FunctionName | Assert-String -Expect 'get-bar' -Tag 'function name'


