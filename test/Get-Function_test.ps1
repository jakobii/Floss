
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"


function get-blah ([int]$omg, [array]$rar, [string]$lala){ 
    $func = Get-Function -CallStack 2

    $func.ScriptBlock
}


get-blah -lala 'laksjhdf' -rar @('a','b') -omg 876


